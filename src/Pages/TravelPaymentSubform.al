page 50646 "Travel Payment Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Travel Payment Entry";
    Caption = 'Payments';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = All;
                }
                field("Notes"; Rec."Notes")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
