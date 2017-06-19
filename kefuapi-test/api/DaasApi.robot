*** Settings ***
Library           uuid

*** Keywords ***
/daas/internal/agent/online
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId=${agent.tenantId}   SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/agent/online
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/session/today/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId=${agent.tenantId}   SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/session/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/session/today/processing
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId=${agent.tenantId}   SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/session/today/processing
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/message/today/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId=${agent.tenantId}   SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/message/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/daas/internal/session/trend
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId=${agent.tenantId}   SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}
    ${uri}=    set variable    /daas/internal/session/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/message/trend
    [Arguments]    ${agent}    ${timeout}    ${DateRange}    ${FilterEntity}
    ${header}=    Create Dictionary    tenantId=${agent.tenantId}   SESSION=${agent.session}    userid=${agent.userId}
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}
    ${uri}=    set variable    /daas/internal/message/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/daas/internal/agent/kpi/session/today
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    tenantId=${agent.tenantId}   SESSION=${agent.session}    userid=${agent.userId}
    ${uri}=    set variable    /daas/internal/agent/kpi/session/today
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
