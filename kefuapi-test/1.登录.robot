*** Settings ***
Suite Setup
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          AgentRes.robot
Resource          api/KefuApi.robot
Library           uuid
Resource          JsonDiff.robot
Library           jsonschema

*** Test Cases ***
客服登录(/login)
    Create Session    adminsession    ${kefuurl}
    ${resp}=    /login    adminsession    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${loginJson}
    set to dictionary    ${temp['agentUser']}    username=${AdminUser.username}    onLineState=${AdminUser.status}    state=${AdminUser.status}    currentOnLineState=${AdminUser.status}
    ${r}=    loginJsonDiff    ${temp}    ${j}
    #Should Be True    ${r['ValidJson']}    登录失败：${r}
    set global variable    ${loginJson}    ${j}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=adminsession
    set global variable    ${AdminUser}    ${AdminUser}
    ${DR}=    initFilterTime
    set global variable    ${DateRange}    ${DR}

获取初始化数据(/home/initdata)
    ${resp}=    /home/initdata    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${initdataJson}
    set to dictionary    ${temp}    role=${loginJson['agentUser']['roles']}    sessionId=${loginJson['token']['value']}    resource=/tenants/${loginJson['agentUser']['tenantId']}/agents/${loginJson['agentUser']['userId']}/1480929543793
    log    ${temp}
    ${r}=    initdataJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取初始化数据失败：${r}
    set global variable    ${initdataJson}    ${j}

获取organ信息(/v1/infos)
    [Tags]    unused
    ${resp}=    /v1/infos    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${infosJson}
    ${r}=    infosJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    infos数据不正确：${r}
    set global variable    ${infosJson}    ${j}
    set to dictionary    ${orgEntity}    organId=${j['entity']['organId']}    organName=${j['entity']['organName']}
    set global variable    ${orgEntity}    ${orgEntity}

获取organ信息(/v2/infos)
    ${resp}=    /v2/infos    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${infosJson}
    ${r}=    infosJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    infos数据不正确：${r}
    set global variable    ${infosJson}    ${j}
    set to dictionary    ${orgEntity}    organId=${j['entity']['orgId']}    organName=${j['entity']['orgName']}
    set global variable    ${orgEntity}    ${orgEntity}

获取登录状态(/v1/Agents/me)
    log    ${AdminUser}
    ${resp}=    /v1/Agents/me    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${AgentsMeJson}
    set to dictionary    ${temp}    maxServiceUserNumber=${AdminUser.maxServiceSessionCount}    status=${AdminUser.status}    userId=${AdminUser.userId}
    ${r}=    AgentsMeJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取登录状态失败：${r}
    set global variable    ${AgentsMeJson}    ${j}

获取坐席数据(/v1/Tenants/me/Agents/me)
    ${resp}=    /v1/Tenants/me/Agents/me    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${r}=    TenantsMeAgentsMeJsonDiff    ${loginJson['agentUser']}    ${j}
    Should Be True    ${r['ValidJson']}    获取坐席数据失败：${r}
    set global variable    ${TenantsMeAgentsMeJson}    ${j}

获取租户信息(/v1/Tenants/me)
    ${resp}=    /v1/Tenants/me    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${TenantsMeJson}
    set to dictionary    ${temp}    tenantId=${AdminUser.tenantId}    organId=${orgEntity.organId}    organName=${orgEntity.organName}
    ${r}=    TenantsMeJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取登录状态失败：${r}
    set global variable    ${TenantsMeJson}    ${j}

添加客服并获取客服列表(/v1/Admin/Agents)
    ${curTime}    get time    epoch
    ${t}    evaluate    type('${curTime}@test.com')
    set to dictionary    ${AgentUser1}    username=${AdminUser.tenantId}${curTime}@test.com    password=test2015    maxServiceSessionCount=10    tenantId=${AdminUser.tenantId}
    ${data}=    set variable    {"nicename":"${AgentUser1.username}","username":"${AgentUser1.username}","password":"${AgentUser1.password}","confirmPassword":"${AgentUser1.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${AgentUser1.maxServiceSessionCount}","roles":"agent"}
    ###添加坐席
    ${resp}=    /v1/Admin/Agents    post    ${AdminUser}    ${AgentFilterEntity}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['tenantId']}'=='${AgentUser1.tenantId}'    返回的tenantId不正确：${resp.content}
    set to dictionary    ${AgentUser1}    userId=${j['userId']}    roles=${j['roles']}
    set global variable    ${AgentUser1}    ${AgentUser1}
    ###查询坐席信息
    set to dictionary    ${AgentFilterEntity}    keyValue=${curTime}
    ${resp}=    /v1/Admin/Agents    get    ${AdminUser}    ${AgentFilterEntity}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['numberOfElements']}==1    获取客服列表不正确：${resp.content}
    Should Be True    '${j['content'][0]['username']}'=='${AgentUser1.username}'    获取客服列表不正确：${resp.content}

添加技能组并获取技能组列表(/v1/AgentQueue)
    #添加技能组
    ${curTime}    get time    epoch
    set to dictionary    ${AgentQueue1}    queueName=${AdminUser.tenantId}${curTime}
    ${data}=    set variable    {"queueName":"${AgentQueue1.queueName}"}
    ${resp}=    /v1/AgentQueue    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    技能组列表数据不正确：${resp.content}
    set to dictionary    ${AgentQueue1}    queueId=${j['queueId']}
    set global variable    ${AgentQueue1}    ${AgentQueue1}
    ###获取技能组
    ${resp}=    /v1/AgentQueue    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j[0]['agentQueue']['tenantId']}'    '${AdminUser.tenantId}'    技能组列表数据不正确：${resp.content}
    : FOR    ${i}    IN    @{j}
    \    Exit For Loop If    '${i['agentQueue']['queueId']}' =='${AgentQueue1.queueId}'
    Should Be Equal    '${i['agentQueue']['queueId']}'    '${AgentQueue1.queueId}'    技能组id数据不正确：${i}
    set global variable    ${AgentQueueJson}    ${j}
    log    ${AgentQueue1}

