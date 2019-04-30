*** Keywords ***
3年r
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /management/organizations
    Run Keyword And Return    Post Request
