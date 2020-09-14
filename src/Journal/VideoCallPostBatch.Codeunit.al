codeunit 50102 "Video Call Post Batch"
{
    TableNo = "Video Call Batch";

    trigger OnRun()
    begin
        PostBatch(Rec);
    end;

    local procedure PostBatch(VideoCallBatch: Record "Video Call Batch")
    var
        VideoJnlLine: Record "Video Journal Line";
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorContextElement: Codeunit "Error Context Element";
    begin
        ErrorMessageMgt.PushContext(ErrorContextElement, VideoCallBatch, 0, '');

        VideoJnlLine.SetRange("Batch Name", VideoCallBatch.Name);
        VideoJnlLine.FindSet();
        repeat
            VideoJnlLine.Post();
        until VideoJnlLine.Next() = 0;

        ErrorMessageMgt.Finish(VideoCallBatch);
    end;
}