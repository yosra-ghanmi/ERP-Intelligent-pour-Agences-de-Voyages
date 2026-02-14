table 50102 "Travel Reservation"
{
    DataClassification = ToBeClassified;
    Caption = 'Travel Reservation';

    fields
    {
        field(1; "Reservation No."; Code[20])
        {
            Caption = 'Reservation No.';
            DataClassification = CustomerContent;
        }
        field(2; "Client No."; Code[20])
        {
            Caption = 'Client No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel Client"."No.";
        }
        field(3; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            DataClassification = CustomerContent;
            TableRelation = "Travel Service"."Code";
        }
        field(4; "Reservation Date"; Date)
        {
            Caption = 'Reservation Date';
            DataClassification = CustomerContent;
        }
        field(5; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Pending","Confirmed","Cancelled";
            DataClassification = CustomerContent;
        }
        // Helper fields for display
        field(10; "Client Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Travel Client".Name where("No." = field("Client No.")));
            Editable = false;
            Caption = 'Client Name';
        }
        field(11; "Service Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Travel Service".Name where("Code" = field("Service Code")));
            Editable = false;
            Caption = 'Service Name';
        }
    }

    keys
    {
        key(PK; "Reservation No.")
        {
            Clustered = true;
        }
    }
}
