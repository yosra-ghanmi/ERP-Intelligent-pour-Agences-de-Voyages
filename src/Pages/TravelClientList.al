page 50102 "Travel Client List"
{
    PageType = List;
    SourceTable = "Travel Client";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Travel Clients';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the client.';
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the client.';
                }
                field("AI_Preferences"; Rec."AI_Preferences")
                {
                    ApplicationArea = All;
                    ToolTip = 'Client travel preferences for AI.';
                }
            }
        }
    }
}
