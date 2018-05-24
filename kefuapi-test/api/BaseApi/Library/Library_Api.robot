*** Keywords ***
/v1/Tenants/{tenantId}/robot/media/items
    [Arguments]    ${method}    ${agent}    ${filter}    ${files}    ${itemId}    ${timeout}
    ${header}=    Create Dictionary    #Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/media/items
    run keyword if    '${method}'=='post'     set suite variable    ${uri}    /v1/Tenants/${agent.tenantId}/robot/media/item
    run keyword if    '${method}'=='delete'     set suite variable    ${uri}    /v1/Tenants/${agent.tenantId}/robot/media/item/${itemId}
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&q=${filter.q}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    files=${files}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/news/search
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}    ${newsId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/news/search
    run keyword if    '${method}'=='post' or '${method}'=='put'     set suite variable    ${uri}    /v1/Tenants/${agent.tenantId}/robot/news
    run keyword if    '${method}'=='delete'     set suite variable    ${uri}    /v1/Tenants/${agent.tenantId}/robot/news/${newsId}
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&keyword=${filter.keyword}&source=${filter.source}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}