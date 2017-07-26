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
