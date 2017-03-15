*** Keywords ***
/tenants/{tenantId}/projects
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${AgentEntity}    ${FilterEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${tenantId}/projects?tenantId=${tenantId}&userId=${AgentEntity.userId}&userRoles=${AgentEntity.roles}&page=${FilterEntity.page}&per_page=${FilterEntity.per_page}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
