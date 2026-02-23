table 50631 "Travel Quote Line"
{
    DataClassification = CustomerContent;
    Caption = 'Travel Quote Line';

    fields
    {
        field(1; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel Quote Header"."Quote No.";
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
                    "Service Type" := TravelService."Service Type";
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
        field(9; "Service Type"; Option)
        {
            Caption = 'Service Type';
            DataClassification = CustomerContent;
            OptionMembers = " ","Hotel","Flight","Tour","Car Rental","Activity";
        }
    }

    keys
    {
        key(PK; "Quote No.", "Line No.")
        {
            Clustered = true;
        }
    }

    local procedure UpdateLineAmount()
    begin
        "Line Amount" := Quantity * "Unit Price";
    end;
}