添加坐席到技能组(/v1/AgentQueue/{queueId}/AgentUser)
    #添加坐席到技能组
    ${data}=    set variable    ["${AgentUser1.userId}"]
    ${resp}=    /v1/AgentQueue/{queueId}/AgentUser    ${AdminUser}    ${AgentQueue1.queueId}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}
    ###获取技能组
    ${resp}=    /v1/AgentQueue    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    Exit For Loop If    '${i['agentQueue']['queueId']}' =='${AgentQueue1.queueId}'
    Should Be Equal    '${i['agentUsers'][0]['tenantId']}'    '${AgentUser1.tenantId}'    用户tenantId数据不正确：${i}
    Should Be Equal    '${i['agentUsers'][0]['userId']}'    '${AgentUser1.userId}'    用户userId数据不正确：${i}

创建关联信息并获取app关联信息
    #快速创建关联
    ${data}=    create dictionary    companyName=对接移动客服 请勿移除管理员    email=${AdminUser.userId}@easemob.com    password=47iw5ytIN8Ab8f2KopaAaq    telephone=13800138000    tenantId=${AdminUser.tenantId}
    ${resp}=    /v1/autoCreateImAssosciation    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    set to dictionary    ${RestEntity}    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}    clientSecret=${j['entity']['clientSecret']}
    ...    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}    agentQueueId=${j['entity']['agentQueueId']}    robotId=${j['entity']['robotId']}
    #查询关联id
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j[0]['appKey']}    appkey为空
    set test variable    ${diffs1}    ${RestEntity.appName}${RestEntity.orgName}${RestEntity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    set test variable    ${diffs2}    ${d['appName']}${d['orgName']}${d['serviceEaseMobIMNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    set global variable    ${easemobtechchannelJson}    ${d}
    set to dictionary    ${RestEntity}    channelId=${d['id']}
    set global variable    ${RestEntity}    ${RestEntity}
    log    ${RestEntity}

webim获取关联信息(/v1/webimplugin/targetChannels)
    ${resp}=    /v1/webimplugin/targetChannels    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${targetchannelJson}
    set to dictionary    ${temp}    tenantName=${TenantsMeJson['name']}    tenantAvatar=${TenantsMeJson['avatar']}    tenantLogo=${TenantsMeJson['logo']}
    : FOR    ${d}    IN    @{j}
    \    ${r}=    targetchannelJsonDiff    ${temp}    ${d}
    \    Should Be True    ${r['ValidJson']}    webim获取关联信息失败：${r}
    set test variable    ${diffs1}    ${RestEntity.appName}${RestEntity.orgName}${RestEntity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    set test variable    ${diffs2}    ${d['appName']}${d['orgName']}${d['imServiceNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    #获取第一个run字段为true的channal
    set global variable    ${targetchannelJson}    ${d}
    set global variable    ${targetchannelsJson}    ${j}
    ##
    Create Session    restsession    https://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${RestEntity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    set global variable    ${RestEntity}    ${RestEntity}

获取开关状态(/tenants/{tenantId}/options)
    ${resp}=    /tenants/{tenantId}/options    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    获取开关状态失败：${resp.content}
    Should Be True    ${j['count']}>=0    获取开关数量失败：${resp.content}
    ${temp}    to json    ${optionJson}
    set to dictionary    ${temp}    tenantId=${AdminUser.tenantId}
    set global variable    ${optionJson}    ${temp}
    : FOR    ${d}    IN    @{j['data']}
    \    ${r}=    optionJsonDiff    ${temp}    ${d}
    \    Should Be True    ${r['ValidJson']}    获取开关信息失败：${r}
    set global variable    ${optionsJson}    ${j}
    log    ${optionsJson}

获取机器人渠道开关信息并关闭所有渠道
    #获取机器人渠道开关信息
    ${resp}=    /v1/Tenants/{tenantId}/robot/userChannelSwitches    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人渠道开关信息不正确：${resp.content}
    #关闭所有开启渠道
    : FOR    ${i}    IN    @{j}
    \    set to dictionary    ${i}    active=false
    \    ${resp}=    /v1/Tenants/{tenantId}/robot/userChannelSwitches/{channel}    ${AdminUser}    ${i['originType']}    ${i}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

绑定新创建的关联(/v1/Tenants/{tenantId}/channel-data-binding)
    ${cData}=    create dictionary    dutyType=Allday    id=${AgentQueue1.queueId}    id2=0    type=agentQueue    type2=
    set to dictionary    ${AgentQueue1}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${RestEntity.channelId}","dutyType":"${AgentQueue1.channelData.dutyType}","name":"${RestEntity.channelName}","info":"${RestEntity.orgName}#${RestEntity.appName}#${RestEntity.serviceEaseMobIMNumber}","id1":"${AgentQueue1.channelData.id}","type1":"${AgentQueue1.channelData.type}","id2":"${AgentQueue1.channelData.id2}","type2":"${AgentQueue1.channelData.type2}"}
    log    ${data}
    #绑定新建技能组到新建关联
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${AdminUser}    ${cData}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    set to dictionary    ${RestEntity}    queueId=${AgentQueue1.queueId}    queueName=${AgentQueue1.queueName}
    set global variable    ${RestEntity}    ${RestEntity}
