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
    ...    Request Method: GET / PUT / POST / DELETE
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/channel-binding
    ${params}=    set variable    page=1&per_page=100&_=1489409326850
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/channel-data-binding
    [Arguments]    ${agent}    ${channeldata}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/channel-data-binding
    ${params}    set variable    dutyType=${channeldata.dutyType}&id=${channeldata.id}&id2=${channeldata.id2}&type=${channeldata.type}&type2=${channeldata.type2}&
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    data=${data}
    ...    timeout=${timeout}
