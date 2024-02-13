pageextension 50101 "My G/L Entry List" extends "General Ledger Entries"
{
    layout
    {
        addbefore("Posting Date")
        {
            field(AccountingPeriod; Rec.AccountingPeriod)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(Processing)
        {
            action(AddActP)
            {
                Caption = 'Add Account Period to Posted entries';
                ApplicationArea = All;
                trigger OnAction()
                var
                    OddMgt: Codeunit "Odd Accounting";
                begin
                    OddMgt.UpdateAccountingPeriods();
                end;
            }
        }
    }
}