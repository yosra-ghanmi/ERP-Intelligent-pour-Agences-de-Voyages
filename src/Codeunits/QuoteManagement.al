codeunit 50650 "Quote Management"
{
    procedure CreateQuoteFromReservation(ReservationNo: Code[20]): Code[20]
    var
        Reservation: Record "Travel Reservation";
        QuoteHeader: Record "Travel Quote Header";
        QuoteLine: Record "Travel Quote Line";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        NewQuoteNo: Code[20];
    begin
        if not Reservation.Get(ReservationNo) then
            Error('Reservation %1 not found.', ReservationNo);

        // Get next quote number from NoSeries
        NewQuoteNo := GetNextQuoteNo();

        // Create Header
        QuoteHeader.Init();
        QuoteHeader."Quote No." := NewQuoteNo;
        QuoteHeader."Client No." := Reservation."Client No.";
        QuoteHeader."Reservation No." := ReservationNo;
        QuoteHeader."Quote Date" := Today;
        QuoteHeader."Valid Until Date" := CalcDate('<30D>', Today);
        QuoteHeader.Status := QuoteHeader.Status::Draft;
        QuoteHeader.Insert(true);

        // Create Line
        QuoteLine.Init();
        QuoteLine."Quote No." := NewQuoteNo;
        QuoteLine."Line No." := 10000;
        QuoteLine.Validate("Service Code", Reservation."Service Code");
        QuoteLine.Insert(true);

        exit(NewQuoteNo);
    end;

    local procedure GetNextQuoteNo(): Code[20]
    var
        NoSeriesLine: Record "No. Series";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
    begin
        // Try to get NoSeries, create default if not exists
        if not NoSeriesLine.Get('TRAVELQUOTE') then begin
            NoSeriesLine.Init();
            NoSeriesLine.Code := 'TRAVELQUOTE';
            NoSeriesLine.Description := 'Travel Quote Numbers';
            NoSeriesLine."Default Nos." := true;
            NoSeriesLine.Insert(true);
        end;

        exit(NoSeriesMgmt.GetNextNo('TRAVELQUOTE', Today, true));
    end;

    procedure CalculateQuoteTotals(QuoteNo: Code[20]): Decimal
    var
        QuoteHeader: Record "Travel Quote Header";
    begin
        if QuoteHeader.Get(QuoteNo) then begin
            QuoteHeader.CalcFields("Total Amount");
            exit(QuoteHeader."Total Amount");
        end;
        exit(0);
    end;

    procedure ConvertQuoteToInvoice(QuoteNo: Code[20]): Code[20]
    var
        QuoteHeader: Record "Travel Quote Header";
        InvoiceMgmt: Codeunit "Invoice Management";
    begin
        if not QuoteHeader.Get(QuoteNo) then
            Error('Quote %1 not found.', QuoteNo);

        if QuoteHeader.Status <> QuoteHeader.Status::Accepted then
            Error('Invoice can only be created from an Accepted quote.');

        exit(InvoiceMgmt.CreateInvoiceFromQuote(QuoteNo));
    end;

    procedure SetQuoteStatusSent(QuoteNo: Code[20])
    var
        QuoteHeader: Record "Travel Quote Header";
    begin
        if not QuoteHeader.Get(QuoteNo) then
            Error('Quote %1 not found.', QuoteNo);
        if QuoteHeader.Status <> QuoteHeader.Status::Draft then
            Error('Only Draft quotes can be marked as Sent.');
        QuoteHeader.Status := QuoteHeader.Status::Sent;
        QuoteHeader.Modify();
    end;

    procedure SetQuoteStatusAccepted(QuoteNo: Code[20])
    var
        QuoteHeader: Record "Travel Quote Header";
    begin
        if not QuoteHeader.Get(QuoteNo) then
            Error('Quote %1 not found.', QuoteNo);
        if QuoteHeader.Status <> QuoteHeader.Status::Sent then
            Error('Only Sent quotes can be marked as Accepted.');
        QuoteHeader.Status := QuoteHeader.Status::Accepted;
        QuoteHeader.Modify();
    end;

    procedure SetQuoteStatusRejected(QuoteNo: Code[20])
    var
        QuoteHeader: Record "Travel Quote Header";
        Reservation: Record "Travel Reservation";
    begin
        if not QuoteHeader.Get(QuoteNo) then
            Error('Quote %1 not found.', QuoteNo);
        if QuoteHeader.Status <> QuoteHeader.Status::Sent then
            Error('Only Sent quotes can be marked as Rejected.');
        QuoteHeader.Status := QuoteHeader.Status::Rejected;
        QuoteHeader.Modify();

        if QuoteHeader."Reservation No." <> '' then
            if Reservation.Get(QuoteHeader."Reservation No.") then begin
                Reservation.Status := Reservation.Status::Cancelled;
                Reservation.Modify();
            end;
    end;

    procedure ExpireQuotes()
    var
        QuoteHeader: Record "Travel Quote Header";
    begin
        QuoteHeader.SetRange(Status, QuoteHeader.Status::Sent);
        QuoteHeader.SetFilter("Valid Until Date", '<%1', Today);
        if QuoteHeader.FindSet() then
            repeat
                QuoteHeader.Status := QuoteHeader.Status::Expired;
                QuoteHeader.Modify();
            until QuoteHeader.Next() = 0;
    end;

    procedure GetActiveQuoteCount(): Integer
    var
        QuoteHeader: Record "Travel Quote Header";
    begin
        // Count quotes that are Draft, Sent, or Accepted (not Rejected, Expired, or converted to Invoice)
        QuoteHeader.SetFilter(Status, '%1|%2|%3',
            QuoteHeader.Status::Draft,
            QuoteHeader.Status::Sent,
            QuoteHeader.Status::Accepted);
        exit(QuoteHeader.Count());
    end;

    procedure GetConvertedQuoteCount(): Integer
    var
        QuoteHeader: Record "Travel Quote Header";
        ConvertedCount: Integer;
    begin
        ConvertedCount := 0;
        QuoteHeader.SetRange(Status, QuoteHeader.Status::Accepted);
        if QuoteHeader.FindSet() then
            repeat
                if InvoiceExistsForAcceptedQuote(QuoteHeader."Quote No.") then
                    ConvertedCount += 1;
            until QuoteHeader.Next() = 0;
        exit(ConvertedCount);
    end;

    local procedure InvoiceExistsForAcceptedQuote(QuoteNo: Code[20]): Boolean
    var
        InvoiceHeader: Record "Travel Invoice Header";
    begin
        InvoiceHeader.SetRange("Quote No.", QuoteNo);
        exit(not InvoiceHeader.IsEmpty());
    end;
}
