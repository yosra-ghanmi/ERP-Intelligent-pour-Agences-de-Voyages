codeunit 50620 "AI Itinerary Generator"
{
    var
        AIServerURL: Text;

    trigger OnRun()
    begin
        AIServerURL := 'http://localhost:8000';
    end;

    procedure GenerateItineraryForReservation(ReservationNo: Code[20]): Text
    var
        TravelReservation: Record "Travel Reservation";
        TravelClient: Record "Travel Client";
        TravelService: Record "Travel Service";
        Client: JsonObject;
        Reservation: JsonObject;
        Services: JsonArray;
        RequestBody: JsonObject;
        ResponseText: Text;
        ItinerarySummary: Text;
    begin
        if AIServerURL = '' then
            AIServerURL := 'http://localhost:8000';

        // Get reservation
        TravelReservation.Get(ReservationNo);

        // Get client
        TravelClient.Get(TravelReservation."Client No.");

        // Build Client JSON
        Client.Add('id', TravelClient."No.");
        Client.Add('name', TravelClient.Name);
        if TravelClient."AI_Preferences" <> '' then
            Client.Add('preferences', TravelClient."AI_Preferences")
        else
            Client.Add('preferences', '');

        // Build Reservation JSON
        Reservation.Add('reservationNo', TravelReservation."Reservation No.");
        Reservation.Add('clientId', TravelReservation."Client No.");
        Reservation.Add('serviceCode', TravelReservation."Service Code");
        if TravelReservation."Reservation Date" <> 0D then
            Reservation.Add('reservationDate', Format(TravelReservation."Reservation Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        Reservation.Add('status', Format(TravelReservation.Status));

        // Build Services JSON Array
        if TravelReservation."Service Code" <> '' then begin
            if TravelService.Get(TravelReservation."Service Code") then
                AddServiceToJsonArray(Services, TravelService);
        end;

        // Build Request Body
        RequestBody.Add('client', Client);
        RequestBody.Add('reservation', Reservation);
        RequestBody.Add('services', Services);
        RequestBody.Add('days', 3); // Default 3 days

        // Call AI Server
        ResponseText := CallAIServer('/generate', RequestBody);

        // Extract summary from response
        ItinerarySummary := ExtractSummary(ResponseText);

        exit(ItinerarySummary);
    end;

    local procedure AddServiceToJsonArray(var Services: JsonArray; Service: Record "Travel Service")
    var
        ServiceObj: JsonObject;
    begin
        ServiceObj.Add('code', Service.Code);
        ServiceObj.Add('name', Service.Name);
        ServiceObj.Add('serviceType', Format(Service."Service Type"));
        ServiceObj.Add('destination', Service.Location);

        if Service.Price <> 0 then
            ServiceObj.Add('price', Service.Price);
        if Service."Currency Code" <> '' then
            ServiceObj.Add('currency', Service."Currency Code");
        if Service.Latitude <> 0 then
            ServiceObj.Add('latitude', Service.Latitude);
        if Service.Longitude <> 0 then
            ServiceObj.Add('longitude', Service.Longitude);
        if Service.Description <> '' then
            ServiceObj.Add('description', Service.Description);

        Services.Add(ServiceObj);
    end;

    local procedure CallAIServer(Endpoint: Text; Body: JsonObject): Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        BodyText: Text;
        ResponseText: Text;
    begin
        // Prepare request
        Request.Method := 'POST';
        Request.SetRequestUri(AIServerURL + Endpoint);

        Body.WriteTo(BodyText);
        Content.WriteFrom(BodyText);

        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        Request.Content := Content;

        // Send request
        if not Client.Send(Request, Response) then
            Error('Failed to connect to AI Server at %1', AIServerURL);

        // Read response
        if not Response.IsSuccessStatusCode() then
            Error('AI Server returned error: %1 %2', Response.HttpStatusCode(), Response.ReasonPhrase());

        Response.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    local procedure ExtractSummary(ResponseText: Text): Text
    var
        ResponseObj: JsonObject;
        SummaryToken: JsonToken;
        DaysToken: JsonToken;
        DayToken: JsonToken;
        DayObj: JsonObject;
        ItemsToken: JsonToken;
        ItemToken: JsonToken;
        ItemObj: JsonObject;
        TitleToken: JsonToken;
        DayArray: JsonArray;
        ItemArray: JsonArray;
        Summary: TextBuilder;
        DayIndex: Integer;
        ItemIndex: Integer;
        Title: Text;
    begin
        ResponseObj.ReadFrom(ResponseText);

        // Try to get summary field first
        if ResponseObj.Get('summary', SummaryToken) then
            if not SummaryToken.AsValue().IsNull() then
                exit(SummaryToken.AsValue().AsText());

        // Fallback: build summary from days array
        Summary.AppendLine('=== Generated Itinerary ===');

        if ResponseObj.Get('days', DaysToken) then begin
            DayArray := DaysToken.AsArray();

            for DayIndex := 0 to DayArray.Count() - 1 do begin
                DayArray.Get(DayIndex, DayToken);
                DayObj := DayToken.AsObject();
                Summary.AppendLine('');
                Summary.AppendLine('Day ' + Format(DayIndex + 1) + ':');

                if DayObj.Get('items', ItemsToken) then begin
                    ItemArray := ItemsToken.AsArray();

                    for ItemIndex := 0 to ItemArray.Count() - 1 do begin
                        ItemArray.Get(ItemIndex, ItemToken);
                        ItemObj := ItemToken.AsObject();
                        if ItemObj.Get('title', TitleToken) then begin
                            Title := TitleToken.AsValue().AsText();
                            Summary.AppendLine('  • ' + Title);
                        end;
                    end;
                end;
            end;
        end;

        exit(Summary.ToText());
    end;

    procedure SetAIServerURL(NewURL: Text)
    begin
        AIServerURL := NewURL;
    end;

    procedure GetAIServerURL(): Text
    begin
        if AIServerURL = '' then
            AIServerURL := 'http://localhost:8000';
        exit(AIServerURL);
    end;
}
