page 50102 "Travel Client API"
{
    PageType = API;
    Caption = 'Travel Client API';
    APIPublisher = 'SmartTravel';
    APIGroup = 'Travel';
    APIVersion = 'v1.0';
    EntityName = 'travelClient';
    EntitySetName = 'travelClients';
    SourceTable = "Travel Client";
    DelayedInsert = true;
    ODataKeyFields = "No.";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(no; Rec."No.")
                {
                    Caption = 'Client No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(aiPreferences; Rec."AI_Preferences")
                {
                    Caption = 'AI Preferences';
                }
            }
        }
    }
}