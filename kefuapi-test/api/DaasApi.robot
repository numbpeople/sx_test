*** Settings ***
Library           uuid

*** Keywords ***
/daas/internal/agent/online
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/agent/online
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/session/today/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/session/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/session/today/processing
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/session/today/processing
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/message/today/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/message/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/session/trend
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}
    ${uri}=    set variable    /daas/internal/session/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/message/trend
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}
    ${uri}=    set variable    /daas/internal/message/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/kpi/session/today
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/agent/kpi/session/today
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/agent/kpi/wl
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dataAuth=${FilterEntity.dataAuth}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}
    ${uri}=    set variable    /daas/internal/agent/kpi/wl
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/group/kpi/wl
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dataAuth=${FilterEntity.dataAuth}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}
    ${uri}=    set variable    /daas/internal/group/kpi/wl
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/wl/total
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/wl/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/trend/total
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/trend/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/session/tag
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/session/tag
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/message/count
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/message/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/session/time
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/session/time
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/kpi/wq
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dataAuth=${FilterEntity.dataAuth}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}
    ${uri}=    set variable    /daas/internal/agent/kpi/wq
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/group/kpi/wq
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dataAuth=${FilterEntity.dataAuth}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}
    ${uri}=    set variable    /daas/internal/group/kpi/wq
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/wq/total
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/wq/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/vm
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/vm
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/qm
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/qm
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/effective
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/effective
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/response/first
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/response/first
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/dist/response/avg
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/session/dist/response/avg
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/serve
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}
    ${uri}=    set variable    /daas/internal/agent/serve
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/serve/detail
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&agentId=${agent.userId}&order=${FilterEntity.order}
    ${uri}=    set variable    /daas/internal/agent/serve/detail
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/visitor/total
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=V_ORIGINTYPE
    ${uri}=    set variable    /daas/internal/visitor/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/visitor/trend
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=V_ORIGINTYPE
    ${uri}=    set variable    /daas/internal/visitor/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/visitor/count
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&queryType=V_ORIGINTYPE
    ${uri}=    set variable    /daas/internal/visitor/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/wait/total
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&waitTime=${FilterEntity.waitTime}
    ${uri}=    set variable    /daas/internal/wait/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/wait/hour/create
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&waitTime=${FilterEntity.waitTime}
    ${uri}=    set variable    /daas/internal/wait/hour/create
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/wait/day/create
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&waitTime=${FilterEntity.waitTime}
    ${uri}=    set variable    /daas/internal/wait/day/create
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/wait/hour/wait
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&waitTime=${FilterEntity.waitTime}
    ${uri}=    set variable    /daas/internal/wait/hour/wait
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/wait/trend
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&waitTime=${FilterEntity.waitTime}
    ${uri}=    set variable    /daas/internal/wait/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/wait/session/tag
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&waitTime=${FilterEntity.waitTime}&sessionTag=all
    ${uri}=    set variable    /daas/internal/wait/session/tag
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/monitor/agent/status/dist
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/monitor/agent/status/dist
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/monitor/agent/load
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/monitor/agent/load
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/monitor/wait/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/monitor/wait/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/monitor/session/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/monitor/session/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/monitor/visitor/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/monitor/visitor/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/monitor/quality/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/monitor/quality/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/monitor/list/session/start
    [Arguments]    ${agent}    ${timeout}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    top=${FilterEntity.top}&objectType=${FilterEntity.objectType}
    ${uri}=    set variable    /daas/internal/monitor/list/session/start
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/monitor/list/first/response
    [Arguments]    ${agent}    ${timeout}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    top=${FilterEntity.top}&objectType=${FilterEntity.objectType}
    ${uri}=    set variable    /daas/internal/monitor/list/first/response
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/monitor/list/visitor/mark
    [Arguments]    ${agent}    ${timeout}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    top=${FilterEntity.top}&objectType=${FilterEntity.objectType}
    ${uri}=    set variable    /daas/internal/monitor/list/visitor/mark
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/monitor/list/response/time
    [Arguments]    ${agent}    ${timeout}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    top=${FilterEntity.top}&objectType=${FilterEntity.objectType}
    ${uri}=    set variable    /daas/internal/monitor/list/response/time
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/file/wl
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&objectType=${FilterEntity.objectType}
    ${uri}=    set variable    /daas/internal/session/file/wl
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/session/file/wq
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&objectType=${FilterEntity.objectType}
    ${uri}=    set variable    /daas/internal/session/file/wq
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/visitor/file
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&queryType=V_ORIGINTYPE
    ${uri}=    set variable    /daas/internal/visitor/file
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/wait/file
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&waitTime=${FilterEntity.waitTime}
    ${uri}=    set variable    /daas/internal/wait/file
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/file/serve
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    ${uri}=    set variable    /daas/internal/agent/file/serve
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/file/serve/detail
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&queryTypes=${FilterEntity.queryTypes}
    ${uri}=    set variable    /daas/internal/agent/file/serve/detail
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}


/daas/internal/agent/detail/total
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    ${uri}=    set variable    /daas/internal/agent/detail/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/detail/serve
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    ${uri}=    set variable    /daas/internal/agent/detail/serve
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/detail/trend
    [Arguments]    ${agent}    ${timeout}    ${DateRange}
    ${header}=    Create Dictionary    tenantId="${agent.tenantId}"    SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    ${uri}=    set variable    /daas/internal/agent/detail/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
