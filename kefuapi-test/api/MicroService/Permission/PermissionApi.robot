*** Keywords ***
/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/users/${agent.userId}/resource_categories
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
