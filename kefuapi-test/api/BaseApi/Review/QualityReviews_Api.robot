*** Keywords ***
/v1/tenants/{tenantId}/servicesessions/qualityreviews
    [Arguments]    ${agent}    ${filter}    ${range}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/qualityreviews
    ${params}=    set variable    page=${filter.page}&pagesize=${filter.per_page}&beginDateTime=${range.beginDate}&endDateTime=${range.endDate}&firstResponseTime=${filter.firstResponseTime}&sessionTime=${filter.sessionTime}&avgResponseTime=${filter.avgResponseTime}&visitorMark=${filter.visitorMark}&originType=${filter.originType}&sessionTag=${filter.sessionTag}&agentUserId=${filter.agentUserId}&channelId=${filter.channelId}&hasQM=${filter.hasQM}&groupId=${filter.groupId}&rangeValue=${filter.rangeValue}&qmActorId=${filter.qmActorId}&asc=${filter.asc}&amsgCount=${filter.amsgCount}&vmsgCount=${filter.vmsgCount}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview
    [Arguments]    ${method}    ${agent}    ${timeout}    ${sessionInfo}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${sessionInfo.serviceSessionId}/steps/${sessionInfo.stepNum}/qualityreview
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/quality/tenants/{tenantId}/appeals
    [Arguments]    ${method}    ${agent}    ${range}    ${paramsOrData}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/quality/tenants/${agent.tenantId}/appeals
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${paramsOrData}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${paramsOrData}    timeout=${timeout}

/v1/quality/tenants/{tenantId}/appeal-amounts
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/quality/tenants/${agent.tenantId}/appeal-amounts
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/quality/tenants/{tenantId}/appeals/{id}
    [Arguments]    ${agent}    ${timeout}    ${id}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/quality/tenants/${agent.tenantId}/appeals/${id}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}