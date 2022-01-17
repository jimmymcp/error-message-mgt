codeunit 50103 "Show Errors"
{
    SingleInstance = true;

    procedure ShowErrors(Errors: List of [ErrorInfo]; Context: Variant)
    var
        TempErrorMsg: Record "Error Message" temporary;
        DataTypeMgt: Codeunit "Data Type Management";
        ErrorInfo: ErrorInfo;
        RecRef: RecordRef;
    begin
        if Errors.Count() = 0 then
            exit;

        foreach ErrorInfo in Errors do begin
            TempErrorMsg.LogDetailedMessage(ErrorInfo.RecordId, ErrorInfo.FieldNo, TempErrorMsg."Message Type"::Error, ErrorInfo.Message, ErrorInfo.DetailedMessage, '');
            if DataTypeMgt.GetRecordRef(Context, RecRef) then
                TempErrorMsg.Validate("Context Record ID", RecRef.RecordId());
            TempErrorMsg.SetErrorCallStack(ErrorInfo.Callstack);
            TempErrorMsg.Modify();
        end;

        Page.Run(Page::"Error Messages", TempErrorMsg);
        Error('');
    end;
}