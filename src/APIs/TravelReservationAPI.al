page 50615 "Travel Reservation API"
{
    PageType = API;
    Caption = 'Travel Reservation API';
    APIPublisher = 'defaultPublisher';
    APIGroup = 'travel';
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
                field(clientName; Rec."Client Name")
                {
                    Caption = 'Client Name';
                }
                field(serviceCode; Rec."Service Code")
                {
                    Caption = 'Service Code';
                }
                field(serviceName; Rec."Service Name")
                {
                    Caption = 'Service Name';
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
