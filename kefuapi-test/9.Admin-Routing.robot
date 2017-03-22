*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        routing
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/RoutingApi.robot
Resource          api/KefuApi.robot
Library           uuid
Resource          commons/admin common/admin_common.robot

*** Test Cases ***
渠道指定规则(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：渠道指定技能组规则
    ...
    ...    前提：
    ...    1.渠道指定技能组A
    ...    2.将关联a指定为空
    [Tags]
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}
    ${queueentity}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${restentity}=    Add Channel    #快速创建一个关联
    #将规则排序设置为渠道优先
    ${data}=    set variable    {"value":"Channel:ChannelData:UserSpecifiedChannel:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #判断渠道是否有绑定关系
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentity}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentity}
    #获取关联appkey的token
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${restentity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    Comment    ${filterentity}=    create dictionary    visitorName=${GuestEntity.userName}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #技能组和关联信息
    Delete Agentqueue    ${queueentity.queueId}
    Delete Channel    ${restentity.channelId}

关联指定规则(/v1/tenants/{tenantId}/channel-data-binding)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：关联指定技能组规则
    ...
    ...    前提：
    ...    1.将关联a指定技能组A
    ...    2.渠道未设置
    [Tags]
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}
    ${queueentity}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${restentity}=    Add Channel    #快速创建一个关联
    #将规则排序设置为渠道优先
    ${data}=    set variable    {"value":"ChannelData:Channel:UserSpecifiedChannel:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentity.queueId}    id2=0    type=agentQueue    type2=
    set to dictionary    ${queueentity}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    log    ${data}
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${AdminUser}    ${cData}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取渠道绑定关系
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentity}
    Run Keyword If    ${listlength} > 0    Delete Routing    ${originTypeentity}    ${queueentity}
    #获取关联appkey的token
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${restentity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    Comment    ${filterentity}=    create dictionary    visitorName=${GuestEntity.userName}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #技能组和关联信息
    Delete Agentqueue    ${queueentity.queueId}
    Delete Channel    ${restentity.channelId}

入口指定规则(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：入口指定技能组规则
    ...
    ...    前提：
    ...    1.将入口优先级最先
    [Tags]
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}
    ${queueentity}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${restentity}=    Add Channel    #快速创建一个关联
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentity.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #将入口指定设置优先顺序
    ${data}=    set variable    {"value":"UserSpecifiedChannel:ChannelData:Channel:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取关联appkey的token
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${restentity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    Comment    ${filterentity}=    create dictionary    visitorName=${GuestEntity.userName}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #技能组和关联信息
    Delete Agentqueue    ${queueentity.queueId}
    Delete Channel    ${restentity.channelId}

渠道和关联指定规则(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：渠道/关联指定技能组规则
    ...
    ...    前提：
    ...    1.将渠道指定技能组A
    ...    2.关联指定技能组B
    [Tags]
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentity}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentity1}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #快速创建一个关联
    ${restentity}=    Add Channel
    #将规则排序设置为渠道->关联指定优先
    ${data}=    set variable    {"value":"Channel:ChannelData:UserSpecifiedChannel:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取渠道绑定关系
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentity}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentity}
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentity1.queueId}    id2=0    type=agentQueue    type2=
    set to dictionary    ${queueentity1}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity1.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity1.channelData.id}","type1":"${queueentity1.channelData.type}","id2":"${queueentity1.channelData.id2}","type2":"${queueentity1.channelData.type2}"}
    log    ${data}
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${AdminUser}    ${cData}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取关联appkey的token
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${restentity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    Comment    ${filterentity}=    create dictionary    visitorName=${GuestEntity.userName}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #技能组和关联信息
    Delete Agentqueue    ${queueentity.queueId}
    Delete Agentqueue    ${queueentity1.queueId}
    Delete Channel    ${restentity.channelId}

关联和渠道指定规则(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：关联/渠道指定技能组规则
    ...
    ...    前提：
    ...    1.关联指定技能组A
    ...    2.将渠道指定技能组B
    [Tags]
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentity}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentity1}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #快速创建一个关联
    ${restentity}=    Add Channel
    #将规则排序设置为渠道->关联指定优先
    ${data}=    set variable    {"value":"ChannelData:Channel:UserSpecifiedChannel:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentity.queueId}    id2=0    type=agentQueue    type2=
    set to dictionary    ${queueentity}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    log    ${data}
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${AdminUser}    ${cData}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取渠道绑定关系
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity1.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentity1}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentity1}
    #获取关联appkey的token
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${restentity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    Comment    ${filterentity}=    create dictionary    visitorName=${GuestEntity.userName}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #技能组和关联信息
    Delete Agentqueue    ${queueentity.queueId}
    Delete Agentqueue    ${queueentity1.queueId}
    Delete Channel    ${restentity.channelId}

渠道和入口指定规则(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：渠道/入口指定技能组规则
    ...
    ...    前提：
    ...    1.关联指定技能组A
    ...    2.入口指定技能组B
    [Tags]
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentity}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentity1}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentity1.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建一个关联
    ${restentity}=    Add Channel
    #将规则排序设置为渠道->入口指定优先
    ${data}=    set variable    {"value":"Channel:UserSpecifiedChannel:ChannelData:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取渠道绑定关系
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentity}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentity}
    #获取关联appkey的token
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${restentity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    Comment    ${filterentity}=    create dictionary    visitorName=${GuestEntity.userName}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #技能组和关联信息
    Delete Agentqueue    ${queueentity.queueId}
    Delete Agentqueue    ${queueentity1.queueId}
    Delete Channel    ${restentity.channelId}

入口和渠道指定规则(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：入口/渠道指定技能组规则
    ...
    ...    前提：
    ...    1.入口指定技能组A
    ...    2.关联指定技能组B
    [Tags]
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentity}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentity1}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentity.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建一个关联
    ${restentity}=    Add Channel
    #将规则排序设置为入口-> 渠道指定优先
    ${data}=    set variable    {"value":"UserSpecifiedChannel:Channel:ChannelData:Default"}
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取渠道绑定关系
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity1.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentity1}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentity1}
    #获取关联appkey的token
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${restentity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    Comment    ${filterentity}=    create dictionary    visitorName=${GuestEntity.userName}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #技能组和关联信息
    Delete Agentqueue    ${queueentity.queueId}
    Delete Agentqueue    ${queueentity1.queueId}
    Delete Channel    ${restentity.channelId}
