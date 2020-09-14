codeunit 50100 "Video Jnl. Post Line"
{
    TableNo = "Video Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    procedure RunWithCheck(var VideoJnlLine: Record "Video Journal Line")
    var
        
    begin
        Codeunit.Run(Codeunit::"Video Jnl. Check Line", VideoJnlLine);
    end;
}