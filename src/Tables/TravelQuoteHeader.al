table 50630 "Travel Quote Header"
{
    DataClassification = CustomerContent;
    Caption = 'Travel Quote Header';

    fields
    {
        field(1; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(2; "Client No."; Code[20])
        {
            Caption = 'Client No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel Client"."No.";
        }
        field(3; "Client Name"; Text[100])
        {
            Caption = 'Client Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Travel Client".Name where("No." = field("Client No.")));
            Editable = false;
        }
        field(4; "Client Address"; Text[100])
        {
            Caption = 'Client Address';
            DataClassification = CustomerContent;
        }
        field(5; "Quote Date"; Date)
        {
            Caption = 'Quote Date';
            DataClassification = CustomerContent;
        }
        field(6; "Valid Until Date"; Date)
        {
            Caption = 'Valid Until Date';
            DataClassification = CustomerContent;
        }
        field(7; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Draft","Sent","Accepted","Rejected","Expired";
            DataClassification = CustomerContent;
        }
        field(8; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Travel Quote Line"."Line Amount" where("Quote No." = field("Quote No.")));
            Editable = false;
        }
        field(9; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
        field(10; "AI Itinerary Summary"; Text[2048])
        {
            Caption = 'AI Itinerary Summary';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Quote No.")
        {
            Clustered = true;
        }
    }
}
