*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/RoutingApi.robot

*** Keywords ***
Add Routing
    [Arguments]    ${originTypeentity}    ${agentQueueId}=0    ${secondQueueId}=0    ${robotId}=null    ${secondRobotId}=null
    [Documentation]    渠道指定技能组/机器人
    ...
    ...    describtion：包含字段
    ...
    ...    参数：
    ...
    ...    ${originTypeentity} 渠道设置的值
    ...
    ...    ${agentQueueId}=0 第一个技能组Id值，默认为0
    ...
    ...    ${secondQueueId}=0 第二个技能组Id值，默认为0
    ...
    ...    ${robotId}=null \ 第一个机器人Id值，默认为null
    ...
    ...    ${secondRobotId}=null 第二个机器人Id值，默认为null
    #将渠道绑定到技能组或机器人
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"${originTypeentity.dutyType}","agentQueueId":${agentQueueId},"robotId":${robotId},"secondQueueId":${secondQueueId},"secondRobotId":${secondRobotId}}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    post    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}

Update Routing
    [Arguments]    ${originTypeentity}    ${agentQueueId}=0    ${secondQueueId}=0    ${robotId}=null    ${secondRobotId}=null
    [Documentation]    渠道指定技能组/机器人
    ...
    ...    describtion：包含字段
    ...
    ...    参数：
    ...
    ...    ${originTypeentity} 渠道设置的值
    ...
    ...    ${agentQueueId}=0 第一个技能组Id值，默认为0
    ...
    ...    ${secondQueueId}=0 第二个技能组Id值，默认为0
    ...
    ...    ${robotId}=null \ 第一个机器人Id值，默认为null
    ...
    ...    ${secondRobotId}=null 第二个机器人Id值，默认为null
    #获取对应渠道的信息
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${Empty}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    Exit For Loop If    '${j['content'][${i}]['channelType']}' =='${originTypeentity.originType}'
    Comment    Return From Keyword If    '${j['content'][${i}]['channelType']}' !='${originTypeentity.originType}'
    set to dictionary    ${originTypeentity}    id=${j['content'][${i}]['id']}
    #修改渠道绑定关系
    ${data}=    set variable    {"id":${originTypeentity.id},"tenantId":${AdminUser.tenantId},"channelType":"${originTypeentity.originType}","dutyType":"${originTypeentity.dutyType}","agentQueueId":${agentQueueId},"secondQueueId":${secondQueueId},"robotId":${robotId},"secondRobotId":${secondRobotId},"createDateTime":1489485870000}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    put    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

Update Routing Ext
    [Arguments]    ${originTypeentity}    ${agentQueueId}=0    ${secondQueueId}=0    ${robotId}=null    ${secondRobotId}=null
    [Documentation]    渠道指定技能组/机器人
    ...
    ...    describtion：包含字段
    ...
    ...    参数：
    ...
    ...    ${originTypeentity} 渠道设置的值
    ...
    ...    ${agentQueueId}=0 第一个技能组Id值，默认为0
    ...
    ...    ${secondQueueId}=0 第二个技能组Id值，默认为0
    ...
    ...    ${robotId}=null \ 第一个机器人Id值，默认为null
    ...
    ...    ${secondRobotId}=null 第二个机器人Id值，默认为null
    #获取对应渠道的信息
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${Empty}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    Exit For Loop If    '${j['content'][${i}]['channelType']}' =='${originTypeentity.originType}'
    Comment    Return From Keyword If    '${j['content'][${i}]['channelType']}' !='${originTypeentity.originType}'
    set to dictionary    ${originTypeentity}    id=${j['content'][${i}]['id']}
    #修改渠道绑定关系
    ${data}=    set variable    {"id":${originTypeentity.id},"tenantId":${AdminUser.tenantId},"channelType":"${originTypeentity.originType}","dutyType":"${originTypeentity.dutyType}","agentQueueId":${agentQueueId},"secondQueueId":${secondQueueId},"robotId":${robotId},"secondRobotId":${secondRobotId},"createDateTime":1489485870000,"timeScheduleId":${originTypeentity.scheduleId}}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    put    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

