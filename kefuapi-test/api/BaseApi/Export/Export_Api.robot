*** keyword ***
/tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/downloadDetails
    [Arguments]    ${method}    ${agent}    ${serviceSessionHistoryFileId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessionHistoryFiles/${serviceSessionHistoryFileId}/downloadDetails
    ${params}=    set variable    page=0&size=20&total_pages=0&_=1512042536478
    Run Keyword If    '${method}'=='post'    set suite variable    ${params}    page=1&size=20
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}

/tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/file
    [Arguments]    ${agent}    ${serviceSessionHistoryFileId}    ${timeout}
    ${header}=    Create Dictionary    Accept-Language=en-US
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessionHistoryFiles/${serviceSessionHistoryFileId}/file
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    timeout=${timeout}