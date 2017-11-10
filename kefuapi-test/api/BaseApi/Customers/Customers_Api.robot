*** Keywords ***
/v1/crm/tenants/{tenantId}/agents/{agentId}/customers
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/agents/${agent.userId}/customers
    ${params}=    set variable    page=${FilterEntity.page}&size=${FilterEntity.per_page}&userTagIds=${FilterEntity.userTagIds}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&enquirySummary=${FilterEntity.enquirySummary}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/crm/tenants/{tenantId}/customers
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/customers
    ${params}=    set variable    page=${FilterEntity.page}&size=${FilterEntity.per_page}&userTagIds=${FilterEntity.userTagIds}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&enquirySummary=${FilterEntity.enquirySummary}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
