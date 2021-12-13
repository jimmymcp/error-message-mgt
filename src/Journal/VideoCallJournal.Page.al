page 50100 "Video Call Journal"
{
    ApplicationArea = All;
    Caption = 'Video Call Journal';
    PageType = Worksheet;
    SourceTable = "Video Journal Line";
    UsageCategory = Administration;
    AutoSplitKey = true;
    SaveValues = true;
    
    layout
    {
        area(content)
        {
            field(BatchName; BatchName)
            {
                ApplicationArea = All;
                Caption = 'Batch Name';
            }
            repeater(General)
            {
                field("Video Platform"; Rec."Video Platform")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Call Type"; Rec."Call Type")
                {
                    ApplicationArea = All;
                }
                field("No. of Participants"; Rec."No. of Participants")
                {
                    ApplicationArea = All;
                }
                field("Duration (mins)"; Rec."Duration (mins)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ShortcutKey = F9;
                
                trigger OnAction()
                var
                    VideoCallBatch: Record "Video Call Batch";
                begin
                    VideoCallBatch.Get(BatchName);
                    VideoCallBatch.Post();
                end;
            }
        }
    }

    var
        BatchName: Code[20];

    local procedure ValidateBatchName()
    var
        myInt: Integer;
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Batch Name", BatchName);
        Rec.FilterGroup(0);
    end;

    trigger OnOpenPage()
    var
        VideoCallBatch: Record "Video Call Batch";
    begin
        if BatchName = '' then
            BatchName := 'DEFAULT';

        if not VideoCallBatch.Get(BatchName) then begin
            VideoCallBatch.Name := BatchName;
            VideoCallBatch.Insert(true);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Batch Name" := BatchName;
    end;
}
