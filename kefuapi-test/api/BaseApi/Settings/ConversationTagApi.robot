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