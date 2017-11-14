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
    [Arguments]    ${agent}    ${timeout}    ${str}
    [Documentation]    Description:
    ...
    ...    获取租户，坐席留言的未读数据
    ...
    ...    Request URL: /tenants/{tenantId}/projects/{projectId}/tickets/count
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/count
    ${params}=    set variable    statusIds=${str}&agentUserId=${agent.userId}&_=1487581383150
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取租户某留言的全部信息
    ...
    ...    Request URL: /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/${ticketEntity.ticketId}?_=1487653208290
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets
    [Arguments]    ${agent}    ${timeout}    ${data}
    [Documentation]    Description:
    ...
    ...    发送留言
    ...
    ...    Request URL: /tenants/{tenantId}/projects/{projectId}/tickets
    ...
    ...    Request Method:POST
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments
    [Arguments]    ${method}    ${agent}    ${timeout}    ${data}
    [Documentation]    Description:
    ...
    ...    发起评论
    ...
    ...    Request URL: /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments
    ...
    ...    Request Method: GET / POST
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/${ticketEntity.ticketId}/comments
    ${params}=    set variable    size=10000&page=0&_=1488265090009
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
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    下载留言文件
    ...
    ...    Request URL:/v1/tenants/{tenantId}/projects/{projectId}/tickets/file
    ...
    ...    Request Method:POST
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/projects/${projectId}/tickets/file
    ${params}=    set variable    sort=updatedAt,desc&tenantId=${agent.tenantId}&userId=${agent.userId}&userRoles=${agent.roles}&ticketId=&assigned=0&assignee=${agent.userId}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/{assigneeId}
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    分配留言给其他坐席
    ...
    ...    Request URL: /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/{assigneeId}
    ...
    ...    Request Method:POST
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects/${projectId}/tickets/${ticketEntity.ticketId}/assign/${agent.userId}
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
