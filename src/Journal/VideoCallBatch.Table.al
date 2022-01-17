table 50101 "Video Call Batch"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1;Name; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
    }
    
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }

    procedure Post()
    begin
        Codeunit.Run(Codeunit::"Video Call Post Batch", Rec);
    end;
}