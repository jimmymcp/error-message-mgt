table 50100 "Video Journal Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Video Platform"; Enum "Video Platform")
        {
            DataClassification = CustomerContent;
        }
        field(4; "Duration (mins)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "No. of Participants"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Call Type"; Enum "Video Call Type")
        {
            DataClassification = CustomerContent;
        }
        field(7; "Batch Name"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Video Call Batch";
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }

    procedure Post()
    begin
        Codeunit.Run(Codeunit::"Video Jnl. Post Line", Rec);
    end;
}