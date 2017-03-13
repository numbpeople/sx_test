*** Variables ***

*** Keywords ***
/tenants/{tenantId}/options/RoutingPriorityList
    [Arguments]    ${agent}    ${timeout}    ${data}
    [Documentation]    Description:
    ...
    ...    调整租户路由的规则排序
    ...
    ...    Request URL:/tenants/{tenantId}/options/RoutingPriorityList
    ...
    ...    Request Method: PUT
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/options/RoutingPriorityList
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/tenants/{tenantId}/channel-binding
    [Arguments]    ${method}    ${agent}    ${timeout}    ${data}
    [Documentation]    Description:
    ...
    ...    获取/调整租户渠道指定规则
    ...
    ...    Request URL: /v1/tenants/{tenantId}/channel-binding
    ...
    ...    Request Method: GET / PUT
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/channel-binding
    ${params}=    set variable    page=1&per_page=100&_=1489409326850
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
