*** Keywords ***
/tenants/{tenantId}/projects
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取租户的project的数据
    ...
    ...    Request URL:/tenants/{tenantId}/projects
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects
    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}&userRoles=${agent.roles}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/status
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取租户的project的留言数据
    ...
    ...    Request URL:/tenants/{tenantId}/projects/{projectId}/status
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/status
    Comment    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}&userRoles=${agent.roles}&_=1487571783832
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/count
    [Arguments]    ${agent}    ${projectId}    ${statusId}    ${userId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/count
    ${params}=    set variable    statusIds=${statusId}&agentUserId=${userId}&_=1487581383150
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${filter.projectId}/tickets/${filter.ticketId}?_=1487653208290
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}    ${visitor}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=${filter.Authorization}
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${filter.projectId}/tickets
    ${params}=    set variable    tenantId=${filter.tenantId}&userId=${filter.userId}&userRoles=${filter.userRoles}&page=${filter.page}&size=${filter.size}&ticketId=${filter.ticketId}&sort=${filter.sort}&statusId=${filter.statusId}&visitorName=${filter.visitorName}&assigned=${filter.assigned}&agentIds=${filter.agentIds}&_=1526882000450
    run keyword if    '${method}'=='post' and '${filter.Authorization}'!='${EMPTY}'    set suite variable    ${params}    tenantId=${visitor.tenantId}&easemob-target-username=${visitor.imServiceNumber}&easemob-appkey=${visitor.appkey}&easemob-username=${visitor.username}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    data=${data}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${filter.projectId}/tickets/${filter.ticketId}/comments
    ${params}=    set variable    size=${filter.size}&page=${filter.page}&_=1488265090009
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/categories
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取租户的project的分类数据
    ...
    ...    Request URL:/tenants/{tenantId}/projects/{projectId}/categories
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/categories
    ${params}=    set variable    page=0&size=100&_=1488269884579
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/projects/{projectId}/tickets/file
    [Arguments]    ${agent}    ${filter}    ${language}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/projects/${filter.projectId}/tickets/file
    ${params}=    set variable    tenantId=${filter.tenantId}&userId=${filter.userId}&userRoles=${filter.userRoles}&ticketId=${filter.ticketId}&visitorName=${filter.visitorName}&statusId=${filter.statusId}&sort=${filter.sort}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/{assigneeId}
    [Arguments]    ${agent}    ${filter}    ${assigneeId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${filter.projectId}/tickets/${filter.ticketId}/assign/${assigneeId}
    ${params}=    set variable    userId=${agent.userId}&tenantId=${agent.tenantId}&userRoles=${agent.roles}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/take
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${filter.projectId}/tickets/${filter.ticketId}/take
    ${params}=    set variable    userId=${agent.userId}&tenantId=${agent.tenantId}&userRoles=${agent.roles}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/countAll
    [Arguments]    ${agent}    ${timeout}    ${str}
    [Documentation]    Description:
    ...
    ...    获取租户全部留言数据
    ...
    ...    Request URL:/tenants/{tenantId}/projects/{projectId}/tickets/count
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/count
    ${params}=    set variable    statusIds=${str}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

v1/tickets/tenants/{tenantId}/projects/{projectId}/tickets/unassignee/count
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    获取租户的project的未分配留言数据
    ...
    ...    Request URL:v1/tickets/tenants/{tenantId}/projects/{projectId}/tickets/unassignee/count
    ...
    ...    \ \ \ \ \ \ \ \ \ \ \ v1/tickets/tenants/28076/projects/398001/tickets/unassignee/count
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    v1/tickets/tenants/${agent.tenantId}/projects/${projectId}/tickets/unassignee/count
    Comment    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}&userRoles=${agent.roles}&
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/countUnfix
    [Arguments]    ${agent}    ${timeout}    ${statusIds}    ${str}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/count
    ${params}=    set variable    statusIds=${statusIds[2]}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/countFixed
    [Arguments]    ${agent}    ${timeout}    ${statusIds}    ${str}
    [Documentation]    已解决
    ...
    ...
    ...    /tenants/{tenantId}/projects/{projectId}/tickets/countfixed
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/count
    ${params}=    set variable    statusIds=${statusIdS[1]}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/countFixing
    [Arguments]    ${agent}    ${timeout}    ${statusIds}    ${str}
    [Documentation]    获取处理中留言
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/count
    ${params}=    set variable    statusIds=${statusIds[0]}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
