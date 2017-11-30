*** Keywords ***
/tenants/{tenantId}/serviceSessionHistoryFiles
    [Arguments]    ${method}    ${agent}    ${timeout}    ${filter}    ${range}    ${userId}=
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessionHistoryFiles
    ${params}=    set variable    beginDate=${range.beginDate}&endDate=${range.endDate}&techChannelId=${filter.techChannelId}&techChannelType=${filter.techChannelType}&customerName=${filter.customerName}&sortOrder=${filter.sortOrder}&state=${filter.state}&originType=${filter.originType}&transfered=${filter.transfered}&fromAgentCallback=${filter.fromAgentCallback}&summaryIds=${filter.summaryIds}&queueId=${filter.queueId}&isAgent=${filter.isAgent}&withMessage=${filter.withMessage}
    Run Keyword If    '${method}'=='get'    set suite variable    ${params}    agentUserId=${userId}&page=0&size=15&_=1511953848655
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}

/v1/Tenant/me/ServiceSessionHistorys
    [Arguments]    ${agent}    ${filter}    ${range}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSessionHistorys
    ${params}=    set variable    page=${filter.page}&per_page=${filter.per_page}&state=${filter.state}&isAgent=${filter.isAgent}&originType=${filter.originType}&techChannelId=${filter.techChannelId}&techChannelType=${filter.techChannelType}&visitorName=${filter.visitorName}&summaryIds=${filter.summaryIds}&sortOrder=${filter.sortOrder}&stopDateFrom=${range.stopDateFrom}&stopDateTo=${range.stopDateTo}&sortField=${filter.sortField}
    run keyword if    '${filter.sortField}' == 'startDateTime'    Set Suite Variable    ${params}    page=${filter.page}&per_page=${filter.per_page}&state=${filter.state}&isAgent=${filter.isAgent}&originType=${filter.originType}&techChannelId=${filter.techChannelId}&techChannelType=${filter.techChannelType}&visitorName=${filter.visitorName}&summaryIds=${filter.summaryIds}&sortOrder=${filter.sortOrder}&beginDate=${range.beginDate}&endDate=${range.endDate}&sortField=${filter.sortField}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
