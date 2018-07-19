*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Conversations/InviteEnquiryApi.robot
Resource          ../../../api/BaseApi/Conversations/ConversationApi.robot
Resource          ../../admin common/Members/AgentQueue_Common.robot
Resource          ../../admin common/Setting/Routing_Common.robot
Resource          ../../admin common/BaseKeyword.robot
Resource          ../../../api/MicroService/Attributes/AttributesApi.robot
Resource          ../../../api/MicroService/IntegrationSysinfoManage/GrowingIOApi.robot
Resource          ../../../api/MicroService/Webapp/InitApi.robot
Resource          ../../../api/MicroService/Webapp/WebappApi.robot
Resource          ../../../api/MicroService/Enquiry/EnquiryApi.robot
Resource          ../../../api/BaseApi/Conversations/ConversationApi.robot
Resource          ../Queue/Queue_Common.robot
Resource          ../History/History_Common.robot
Resource          ../../Base Common/Base_Common.robot

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

Get Processing Session
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
    #查询进行中会话
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    Return Result    ${resp}
    Return From Keyword    ${j}

Get Processing Conversations With FieldName
    [Arguments]    ${agent}    ${fieldName}    ${fieldValue}    ${fieldConstruction}
    [Documentation]    根据会话某些属性来获取进行中会话列表，并返回会话数据
    ...    ${fieldName}: 搜索的某字段
    ...    ${fieldValue}: 预期搜索某字段预期值
    ...    ${fieldConstruction}：搜索的某字段的结构路径
    ${sessionList}    create list
    #获取进行中会话列表
    ${j}    Get Processing Session    ${agent}
    ${text}    set variable    ${j.text}
    ${status}    set variable    ${j.status}
    ${url}    set variable    ${j.url}
    ${length}    get length    ${text}
    run keyword if    ${length} > 50    ${sessionList}
    #判断结果是否包含指定字段
    ${status}    Run Keyword And Return Status    Should Contain    "${text}"    ${fieldName}
    return from keyword if   not ${status}    ${sessionList}
    #将符合预期值的结果加到列表中，并返回列表数据
    :FOR    ${i}    IN    @{text}
    \    log    ${i}
    \    ${resultValue}    set variable    ${i${fieldConstruction}}
    \    run keyword if    "${fieldValue}" == "${resultValue}"    Append To List    ${sessionList}    ${i}
    return from keyword   ${sessionList}

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

Stop Processing Conversations
    [Arguments]    ${agent}    ${sessionList}
    [Documentation]    批量结束进行中的会话，超过100不允许执行
    ...    
    ...    【参数值】：
    ...    - ${agent}：同一个连接别名、tenantId、userid、roles等坐席信息
    ...    - ${sessionList}：会话id的列表
    ...    
    ...    【返回值】：
    ...    - 空
    #判断进行中是否超过100会话
    ${length}    get length    ${sessionList}
    Run Keyword If    ${length} > 100    Fail    进行中会话超过100个会话，以防性能问题，不允许执行 , ${sessionList}
    #批量关闭进行中会话
    : FOR    ${i}    IN    @{sessionList}
    \    Stop Processing Conversation    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms

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
    # ${curTime}    get time    epoch
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${randoNumber}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${randoNumber}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${randoNumber}    originType=${originType}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #根据访客昵称查询待接入列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${GuestEntity.userName}
    set to dictionary    ${filter}    page=0    #visitorName=${guestentity.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${DateRange}
    ${expectConstruction}    set variable    ['totalElements']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    1    #该参数为获取接口某字段的预期值
    #获取会话对应的待接入会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    待接入会话没有找到指定会话
    # ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
    # ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['entities'][0]['visitor_name']}    ${guestentity.userName}    访客名称不正确：${j}
    Should Be Equal    ${j['entities'][0]['skill_group_id']}    ${queueentityA.queueId}    技能组id不正确：${j}
    Should Not Be True    ${j['entities'][0]['vip']}    非vip用户显示为vip：${j}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['entities'][0]['session_id']}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    log    ${a}
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    访客昵称不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${restentity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    msgEntity=${MsgEntity}    guestEntity=${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}    queueId=${queueentityA.queueId}
    Return From Keyword    ${GuestEntity}

Create Terminal Conversation
    [Documentation]    创建会话并手动接入到进行中列表，手动结束后去历史会话查询该访客的会话
    ...    返回会话的属性以及访客的信息
    ...
    ...    Return：
    ...
    ...    userId、chatGroupId、sessionServiceId、chatGroupSeqId、userName、originType、${MsgEntity}
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
    #根据访客昵称查询待接入列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${GuestEntity.userName}
    Comment    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
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
    #结束进行中的会话
    Stop Processing Conversation    ${AdminUser}    ${a['user']['userId']}    ${a['serviceSessionId']}
    #坐席模式下查询该访客的会话
    set to dictionary    ${filter}    isAgent=true
    ${j}    Get History    ${AdminUser}    ${filter}    ${DateRange}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话：${j}
    #将需要的信息返回
    set to dictionary    ${GuestEntity}    createDatetime=${j['items'][0]['createDatetime']}    startDateTime=${j['items'][0]['startDateTime']}    stopDateTime=${j['items'][0]['stopDateTime']}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}    queueId=${queueentityA.queueId}    techChannelId=${a['techChannelId']}
    ...    msg=${MsgEntity}
    Return From Keyword    ${GuestEntity}

