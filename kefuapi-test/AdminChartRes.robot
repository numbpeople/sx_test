*** Keywords ***
/v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/EveryDayNewServiceSessionCountCurrentMonthList
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/EveryDayNewServiceSessionCountCurrentMonthList
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/{tenantId}/ChatMessage/Statistics/CurrentMonthMessageCountByDayList
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/${tenantId}/ChatMessage/Statistics/CurrentMonthMessageCountByDayList
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${orgEntity}    ${StatisticFilterEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${tenantId}/statistics/internal/session/trend?beginDateTime=${StatisticFilterEntity.beginDateTime}&endDateTime=${StatisticFilterEntity.endDateTime}&dateInterval=${StatisticFilterEntity.dateInterval}d&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    headers=${header}    timeout=${timeout}
