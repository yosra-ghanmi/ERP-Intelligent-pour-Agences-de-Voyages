table 50100 "Travel Service"
{
    DataClassification = ToBeClassified;
    Caption = 'Travel Service';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'Service Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Service Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = " ","Hotel","Flight","Tour","Car Rental","Activity";
        }
        field(4; "Price"; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 3; // Supporte TND (3 digits) w EUR/USD (2 digits)
        }
        field(5; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency; // Yjib l'Euro w Dollar mel BC standard
        }
        field(6; "Location"; Text[50])
        {
            Caption = 'Location (City)';
        }
        field(7; "Description"; Text[2048])
        {
            Caption = 'AI Description';
            ToolTip = 'Hott hna el détails elli el IA (Gemini) bech testa3malhom.';
        }
        field(8; "Latitude"; Decimal)
        {
            Caption = 'Latitude';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 8;
        }
        field(9; "Longitude"; Decimal)
        {
            Caption = 'Longitude';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 8;
        }
        field(10; "Long Description"; Text[2048])
        {
            Caption = 'Long Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}