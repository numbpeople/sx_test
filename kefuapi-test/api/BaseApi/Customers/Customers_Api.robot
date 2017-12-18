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

/v1/crm/tenants/{tenantId}/visitors/{visitorId}/tags
    [Arguments]    ${agent}    ${userId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/visitors/${userId}/tags
    ${params}=    set variable    _=1511076561527
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/crm/tenants/{tenantId}/filters
    [Arguments]    ${method}    ${agent}    ${timeout}    ${data}    ${filterId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/filters
    run keyword if    '${method}'=='put' or '${method}'=='delete'    set suite variable    ${uri}    /v1/crm/tenants/${agent.tenantId}/filters/${filterId}
    ${params}=    set variable    _=1511151681867
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/crm/tenants/{tenantId}/visitor/{visitorId}/filters
    [Arguments]    ${agent}    ${userId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/visitor/${userId}/filters
    ${params}=    set variable    _=1511076561527
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
