codeunit 50213 "SC Sales Posting Procedures"
{
    EventSubscriberInstance = Manual;
    Permissions = TableData "Batch Processing Parameter" = rimd,
                  TableData "Batch Processing Session Map" = rimd;
    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        SalesBatchPostMgt: Codeunit "Sales Batch Post Mgt.";
    begin
        SalesHeader.Copy(Rec);

        BindSubscription(SalesBatchPostMgt);
        SalesBatchPostMgt.SetPostingCodeunitId(PostingCodeunitId);
        SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
        SalesBatchPostMgt.Code(SalesHeader);

        Rec := SalesHeader;
    end;

    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        PostingCodeunitId: Integer;
        PostingDateIsNotSetErr: Label 'Enter the posting date.';
        BatchPostingMsg: Label 'Bacth posting of sales documents.';

    procedure RunBatch(var SalesHeader: Record "Sales Header"; ReplacePostingDate: Boolean; PostingDate: Date; ReplaceDocumentDate: Boolean; CalcInvoiceDiscount: Boolean; Ship: Boolean; Invoice: Boolean)
    var
        TempErrorMessage: Record "Error Message" temporary;
        BatchPostParameterTypes: Codeunit "Batch Post Parameter Types";
        SalesBatchPostMgt: Codeunit "Sales Batch Post Mgt.";
        ErrorMessages: Page "Error Messages";
        ErrorText: Text;
        MyRecordRef: RecordRef;
        ErrorRec: FieldRef;
        ErrorDesc: FieldRef;
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorContextElement: Codeunit "Error Context Element";
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        if ReplacePostingDate and (PostingDate = 0D) then
            Error(PostingDateIsNotSetErr);

        BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice, Invoice);
        BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Ship, Ship);
        BatchProcessingMgt.AddParameter(BatchPostParameterTypes.CalcInvoiceDiscount, CalcInvoiceDiscount);
        BatchProcessingMgt.AddParameter(BatchPostParameterTypes.PostingDate, PostingDate);
        BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplacePostingDate, ReplacePostingDate);
        BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplaceDocumentDate, ReplaceDocumentDate);

        ErrorMessageMgt.PushContext(ErrorContextElement, DATABASE::"Sales Header", 0, BatchPostingMsg);

        SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
        Commit();
        if SalesBatchPostMgt.Run(SalesHeader) then;
        BatchProcessingMgt.ResetBatchID;


        //Error Handling
        if ErrorMessageMgt.GetLastErrorID > 0 then begin
            ErrorMessageMgt.GetErrors(TempErrorMessage);
            MyRecordRef.GetTable(TempErrorMessage);
            ErrorDesc := MyRecordRef.FIELD(5);
            ErrorRec := MyRecordRef.FIELD(10);
            if MyRecordRef.FINDSET(FALSE, FALSE) then begin
                repeat
                    ErrorText := ErrorText + Format(ErrorRec.VALUE) + ': ' + Format(ErrorDesc.VALUE) + '\\';
                until MyRecordRef.NEXT = 0;
            end;
            ErrorText := 'Error Count: ' + Format(MyRecordRef.Count) + '\\Error Messages: ' + ErrorText;

            error(ErrorText);
        end;
    end;

    procedure GetBatchProcessor(var ResultBatchProcessingMgt: Codeunit "Batch Processing Mgt.")
    begin
        ResultBatchProcessingMgt := BatchProcessingMgt;
    end;

    procedure SetBatchProcessor(NewBatchProcessingMgt: Codeunit "Batch Processing Mgt.")
    begin
        BatchProcessingMgt := NewBatchProcessingMgt;
    end;

    procedure "Code"(var SalesHeader: Record "Sales Header")
    var
        RecRef: RecordRef;
    begin
        if PostingCodeunitId = 0 then
            PostingCodeunitId := CODEUNIT::"Sales-Post";

        RecRef.GetTable(SalesHeader);

        BatchProcessingMgt.SetProcessingCodeunit(PostingCodeunitId);
        BatchProcessingMgt.BatchProcess(RecRef);

        RecRef.SetTable(SalesHeader);
    end;

    local procedure PrepareSalesHeader(var SalesHeader: Record "Sales Header"; var BatchConfirm: Option)
    var
        BatchPostParameterTypes: Codeunit "Batch Post Parameter Types";
        CalcInvoiceDiscont: Boolean;
        ReplacePostingDate: Boolean;
        PostingDate: Date;
    begin
        BatchProcessingMgt.GetParameterBoolean(SalesHeader.RecordId, BatchPostParameterTypes.CalcInvoiceDiscount, CalcInvoiceDiscont);
        BatchProcessingMgt.GetParameterBoolean(SalesHeader.RecordId, BatchPostParameterTypes.ReplacePostingDate, ReplacePostingDate);
        BatchProcessingMgt.GetParameterDate(SalesHeader.RecordId, BatchPostParameterTypes.PostingDate, PostingDate);

        if CalcInvoiceDiscont then
            CalculateInvoiceDiscount(SalesHeader);

        SalesHeader.BatchConfirmUpdateDeferralDate(BatchConfirm, ReplacePostingDate, PostingDate);

        BatchProcessingMgt.GetParameterBoolean(SalesHeader.RecordId, BatchPostParameterTypes.Ship, SalesHeader.Ship);
        BatchProcessingMgt.GetParameterBoolean(SalesHeader.RecordId, BatchPostParameterTypes.Invoice, SalesHeader.Invoice);
        BatchProcessingMgt.GetParameterBoolean(SalesHeader.RecordId, BatchPostParameterTypes.Receive, SalesHeader.Receive);
        BatchProcessingMgt.GetParameterBoolean(SalesHeader.RecordId, BatchPostParameterTypes.Print, SalesHeader."Print Posted Documents");

        OnAfterPrepareSalesHeader(SalesHeader);
    end;

    procedure SetPostingCodeunitId(NewPostingCodeunitId: Integer)
    begin
        PostingCodeunitId := NewPostingCodeunitId;
    end;

    local procedure CalculateInvoiceDiscount(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst then begin
            CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", SalesLine);
            Commit();
            SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
        end;
    end;

    local procedure CanPostDocument(var SalesHeader: Record "Sales Header"): Boolean
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled(SalesHeader) then
            exit(false);

        if SalesHeader.Status = SalesHeader.Status::"Pending Approval" then
            exit(false);

        if not SalesHeader.IsApprovedForPostingBatch then
            exit(false);

        exit(true);
    end;

    procedure AddParameter(ParameterId: Integer; ParameterValue: Variant)
    var
        ResultBatchProcessingMgt: Codeunit "Batch Processing Mgt.";
    begin
        GetBatchProcessor(ResultBatchProcessingMgt);
        ResultBatchProcessingMgt.AddParameter(ParameterId, ParameterValue);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1380, 'OnBeforeBatchProcessing', '', false, false)]
    local procedure PrepareSalesHeaderOnBeforeBatchProcessing(var RecRef: RecordRef; var BatchConfirm: Option)
    var
        SalesHeader: Record "Sales Header";
    begin
        RecRef.SetTable(SalesHeader);
        PrepareSalesHeader(SalesHeader, BatchConfirm);
        RecRef.GetTable(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1380, 'OnVerifyRecord', '', false, false)]
    local procedure CheckSalesHeaderOnVerifyRecord(var RecRef: RecordRef; var Result: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        RecRef.SetTable(SalesHeader);
        Result := CanPostDocument(SalesHeader);
        RecRef.GetTable(SalesHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPrepareSalesHeader(var SalesHeader: Record "Sales Header")
    begin
    end;
}
