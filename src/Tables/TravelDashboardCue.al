table 50647 "Travel Dashboard Cue"
{
    DataClassification = CustomerContent;
    Caption = 'Travel Dashboard Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Total Clients"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Travel Client");
            Caption = 'Total Clients';
        }
        field(3; "Total Reservations"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Travel Reservation");
            Caption = 'Total Reservations';
        }
        field(4; "Pending Quotes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Travel Quote Header" where(Status = const(Sent)));
            Caption = 'Pending Quotes';
        }
        field(5; "Total Revenue"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Travel Payment Entry".Amount);
            Caption = 'Total Revenue';
        }
        field(6; "Monthly Revenue"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Monthly Revenue';
        }
        field(7; "Top Destination"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Top Destination';
        }
        field(8; "Conversion Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Conversion Rate (%)';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
