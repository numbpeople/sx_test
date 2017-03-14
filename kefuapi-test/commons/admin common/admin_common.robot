*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../api/KefuApi.robot
Resource          ../../api/RoutingApi.robot

*** Keywords ***
add_agentqueue
    [Documentation]    创建一个技能组，返回该技能组的id和名字
    ...
    ...    describtion：包含字段
    ...
    ...    queueId、queueName
    #添加技能组
    ${curTime}    get time    epoch
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}
    ${data}=    set variable    {"queueName":"${agentqueue.queueName}"}
    ${resp}=    /v1/AgentQueue    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    技能组列表数据不正确：${resp.content}
    set to dictionary    ${agentqueue}    queueId=${j['queueId']}
    Return From Keyword    ${agentqueue}

add_channel
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

add_routing
    [Arguments]    ${originTypeentity}    ${queueentity}
    #将渠道绑定到技能组
    ${data}=    set variable    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    post    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}

update_routing
    [Arguments]    ${originTypeentity}    ${queueentity}
    #获取对应渠道的信息
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    get    ${AdminUser}    ${timeout}    {"channelType":"${originTypeentity.originType}","key":"${originTypeentity.key}","name":"${originTypeentity.name}","tenantId":"${AdminUser.tenantId}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"robotId":0,"secondQueueId":null,"secondRobotId":null}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    :FOR    ${i}    IN RANGE    ${listlength}
    \    Exit For Loop If    '${j['content'][${i}]['channelType']}' =='${originTypeentity.originType}'
    set to dictionary    ${originTypeentity}    id=${j['content'][${i}]['id']}
    #修改渠道绑定到技能组
    ${data}=    set variable    {"id":${originTypeentity.id},"tenantId":${AdminUser.tenantId},"channelType":"${originTypeentity.originType}","dutyType":"Allday","agentQueueId":${queueentity.queueId},"secondQueueId":0,"robotId":null,"secondRobotId":null,"createDateTime":1489485870000}
    ${resp}=    /v1/tenants/{tenantId}/channel-binding    put    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
