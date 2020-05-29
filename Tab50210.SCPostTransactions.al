table 50210 "SC Post Transactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ShipReq; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(2; InvReq; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(3; PostingDateReq; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(4; ReplacePostingDate; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(5; ReplaceDocumentDate; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(6; DateFromFilter; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(7; DateToFilter; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(8; CalcInvDisc; Boolean)
        {
            DataClassification = ToBeClassified;
            //InitValue = false;
        }
        field(9; DocumentType; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Sales Order","Sales Invoice","Sales Credit Memo","Purchase Order","Purchase Invoice","Purchase Credit Memo";
        }

        field(8000; ID; Guid)
        {
            DataClassification = ToBeClassified;


        }
    }

    keys
    {
        key(ID; ID)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        ID := CreateGuid();
        post();
    end;

    local procedure post()
    var
        SalesPostingProcedure: Codeunit "SC Sales Posting Procedures";
        PurchPostingProcedure: Codeunit "SC Purch Posting Procedures";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
    begin
        case DocumentType of
            0:
                begin
                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SETRANGE("Document Date", DateFromFilter, DateToFilter);
                    SalesPostingProcedure.RunBatch(SalesHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);
                end;
            1:
                begin
                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
                    SalesHeader.SETRANGE("Document Date", DateFromFilter, DateToFilter);
                    SalesPostingProcedure.RunBatch(SalesHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);
                end;
            2:
                begin
                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Credit Memo");
                    SalesHeader.SETRANGE("Document Date", DateFromFilter, DateToFilter);
                    SalesPostingProcedure.RunBatch(SalesHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);
                end;
            3:
                begin
                    PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                    PurchHeader.SETRANGE("Document Date", DateFromFilter, DateToFilter);
                    PurchPostingProcedure.RunBatch(PurchHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);
                end;
            4:
                begin
                    PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Invoice);
                    PurchHeader.SETRANGE("Document Date", DateFromFilter, DateToFilter);
                    PurchPostingProcedure.RunBatch(PurchHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);
                end;
            5:
                begin
                    PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::"Credit Memo");
                    PurchHeader.SETRANGE("Document Date", DateFromFilter, DateToFilter);
                    PurchPostingProcedure.RunBatch(PurchHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);
                end;
        end;
    end;
}