Get EnquiryStatus
    [Arguments]    ${agent}    ${serviceSessionId}
    [Documentation]    查询会话的满意度评价信息
    #查询会话的满意度评价信息
    ${resp}=    /tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus    ${agent}    ${serviceSessionId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Set ServiceSessionSummaryResults
    [Arguments]    ${method}    ${agent}    ${serviceSessionId}    ${data}=
    [Documentation]    查询会话标签信息
    #查询会话标签信息
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults    ${method}    ${agent}    ${serviceSessionId}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    return From Keyword If    '${method}'=='post'    ${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Add ServiceSessionSummaryResults
    [Arguments]    ${method}    ${agent}    ${serviceSessionId}    ${data}=
    [Documentation]    给会话打标签信息
    #给会话打标签信息
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults    ${method}    ${agent}    ${serviceSessionId}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Set Comment
    [Arguments]    ${method}    ${agent}    ${serviceSessionId}    ${data}=
    [Documentation]    操作会话备注信息
    #操作会话备注信息
    ${resp}=    /tenants/{tenantId}/serviceSessions/{serviceSessionId}/comment    ${method}    ${agent}    ${serviceSessionId}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #如果请求结果为空，则返回空，不为空，返回数据
    return From Keyword If    '${method}'=='get'    ${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Read Message
    [Arguments]    ${agent}    ${serviceSessionId}    ${data}
    [Documentation]    将消息标记为已读
    #将消息标记为已读
    ${resp}=    /v1/tenants/{tenantId}/sessions/{serviceSessionId}/messages/read    ${agent}    ${serviceSessionId}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get UnRead Count
    [Arguments]    ${agent}
    ${resp}=    /v1/Tenants/me/Agents/me/UnReadTags/Count    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Tansfer Conversation To Queue
    [Arguments]    ${agent}    ${serviceSessionId}    ${queueId}
    [Documentation]    将进行中会话转接到技能组
    ${resp}=    /v1/ServiceSession/{serviceSessionId}/AgentQueue/{queueId}    ${agent}    ${serviceSessionId}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}
    
Tansfer Conversation To Agent
    [Arguments]    ${agent}    ${serviceSessionId}    ${queueId}    ${transferData}
    [Documentation]    将进行中会话转接到技能组
    ${resp}=    /v6/tenants/{tenantId}/servicesessions/{serviceSessionId}/transfer    ${agent}    ${serviceSessionId}    ${queueId}    ${transferData}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Stop All Processing Conversations
    [Arguments]    ${agent}
    [Documentation]    关闭当前坐席所有processing的会话
    #查询当前坐席进行中会话列表
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    ${l}    Get Length  ${j}
    Return From Keyword If    ${l}==0
    #批量关闭进行中会话
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms
