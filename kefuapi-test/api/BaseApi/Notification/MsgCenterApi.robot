*** Keywords ***
/v1/tenants/{tenantId}/activities
    [Arguments]    ${agent}    ${timeout}    ${data}
    [Documentation]    Description:
    ...
    ...    发起消息中心未读消息
    ...
    ...    Request URL:/v1/tenants/{tenantId}/activities
    ...
    ...    Request Method:POST
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/activities
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/users/{agentUserId}/activities
    [Arguments]    ${agent}    ${timeout}    ${status}
    [Documentation]    Description:
    ...
    ...    获取坐席的消息中心消息
    ...
    ...    Request URL:/users/{agentUserId}/activities
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /users/${agent.userId}/activities
    ${params}=    set variable    page=1&per_page=10000&status=${status}&_=1488354736235
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/users/{agentUserId}/feed/info
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取未读消息数接口
    ...
    ...    Request URL:/users/{agentUserId}/feed/info
    ...
    ...    Request Method:GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /users/${agent.userId}/feed/info
    ${params}=    set variable    ?_=1488357123333
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v2/users/{agentUserId}/activities/{activitiesId}
    [Arguments]    ${agent}    ${activitiesId}    ${timeout}
    [Documentation]    Description:
    ...
    ...    标记已读消息
    ...
    ...    Request URL: /v2/users/{agentUserId}/activities/{activitiesId}
    ...
    ...    Request Method:PUT
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/users/${agent.userId}/activities/${activitiesId}
    ${data}=    set variable    {"status":"read"}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/tenants/{tenantId}/agents/{userId}/activities
    [Arguments]    ${method}    ${agent}    ${timeout}    ${data}
    [Documentation]    Description:
    ...
    ...    获取或发送新通知给其他坐席
    ...
    ...    Request URL: /v1/tenants/{tenantId}/agents/{userId}/activities
    ...
    ...    Request Method:POST / GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/agents/${agent.userId}/activities
    ${params}=    set variable    per_page=10000&_=1488440525653
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/users/{agentId}/feed/info
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /users/${agent.userId}/feed/info
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/users/{agentId}/activities
    [Arguments]    ${agent}    ${FilterEntity}    ${MsgCenterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSessionHistorys
    ${params}=    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&total_pages=${MsgCenterEntity.total_pages}&total_entries=${MsgCenterEntity.total_entries}&status=${MsgCenterEntity.status}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
