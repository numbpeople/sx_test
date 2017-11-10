*** Keywords ***
/tenants/{tenantId}/serviceSessionHistoryFiles
    [Arguments]    ${method}    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessionHistoryFiles
    ${params}=    set variable    beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}&techChannelId=${FilterEntity.techChannelId}&techChannelType=${FilterEntity.techChannelType}&customerName=${FilterEntity.customerName}&sortOrder=${FilterEntity.sortOrder}&state=${FilterEntity.state}&originType=${FilterEntity.originType}&transfered=${FilterEntity.transfered}&fromAgentCallback=${FilterEntity.fromAgentCallback}&summaryIds=${FilterEntity.summaryIds}&queueId=${FilterEntity.queueId}&isAgent=${FilterEntity.isAgent}&withMessage=${FilterEntity.withMessage}
    ${rs}=    Run Keyword If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/v1/Tenant/me/ServiceSessionHistorys
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSessionHistorys
    ${params}=    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&state=${FilterEntity.state}&isAgent=${FilterEntity.isAgent}&originType=${FilterEntity.originType}&techChannelId=${FilterEntity.techChannelId}&techChannelType=${FilterEntity.techChannelType}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&sortOrder=${FilterEntity.sortOrder}&stopDateFrom=${DateRange.stopDateFrom}&stopDateTo=${DateRange.stopDateTo}&sortField=${FilterEntity.sortField}
    run keyword if    '${FilterEntity.sortField}' == 'startDateTime'    Set Suite Variable    ${params}    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&state=${FilterEntity.state}&isAgent=${FilterEntity.isAgent}&originType=${FilterEntity.originType}&techChannelId=${FilterEntity.techChannelId}&techChannelType=${FilterEntity.techChannelType}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&sortOrder=${FilterEntity.sortOrder}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}&sortField=${FilterEntity.sortField}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
