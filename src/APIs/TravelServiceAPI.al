page 50101 "Travel Service API"
{
    PageType = API;
    Caption = 'Travel Service API';
    APIPublisher = 'SmartTravel';
    APIGroup = 'Travel';
    APIVersion = 'v1.0';
    EntityName = 'travelService';
    EntitySetName = 'travelServices';
    SourceTable = "Travel Service";
    DelayedInsert = true;
    ODataKeyFields = "Code";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(code; Rec.Code)
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(serviceType; Rec."Service Type")
                {
                    Caption = 'Service Type';
                }
                field(price; Rec.Price)
                {
                    Caption = 'Price';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(location; Rec.Location)
                {
                    Caption = 'Location';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(latitude; Rec.Latitude)
                {
                    Caption = 'Latitude';
                }
                field(longitude; Rec.Longitude)
                {
                    Caption = 'Longitude';
                }
                field(longDescription; Rec."Long Description")
                {
                    Caption = 'Long Description';
                }
            }
        }
    }
}
