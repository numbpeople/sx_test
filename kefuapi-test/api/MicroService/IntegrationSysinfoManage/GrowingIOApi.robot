*** Keywords ***
/v1/integration/tenants/{tenantId}/userinfo
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/integration/tenants/${agent.tenantId}/userinfo
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/integration/tenants/{tenantId}/dashboard
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/integration/tenants/${agent.tenantId}/dashboard
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/integration/tenants/{tenantId}/servicesessions/{serviceSessions}/tracks
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/integration/tenants/${agent.tenantId}/servicesessions/${serviceSessionId} /tracks
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
