*** Keywords ***
/v1/tenants/{tenantId}/skillgroups
    [Arguments]    ${agent}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/skillgroups
    ${params}    set variable    beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/options/agentUserLanguage_{userId}
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/options/agentUserLanguage_${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
