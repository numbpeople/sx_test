*** Keywords ***
/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/total
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${orgEntity}    ${DateRange}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${tenantId}/statistics/internal/visitor/total?beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/visitorMark
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${orgEntity}    ${AgentEntity}    ${FilterEntity}
    ...    ${DateRange}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${tenantId}/statistics/internal/session/dist/visitorMark?beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&agentUserId=${AgentEntity.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/qualityMark
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${orgEntity}    ${AgentEntity}    ${FilterEntity}
    ...    ${DateRange}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${tenantId}/statistics/internal/session/dist/qualityMark?beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&agentUserId=${AgentEntity.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/effective
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${orgEntity}    ${AgentEntity}    ${FilterEntity}
    ...    ${DateRange}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${tenantId}/statistics/internal/session/dist/effective?beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&agentUserId=${AgentEntity.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/firstResTime
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${orgEntity}    ${AgentEntity}    ${FilterEntity}
    ...    ${DateRange}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${tenantId}/statistics/internal/session/dist/firstResTime?beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&agentUserId=${AgentEntity.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/avgResTime
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${orgEntity}    ${AgentEntity}    ${FilterEntity}
    ...    ${DateRange}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${tenantId}/statistics/internal/session/dist/avgResTime?beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&agentUserId=${AgentEntity.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
