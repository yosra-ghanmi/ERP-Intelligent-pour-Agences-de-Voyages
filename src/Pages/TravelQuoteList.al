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
