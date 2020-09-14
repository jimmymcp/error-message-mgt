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
        ErrorMessageMgt: Codeunit "Error Message Management";
    begin
        if VideoJnlLine."No. of Participants" = 0 then
            ErrorMessageMgt.LogErrorMessage(VideoJnlLine.FieldNo("No. of Participants"), StrSubstNo('%1 must not be 0', VideoJnlLine.FieldCaption("No. of Participants")), VideoJnlLine, VideoJnlLine.FieldNo("No. of Participants"), '');

        if VideoJnlLine."Duration (mins)" = 0 then
            ErrorMessageMgt.LogErrorMessage(VideoJnlLine.FieldNo("Duration (mins)"), StrSubstNo('%1 must not be 0', VideoJnlLine.FieldCaption("Duration (mins)")), VideoJnlLine, VideoJnlLine.FieldNo("Duration (mins)"), '');

        if VideoJnlLine."Posting Date" = 0D then
            ErrorMessageMgt.LogErrorMessage(VideoJnlLine.FieldNo("Posting Date"), StrSubstNo('%1 must be set', VideoJnlLine.FieldCaption("Posting Date")), VideoJnlLine, VideoJnlLine.FieldNo("Posting Date"), '');

        GLSetup.CheckAllowedPostingDates(0);

        case VideoJnlLine."Video Platform" of
            "Video Platform"::Zoom:
                if (VideoJnlLine."Duration (mins)" > 40) and (VideoJnlLine."No. of Participants" > 2) then
                    ErrorMessageMgt.LogError(VideoJnlLine, 'Zoom calls cannot be over 40 minutes. You haven''t paid for it, remember?', '');
            "Video Platform"::Teams:
                if VideoJnlLine."Call Type" = VideoJnlLine."Call Type"::"Family Quiz" then
                    ErrorMessageMgt.LogError(VideoJnlLine, 'A family quiz on Teams? Sounds too corporate for my liking', '');
            "Video Platform"::WhatsApp:
                begin
                    if VideoJnlLine."No. of Participants" > 4 then
                        ErrorMessageMgt.LogError(VideoJnlLine, 'Do yourself a favour and don''t WhatsApp for group chats with more than 4 people.', '');

                    if VideoJnlLine."Call Type" = "Video Call Type"::"Customer Demo" then
                        ErrorMessageMgt.LogError(VideoJnlLine, 'I know you didn''t do a customer demo on WhatsApp. That would be crazy', '');
                end;
            "Video Platform"::Skype:
                if VideoJnlLine."No. of Participants" > 2 then
                    ErrorMessageMgt.LogError(VideoJnlLine, 'Don''t tell me you found more than 2 friends who still use Skype?!', '');
        end;

        if VideoJnlLine."Call Type" = "Video Call Type"::"Family Quiz" then
            if Date2DWY(VideoJnlLine."Posting Date", 1) in [1 .. 4] then
                ErrorMessageMgt.LogError(VideoJnlLine, 'Surely family quizzes are a weekend pastime?', '');

        if VideoJnlLine."Call Type" = "Video Call Type"::"Daily Team Call" then begin
            if VideoJnlLine."Duration (mins)" > 45 then
                ErrorMessageMgt.LogError(VideoJnlLine, 'Your daily call with the team was over 45 minutes long? No way.', '');

            if VideoJnlLine."No. of Participants" > 30 then
                ErrorMessageMgt.LogError(VideoJnlLine, 'You need to find a smaller team to hang out with at the start of the day.', '');
        end;
    end;
}