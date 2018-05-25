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

/customers/_search
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /customers/_search
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
    
/v1/crm/tenants/{tenantId}/customers/newfile
    [Arguments]    ${agent}    ${data}    ${language}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/customers/newfile
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/download/tplfiles/%E5%AE%A2%E6%88%B7%E4%B8%AD%E5%BF%83%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xlsx
    [Arguments]    ${agent}    ${language}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /download/tplfiles/%E5%AE%A2%E6%88%B7%E4%B8%AD%E5%BF%83%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xlsx
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    
