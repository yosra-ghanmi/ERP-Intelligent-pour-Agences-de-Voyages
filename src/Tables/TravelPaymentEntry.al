table 50634 "Travel Payment Entry"
{
    DataClassification = CustomerContent;
    Caption = 'Travel Payment Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel Invoice Header"."Invoice No.";
        }
        field(3; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
            DataClassification = CustomerContent;
        }
        field(4; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(5; "Payment Method"; Option)
        {
            Caption = 'Payment Method';
            OptionMembers = "Cash","Bank Transfer","Credit Card","Check";
            DataClassification = CustomerContent;
        }
        field(6; "Reference No."; Code[50])
        {
            Caption = 'Reference No.';
            DataClassification = CustomerContent;
        }
        field(7; "Notes"; Text[250])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
