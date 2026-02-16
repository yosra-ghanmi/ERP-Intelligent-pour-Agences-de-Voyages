page 50103 "Travel Reservation API"
{
    PageType = API;
    Caption = 'Travel Reservation API';
    APIPublisher = 'SmartTravel';
    APIGroup = 'Travel';
    APIVersion = 'v1.0';
    EntityName = 'travelReservation';
    EntitySetName = 'travelReservations';
    SourceTable = "Travel Reservation";
    DelayedInsert = true;
    ODataKeyFields = "Reservation No.";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(reservationNo; Rec."Reservation No.")
                {
                    Caption = 'Reservation No.';
                }
                field(clientNo; Rec."Client No.")
                {
                    Caption = 'Client No.';
                }
                field(serviceCode; Rec."Service Code")
                {
                    Caption = 'Service Code';
                }
                field(reservationDate; Rec."Reservation Date")
                {
                    Caption = 'Reservation Date';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
            }
        }
    }
}