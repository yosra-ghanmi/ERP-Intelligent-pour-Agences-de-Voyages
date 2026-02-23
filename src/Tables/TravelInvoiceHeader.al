table 50632 "Travel Invoice Header"
{
    DataClassification = CustomerContent;
    Caption = 'Travel Invoice Header';

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = CustomerContent;
        }
        field(2; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel Quote Header"."Quote No.";
        }
        field(3; "Client No."; Code[20])
        {
            Caption = 'Client No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel Client"."No.";
        }
        field(4; "Client Name"; Text[100])
        {
            Caption = 'Client Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Travel Client".Name where("No." = field("Client No.")));
            Editable = false;
        }
        field(5; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            DataClassification = CustomerContent;
        }
        field(6; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(7; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Open","Partial","Paid","Overdue";
            DataClassification = CustomerContent;
        }
        field(8; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Travel Invoice Line"."Line Amount" where("Invoice No." = field("Invoice No.")));
            Editable = false;
        }
        field(9; "Amount Paid"; Decimal)
        {
            Caption = 'Amount Paid';
            FieldClass = FlowField;
            CalcFormula = sum("Travel Payment Entry".Amount where("Invoice No." = field("Invoice No.")));
            Editable = false;
        }
        field(10; "Balance Due"; Decimal)
        {
            Caption = 'Balance Due';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
    }

    keys
    {
        key(PK; "Invoice No.")
        {
            Clustered = true;
        }
    }
}
