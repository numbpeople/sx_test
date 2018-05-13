*** Keywords ***
/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree
    [Arguments]    ${method}    ${agent}    ${summaryId}    ${conversationTagEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/ServiceSessionSummaries/${summaryId}/tree
    ${params}=    set variable    systemOnly=${conversationTagEntity.systemOnly}&buildCount=${conversationTagEntity.buildCount}&_=1523951277711
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children
    [Arguments]    ${method}    ${agent}    ${ServiceSessionSummaryId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/ServiceSessionSummaries/${ServiceSessionSummaryId}/children
    run keyword if    '${method}'=='put' or '${method}'=='delete'    set suite variable    ${uri}    /v1/Tenants/${agent.tenantId}/ServiceSessionSummaries/${ServiceSessionSummaryId}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessionSummaries/exportfile
    [Arguments]    ${agent}    ${timeout}    ${language}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/ServiceSessionSummaries/exportfile
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/download/tplfiles/%E4%BC%9A%E8%AF%9D%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx
    [Arguments]    ${agent}    ${timeout}    ${language}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /download/tplfiles/%E4%BC%9A%E8%AF%9D%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
