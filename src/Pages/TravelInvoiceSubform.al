page 50645 "Travel Invoice Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Travel Invoice Line";
    Caption = 'Lines';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = All;
                }
                field("Service Name"; Rec."Service Name")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
