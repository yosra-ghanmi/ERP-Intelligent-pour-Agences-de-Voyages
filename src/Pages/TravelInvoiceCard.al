page 50644 "Travel Invoice Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Travel Invoice Header";
    Caption = 'Travel Invoice Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = All;
                }
                field("Client No."; Rec."Client No.")
                {
                    ApplicationArea = All;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = All;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "Travel Invoice Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Invoice No." = field("Invoice No.");
                UpdatePropagation = Both;
            }
            group(Totals)
            {
                Caption = 'Totals';
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ApplicationArea = All;
                }
                field("Balance Due"; Rec."Balance Due")
                {
                    ApplicationArea = All;
                }
            }
            part(Payments; "Travel Payment Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Invoice No." = field("Invoice No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RegisterPayment)
            {
                ApplicationArea = All;
                Caption = 'Register Payment';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    InvoiceMgmt: Codeunit "Invoice Management";
                begin
                    InvoiceMgmt.RegisterPayment(Rec."Invoice No.", Rec."Balance Due", 0); // Default to Cash
                end;
            }
        }
    }
}
