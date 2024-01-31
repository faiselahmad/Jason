page 50101 "User Interface Card"
{
    Caption = 'User Interface Card';
    PageType = Card;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("ID"; ID)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        GetUserInfo;
                        GetUserInformation(5);
                        CreatePost;
                    end;
                }
                field("Name"; Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Email"; Email)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Phone"; Phone)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("CompanyName"; CompanyName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

        }

    }
    var
        ID: Integer;
        Name: Text;
        Email: Text;
        Phone: Text;
        CompanyName: Text;

    local procedure GetUserInfo()

    var

        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        Token: JsonToken;
        Object: JsonObject;
        JsonText: Text;
        Url: Text;

    begin
        Url := 'https://jsonplaceholder.typicode.com/users/' + Format(Id);
        if not Client.Get(Url, ResponseMessage) then
            Error('The call to the web service failed');
        if not ResponseMessage.IsSuccessStatusCode then
            Error('The web service returned an error message:\\' + 'Status code: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
        ResponseMessage.Content.ReadAs(JsonText);

        if not Object.ReadFrom(JsonText) then
            Error('Invalid response, expected a JSON Object');

        Object.Get('name', Token);
        Name := Token.AsValue().AsText();
        Object.Get('phone', Token);
        Phone := Token.AsValue().AsText();
        Object.Get('email', Token);
        Email := Token.AsValue().AsText();
        Object.Get('company', Token);
        Token.AsObject().Get('name', Token);
        CompanyName := Token.AsValue().AsText();
    end;

    procedure GetUserInformation(UserNumber: Integer)
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;
        Jtoken2: JsonToken;
        JObject: JsonObject;
    begin
        if not Client.Get(StrSubstNo('https://jsonplaceholder.typicode.com/users/%1',
                          UserNumber), ResponseMessage) then
            Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);

        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        if not Jtoken.IsObject() then
            Error('Expected a JSON object.');

        JObject := Jtoken.AsObject();

        if not JObject.Get('name', Jtoken2) then
            Error('Value for key name not found.');

        if not Jtoken2.IsValue then
            Error('Expected a JSON value.');

        Message(Jtoken2.AsValue().AsText());
    end;

    procedure CreatePost()
    var
        Client: HttpClient;
        Content: HttpContent;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        JObject: JsonObject;
        JsonText: Text;
    begin

        JObject.Add('userId', 2);
        JObject.Add('id', 10);
        JObject.Add('title', 'Microsoft Dynamics 365 Business Central Post Test');
        JObject.Add('body', 'This is a MS Dynamics 365 Business Central Post Test');
        JObject.WriteTo(JsonText);

        Content.WriteFrom(JsonText);

        if not Client.Post('https://jsonplaceholder.typicode.com/posts', Content,
                           ResponseMessage) then
            Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                    'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                    'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);

        Message(ResponseString);
    end;
}
