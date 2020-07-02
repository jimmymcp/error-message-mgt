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
        VideoJnlLine.TestField("No. of Participants");
        VideoJnlLine.TestField("Duration (mins)");
        VideoJnlLine.TestField("Posting Date");
        GLSetup.CheckAllowedPostingDates(0);

        case VideoJnlLine."Video Platform" of
            "Video Platform"::Zoom:
                if (VideoJnlLine."Duration (mins)" > 40) and (VideoJnlLine."No. of Participants" > 2) then
                    Error('Zoom calls cannot be over 40 minutes. You haven''t paid for it, remember?');
            "Video Platform"::Teams:
                if VideoJnlLine."Call Type" = VideoJnlLine."Call Type"::"Family Quiz" then
                    Error('A family quiz on Teams? Sounds too corporate for my liking');
            "Video Platform"::WhatsApp:
                begin
                    if VideoJnlLine."No. of Participants" > 4 then
                        Error('Do yourself a favour and don''t WhatsApp for group chats with more than 4 people.');

                    if VideoJnlLine."Call Type" = "Video Call Type"::"Customer Demo" then
                        Error('I know you didn''t do a customer demo on WhatsApp. That would be crazy');
                end;
            "Video Platform"::Skype:
                if VideoJnlLine."No. of Participants" > 2 then
                    Error('Don''t tell me you found more than 2 friends who still use Skype?!');
        end;

        if VideoJnlLine."Call Type" = "Video Call Type"::"Family Quiz" then
            if Date2DWY(VideoJnlLine."Posting Date", 1) in [1..4] then
                Error('Surely family quizzes are a weekend pastime?');

        if VideoJnlLine."Call Type" = "Video Call Type"::"Daily Team Call" then begin
            if VideoJnlLine."Duration (mins)" > 45 then
                Error('Your daily call with the team was over 45 minutes long? No way.');

            if VideoJnlLine."No. of Participants" > 30 then
                Error('You need to find a smaller team to hang out with at the start of the day.');
        end;
    end;
}