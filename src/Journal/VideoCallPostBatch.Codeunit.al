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
    begin
        VideoJnlLine.SetRange("Batch Name", VideoCallBatch.Name);
        VideoJnlLine.FindSet();
        repeat
            VideoJnlLine.Post();
        until VideoJnlLine.Next() = 0;
    end;
}