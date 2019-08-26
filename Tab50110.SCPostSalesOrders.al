table 50110 "SC Post Sales Orders"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ShipReq; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(2; InvReq; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(3; PostingDateReq; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(4; ReplacePostingDate; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(5; ReplaceDocumentDate; Boolean)
        {
            DataClassification = ToBeClassified;


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


        }
        field(9; DocumentType; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Order,Invoice';
            OptionMembers = "Order","Invoice";

        }
        field(10; CreatedOn; DateTime)
        {
            DataClassification = ToBeClassified;

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

    var
        SalesBatchPostMgt: Codeunit 1371;
        SalesHeader: Record "Sales Header";

    trigger OnInsert()
    begin
        ID := CreateGuid();
        CreatedOn := CreateDateTime(Today, Time);
    end;

    trigger OnModify()
    begin
        if DocumentType = 0 then begin
            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        end else Begin
            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
        end;
        SalesHeader.SETRANGE("Document Date", DateFromFilter, DateToFilter);
        SalesBatchPostMgt.RunBatch(SalesHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}