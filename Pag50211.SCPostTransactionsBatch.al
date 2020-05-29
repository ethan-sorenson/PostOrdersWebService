page 50211 "SC Post Transactions Batch"
{
    PageType = API;
    Caption = 'SC Post Transactions Batch';
    APIPublisher = 'EthanSorenson';
    APIGroup = 'sc';
    APIVersion = 'v1.0';
    EntityName = 'SCPostTransactionsBatch';
    EntitySetName = 'SCPostTransactionsBatch';
    SourceTable = "SC Post Transactions";
    SourceTableTemporary = true;
    DelayedInsert = true;
    ODataKeyFields = ID;
    DeleteAllowed = true;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(Settings)
            {
                field(Ship; ShipReq)
                {
                    ApplicationArea = All;
                    Caption = 'Ship';

                }
                field(Invoice; InvReq)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice';

                }
                field(PostingDate; PostingDateReq)
                {
                    ApplicationArea = All;
                    Caption = 'PostingDate';

                }
                field(ReplacePostingDate; ReplacePostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'ReplacePostingDate';

                }
                field(ReplaceDocumentDate; ReplaceDocumentDate)
                {
                    ApplicationArea = All;
                    Caption = 'ReplaceDocumentDate';
                }
                field("CalcInvDiscount"; CalcInvDisc)
                {
                    ApplicationArea = All;
                    Caption = 'CalcInvDiscount';

                }
                field("DocumentType"; DocumentType)
                {
                    ApplicationArea = All;
                    Caption = 'DocumentType';
                    ShowMandatory = true;
                }
                field("DocumentDateFrom"; DateFromFilter)
                {
                    ApplicationArea = All;
                    Caption = 'DateFrom';
                    ShowMandatory = true;
                }
                field("DocumentDateTo"; DateToFilter)
                {
                    ApplicationArea = All;
                    Caption = 'DateTo';
                    ShowMandatory = true;
                }
            }
        }
    }
}
