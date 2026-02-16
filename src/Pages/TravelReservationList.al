page 50107 "Travel Reservation List"
{
    PageType = List;
    SourceTable = "Travel Reservation";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Travel Reservations';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Reservation No."; Rec."Reservation No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the reservation.';
                }
                field("Client No."; Rec."Client No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier of the client.';
                    Lookup = true;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the client.';
                }
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier of the booked service.';
                    Lookup = true;
                }
                field("Service Name"; Rec."Service Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the booked service.';
                }
                field("Reservation Date"; Rec."Reservation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date of the reservation.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the reservation.';
                }
            }
        }
    }
}
