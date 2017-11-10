*** Keywords ***
/tenants/{tenantId}/projects
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects
    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}&userRoles=${agent.roles}&page=${FilterEntity.page}&per_page=${FilterEntity.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
