*** Keywords ***
/v1/tenants/{tenantId}/searchrecords
    [Arguments]    ${method}    ${agent}    ${filter}    ${timeout}    ${data}=
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/searchrecords
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&_=1512385488441
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/chatmessagehistorys
    [Arguments]    ${agent}    ${filter}    ${range}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/chatmessagehistorys
    ${params}=    set variable    page=${filter.page}&per_page=${filter.per_page}&state=${filter.state}&isAgent=${filter.isAgent}&originType=${filter.originType}&techChannelId=${filter.techChannelId}&techChannelType=${filter.techChannelType}&visitorName=${filter.visitorName}&summaryIds=${filter.summaryIds}&sortOrder=${filter.sortOrder}&beginDate=${range.beginDate}&endDate=${range.endDate}&message=${filter.message}
    log    ${params}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
