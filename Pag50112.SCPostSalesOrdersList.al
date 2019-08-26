page 50112 "SC Post Sales Orders List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SC Post Sales Orders";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("CreatedOn"; CreatedOn)
                {
                    ApplicationArea = All;
                    Caption = 'Created On';

                }
                field(PostingDate; PostingDateReq)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';

                }
                field("DocumentType"; DocumentType)
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';

                }
                field("DateFrom"; DateFromFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Date From';

                }
                field("DateTo"; DateToFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Date To';

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
            }
        }
    }
}