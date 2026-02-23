page 50613 "Travel Reservation List"
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

    actions
    {
        area(Processing)
        {
            action(GenerateItinerary)
            {
                ApplicationArea = All;
                Caption = 'Generate AI Itinerary';
                Image = Map;
                ToolTip = 'Generate a travel itinerary using AI based on this reservation.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AIItineraryGenerator: Codeunit "AI Itinerary Generator";
                    ItinerarySummary: Text;
                begin
                    ItinerarySummary := AIItineraryGenerator.GenerateItineraryForReservation(Rec."Reservation No.");
                    Message(ItinerarySummary);
                end;
            }
            action(CreateQuote)
            {
                ApplicationArea = All;
                Caption = 'Create Quote';
                Image = Quote;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    QuoteMgmt: Codeunit "Quote Management";
                begin
                    QuoteMgmt.CreateQuoteFromReservation(Rec."Reservation No.");
                    Message('Quote created successfully.');
                end;
            }
        }
    }
}
