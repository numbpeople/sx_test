*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../AgentRes.robot
Resource          ../../../../JsonDiff/Channels/RestChannelsJsonDiff.robot
Resource          ../../../../commons/admin common/BaseKeyword.robot
Resource          ../../../../api/BaseApi/Channels/RestApi.robot
Library           ../../../../lib/KefuUtils.py
Library           uuid

*** Test Cases ***
添加、查询、编辑并删除rest channel
    #添加rest channel
    ${data}    create dictionary    name=测试rest    callbackUrl=http://www.test.com
    ${resp}=    /v1/tenants/{tenantId}/channels    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    添加rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${PostRestChannelJson}
    set to dictionary    ${temp['entity']}    name=${data.name}    callbackUrl=${data.callbackUrl}    tenantId=${AdminUser.tenantId}
    log    ${j}
    log    ${temp}
    ${r}=    PostRestChannelJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    添加rest channel返回数据不正确：${r}
    set test variable    ${PostRestChannelJson}    ${j}
    #查询rest channel中是否有新添加的channel
    ${resp}=    /v1/tenants/{tenantId}/channels    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['status']}'=='OK'
    set test variable    ${diffs1}    ${PostRestChannelJson['entity']['name']}${PostRestChannelJson['entity']['callbackUrl']}${PostRestChannelJson['entity']['channelId']}${PostRestChannelJson['entity']['postMessageUrl']}
    : FOR    ${i}    IN    @{j['entities']}
    \    set test variable    ${diffs2}    ${i['name']}${i['callbackUrl']}${i['channelId']}${i['postMessageUrl']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Be True    '${diffs1}' == '${diffs2}'    未查询到添加的rest channel信息:${j}
    ${d}    create dictionary    channelId=${i['channelId']}    callbackUrl=${i['callbackUrl']}    clientId=${i['clientId']}    clientSecret=${i['clientSecret']}    postMessageUrl=${i['postMessageUrl']}
    set test variable    ${RestChannelEntity}    ${d}
    #编辑rest channel
    ${data}    create dictionary    name=测试rest1    callbackUrl=http://www.test1.com
    ${resp}=    /v1/tenants/{tenantId}/channels/{channelId}    put    ${AdminUser}    ${RestChannelEntity.channelId}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    添加rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${PutRestChannelJson}
    set to dictionary    ${temp['entity']}    name=${data.name}    callbackUrl=${data.callbackUrl}    tenantId=${AdminUser.tenantId}
    log    ${temp}
    ${r}=    PutRestChannelJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    编辑rest channel返回数据不正确：${r}
    set global variable    ${PutRestChannelJson}    ${j}
    #查询编辑后的channel信息是否正确
    ${resp}=    /v1/tenants/{tenantId}/channels    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['status']}'=='OK'
    set test variable    ${diffs1}    ${PutRestChannelJson['entity']['name']}${PutRestChannelJson['entity']['callbackUrl']}${PutRestChannelJson['entity']['channelId']}${PutRestChannelJson['entity']['postMessageUrl']}
    : FOR    ${i}    IN    @{j['entities']}
    \    set test variable    ${diffs2}    ${i['name']}${i['callbackUrl']}${i['channelId']}${i['postMessageUrl']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Be True    '${diffs1}' == '${diffs2}'    未查询到编辑后的rest channel信息:${j}
    #删除rest channel
    ${resp}=    /v1/tenants/{tenantId}/channels/{channelId}    delete    ${AdminUser}    ${PostRestChannelJson['entity']['channelId']}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    删除rest channel返回不正确的状态码:${resp.status_code}
    #查询编辑后的channel信息是否正确
    ${resp}=    /v1/tenants/{tenantId}/channels    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['status']}'=='OK'
    set test variable    ${diffs1}    ${PutRestChannelJson['entity']['name']}${PutRestChannelJson['entity']['callbackUrl']}${PutRestChannelJson['entity']['channelId']}${PutRestChannelJson['entity']['postMessageUrl']}
    ${diffs2}    set variable    ${EMPTY}
    : FOR    ${i}    IN    @{j['entities']}
    \    set test variable    ${diffs2}    ${i['name']}${i['callbackUrl']}${i['channelId']}${i['postMessageUrl']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Not Be True    '${diffs1}' == '${diffs2}'    查询到已删除的rest channel信息:${j}
    #删除成功后清空${RestEntities}
    ${d}    Clear Dictionary    &{RestChannelEntity}
    set test variable    ${RestChannelEntity}    ${d}

用rest渠道发送消息并关闭会话
    #添加rest channel
    ${data}    create dictionary    name=测试rest    callbackUrl=http://7hqyia.natappfree.cc
    ${resp}=    /v1/tenants/{tenantId}/channels    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    添加rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${PostRestChannelJson}
    set to dictionary    ${temp['entity']}    name=${data.name}    callbackUrl=${data.callbackUrl}    tenantId=${AdminUser.tenantId}
    log    ${j}
    log    ${temp}
    ${r}=    PostRestChannelJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    添加rest channel返回数据不正确：${r}
    set global variable    ${PostRestChannelJson}    ${j}
    #查询rest channel中是否有新添加的channel
    ${resp}=    /v1/tenants/{tenantId}/channels    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['status']}'=='OK'
    set test variable    ${diffs1}    ${PostRestChannelJson['entity']['name']}${PostRestChannelJson['entity']['callbackUrl']}${PostRestChannelJson['entity']['channelId']}${PostRestChannelJson['entity']['postMessageUrl']}
    : FOR    ${i}    IN    @{j['entities']}
    \    set test variable    ${diffs2}    ${i['name']}${i['callbackUrl']}${i['channelId']}${i['postMessageUrl']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Be True    '${diffs1}' == '${diffs2}'    未查询到添加的rest channel信息:${j}
    set test variable    ${d}    ${RestChannelEntity}
    set to dictionary    ${d}    channelId=${i['channelId']}    callbackUrl=${i['callbackUrl']}    clientId=${i['clientId']}    clientSecret=${i['clientSecret']}    postMessageUrl=${i['postMessageUrl']}
    set global variable    ${RestChannelEntity}    ${d}
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${msgid}    uuid 4
    set to dictionary    ${RestMsgEntity}    msg=test    queue_id=${queueentityA.queueId}    queue_name=${queueentityA.queueName}    msg_id=${msgid}    origin_type=rest
    ...    timestamp=${curTime}
    set test variable    ${RestMsgJson}    {"bodies":[{"msg":"${RestMsgEntity.msg}","type":"${RestMsgEntity.type}"}],"ext":{"queue_id":"${RestMsgEntity.queue_id}","queue_name":"${RestMsgEntity.queue_name}","agent_username":"${RestMsgEntity.agent_username}","visitor":{"tags":${RestMsgEntity.tags},"callback_user":"${RestMsgEntity.callback_user}","user_nickname":"${RestMsgEntity.user_nickname}","true_name":"${RestMsgEntity.true_name}","sex":"${RestMsgEntity.sex}","qq":"${RestMsgEntity.qq}","email":"${RestMsgEntity.email}","phone":"${RestMsgEntity.phone}","company_name":"${RestMsgEntity.company_name}","description":"${RestMsgEntity.description}"}},"msg_id":"${RestMsgEntity.msg_id}","origin_type":"${RestMsgEntity.origin_type}","from":"${RestMsgEntity.From}","timestamp":"${RestMsgEntity.timestamp}"}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    ${resp}=    /api/tenants/{tenantId}/rest/channels/{channelId}/messages    ${AdminUser}    ${RestChannelEntity}    ${RestMsgJson}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    set to dictionary    ${FilterEntity}    visitorName=${RestMsgEntity.user_nickname}
    set to dictionary    ${DateRange}    beginDate=${empty}    endDate=${empty}
    #根据访客昵称查询待接入列表
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${RestMsgEntity.user_nickname}    访客名称不正确：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${j}
    Should Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #根据查询结果关闭待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    #删除rest channel
    ${resp}=    /v1/tenants/{tenantId}/channels/{channelId}    delete    ${AdminUser}    ${PostRestChannelJson['entity']['channelId']}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    删除rest channel返回不正确的状态码:${resp.status_code}
    #删除成功后清空${RestEntities}
    ${d}    Clear Dictionary    &{RestChannelEntity}
    set global variable    ${RestChannelEntity}    ${d}
