page 50610 "Travel Service List"
{
    PageType = List;
    SourceTable = "Travel Service";
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Travel Services Catalogue';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the travel service.';
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the travel service.';
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of service (e.g., Hotel, Flight, Tour).';
                }
                field("Location"; Rec."Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'City or location of the service.';
                }
                field("Price"; Rec."Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Price of the service.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency used for the price.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Short description for AI analysis.';
                }
                field("Latitude"; Rec."Latitude")
                {
                    ApplicationArea = All;
                    ToolTip = 'Geographical latitude for mapping.';
                }
                field("Longitude"; Rec."Longitude")
                {
                    ApplicationArea = All;
                    ToolTip = 'Geographical longitude for mapping.';
                }
                field("Long Description"; Rec."Long Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Detailed description for AI itinerary generation.';
                }
            }
        }
    }
}
