pageextension 50104 SalesOrder extends "Sales Order"
{

    actions
    {
        addfirst(Processing)
        {
            action(DimTest)
            {
                Caption = 'Test Dimensions';
                ApplicationArea = All;
                trigger OnAction()
                var
                    dims: Record "Dimension Set Entry" temporary;
                begin
                    dims.Init();
                    dims.Validate("Dimension Code", 'BUSINESSGROUP');
                    dims.Validate("Dimension Value Code", 'HOME');
                    dims.Init();
                    dims.Validate("Dimension Code", 'PURCHASER');
                    dims.Validate("Dimension Value Code", 'RB');
                    dims.Insert();
                    UpdateDimSetOnSalesHeader(Rec, Dims);
                    Rec.Modify();
                end;
            }
        }
    }
    procedure UpdateDimSetOnSalesHeader(var SH: Record "Sales Header"; var ToAddDims: Record "Dimension Set Entry" temporary)
    var
        DimMgt: Codeunit DimensionManagement;
        NewDimSet: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(NewDimSet, SH."Dimension Set ID");
        if ToAddDims.FindSet() then
            repeat
                if NewDimSet.Get(SH."Dimension Set ID", ToAddDims."Dimension Code") then begin
                    NewDimSet.validate("Dimension Value Code", ToAddDims."Dimension Value Code");
                    NewDimSet.Modify();

                end else begin
                    NewDimSet := ToAddDims;
                    NewDimSet."Dimension Set ID" := SH."Dimension Set ID";
                    NewDimSet.insert();
                end;
            until ToAddDims.Next() = 0;
        SH."Dimension Set ID" := DimMgt.GetDimensionSetID(NewDimSet);
        DimMgt.UpdateGlobalDimFromDimSetID(SH."Dimension Set ID", SH."Shortcut Dimension 1 Code", SH."Shortcut Dimension 2 Code")
    end;

}