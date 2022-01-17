codeunit 50101 "Video Jnl. Check Line"
{
    TableNo = "Video Journal Line";

    trigger OnRun()
    begin
        Check(Rec);
    end;

    local procedure Check(var VideoJnlLine: Record "Video Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if VideoJnlLine."No. of Participants" = 0 then
            VideoJnlLine.TestField("No. of Participants", ErrorInfo.Create('', true, VideoJnlLine, VideoJnlLine.FieldNo("No. of Participants")));

        if VideoJnlLine."Duration (mins)" = 0 then
            VideoJnlLine.TestField("Duration (mins)", ErrorInfo.Create('', true, VideoJnlLine, VideoJnlLine.FieldNo("Duration (mins)")));

        if VideoJnlLine."Posting Date" = 0D then
            VideoJnlLine.TestField("Posting Date", ErrorInfo.Create('', true, VideoJnlLine, VideoJnlLine.FieldNo("Posting Date")));

        GLSetup.CheckAllowedPostingDates(0);

        case VideoJnlLine."Video Platform" of
            "Video Platform"::Zoom:
                if (VideoJnlLine."Duration (mins)" > 40) and (VideoJnlLine."No. of Participants" > 2) then
                    Error(ErrorInfo.Create('Zoom calls cannot be over 40 minutes. You haven''t paid for it, remember?', true, VideoJnlLine));
            "Video Platform"::Teams:
                if VideoJnlLine."Call Type" = VideoJnlLine."Call Type"::"Family Quiz" then
                    Error(ErrorInfo.Create('A family quiz on Teams? Sounds too corporate for my liking', true, VideoJnlLine));
            "Video Platform"::WhatsApp:
                begin
                    if VideoJnlLine."No. of Participants" > 4 then
                        Error(ErrorInfo.Create('Do yourself a favour and don''t WhatsApp for group chats with more than 4 people.', true, VideoJnlLine));

                    if VideoJnlLine."Call Type" = "Video Call Type"::"Customer Demo" then
                        Error(ErrorInfo.Create('I know you didn''t do a customer demo on WhatsApp. That would be crazy', true, VideoJnlLine));
                end;
            "Video Platform"::Skype:
                if VideoJnlLine."No. of Participants" > 2 then
                    Error(ErrorInfo.Create('Don''t tell me you found more than 2 friends who still use Skype?!', true, VideoJnlLine));
        end;

        if VideoJnlLine."Call Type" = "Video Call Type"::"Family Quiz" then
            if Date2DWY(VideoJnlLine."Posting Date", 1) in [1 .. 4] then
                Error(ErrorInfo.Create('Surely family quizzes are a weekend pastime?', true, VideoJnlLine));

        if VideoJnlLine."Call Type" = "Video Call Type"::"Daily Team Call" then begin
            if VideoJnlLine."Duration (mins)" > 45 then
                Error(ErrorInfo.Create('Your daily call with the team was over 45 minutes long? No way.', true, VideoJnlLine));

            if VideoJnlLine."No. of Participants" > 30 then
                Error(ErrorInfo.Create('You need to find a smaller team to hang out with at the start of the day.', true, VideoJnlLine));
        end;
    end;
}