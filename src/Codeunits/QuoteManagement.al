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

        // Create Header
        NewQuoteNo := 'QT-' + Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>'); // Simple numbering for now
        QuoteHeader.Init();
        QuoteHeader."Quote No." := NewQuoteNo;
        QuoteHeader."Client No." := Reservation."Client No.";
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

        if QuoteHeader.Status = QuoteHeader.Status::Expired then
            Error('Cannot convert an expired quote.');

        QuoteHeader.Status := QuoteHeader.Status::Accepted;
        QuoteHeader.Modify();

        exit(InvoiceMgmt.CreateInvoiceFromQuote(QuoteNo));
    end;
}
