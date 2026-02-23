codeunit 50652 "Dashboard Calculations"
{
    procedure CalculateMonthlyRevenue(): Decimal
    var
        PaymentEntry: Record "Travel Payment Entry";
        Total: Decimal;
        StartOfMonth: Date;
        EndOfMonth: Date;
    begin
        StartOfMonth := CalcDate('<-CM>', Today);
        EndOfMonth := CalcDate('<CM>', Today);

        PaymentEntry.SetRange("Payment Date", StartOfMonth, EndOfMonth);
        if PaymentEntry.FindSet() then
            repeat
                Total += PaymentEntry.Amount;
            until PaymentEntry.Next() = 0;

        exit(Total);
    end;

    procedure CalculateTopDestination(): Text[50]
    var
        Res: Record "Travel Reservation";
        Service: Record "Travel Service";
        DestCount: Dictionary of [Text, Integer];
        Dest: Text;
        MaxCount: Integer;
        TopDest: Text[50];
    begin
        if Res.FindSet() then
            repeat
                if Service.Get(Res."Service Code") then begin
                    if Service.Location <> '' then begin
                        if DestCount.ContainsKey(Service.Location) then
                            DestCount.Set(Service.Location, DestCount.Get(Service.Location) + 1)
                        else
                            DestCount.Add(Service.Location, 1);
                    end;
                end;
            until Res.Next() = 0;

        MaxCount := 0;
        foreach Dest in DestCount.Keys() do begin
            if DestCount.Get(Dest) > MaxCount then begin
                MaxCount := DestCount.Get(Dest);
                TopDest := CopyStr(Dest, 1, 50);
            end;
        end;

        exit(TopDest);
    end;

    procedure CalculateConversionRate(): Decimal
    var
        Quote: Record "Travel Quote Header";
        TotalQuotes: Integer;
        ConvertedQuotes: Integer;
    begin
        TotalQuotes := Quote.Count();
        if TotalQuotes = 0 then
            exit(0);

        ConvertedQuotes := 0;
        if Quote.FindSet() then
            repeat
                if InvoiceExistsForQuote(Quote."Quote No.") then
                    ConvertedQuotes += 1;
            until Quote.Next() = 0;

        exit(Round((ConvertedQuotes / TotalQuotes) * 100, 0.01));
    end;

    local procedure InvoiceExistsForQuote(QuoteNo: Code[20]): Boolean
    var
        Inv: Record "Travel Invoice Header";
    begin
        if QuoteNo = '' then exit(false);
        Inv.SetRange("Quote No.", QuoteNo);
        exit(not Inv.IsEmpty());
    end;

    procedure PopulateRevenueByMonth(var BusChartBuf: Record "Business Chart Buffer")
    var
        PaymentEntry: Record "Travel Payment Entry";
        Month: Integer;
        Year: Integer;
        I: Integer;
        MonthName: Text;
        RevByMonth: array[12] of Decimal;
    begin
        BusChartBuf.Initialize();
        BusChartBuf.AddMeasure('Revenue', 1, BusChartBuf."Data Type"::Decimal, BusChartBuf."Chart Type"::Column);
        BusChartBuf.SetXAxis('Month', BusChartBuf."Data Type"::String);

        Year := Date2DMY(Today, 3);
        PaymentEntry.Reset();
        if PaymentEntry.FindSet() then
            repeat
                if Date2DMY(PaymentEntry."Payment Date", 3) = Year then begin
                    Month := Date2DMY(PaymentEntry."Payment Date", 2);
                    if (Month >= 1) and (Month <= 12) then
                        RevByMonth[Month] += PaymentEntry.Amount;
                end;
            until PaymentEntry.Next() = 0;

        for I := 1 to 12 do begin
            MonthName := Format(DMY2Date(1, I, Year), 0, '<Month Text,3>');
            BusChartBuf.AddColumn(MonthName);
            BusChartBuf.SetValueByIndex(0, I - 1, RevByMonth[I]);
        end;
    end;

    procedure PopulateResByStatus(var BusChartBuf: Record "Business Chart Buffer")
    var
        Res: Record "Travel Reservation";
        PendingCount, ConfirmedCount, CancelledCount : Integer;
    begin
        BusChartBuf.Initialize();
        BusChartBuf.AddMeasure('Reservations', 1, BusChartBuf."Data Type"::Integer, BusChartBuf."Chart Type"::Pie);
        BusChartBuf.SetXAxis('Status', BusChartBuf."Data Type"::String);

        Res.Reset();
        Res.SetRange(Status, Res.Status::Pending);
        PendingCount := Res.Count();

        Res.SetRange(Status, Res.Status::Confirmed);
        ConfirmedCount := Res.Count();

        Res.SetRange(Status, Res.Status::Cancelled);
        CancelledCount := Res.Count();

        BusChartBuf.AddColumn('Pending');
        BusChartBuf.SetValueByIndex(0, 0, PendingCount);

        BusChartBuf.AddColumn('Confirmed');
        BusChartBuf.SetValueByIndex(0, 1, ConfirmedCount);

        BusChartBuf.AddColumn('Cancelled');
        BusChartBuf.SetValueByIndex(0, 2, CancelledCount);
    end;

    procedure PopulateTopServices(var BusChartBuf: Record "Business Chart Buffer")
    var
        Res: Record "Travel Reservation";
        Service: Record "Travel Service";
        ServiceCount: Dictionary of [Code[20], Integer];
        SvcCode: Code[20];
        I, J : Integer;
        TempCode: Code[20];
        TempCount: Integer;
        Codes: List of [Code[20]];
        Counts: List of [Integer];
    begin
        BusChartBuf.Initialize();
        BusChartBuf.AddMeasure('Reservations', 1, BusChartBuf."Data Type"::Integer, BusChartBuf."Chart Type"::Column);
        BusChartBuf.SetXAxis('Service', BusChartBuf."Data Type"::String);

        if Res.FindSet() then
            repeat
                if Res."Service Code" <> '' then begin
                    if ServiceCount.ContainsKey(Res."Service Code") then
                        ServiceCount.Set(Res."Service Code", ServiceCount.Get(Res."Service Code") + 1)
                    else
                        ServiceCount.Add(Res."Service Code", 1);
                end;
            until Res.Next() = 0;

        foreach SvcCode in ServiceCount.Keys() do begin
            Codes.Add(SvcCode);
            Counts.Add(ServiceCount.Get(SvcCode));
        end;

        for I := 1 to Counts.Count() do begin
            for J := I + 1 to Counts.Count() do begin
                if Counts.Get(J) > Counts.Get(I) then begin
                    TempCount := Counts.Get(I);
                    TempCode := Codes.Get(I);

                    Counts.Set(I, Counts.Get(J));
                    Codes.Set(I, Codes.Get(J));

                    Counts.Set(J, TempCount);
                    Codes.Set(J, TempCode);
                end;
            end;
        end;

        for I := 1 to 5 do begin
            if I <= Codes.Count() then begin
                if Service.Get(Codes.Get(I)) then
                    BusChartBuf.AddColumn(Service.Name)
                else
                    BusChartBuf.AddColumn(Codes.Get(I));
                BusChartBuf.SetValueByIndex(0, I - 1, Counts.Get(I));
            end;
        end;
    end;

    procedure PopulateRevByServiceType(var BusChartBuf: Record "Business Chart Buffer")
    var
        InvLine: Record "Travel Invoice Line";
        InvHeader: Record "Travel Invoice Header";
        Service: Record "Travel Service";
        RevByType: Dictionary of [Integer, Decimal];
        OptVal: Integer;
        ColIndex: Integer;
    begin
        BusChartBuf.Initialize();
        BusChartBuf.AddMeasure('Revenue', 1, BusChartBuf."Data Type"::Decimal, BusChartBuf."Chart Type"::Pie);
        BusChartBuf.SetXAxis('Service Type', BusChartBuf."Data Type"::String);

        InvHeader.SetRange(Status, InvHeader.Status::Paid);
        if InvHeader.FindSet() then
            repeat
                InvLine.SetRange("Invoice No.", InvHeader."Invoice No.");
                if InvLine.FindSet() then
                    repeat
                        if Service.Get(InvLine."Service Code") then begin
                            OptVal := Service."Service Type";
                            if RevByType.ContainsKey(OptVal) then
                                RevByType.Set(OptVal, RevByType.Get(OptVal) + InvLine."Line Amount")
                            else
                                RevByType.Add(OptVal, InvLine."Line Amount");
                        end;
                    until InvLine.Next() = 0;
            until InvHeader.Next() = 0;

        ColIndex := 0;
        foreach OptVal in RevByType.Keys() do begin
            Service."Service Type" := OptVal;
            BusChartBuf.AddColumn(Format(Service."Service Type"));
            BusChartBuf.SetValueByIndex(0, ColIndex, RevByType.Get(OptVal));
            ColIndex += 1;
        end;
    end;
}
