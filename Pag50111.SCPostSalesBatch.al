page 50111 "SC Post Sales Batch"
{
    PageType = API;
    Caption = 'SC Post Sales Batch';
    APIPublisher = 'publisherName';
    APIGroup = 'app1';
    APIVersion = 'v1.0';
    EntityName = 'SCPostSalesOrder';
    EntitySetName = 'SCPostSalesOrders';
    SourceTable = "SC Post Sales Orders";
    DelayedInsert = true;
    ODataKeyFields = ID;

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

                }
                field("DateFrom"; DateFromFilter)
                {
                    ApplicationArea = All;
                    Caption = 'DateFrom';

                }
                field("DateTo"; DateToFilter)
                {
                    ApplicationArea = All;
                    Caption = 'DateTo';

                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Insert(true);
        Modify(true);
        exit(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Delete(true)
    end;
}
