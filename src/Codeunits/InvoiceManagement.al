codeunit 50651 "Invoice Management"
{
    trigger OnRun()
    begin
    end;

    procedure CreateInvoiceFromQuote(QuoteNo: Code[20]): Code[20]
    var
        QuoteHeader: Record "Travel Quote Header";
        QuoteLine: Record "Travel Quote Line";
        InvoiceHeader: Record "Travel Invoice Header";
        InvoiceLine: Record "Travel Invoice Line";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        NewInvoiceNo: Code[20];
    begin
        if not QuoteHeader.Get(QuoteNo) then
            Error('Quote %1 not found.', QuoteNo);

        if QuoteHeader.Status <> QuoteHeader.Status::Accepted then
            Error('Cannot create invoice: Quote %1 is not Accepted.', QuoteNo);

        InvoiceHeader.SetRange("Quote No.", QuoteNo);
        if InvoiceHeader.FindFirst() then
            Error('An invoice already exists for Quote %1.', QuoteNo);
        InvoiceHeader.Reset();

        // Get next invoice number from NoSeries
        NewInvoiceNo := GetNextInvoiceNo();

        // Create Header
        InvoiceHeader.Init();
        InvoiceHeader."Invoice No." := NewInvoiceNo;
        InvoiceHeader."Quote No." := QuoteNo;
        InvoiceHeader."Client No." := QuoteHeader."Client No.";
        InvoiceHeader."Reservation No." := QuoteHeader."Reservation No.";
        InvoiceHeader."Invoice Date" := Today;
        InvoiceHeader."Due Date" := CalcDate('<30D>', Today);
        InvoiceHeader.Status := InvoiceHeader.Status::Open;
        InvoiceHeader.Insert(true);

        // Create Lines
        QuoteLine.SetRange("Quote No.", QuoteNo);
        if QuoteLine.FindSet() then
            repeat
                InvoiceLine.Init();
                InvoiceLine."Invoice No." := NewInvoiceNo;
                InvoiceLine."Line No." := QuoteLine."Line No.";
                InvoiceLine."Service Code" := QuoteLine."Service Code";
                InvoiceLine."Service Name" := QuoteLine."Service Name";
                InvoiceLine.Description := QuoteLine.Description;
                InvoiceLine.Quantity := QuoteLine.Quantity;
                InvoiceLine."Unit Price" := QuoteLine."Unit Price";
                InvoiceLine."Line Amount" := QuoteLine."Line Amount";
                InvoiceLine.Insert(true);
            until QuoteLine.Next() = 0;

        UpdateInvoiceStatus(NewInvoiceNo);
        exit(NewInvoiceNo);
    end;

    local procedure GetNextInvoiceNo(): Code[20]
    var
        NoSeriesLine: Record "No. Series";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
    begin
        // Try to get NoSeries, create default if not exists
        if not NoSeriesLine.Get('TRAVELINVOICE') then begin
            NoSeriesLine.Init();
            NoSeriesLine.Code := 'TRAVELINVOICE';
            NoSeriesLine.Description := 'Travel Invoice Numbers';
            NoSeriesLine."Default Nos." := true;
            NoSeriesLine.Insert(true);
        end;

        exit(NoSeriesMgmt.GetNextNo('TRAVELINVOICE', Today, true));
    end;

    procedure RegisterPayment(InvoiceNo: Code[20]; Amount: Decimal; PaymentMethod: Option): Integer
    var
        PaymentEntry: Record "Travel Payment Entry";
        InvoiceHeader: Record "Travel Invoice Header";
        RemainingAmount: Decimal;
    begin
        if not InvoiceHeader.Get(InvoiceNo) then
            Error('Invoice %1 not found.', InvoiceNo);

        // Calculate remaining amount
        InvoiceHeader.CalcFields("Total Amount", "Amount Paid");
        RemainingAmount := InvoiceHeader."Total Amount" - InvoiceHeader."Amount Paid";

        // Validate payment amount
        if Amount <= 0 then
            Error('Payment amount must be greater than zero.');
        if Amount > RemainingAmount then
            Error('Payment amount (%1) exceeds remaining balance (%2).', Amount, RemainingAmount);

        PaymentEntry.Init();
        PaymentEntry."Invoice No." := InvoiceNo;
        PaymentEntry."Payment Date" := Today;
        PaymentEntry.Amount := Amount;
        PaymentEntry."Payment Method" := PaymentMethod;
        PaymentEntry.Insert(true);

        UpdateInvoiceStatus(InvoiceNo);
        exit(PaymentEntry."Entry No.");
    end;

    procedure UpdateInvoiceStatus(InvoiceNo: Code[20])
    var
        InvoiceHeader: Record "Travel Invoice Header";
        Res: Record "Travel Reservation";
    begin
        if InvoiceHeader.Get(InvoiceNo) then begin
            InvoiceHeader.CalcFields("Total Amount", "Amount Paid");
            InvoiceHeader."Balance Due" := InvoiceHeader."Total Amount" - InvoiceHeader."Amount Paid";

            // Handle overpayment case - set balance to 0 if overpaid
            if InvoiceHeader."Balance Due" < 0 then
                InvoiceHeader."Balance Due" := 0;

            if InvoiceHeader."Balance Due" <= 0 then
                InvoiceHeader.Status := InvoiceHeader.Status::Paid
            else if InvoiceHeader."Amount Paid" > 0 then
                InvoiceHeader.Status := InvoiceHeader.Status::Partial
            else if InvoiceHeader."Due Date" < Today then
                InvoiceHeader.Status := InvoiceHeader.Status::Overdue
            else
                InvoiceHeader.Status := InvoiceHeader.Status::Open;

            InvoiceHeader.Modify();

            if InvoiceHeader.Status = InvoiceHeader.Status::Paid then
                if InvoiceHeader."Reservation No." <> '' then
                    if Res.Get(InvoiceHeader."Reservation No.") then begin
                        Res.Status := Res.Status::Confirmed;
                        Res.Modify();
                    end;
        end;
    end;
}
