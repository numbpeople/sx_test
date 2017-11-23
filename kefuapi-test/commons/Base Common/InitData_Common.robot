*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../AgentRes.robot
Resource          ../../JsonDiff/KefuJsonDiff.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../commons/admin common/BaseKeyword.robot
Resource          ../../api/BaseApi/Settings/RoutingApi.robot
Resource          ../../api/MicroService/WebGray/WebGrayApi.robot
Resource          ../../tool/Tools-Resource.robot
Resource          ../../api/IM/IMApi.robot
Resource          ../../api/BaseApi/Channels/AppApi.robot
Resource          ../../api/BaseApi/Channels/WebimApi.robot
Resource          ../../api/BaseApi/Settings/CompanyApi.robot
Resource          ../../api/BaseApi/Members/Agent_Api.robot
Resource          ../../api/BaseApi/Members/Queue_Api.robot
Resource          ../../api/BaseApi/Robot/Robot_Api.robot
Resource          ../../api/MicroService/Organ/OrgApi.robot
Resource          ../../api/MicroService/Webapp/InitApi.robot
Resource          ../../api/MicroService/Webapp/OutDateApi.robot
Resource          ../../api/HomePage/Login/Login_Api.robot

*** Keywords ***
Login Init
    [Documentation]    坐席登录，初始化cookie、tenantId、userid等信息
    #${t}    urlencode    username=00001@qq.com&password=!@#123&stat=flsf
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
    ...    session=adminsession    nicename=${j['agentUser']['nicename']}
    set global variable    ${AdminUser}    ${AdminUser}
    ${DR}=    InitFilterTime
    set global variable    ${DateRange}    ${DR}
    #Close All Session In Waitlist    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}

Initdata Init
    [Documentation]    获取租户的initdata数据，存储角色、sessionid、resource数据
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /home/initdata    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${initdataJson}
    set to dictionary    ${temp}    role=${loginJson['agentUser']['roles']}    sessionId=${loginJson['token']['value']}    resource=/tenants/${loginJson['agentUser']['tenantId']}/agents/${loginJson['agentUser']['userId']}/1480929543793
    log    ${temp}
    ${r}=    initdataJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取初始化数据失败：${r}
    set global variable    ${initdataJson}    ${j}

OrganInfo Init
    [Documentation]    坐席登录后，获取租户所属的organId和organName
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /v2/infos    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${infosJson}
    ${r}=    infosJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    infos数据不正确：${r}
    set global variable    ${infosJson}    ${j}
    set to dictionary    ${orgEntity}    organId=${j['entity']['orgId']}    organName=${j['entity']['orgName']}
    set global variable    ${orgEntity}    ${orgEntity}

Grayscale List Init
    [Documentation]    获取租户灰度列表，如音视频、消息撤回、自定义报表等多个增值功能
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /v1/grayscale/tenants/{tenantId}    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}

Agent Status Init
    [Documentation]    获取坐席登录后的最大接待数、状态、userId值
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /v1/Agents/me    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${AgentsMeJson}
    set to dictionary    ${temp}    maxServiceUserNumber=${AdminUser.maxServiceSessionCount}    status=${AdminUser.status}    userId=${AdminUser.userId}
    ${r}=    AgentsMeJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取登录状态失败：${r}
    set global variable    ${AgentsMeJson}    ${j}

Agent Data Init
    [Documentation]    获取坐席登录后的坐席账号等信息
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /v1/Tenants/me/Agents/me    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${r}=    TenantsMeAgentsMeJsonDiff    ${loginJson['agentUser']}    ${j}
    Should Be True    ${r['ValidJson']}    获取坐席数据失败：${r}
    set global variable    ${TenantsMeAgentsMeJson}    ${j}

Tenant Info Init
    [Documentation]    获取租户信息，如租户id、所属的organId和organName
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /v1/Tenants/me    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${TenantsMeJson}
    set to dictionary    ${temp}    tenantId=${AdminUser.tenantId}    organId=${orgEntity.organId}    organName=${orgEntity.organName}
    ${r}=    TenantsMeJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取登录状态失败：${r}
    set global variable    ${TenantsMeJson}    ${j}

agentUserLanguage Init
    [Documentation]    坐席登录后，获取坐席的当前浏览器语言
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /tenants/{tenantId}/options/agentUserLanguage_{userId}    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    language=${j['data'][0]['optionValue']}
    set global variable    ${AdminUser}    ${AdminUser}

