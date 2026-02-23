table 50633 "Travel Invoice Line"
{
    DataClassification = CustomerContent;
    Caption = 'Travel Invoice Line';

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel Invoice Header"."Invoice No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            DataClassification = CustomerContent;
            TableRelation = "Travel Service"."Code";

            trigger OnValidate()
            var
                TravelService: Record "Travel Service";
            begin
                if TravelService.Get("Service Code") then begin
                    "Service Name" := TravelService.Name;
                    "Unit Price" := TravelService.Price;
                    if Quantity = 0 then
                        Quantity := 1;
                    UpdateLineAmount();
                end;
            end;
        }
        field(4; "Service Name"; Text[100])
        {
            Caption = 'Service Name';
            DataClassification = CustomerContent;
        }
        field(5; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateLineAmount();
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateLineAmount();
            end;
        }
        field(8; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Invoice No.", "Line No.")
        {
            Clustered = true;
        }
    }

    local procedure UpdateLineAmount()
    begin
        "Line Amount" := Quantity * "Unit Price";
    end;
}
