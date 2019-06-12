page 50111 "SC Post Sales Batch"
{
    PageType = API;
    Caption = 'apiPageName';
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

                }
                field(Invoice; InvReq)
                {
                    ApplicationArea = All;

                }
                field(PostingDate; PostingDateReq)
                {
                    ApplicationArea = All;

                }
                field(ReplacePostingDate; ReplacePostingDate)
                {
                    ApplicationArea = All;

                }
                field(ReplaceDocumentDate; ReplaceDocumentDate)
                {
                    ApplicationArea = All;

                }
                field("CalcInvDiscount"; CalcInvDisc)
                {
                    ApplicationArea = All;

                }
                field("DocumentType"; DocumentType)
                {
                    ApplicationArea = All;

                }
                field("DateFrom"; DateFromFilter)
                {
                    ApplicationArea = All;

                }
                field("DateTo"; DateToFilter)
                {
                    ApplicationArea = All;

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
