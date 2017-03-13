*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        routing
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          RoutingApi.robot
Library           uuid

*** Test Cases ***
渠道指定规则()
    [Documentation]    设置路由规则：
    ...
    ...    规则为：渠道指定技能组规则
    ...
    ...    前提：
    ...    1.将关联a指定为空
    ...    2.渠道指定技能组A
    [Tags]
    #将规则排序设置为渠道优先
    ${data}=    set variable    {"value":"Channel:ChannelData:UserSpecifiedChannel:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取/设置渠道指定
    ${data}=    set variable    {"id":1087,"tenantId":5371,"channelType":"webim","dutyType":"Allday","agentQueueId":23252,"secondQueueId":0,"robotId":null,"secondRobotId":null,"createDateTime":1489409172000}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    post    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
