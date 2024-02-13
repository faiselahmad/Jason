tableextension 50102 "My G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50102; AccountingPeriod; Integer)
        {
            Caption = 'MyField';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; AccountingPeriod)
        {

        }
    }

}