Create Channel Init
    [Documentation]    快速创建关联后，获取关联的appKey、clientId、clientSecret、im号等信息
    Set Suite Variable    ${tadmin}    ${AdminUser}
    #快速创建关联
    ${data}=    create dictionary    companyName=对接移动客服 请勿移除管理员    email=${tadmin.userId}@easemob.com    password=47iw5ytIN8Ab8f2KopaAaq    telephone=13800138000    tenantId=${tadmin.tenantId}
    ${resp}=    /v1/autoCreateImAssosciation    ${tadmin}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    set to dictionary    ${RestEntity}    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}    clientSecret=${j['entity']['clientSecret']}
    ...    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}    agentQueueId=${j['entity']['agentQueueId']}    robotId=${j['entity']['robotId']}
    Comment    set to dictionary    ${RestEntity}    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}
    ...    clientSecret=${j['entity']['clientSecret']}    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}
    #查询关联id
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j[0]['appKey']}    appkey为空
    Set Suite Variable    ${diffs1}    ${RestEntity.appName}${RestEntity.orgName}${RestEntity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    Set Suite Variable    ${diffs2}    ${d['appName']}${d['orgName']}${d['serviceEaseMobIMNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    set global variable    ${easemobtechchannelJson}    ${d}
    set to dictionary    ${RestEntity}    channelId=${d['id']}
    set global variable    ${RestEntity}    ${RestEntity}
    log    ${RestEntity}

TargetChannels Init
    [Documentation]    获取租户下的关联列表，如：token、restserver、xmppserver、Im登录的restSession
    Set Suite Variable    ${tadmin}    ${AdminUser}
    ${resp}=    /v1/webimplugin/targetChannels    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${targetchannelJson}
    set to dictionary    ${temp}    tenantName=${TenantsMeJson['name']}    tenantAvatar=${TenantsMeJson['avatar']}    tenantLogo=${TenantsMeJson['logo']}
    Comment    set to dictionary    ${temp}    tenantName=${TenantsMeJson['name']}    tenantAvatar=${TenantsMeJson['avatar']}    tenantLogo=${TenantsMeJson['logo']}
    : FOR    ${d}    IN    @{j}
    \    ${r}=    targetchannelJsonDiff    ${temp}    ${d}
    \    Should Be True    ${r['ValidJson']}    webim获取关联信息失败：${r}
    Set Suite Variable    ${diffs1}    ${RestEntity.appName}${RestEntity.orgName}${RestEntity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    Set Suite Variable    ${diffs2}    ${d['appName']}${d['orgName']}${d['imServiceNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    #获取第一个run字段为true的channal
    set global variable    ${targetchannelJson}    ${d}
    set global variable    ${targetchannelsJson}    ${j}
    ##
    Create Session    restsession    http://${targetchannelJson['restDomain']}
    ${resp1}    get token by credentials    restsession    ${easemobtechchannelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    set to dictionary    ${RestEntity}    token=${j['access_token']}    restDomain=${targetchannelJson['restDomain']}    session=restsession
    set global variable    ${RestEntity}    ${RestEntity}

Options List Init
    [Documentation]    获取租户的开关信息，如optionName和optionValue
    log    ${AdminUser}
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

UserChannelSwitches Init
    [Documentation]    获取机器人渠道开关信息
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

Channel Data Init
    [Documentation]    获取关联的数据，包括：关联的appKey、clientId、clientSecret、im号等信息外，加入绑定的queueId和queueName
    ${cData}=    create dictionary    dutyType=Allday    id=${AgentQueue1.queueId}    id2=0    type=agentQueue    type2=
    set to dictionary    ${AgentQueue1}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${RestEntity.channelId}","dutyType":"${AgentQueue1.channelData.dutyType}","name":"${RestEntity.channelName}","info":"${RestEntity.orgName}#${RestEntity.appName}#${RestEntity.serviceEaseMobIMNumber}","id1":"${AgentQueue1.channelData.id}","type1":"${AgentQueue1.channelData.type}","id2":"${AgentQueue1.channelData.id2}","type2":"${AgentQueue1.channelData.type2}"}
    log    ${data}
    #绑定新建技能组到新建关联
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${AdminUser}    ${cData}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    set to dictionary    ${RestEntity}    queueId=${AgentQueue1.queueId}    queueName=${AgentQueue1.queueName}
    set global variable    ${RestEntity}    ${RestEntity}

Clear Data
    Delete Agentusers    #删除坐席
    Delete Queues    #删除技能组
    Delete Channels    #删除关联
