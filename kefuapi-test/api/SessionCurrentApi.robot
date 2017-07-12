*** Keywords ***
/v1/tenants/{tenantId}/servicesessioncurrents
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessioncurrents
    ${params}    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&state=${FilterEntity.state}&isAgent=${FilterEntity.isAgent}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&sortOrder=${FilterEntity.sortOrder}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}&visitorName=${FilterEntity.visitorName}&agentName=${FilterEntity.username}&userTagIds=${FilterEntity.userTagIds}&agentIds=${FilterEntity.agentIds}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/processingsessions/count
    [Arguments]    ${agent}    ${state}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/processingsessions/count
    ${params}    set variable    state=${state}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
