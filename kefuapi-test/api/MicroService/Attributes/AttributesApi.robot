*** Keywords ***
/v1/tenants/{tenantId}/servicesessions/{serviceSessions}/attributes
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/attributes?names=ip%2Cregion%2CuserAgent%2Creferer
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
