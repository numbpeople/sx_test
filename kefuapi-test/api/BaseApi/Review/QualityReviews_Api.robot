*** Keywords ***
/v1/tenants/{tenantId}/servicesessions/qualityreviews
    [Arguments]    ${agent}    ${filter}    ${range}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/qualityreviews
    ${params}=    set variable    page=${filter.page}&pagesize=${filter.per_page}&beginDateTime=${range.beginDate}&endDateTime=${range.endDate}&firstResponseTime=${filter.firstResponseTime}&sessionTime=${filter.sessionTime}&avgResponseTime=${filter.avgResponseTime}&visitorMark=${filter.visitorMark}&originType=${filter.originType}&sessionTag=${filter.sessionTag}&agentUserId=${filter.agentUserId}&channelId=${filter.channelId}&hasQM=${filter.hasQM}&groupId=${filter.groupId}&rangeValue=${filter.rangeValue}&qmActorId=${filter.qmActorId}&asc=${filter.asc}&amsgCount=${filter.amsgCount}&vmsgCount=${filter.vmsgCount}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview
    [Arguments]    ${agent}    ${timeout}    ${sessionInfo}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${sessionInfo.serviceSessionId}/steps/${sessionInfo.stepNum}/qualityreview
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
