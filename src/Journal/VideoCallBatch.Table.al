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
    var
        VideoCallBatchPost: Codeunit "Video Call Post Batch";
    begin
        VideoCallBatchPost.Run(Rec);
    end;
}