table 50601 "Travel Client"
{
    DataClassification = CustomerContent;
    Caption = 'Travel Client';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Client No.';
            DataClassification = CustomerContent;
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "AI_Preferences"; Text[250])
        {
            Caption = 'AI Preferences';
            DataClassification = CustomerContent;
            ToolTip = 'E.g., Luxe, Adventure, History';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
