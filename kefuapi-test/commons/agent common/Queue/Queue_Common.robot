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
    ${resp}=    /v6/Tenant/me/Agents/me/UserWaitQueues/{serviceSesssionId}    ${agent}    ${servicesessionid}    ${timeout}
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
    ...    userName、originType、serviceSessionId、userId、queueId
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
    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    set to dictionary    ${GuestEntity}    serviceSessionId=${j['items'][0]['userWaitQueueId']}    userId=${j['items'][0]['userId']}    queueId=${j['items'][0]['queueId']}
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
    ${resp}=    /v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/assign/queues/{queueId}    ${agent}    ${sessionServiceId}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Assign Agent For Waiting Session
    [Arguments]    ${agent}    ${sessionServiceId}    ${agengUserId}    ${data}
    [Documentation]    转接待接入会话到其他坐席
    ${resp}=    /v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/assign/agents/{agentUserId}    ${agent}    ${sessionServiceId}    ${agengUserId}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}