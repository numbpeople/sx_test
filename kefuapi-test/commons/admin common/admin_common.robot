*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../api/KefuApi.robot
Resource          ../../api/RoutingApi.robot
Resource          ../../api/SystemSwitch.robot

*** Keywords ***
Add Agentqueue
    [Arguments]    ${agentqueue}    ${queueName}
    [Documentation]    创建一个技能组，返回该技能组的id和名字
    ...
    ...    describtion：参数技能组名字
    ...
    ...    返回值：
    ...
    ...    queueId、queueName
    #添加技能组
    ${data}=    set variable    {"queueName":"${queueName}"}
    ${resp}=    /v1/AgentQueue    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    技能组列表数据不正确：${resp.content}
    set to dictionary    ${agentqueue}    queueId=${j['queueId']}
    Return From Keyword    ${agentqueue}

Add Channel
    [Documentation]    快速创建一个关联，并返回该关联的所有信息
    ...
    ...    describtion：包含字段
    ...
    ...    appKey、appName、orgName、clientId、clientSecret、serviceEaseMobIMNumber、channelName、dutyType、agentQueueId、robotId、channelId
    #快速创建关联
    ${data}=    create dictionary    companyName=对接移动客服 请勿移除管理员    email=${AdminUser.userId}@easemob.com    password=47iw5ytIN8Ab8f2KopaAaq    telephone=13800138000    tenantId=${AdminUser.tenantId}
    ${resp}=    /v1/autoCreateImAssosciation    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${restentity}=    create dictionary    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}    clientSecret=${j['entity']['clientSecret']}
    ...    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}    agentQueueId=${j['entity']['agentQueueId']}    robotId=${j['entity']['robotId']}
    #查询关联id
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j[0]['appKey']}    appkey为空
    set test variable    ${diffs1}    ${restentity.appName}${restentity.orgName}${restentity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    set test variable    ${diffs2}    ${d['appName']}${d['orgName']}${d['serviceEaseMobIMNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    set to dictionary    ${restentity}    channelId=${d['id']}
    log    ${restentity}
    Return From Keyword    ${restentity}

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

Set Queue Agents
    [Arguments]    ${agent}    ${userIds}    ${queueId}
    [Documentation]    设置技能组坐席列表
    ...
    ...    describtion：包含字段
    ...
    ...    agent:指定调用接口的agent变量
    ...    userIds:需要设置的用户id列表，格式为list，如：["ccd08c6b-ef15-4380-89cd-c362e8ee11f4","b02ccf78-d5cc-4a81-9890-753a56d1f4ce"] 或 ["ccd08c6b-ef15-4380-89cd-c362e8ee11f4"]
    ...    queueId：需要添加的到的技能组id
    #添加坐席到技能组
    ${resp}=    /v1/AgentQueue/{queueId}/AgentUser    ${agent}    ${queueId}    ${userIds}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Delete Agentqueue
    [Arguments]    ${queueId}
    [Documentation]    删除技能组，参数为技能组Id
    #删除新增技能组
    ${resp}=    /v1/AgentQueue/{queueId}    ${AdminUser}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Delete Channel
    [Arguments]    ${channelId}
    [Documentation]    删除关联，参数为关联Id
    #删除新增关联
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel/{channelId}    ${AdminUser}    ${channelId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Set Worktime
    [Arguments]    ${iswork}    ${weekend}    ${agent}
    [Documentation]    设置工作时间
    ...
    ...    Describtion：
    ...
    ...    参数：${iswork} | ${weekend} | ${agent}
    ...
    ...    ${iswork}代表是否上班， 值为on，则为上班，为off，则为下班
    ...
    ...    ${weekend}代表当前是礼拜几
    #获取上下班时间
    ${r1}    create list
    &{timePlanIds}=    create dictionary
    ${data}=    set variable    NULL
    ${resp}=    /v1/tenants/{tenantId}/timeplans    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    #存储timePlanId值
    ${listlength}=    Get Length    ${j['entities']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${day}=    convert to string    ${j['entities'][${i}]['day']}
    \    ${timePlanId}=    convert to integer    ${j['entities'][${i}]['timePlanId']}
    \    set to dictionary    ${timePlanIds}    ${day}=${timePlanId}
    log    ${timePlanIds}
    #修改工作时间为上班或者下班时间
    ${weekend}=    convert to string    ${weekend}
    ${keys}=    Get Dictionary Keys    ${timePlanIds}
    ${Values}=    Get Dictionary Values    ${timePlanIds}
    ${timePlanId}=    Get From Dictionary    ${timePlanIds}    ${weekend}
    Run Keyword If    '${iswork}' == 'on'    set test variable    ${data}    {"timePlans":[{"timePlanId":${timePlanId},"tenantId":${agent.tenantId},"day":"${weekend}","timePlanItems":[{"startTime":"00:00:00","stopTime":"23:59:59"}]}]}
    Run Keyword If    '${iswork}' == 'off'    set test variable    ${data}    {"timePlans":[]}
    ${resp}=    /v1/tenants/{tenantId}/timeplans    put    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

Get Agentqueue
    [Documentation]    获取所有技能组信息，返回queueName和queueId的字典集
    ###获取技能组
    &{queueList}    create dictionary
    ${resp}=    /v1/AgentQueue    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${queueName}=    convert to string    ${j[${i}]['agentQueue']['queueName']}
    \    log    ${queueName}
    \    set to dictionary    ${queueList}    ${queueName}=${j[${i}]['agentQueue']['queueId']}
    Return From Keyword    ${queueList}

Get Agents
    [Documentation]    获取所有客服信息，返回username和userId的字典集
    ###查询坐席信息
    &{agentList}    create dictionary
    set to dictionary    ${AgentFilterEntity}    size=100
    ${resp}=    /v1/Admin/Agents    get    ${AdminUser}    ${AgentFilterEntity}    ${EMPTY}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${username}=    convert to string    ${j['content'][${i}]['username']}
    \    log    ${username}
    \    set to dictionary    ${agentList}    ${username}=${j['content'][${i}]['userId']}
    Return From Keyword    ${agentList}

Delete Agent
    [Arguments]    ${userId}
    [Documentation]    删除客服，参数为客服userId
    ${resp}=    /v1/Admin/Agents/{userId}    ${AdminUser}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Get Channels
    [Documentation]    获取所有关联信息，返回appkey和channelId的字典集
    #获取关联信息
    &{channelList}    create dictionary
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${appName}=    convert to string    ${j[${i}]['appName']}
    \    ${id}=    convert to string    ${j[${i}]['id']}
    \    log    ${appName}
    \    set to dictionary    ${channelList}    ${appName}#${id}=${j[${i}]['id']}
    Return From Keyword    ${channelList}

Close Conversations By ChannelId
    [Arguments]    ${techChannelId}    ${techChannelType}=easemob
    [Documentation]    根据channelId查找所有processing或wait的会话
    #查询会话
    set to dictionary    ${FilterEntity}    isAgent=false    techChannelId=${techChannelId}    techChannelType=${techChannelType}    state=Processing%2CWait
    set to dictionary    ${DateRange}    beginDate=${EMPTY}    endDate=${EMPTY}
    #根据channelId查询会话
    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    ${listlength}=    set variable    ${j['total_entries']}
    Return From Keyword If    ${listlength} == 0
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${state}=    set variable    ${j['items'][${i}]['state']}
    \    ${serviceSessionId}=    set variable    ${j['items'][${i}]['serviceSessionId']}
    \    ${visitoruserid}=    set variable    ${j['items'][${i}]['visitorUser']['userId']}
    \    Close Conversation    ${state}    ${serviceSessionId}    ${visitoruserid}

Close Conversation
    [Arguments]    ${status}    ${sessionServiceId}    ${userId}
    [Documentation]    根据channelId查找所有processing或wait的会话
    #关闭processing或wait的会话
    Run Keyword If    '${status}' == 'Wait'    Close Waiting Conversation    ${sessionServiceId}
    Run Keyword If    '${status}' == 'Processing'    Close Processing Conversation    ${sessionServiceId}    ${userId}

Close Waiting Conversation
    [Arguments]    ${sessionServiceId}
    [Documentation]    关闭待接入的会话
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}

Close Processing Conversation
    [Arguments]    ${sessionServiceId}    ${userId}
    [Documentation]    关闭processing的会话
    #关闭进行中会话
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop    ${AdminUser}    ${userId}    ${sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${resp.content}    true    会话关闭失败：${resp.content}

Get Robotlist
    [Documentation]    获取所有机器人的tenantId和userId的字典集合
    #获取多机器人的id
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfos    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    log    ${resp.content}
    &{robotList}    create dictionary
    : FOR    ${i}    IN RANGE    ${j['numberOfElements']}
    \    ${tenantId}=    convert to string    ${j['content'][${i}]['tenantId']}
    \    ${userId}=    convert to string    ${j['content'][${i}]['robotId']}
    \    log    ${tenantId}
    \    log    ${userId}
    \    set to dictionary    ${robotList}    ${tenantId}=${userId}
    Return From Keyword    ${robotList}

Set RoutingPriorityList
    [Arguments]    ${firstValue}    ${secondValue}    ${thirdValue}
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
    ${resp}=    /tenants/{tenantId}/options/RoutingPriorityList    ${AdminUser}    ${timeout}    ${data}
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

Search Waiting Conversation
    [Arguments]    ${agent}    ${filter}    ${date}
    [Documentation]    根据筛选条件查询待接入会话
    ...
    ...    Arguments：
    ...
    ...    ${AdminUser}、${FilterEntity}、${DateRange}
    ...
    ...    Return：
    ...
    ...    返回符合筛选的符合结果：resp
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${resp}

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

Get Current Conversation
    [Arguments]    ${agent}    ${filter}    ${date}
    [Documentation]    获取当前会话，返回符合筛选条件的值并返回
    ...
    ...    Arguments：
    ...
    ...    ${AdminUser}、${FilterEntity}、${DateRange}
    ...
    ...    Return：
    ...
    ...    返回符合筛选的符合结果：resp
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/tenants/{tenantId}/servicesessioncurrents    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${resp}

Get Appkey Token
    [Arguments]    ${session}    ${channelJson}
    [Documentation]    获取appkey的管理员token
    ...
    ...    Arguments：
    ...
    ...    ${session} 、${channelJson}
    ...
    ...    Return：
    ...
    ...    ${resp}
    #获取管理员的token
    ${resp1}    get token by credentials    restsession    ${channelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    Return From Keyword    ${j}

Send Message
    [Arguments]    ${rest}    ${guest}    ${msg}
    [Documentation]    模拟访客发送消息
    ...
    ...    Arguments：
    ...
    ...    ${restentity}	${guestentity}	${msgentity}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    ${resp}=    Send Msg    ${rest}    ${guest}    ${msg}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${rest.serviceEaseMobIMNumber}']}    success    发送消息失败
