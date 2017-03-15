*** Keywords ***
/tenants/{tenantId}/serviceSessionHistoryFiles
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${AgentEntity}    ${FilterEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${tenantId}/serviceSessionHistoryFiles?agentUserId=${AgentEntity.userId}&page=${FilterEntity.page}&size=${FilterEntity.per_page}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
