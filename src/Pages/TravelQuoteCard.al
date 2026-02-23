page 50641 "Travel Quote Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Travel Quote Header";
    Caption = 'Travel Quote Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Client Address"; Rec."Client Address")
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "Travel Quote Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Quote No." = field("Quote No.");
                UpdatePropagation = Both;
            }
            group(Totals)
            {
                Caption = 'Totals';
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
            group(AI)
            {
                Caption = 'AI Summary';
                field("AI Itinerary Summary"; Rec."AI Itinerary Summary")
                {
                    ApplicationArea = All;
                    MultiLine = true;
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