Delete Routing
    [Arguments]    ${originTypeentity}    ${queueentity}
    [Documentation]    删除渠道绑定关系
    #获取对应渠道的信息
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    Exit For Loop If    '${j['content'][${i}]['channelType']}' =='${originTypeentity.originType}'
    Return From Keyword If    '${j['content'][${i}]['channelType']}' !='${originTypeentity.originType}'
    set to dictionary    ${originTypeentity}    id=${j['content'][${i}]['id']}
    #删除渠道绑定关系
    ${data}=    set variable    {"id":${originTypeentity.id},"tenantId":${AdminUser.tenantId},"channelType":"${originTypeentity.originType}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"secondQueueId":0,"robotId":null,"secondRobotId":null,"createDateTime":1489485870000}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    delete    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

Set RoutingPriorityList
    [Arguments]    ${firstValue}    ${secondValue}    ${thirdValue}    ${agent}=${AdminUser}
    [Documentation]    设置会话分配的优先级
    ...
    ...    Arguments(可以随意放置位置):
    ...
    ...    渠道、关联、入口
    @{list}    create list    ${firstValue}    ${secondValue}    ${thirdValue}
    #将规则排序设置为渠道优先
    @{keys}    Get Dictionary Keys    ${PriorityEntity}
    ${s}=    set variable    ${EMPTY}
    : FOR    ${i}    IN    @{list}
    \    log    ${i}
    \    ${j}    Get From Dictionary    ${PriorityEntity}    ${i}
    \    ${s}=    evaluate    '${s}:${j}'
    log    ${s}
    #将规则排序设置为渠道优先
    ${s}    Strip String    ${s}    mode=left    characters=:
    log    ${s}
    ${data}=    set variable    {"value":"${s}:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${agent}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

Get Routing
    [Documentation]    获取路由规则中渠道绑定的关系
    ...
    ...    Return：
    ...
    ...    请求返回值：resp
    #判断渠道是否有绑定关系
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Set ChannelData Routing
    [Arguments]    ${agent}    ${cdata}    ${data}
    [Documentation]    关联绑定机器人或者技能组
    ...
    ...    Arguments：
    ...
    ...    ${AdminUser}、${cdata} 、${data}
    #关联绑定技能组或机器人
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${agent}    ${cdata}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

Reverse All Rules Status
    [Arguments]    ${agent}    ${currentstatus}='true'
    [Documentation]    ${currentstatus}只能是字符串'true'或'false'
    ${j}    Get All Rules    ${agent}
    ${l}    Get Length    ${j['entity']}
    Return From Keyword If    ${l}==0    -1
    :FOR    ${i}    IN    @{j['entity']}
    \    Run Keyword If    '${i['rule_set_enable']}'==${currentstatus}    Reverse Rule satus    ${agent}    ${i}    ${currentstatus}

Update Rule Status
    [Arguments]    ${agent}    ${data}
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets/{ruleId}    put    ${AdminUser}    ${data['rule_set_id']}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    开启rule返回不正确的状态码:${resp.status_code};${resp.text}

Reverse RuleString Status
    [Arguments]    ${rulestr}    ${currentstatus}='true'
    [Documentation]    ${currentstatus}只能是字符串'true'或'false'
    ${s}    run keyword if    ${currentstatus}=='true'    replace string    '${rulestr}'    true    false
    ...    ELSE    replace string    '${rulestr}'    false    true
    ${s}    replace string    ${s}    '    "
    ${s}    replace string    ${s}    u"    "
    ${data}    strip string    ${s}    characters="
    ${data}    to json    ${data}
    return from keyword    ${data}

Get All Rules
    [Arguments]    ${agent}
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets    get    ${agent}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rule返回不正确的状态码:${resp.status_code};${resp.text}
    Comment    ${j}    to json    ${resp.content}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Reverse Rule satus
    [Arguments]    ${agent}    ${rulestr}    ${currentstatus}='true'
    [Documentation]    ${currentstatus}只能是字符串'true'或'false'
    ${data}    Reverse RuleString Status    ${rulestr}    ${currentstatus}
    Update Rule Status    ${agent}    ${data}
