codeunit 50651 "Invoice Management"
{
    procedure CreateInvoiceFromQuote(QuoteNo: Code[20]): Code[20]
    var
        QuoteHeader: Record "Travel Quote Header";
        QuoteLine: Record "Travel Quote Line";
        InvoiceHeader: Record "Travel Invoice Header";
        InvoiceLine: Record "Travel Invoice Line";
        NewInvoiceNo: Code[20];
    begin
        if not QuoteHeader.Get(QuoteNo) then
            Error('Quote %1 not found.', QuoteNo);

        // Create Header
        NewInvoiceNo := 'INV-' + Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>');
        InvoiceHeader.Init();
        InvoiceHeader."Invoice No." := NewInvoiceNo;
        InvoiceHeader."Quote No." := QuoteNo;
        InvoiceHeader."Client No." := QuoteHeader."Client No.";
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

    procedure RegisterPayment(InvoiceNo: Code[20]; Amount: Decimal; PaymentMethod: Option): Integer
    var
        PaymentEntry: Record "Travel Payment Entry";
        InvoiceHeader: Record "Travel Invoice Header";
    begin
        if not InvoiceHeader.Get(InvoiceNo) then
            Error('Invoice %1 not found.', InvoiceNo);

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
    begin
        if InvoiceHeader.Get(InvoiceNo) then begin
            InvoiceHeader.CalcFields("Total Amount", "Amount Paid");
            InvoiceHeader."Balance Due" := InvoiceHeader."Total Amount" - InvoiceHeader."Amount Paid";

            if InvoiceHeader."Balance Due" <= 0 then
                InvoiceHeader.Status := InvoiceHeader.Status::Paid
            else if InvoiceHeader."Amount Paid" > 0 then
                InvoiceHeader.Status := InvoiceHeader.Status::Partial
            else if InvoiceHeader."Due Date" < Today then
                InvoiceHeader.Status := InvoiceHeader.Status::Overdue
            else
                InvoiceHeader.Status := InvoiceHeader.Status::Open;

            InvoiceHeader.Modify();
        end;
    end;
}
