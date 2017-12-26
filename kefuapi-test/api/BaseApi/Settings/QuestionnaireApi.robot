*** Keywords ***
/v1/tenants/{tenantId}/questionnaires/accounts
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/questionnaires/accounts
    ${params}=    set variable    _=1509438791265
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/questionnaires/list
    [Arguments]    ${agent}    ${timeout}    ${type}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/questionnaires/list
    ${params}=    set variable    type=${type}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
