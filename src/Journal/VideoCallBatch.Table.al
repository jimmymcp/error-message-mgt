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
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorMessageHandler: Codeunit "Error Message Handler";
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        if not VideoCallBatchPost.Run(Rec) then
            ErrorMessageHandler.ShowErrors();
    end;
}