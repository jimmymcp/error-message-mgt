codeunit 50102 "Video Call Post Batch"
{
    TableNo = "Video Call Batch";

    trigger OnRun()
    begin
        CheckLines(Rec);
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

    [ErrorBehavior(ErrorBehavior::Collect)]
    local procedure CheckLines(VideoCallBatch: Record "Video Call Batch")
    var
        VideoJnlLine: Record "Video Journal Line";
        ShowErrors: Codeunit "Show Errors";
    begin
        VideoJnlLine.SetRange("Batch Name", VideoCallBatch.Name);
        VideoJnlLine.FindSet();
        repeat
            Codeunit.Run(Codeunit::"Video Jnl. Check Line", VideoJnlLine);
        until VideoJnlLine.Next() = 0;

        ShowErrors.ShowErrors(GetCollectedErrors(), VideoCallBatch);
        
    end;
}