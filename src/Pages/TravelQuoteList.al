page 50640 "Travel Quote List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Travel Quote Header";
    CardPageId = "Travel Quote Card";
    Caption = 'Travel Quotes';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
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
                field("Quote Date"; Rec."Quote Date")
                {
                    ApplicationArea = All;
                }
                field("Valid Until Date"; Rec."Valid Until Date")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendQuote)
            {
                ApplicationArea = All;
                Caption = 'Mark as Sent';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    QuoteMgmt: Codeunit "Quote Management";
                begin
                    QuoteMgmt.SetQuoteStatusSent(Rec."Quote No.");
                end;
            }
            action(AcceptQuote)
            {
                ApplicationArea = All;
                Caption = 'Mark as Accepted';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    QuoteMgmt: Codeunit "Quote Management";
                begin
                    QuoteMgmt.SetQuoteStatusAccepted(Rec."Quote No.");
                end;
            }
            action(RejectQuote)
            {
                ApplicationArea = All;
                Caption = 'Mark as Rejected';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    QuoteMgmt: Codeunit "Quote Management";
                begin
                    QuoteMgmt.SetQuoteStatusRejected(Rec."Quote No.");
                end;
            }
            action(ConvertQuote)
            {
                ApplicationArea = All;
                Caption = 'Convert to Invoice';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    QuoteMgmt: Codeunit "Quote Management";
                begin
                    QuoteMgmt.ConvertQuoteToInvoice(Rec."Quote No.");
                end;
            }
        }
    }
}
