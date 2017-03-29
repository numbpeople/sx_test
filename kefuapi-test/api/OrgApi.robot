*** Variables ***
&{OrgRegInfo}     phone=    codeValue=    name=    desc=    username=leoli-org081701@easemob.com    password=111111    orgName=leoli081701

*** Keywords ***
/v2/orgs/{orgId}/token
    [Arguments]    ${method}    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/token
    ${data}=    Create Dictionary    username=${agent.username}    password=${agent.password}
    ${rs}=    Run Keyword If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}
