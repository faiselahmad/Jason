page 50106 "Sales Team Factbox"
{
    Caption = 'Team_Faisal';
    PageType = ListPart;
    SourceTable = "Sales Team Member";
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Add)
            {
                Caption = 'Add new';
                ApplicationArea = All;
                Image = Add;
                trigger OnAction();
                var
                    SP: Record "Salesperson/Purchaser";
                begin
                    if Page.RunModal(PAGE::"Salespersons/Purchasers", SP) = Action::LookupOK then begin
                        Rec.init();
                        Rec.ParentTable := PTable;
                        Rec.ParentSystemId := PSystemId;
                        Rec.SalesPerson := SP.Code;
                        Rec.Insert(true);
                    end;
                end;
            }
        }
    }
    procedure SetParent(Ref: RecordRef)
    var
        SystemIdField: FieldRef;
    begin
        PTable := Ref.Number;
        SystemIdField := Ref.Field(Ref.SystemIdNo);
        PSystemId := SystemIdField.Value;
        Rec.SetRange(ParentTable, PTable);
        Rec.SetRange(ParentSystemId, PSystemId);
        CurrPage.Update(false);
    end;

    var
        PTable: Integer;
        PSystemId: Guid;

}