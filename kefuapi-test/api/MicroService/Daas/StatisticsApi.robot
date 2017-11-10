*** Keywords ***
/v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/processing
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/today/processing
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/agent/online
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/agent/online
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/statistics/tenant/{tenantId}/message/today/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/statistics/tenant/${agent.tenantId}/message/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/EveryDayNewServiceSessionCountCurrentMonthList
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/EveryDayNewServiceSessionCountCurrentMonthList
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/{tenantId}/ChatMessage/Statistics/CurrentMonthMessageCountByDayList
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/${agent.tenantId}/ChatMessage/Statistics/CurrentMonthMessageCountByDayList
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/session/today
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/agent/session/today
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}&tenantId=${agent.tenantId}
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/statistics/tenant/{tenantId}/message/trend
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}&tenantId=${agent.tenantId}
    ${uri}=    set variable    /v1/statistics/tenant/${agent.tenantId}/message/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/status/dist
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/agent/status/dist
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/agent/status/dist
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/agent/status/dist
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/load
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/agent/load
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/wait/count
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/wait/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/wait/count
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/wait/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/session/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/session/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/session/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/visitor/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/visitor/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/visitor/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/quality/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/quality/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/quality/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/quality/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/start/top
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/session/start/top?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/session/start
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/top/session/start?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/first/response/top
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/first/response/top?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/first/response
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/top/first/response?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/mark/top
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/visitor/mark/top?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/visitor/mark
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/top/visitor/mark?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/session/start
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/session/start?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/first/response
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/first/response?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/visitor/mark
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/visitor/mark?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/response/time
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/response/time?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/detail/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/detail/trend
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/serve
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/detail/serve
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/total
    ${params}=    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait/total
    ${params}=    set variable    sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/file
    ${params}=    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/hour
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/hour
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/hour
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/hour
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/hour/create
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait/hour/create
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/hour/wait
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait/hour/wait
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/day/create
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait/day/create
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait/trend
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/session/tag
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait/session/tag
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=all&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/trend
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/total
    [Arguments]    ${agent}    ${orgEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/total
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/count
    ${params}    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&total_entries=${FilterEntity.total_entries}&order=${FilterEntity.sortOrder}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/count/file
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}&order=${FilterEntity.sortOrder}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/trend
    ${params}    set variable    queryType=${FilterEntity.queryType}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workLoad/agent
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&total_entries=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wl
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/agent/wl
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&total_entries=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/group/wl
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/group/wl
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&total_entries=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wq
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/file/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wq
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}&locale=${FilterEntity.locale}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/visitor
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/file/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/visitor
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=V_ORIGINTYPE
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wait
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/file/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait
    ${params}=    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&locale=${FilterEntity.locale}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/agent/serve
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/file/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/serve
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&locale=${FilterEntity.locale}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/agent/serve/detail
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/file/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/serve/detail
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&agentId=${agent.userId}&locale=${FilterEntity.locale}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    create dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/feign/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/quality/mark
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&order=workTime&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&asc=${FilterEntity.asc}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/feign/orgs/{organId}/tenants/{tenantId}/data/detail/invalid
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    create dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/feign/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/data/detail/invalid
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/today
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${timeout}
    ${header}=    create dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/detail/today
    ${params}=    set variable    agentId=${agent.userId}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/feign/orgs/{organId}/tenants/{tenantId}/wait/detail
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    create dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/feign/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wait/detail
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{orgName}/token
    [Arguments]    ${tadmin}    ${AdminUser}    ${data}    ${timeout}
    ${header}=    create dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${tadmin.orgname}/token
    run keyword and return    Post Request    ${AdminUser.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/count
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/visitor/count
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/total
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/visitor/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/processing
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/session/today/processing
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/count/type
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/message/count/type
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/total
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/message/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/today/total
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/message/today/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/trend
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/message/trend
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workLoad
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v2/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/session/workLoad
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&sessionTag=all&sessionType=${FilterEntity.sessionType}
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workQuality
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v2/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/session/workQuality
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&sessionTag=all
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workload
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/session/workload
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&sessionTag=all
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workquality
    [Arguments]    ${agent}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}    ${Cookie}
    ${header}=    create dictionary    Content-Type=application/json    Cookie=${Cookie}
    ${uri}=    set variable    /v1/organs/${OrgAdminUser.orgname}/tenants/${agent.tenantId}/statistics/external/session/workquality
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&sessionTag=all
    run keyword and return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workLoad/agent/file
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&order=${FilterEntity.sortOrder}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wl
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/file/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wl
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&agentUserId=${agent.userId}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workLoad/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wl/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/wl/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/trend/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/trend/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/trend/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTag
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/sessionTag
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/tag
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/session/tag
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/messageCount
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/messageCount
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/message/count
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/message/count
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/time
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/session/time
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTime
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/sessionTime
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wq
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/agent/wq
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/group/wq
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/group/wq
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/serve/agent
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/serve/agent
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/serve/agent/detail
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/serve/agent/detail
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&agentId=${agent.userId}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/visitor/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=V_ORIGINTYPE
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/visitor/trend
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=V_ORIGINTYPE
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/count
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/visitor/count
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=V_ORIGINTYPE
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workQuality/agent
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&order=${FilterEntity.order}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workQuality/agent/file
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&order=${FilterEntity.order}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workQuality/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wq/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/wq/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/visitorMark
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/visitorMark
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/vm
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/vm
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/qualityMark
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/qualityMark
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/qm
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/qm
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/effective
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/effective
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/effective
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/effective
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/firstResTime
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/firstResTime
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/first
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/response/first
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/avgResTime
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/avgResTime
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/avg
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/response/avg
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
