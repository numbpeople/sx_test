*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Queue/WaitApi.robot
Resource          ../../admin common/Members/AgentQueue_Common.robot
Resource          ../../admin common/Setting/Routing_Common.robot
Resource          ../../admin common/BaseKeyword.robot

*** Keywords ***
Access Conversation
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    手动从待接入接入会话
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #根据查询结果接入会话
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/{waitingId}    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Access Waiting Session
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    手动从待接入接入会话
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #根据查询结果接入会话
    ${resp}=    /v6/Tenant/me/Agents/me/UserWaitQueues/{serviceSessionId}    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Create Wait Conversation
    [Arguments]    ${origintype}    ${visitor}={}
    [Documentation]    创建会话到待接入，返回访客信息、渠道信息、消息信息等
    ...
    ...    Params：
    ...
    ...    ${originType}：渠道信息，webim、weixin、app、weibo
    ...    ${visitor}：访客扩展字段
    ...
    ...    Return：
    ...
    ...    userName、originType、serviceSessionId、userId、queueId、channelId、channelType
    #设置渠道信息
    ${originType}    set variable    ${origintype}
    ${curTime}    get time    epoch
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}","visitor":${visitor}}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    log dictionary    ${MsgEntity}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #根据访客昵称查询待接入列表
    ${filter}    Copy Dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${guestentity.userName}    page=0
    ${j}    Search Waiting Session    ${AdminUser}    ${filter}    ${DateRange}
    #断言结果
    Should Be True    ${j['totalElements']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['entities'][0]['visitor_name']}    ${guestentity.userName}    访客名称不正确：${j}
    Should Be Equal    ${j['entities'][0]['skill_group_id']}    ${queueentityA.queueId}    技能组id不正确：${j}
    set to dictionary    ${GuestEntity}    serviceSessionId=${j['entities'][0]['session_id']}    userId=${j['entities'][0]['visitor_id']}    queueId=${j['entities'][0]['skill_group_id']}    channelId=${j['entities'][0]['channel_id']}    channelType=${j['entities'][0]['channel_type']}
    Return From Keyword    ${GuestEntity}

Get UserWaitQueues
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取待接入列表数据
    #获取待接入列表数据
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get UserWaitQueues Count
    [Arguments]    ${agent}
    [Documentation]    获取待接入列表总数
    #获取待接入列表总数
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/count    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Agent In Queue
    [Arguments]    ${agent}
    [Documentation]    获取坐席所处技能组信息
    #获取坐席所处技能组信息
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/queues    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Queue
    [Arguments]    ${agent}
    [Documentation]    获取待接入列表数据
    #获取待接入列表数据
    ${resp}=    /v1/tenants/{tenantId}/queues    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Queue Count
    [Arguments]    ${agent}
    [Documentation]    获取待接入列表总数
    #获取待接入列表总数
    ${resp}=    /v1/tenants/{tenantId}/queues/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Waiting
    [Arguments]    ${agent}    ${filter}    ${dataRange}
    [Documentation]    获取待接入列表数据
    #获取待接入列表数据
    ${resp}=    /waitings    ${agent}    ${filter}    ${dataRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Close Waiting Session
    [Arguments]    ${sessionServiceId}    ${agent}=${AdminUser}
    [Documentation]    关闭待接入的会话
    #清理待接入会话
    ${resp}=    /v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/abort    ${agent}    ${sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Assign Queue For Waiting Session
    [Arguments]    ${agent}    ${sessionServiceId}    ${queueId}
    [Documentation]    转接待接入会话到技能组
    ${resp}=    /v6/tenants/{tenantId}/queues/unused/waitings/{serviceSessionId}/assign/queues/{queueId}    ${agent}    ${sessionServiceId}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Assign Agent For Waiting Session
    [Arguments]    ${agent}    ${sessionServiceId}    ${agengUserId}    ${data}
    [Documentation]    转接待接入会话到其他坐席
    ${resp}=    /v6/tenants/{tenantId}/queues/unused/waitings/{serviceSessionId}/assign/agents/{agentUserId}    ${agent}    ${sessionServiceId}    ${agengUserId}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Access Waiting And Stop Session
    [Arguments]    ${agent}    ${session}    ${filter}    ${range}
    [Documentation]    接入待接入会话并手动结束掉
    #设置查询待接入会话的参数,将筛选条件关联id,从第0页获取数据
    set to dictionary    ${filter}    page=0    visitorName=${session.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${agent}    ${filter}    ${range}    #该参数为Get Waiting接口的参数值
    ${expectConstruction}    set variable    ['entities'][-1]['session_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.sessionServiceId}    #该参数为获取接口某字段的预期值
    #获取待接入会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    会话在待接入中没有被找到
    #根据查询结果接入会话
    Access Conversation    ${agent}    ${j['entities'][0]['session_id']}
    #获取进行中会话列表
    &{searchDic}    create dictionary    fieldName=${session.sessionServiceId}    fieldValue=${session.sessionServiceId}    fieldConstruction=['serviceSessionId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${agent}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['serviceSessionId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.sessionServiceId}    #该参数为获取接口某字段的预期值
    #获取会话对应的会话
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中会话根据会话id搜索不到相应的会话
    should be equal    ${j[0]['serviceSessionId']}    ${session.sessionServiceId}    获取到的会话id不正确, ${j}
    #结束进行中的会话
    Stop Processing Conversation    ${agent}    ${j[0]['user']['userId']}    ${j[0]['serviceSessionId']}

Session Should Be In Watings
    [Arguments]    ${agent}    ${filter}    ${range}
    [Documentation]    获取待接入列表数据
    #检查结果：格式化会话列表json并检查ui
    @{paramList}    create list    ${agent}    ${filter}    ${range}
    ${expectConstruction}    set variable    ['totalElements']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    1    #该参数为获取接口某字段的预期值
    #获取会话对应的会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中不包含预期的over值
    Should Be Equal    ${j['status']}    OK    获取接口返回status不是OK: ${j}
    Should Be Equal    '${j['totalElements']}'    '1'    获取接口返回total_entries不是1: ${j}

Stop Specified Sessions In Waitings
    [Arguments]    ${agent}    ${filter}    ${range}
    [Documentation]    获取待接入列表数据
    #获取待接入列表数据
    ${j}    Get Waiting    ${agent}    ${filter}    ${range}
    ${l}    Get Length    ${j['entities']}
    Return From Keyword If    ${l}==0
    #批量关闭符合条件得会话
    : FOR    ${i}    IN    @{j['entities']}
    \    ${resp}=    /v6/tenants/{tenantId}/queues/unused/waitings/{serviceSessionId}/abort    ${agent}    ${i['session_id']}    ${timeout}
    \    sleep    ${delay}
