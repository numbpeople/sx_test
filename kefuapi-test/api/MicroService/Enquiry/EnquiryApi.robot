*** Keywords ***
/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessions/${serviceSessionId}/enquiryStatus
    ${params}    set variable    _=1511159898703
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiries
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessions/${serviceSessionId}/enquiries
    ${params}    set variable    _=1511159898703
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

