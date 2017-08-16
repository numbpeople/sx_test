*** Keywords ***
/v1/webimplugin/tenants/{tenantId}/sessions/{serviceSessionId}/continue-wait
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/tenants/${agent.tenantId}/sessions/${serviceSessionId}/continue-wait
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/waitings
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /waitings
    ${params}=    set variable    page=${FilterEntity.page}&size=${FilterEntity.per_page}&originType=${FilterEntity.originType}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}&techChannelId=${FilterEntity.techChannelId}&techChannelType=${FilterEntity.techChannelType}&visitorName=${FilterEntity.visitorName}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
