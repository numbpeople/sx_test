*** Keywords ***
/v1/tenants/{tenantId}/knowledge/categories/tree
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/knowledge/categories/tree
    ${params}    set variable    _=1511252000771
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
