*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Conversations/InviteEnquiryApi.robot
Resource          ../../../api/BaseApi/Conversations/ConversationApi.robot
Resource          ../../../api/MicroService/Attributes/AttributesApi.robot
Resource          ../../../api/MicroService/IntegrationSysinfoManage/GrowingIOApi.robot
Resource          ../../../api/MicroService/Webapp/InitApi.robot
Resource          ../../admin common/Members/AgentQueue_Common.robot
Resource          ../../admin common/Setting/Routing_Common.robot
Resource          ../../admin common/BaseKeyword.robot
Resource          ../Queue/Queue_Common.robot

*** Keywords ***
Get Processing Conversation
    [Arguments]    ${agent}
    [Documentation]    获取进行中的所有会话
    ...
    ...    Arguments：
    ...
    ...    ${agent}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查询进行中会话是否有该访客
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    ${listlength}    Get Length    ${j}
    \    Exit For Loop If    ${listlength} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}

Get Attribute
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    获取会话的attribute的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查看attribute是否调用成功
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessions}/attributes    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Track
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    获取会话的track的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查看track是否调用成功
    ${resp}=    /v1/integration/tenants/{tenantId}/servicesessions/{serviceSessions}/tracks    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Single Visitor
    [Arguments]    ${agent}    ${userid}
    [Documentation]    获取单个访客的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${userid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查询访客会话信息是否正确
    ${resp}=    /v1/Tenant/VisitorUsers/{visitorUserId}    ${agent}    ${userid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Messages
    [Arguments]    ${agent}    ${chatgroupid}    ${msgfilter}
    [Documentation]    获取会话的所有消息信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${chatgroupid} | ${msgfilter}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查询访客历史消息是否正确
    ${resp}=    /v1/Tenant/me/ChatGroup/{ChatGroupId}/Messages    ${agent}    ${chatgroupid}    ${msgfilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Stop Processing Conversation
    [Arguments]    ${agent}    ${visitoruserid}    ${servicesessionid}
    [Documentation]    手动结束进行中的会话
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${visitoruserid} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #关闭会话
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop    ${agent}    ${visitoruserid}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${resp.content}    true    会话关闭失败：${resp.content}

Agent Send Message
    [Arguments]    ${agent}    ${visitoruserid}    ${servicesessionid}    ${msg}
    [Documentation]    坐席发送消息给访客
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${visitoruserid} | ${servicesessionid} | ${msg}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #坐席发送消息
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages    ${agent}    ${visitoruserid}    ${servicesessionid}    ${msg}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Send InviteEnquiry
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    坐席发送满意度评价消息给访客
    ...
    ...    Arguments：
    ...
    ...    ${agent} | \ ${servicesessionid} | ${timeout}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #坐席发送消息
    ${resp}=    /v6/tenants/{tenantId}/serviceSessions/{serviceSessionId}/inviteEnquiry    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Official-accounts
    [Arguments]    ${agent}    ${serviceSessionId}
    [Documentation]    查询会话的official-accounts信息
    #查询会话的official-accounts信息
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/official-accounts    ${agent}    ${serviceSessionId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Create Processiong Conversation
    [Documentation]    创建会话并手动接入到进行中列表，返回会话的属性以及访客的信息
    ...
    ...    Return：
    ...
    ...    userId、chatGroupId、sessionServiceId、chatGroupSeqId
    ${originType}    set variable    weixin
    ${curTime}    get time    epoch
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    log    ${a}
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    访客昵称不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${restentity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}
    Return From Keyword    ${GuestEntity}
