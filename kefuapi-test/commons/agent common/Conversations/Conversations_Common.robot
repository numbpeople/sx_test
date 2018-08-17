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
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...
    ...    【返回值】
    ...    | 调用接口/v1/Agents/me/Visitors返回所有进行中会话的数据结果 |
    ...
    ...    【调用方式】
    ...    | 获取进行中会话 | ${j} | Get Processing Session | ${AdminUser} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据调用 /v1/Agents/me/Visitors 查询进行中会话的接口函数 |
    ...    | Step 2 | 针对接口返回对象 用封装函数Return Result ，返回状态码、请求地址、请求返回值等信息 |
    #查询进行中会话
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    Return Result    ${resp}
    Return From Keyword    ${j}

Get Processing Conversations With FieldName
    [Arguments]    ${agent}    ${fieldName}    ${fieldValue}    ${fieldConstruction}
    [Documentation]    根据会话某些属性来获取进行中会话列表，并返回会话数据
    ...
    ...    【参数值】：
    ...    - ${fieldName}: 搜索的某字段
    ...    - ${fieldValue}: 预期搜索某字段预期值
    ...    - ${fieldConstruction}：搜索的某字段的结构路径
    ...
    ...    【返回值】：
    ...    - 返回匹配根据${fieldName}字段结构取值，并且值等于${fieldValue}的结构
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
    return from keyword if    not ${status}    ${sessionList}
    #将符合预期值的结果加到列表中，并返回列表数据
    : FOR    ${i}    IN    @{text}
    \    log    ${i}
    \    ${resultValue}    set variable    ${i${fieldConstruction}}
    \    run keyword if    "${fieldValue}" == "${resultValue}"    Append To List    ${sessionList}    ${i}
    return from keyword    ${sessionList}

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
    ...    【参数值】：
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${visitoruserid} 选填 | 访客id |
    ...    | ${servicesessionid} 选填 | 会话id |
    ...
    ...    【返回值】
    ...    | 无 |
    ...
    ...    【调用方式】
    ...    | 获取进行中会话 | Stop Processing Conversation | ${AdminUser} | ${visitorUserId} | ${serviceSessionId} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据传入参数${visitorUserId}和${serviceSessionId}，调用接口/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop 关闭进行中会话 |
    ...    | Step 2 | 判断接口返回状态是否为200，并且返回值是否为true |
    #关闭会话
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop    ${agent}    ${visitoruserid}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    【实际结果】：关闭会话时接口状态码不是200：调用接口：${resp.url}，实际状态码是：${resp.status_code}，原因是：${resp.text}。
    ${j}    Return Result    ${resp}
    Should Be True    ${j.text}    【实际结果】：关闭会话时接口调用失败：调用接口：${j.url}，判断返回值预期值：True，实际接口返回结果值为：${j.text}。

Stop Processing Conversations
    [Arguments]    ${agent}    ${sessionList}
    [Documentation]    批量结束进行中的会话，超过100不允许执行
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${sessionList} | 选填 | 会话id的列表 |
    ...
    ...    【返回值】
    ...    | 无 |
    ...
    ...    【调用方式】
    ...    | 获取进行中会话 | Stop Processing Conversations | ${AdminUser} | ${sessionList} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据传入参数${sessionList} ，获取有多少元素，如果超过100，则不执行用例，标记为Fail |
    ...    | Step 2 | 依次全部关闭进行中的会话 |
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
    [Documentation]    创建会话并手动接入到进行中会话列表，返回会话的属性以及访客的信息
    ...
    ...    【参数值】：
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | 无 | 无 | 无 |
    ...
    ...    【返回值】
    ...    | 字段描述 | 会话id | 访客昵称 | 访客userid | 访客消息 | 技能组id | ... |
    ...    | 字段名称 | sessionServiceId | userName | userid | msg | queueId | ... |
    ...
    ...    【调用方式】
    ...    | 创建一个进行中会话 | ${sessionInfo} | Create Processiong Conversation |
    ...    | 获取会话id | ${serviceSessionId} | Set Variable | ${sessionInfo.sessionServiceId} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 添加一个技能组、创建渠道变量、创建消息体字典数据、创建访客信息字典数据 |
    ...    | Step 2 | 改变路由规则优先级顺序，使其入口指定优先 |
    ...    | Step 3 | 访客发起新消息，创建新会话 |
    ...    | Step 4 | 根据访客昵称搜索待接入数据 |
    ...    | Step 5 | 手动从待接入接入会话到进行中会话 |
    ...    | Step 6 | 获取坐席的进行中会话列表数据 |
    ...    | Step 7 | 返回该会话的所有属性，包括：会话id、访客昵称、访客userid、访客消息、技能组id等 |
    #Step 1、添加一个技能组、创建渠道变量、创建消息体字典数据、创建访客信息字典数据
    ${originType}    set variable    weixin
    # ${curTime}    get time    epoch
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${randoNumber}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${randoNumber}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${randoNumber}    originType=${originType}
    #Step 2 、 改变路由规则优先级顺序，使其入口指定优先
    Set RoutingPriorityList    入口    渠道    关联
    #Step 3 、 访客发起新消息，创建新会话(访客名称为租户id与随机数的组合)
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #根据访客昵称查询待接入列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${GuestEntity.userName}
    set to dictionary    ${filter}    page=0    #visitorName=${guestentity.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${DateRange}
    ${expectConstruction}    set variable    ['totalElements']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    1    #该参数为获取接口某字段的预期值
    #Step 4 、 根据访客昵称搜索待接入数据
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    待接入会话没有找到指定会话
    # ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
    # ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['entities'][0]['visitor_name']}    ${guestentity.userName}    访客名称不正确：${j}
    Should Be Equal    ${j['entities'][0]['skill_group_id']}    ${queueentityA.queueId}    技能组id不正确：${j}
    Should Not Be True    ${j['entities'][0]['vip']}    非vip用户显示为vip：${j}
    #Step 5 、手动从待接入接入会话到进行中会话
    Access Conversation    ${AdminUser}    ${j['entities'][0]['session_id']}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    log    ${a}
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    访客昵称不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${restentity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    msgEntity=${MsgEntity}    guestEntity=${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}
    ...    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}    queueId=${queueentityA.queueId}    userName=${GuestEntity.userName}    msg=${MsgEntity.msg}    originType=${GuestEntity.originType}
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
    set to dictionary    ${GuestEntity}    createDatetime=${j['items'][0]['createDatetime']}    startDateTime=${j['items'][0]['startDateTime']}    stopDateTime=${j['items'][0]['stopDateTime']}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}
    ...    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}    queueId=${queueentityA.queueId}    techChannelId=${a['techChannelId']}    msg=${MsgEntity}
    Return From Keyword    ${GuestEntity}

Get EnquiryStatus
    [Arguments]    ${agent}    ${serviceSessionId}
    [Documentation]    查询会话的满意度评价状态
    #查询会话的满意度评价信息
    ${resp}=    /tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus    ${agent}    ${serviceSessionId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Servicesession Enquiries
    [Arguments]    ${agent}    ${serviceSessionId}
    [Documentation]    查询会话的满意度评价信息
    #查询会话的满意度评价信息
    ${resp}=    /tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiries    ${agent}    ${serviceSessionId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Servicesession Enquiries Repeatly
    [Arguments]    ${agent}    ${serviceSessionId}
    [Documentation]    多次获取查询会话的满意度评价信息
    #多次获取查询会话的满意度评价信息
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    Get Servicesession Enquiries    ${agent}    ${serviceSessionId}
    \    ${listlength}    Get Length    ${j['data']}
    \    Exit For Loop If    ${listlength} > 0
    \    sleep    ${delay}
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
    [Documentation]    将进行中会话转接到其他坐席
    ${resp}=    /v6/tenants/{tenantId}/servicesessions/{serviceSessionId}/transfer    ${agent}    ${serviceSessionId}    ${queueId}    ${transferData}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Admin Tansfer Conversation To Agent
    [Arguments]    ${agent}    ${serviceSessionId}    ${agentUserId}    ${transferData}
    [Documentation]    在当前会话列表将会话转接到其他坐席
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/agents/{agentUserId}/transfer    ${agent}    ${serviceSessionId}    ${agentUserId}    ${transferData}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Stop All Processing Conversations
    [Arguments]    ${agent}
    [Documentation]    关闭当前坐席所有processing的会话
    #查询当前坐席进行中会话列表
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    ${l}    Get Length    ${j}
    Return From Keyword If    ${l}==0
    #批量关闭进行中会话
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms

Agent Reply Message To Visitor
    [Arguments]    ${agent}    ${nickname}    ${type}    ${msg}=
    [Documentation]    客服回复消息给访客
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${nickname} | 必填 | 访客昵称，例如：634-09049 |
    ...    | ${type} | 必填 | 消息类型：txt、img、file、audio |
    ...    | ${msg} | 选填 | 文本消息内容，例如：坐席消息 |
    ...
    ...    【返回值】
    ...    | 接口调用成功返回值：True |
    ...
    ...    【调用方式】
    ...    | 坐席发送文本消息给访客 | ${j} | Agent Reply Message To Visitor | ${AdminUser} | 634-09049 | txt | 坐席消息 |
    ...    | 坐席发送表情消息给访客 | ${j} | Agent Reply Message To Visitor | ${AdminUser} | 634-09049 | txt | [):] |
    ...    | 坐席发送图片消息给访客 | ${j} | Agent Reply Message To Visitor | ${AdminUser} | 634-09049 | img |
    ...    | 坐席发送文件消息给访客 | ${j} | Agent Reply Message To Visitor | ${AdminUser} | 634-09049 | file |
    ...    | 坐席发送语音消息给访客 | ${j} | Agent Reply Message To Visitor | ${AdminUser} | 634-09049 | audio |
    ...    | Should Be True | ${j} | 坐席发消息未调用成功，具体错误如：${j} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据访客昵称查找进行中的会话 |
    ...    | Step 2 | 获取接口/v1/Agents/me/Visitors，如果返回的进行中数据，每个会话id均不是发起的会话，尝试重试取10次。 |
    ...    | Step 3 | 坐席回复消息给访客 |
    ...    | Step 4 | 返回值：True |
    #Step 1、根据访客昵称查找进行中的会话
    ${serviceSessionId}    Get Processing Conversation With Nickname    ${agent}    ${nickname}
    Return From Keyword If    "${serviceSessionId}" == "{}"    {}
    #获取进行中会话
    &{searchDic}    create dictionary    fieldName=serviceSessionId    fieldValue=${serviceSessionId}    fieldConstruction=['serviceSessionId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${agent}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['serviceSessionId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${serviceSessionId}    #该参数为获取接口某字段的预期值
    #Step2、获取接口/v1/Agents/me/Visitors，如果返回的进行中数据，每个会话id均不是发起的会话，尝试重试取10次。
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    坐席进行中接口返回结果中，根据会话id搜索不到相应的会话
    ${visitorUserId}    set variable    ${j[0]['user']['userId']}
    #Step3、坐席回复消息
    ${j}    Agent Send Msg    ${agent}    ${visitorUserId}    ${serviceSessionId}    ${type}    ${msg}
    Return From Keyword    True

Agent Send Msg
    [Arguments]    ${agent}    ${visitorUserId}    ${serviceSessionId}    ${msgType}    ${msg}
    [Documentation]    封装坐席发各种格式消息
    &{msgEntity}    create dictionary    msg=${msg}    type=${msgType}
    ${image}    run keyword if    '${msgType}' == 'img' or '${msgType}' == 'file'    Upload MediaFile Image    ${agent}
    ${amr}    run keyword if    '${msgType}' == 'audio'    Upload MediaFile Amr    ${agent}
    run keyword if    '${msgType}' == 'img'    set to dictionary    ${msgEntity}    msg=    type=${msgType}    filename=${image.filename}
    ...    imageHeight=68    imageWidth=68    mediaId=${image.uuid}    thumb=${image.url}    url=${image.url}
    run keyword if    '${msgType}' == 'file'    set to dictionary    ${msgEntity}    msg=    type=${msgType}    fileLength=${image.contentLength}
    ...    filename=${image.filename}    imageHeight=120    imageWidth=120    mediaId=${image.uuid}    thumb=${image.url}    url=${image.url}
    run keyword if    '${msgType}' == 'audio'    set to dictionary    ${msgEntity}    type=${msgType}    fileLength=${amr.contentLength}    audioLength=2
    ...    filename=${amr.filename}    mediaId=${amr.uuid}    thumb=${amr.url}    url=${amr.url}
    log    ${msgEntity}
    ${j}    Agent Send Message    ${agent}    ${visitorUserId}    ${serviceSessionId}    ${msgEntity}
    Return From Keyword    ${j}

Upload MediaFile Image
    [Arguments]    ${agent}
    [Documentation]    上传一张富媒体
    #获取图片文件
    ${picpath}    Find MediaFile Image Path    resource    image.gif
    &{fileEntity}    create dictionary    filename=image.gif    filepath=${picpath}    contentType=image/gif
    #上传图片
    ${j}    Upload MediaFile    ${agent}    ${fileEntity}
    set to dictionary    ${fileEntity}    url=${j['url']}    uuid=${j['uuid']}    contentLength=${j['contentLength']}
    return from keyword    ${fileEntity}

Upload MediaFile Amr
    [Arguments]    ${agent}
    [Documentation]    上传一张富媒体
    #获取图片文件
    ${picpath}    Find MediaFile Image Path    resource    blob.amr
    &{fileEntity}    create dictionary    filename=blob    filepath=${picpath}    contentType=audio/webm
    #上传语音
    ${j}    Upload Amr    ${agent}    ${fileEntity}
    set to dictionary    ${fileEntity}    url=${j['url']}    uuid=${j['uuid']}    contentLength=${j['contentLength']}
    return from keyword    ${fileEntity}

Find MediaFile Image Path
    [Arguments]    ${folderName}    ${fileName}
    [Documentation]    找到${folderName}文件夹下的图片文件: ${fileName},例如: resource文件夹下image.gif文件
    #找到resource文件夹下的图片文件: image.gif
    ${folderName}    set variable    ${folderName}
    ${folderPath}    set variable    ${CURDIR}
    ${folderPath}    find folder path    ${folderPath}    ${folderName}
    ${picpath}    set variable    ${folderPath}${/}${fileName}
    ${picpath}    replace string    '${picpath}'    \\    /
    ${picpath}    replace string    ${picpath}    '    ${EMPTY}
    return from keyword    ${picpath}

Upload MediaFile
    [Arguments]    ${agent}    ${file}
    [Documentation]    上传一张富媒体
    #打开图片文件
    ${fileData}    Open MediaFile    ${file}
    #上传图片
    ${resp}=    /v1/Tenant/me/MediaFiles    ${agent}    ${fileData}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Upload Amr
    [Arguments]    ${agent}    ${file}
    [Documentation]    上传一张语音富媒体文件
    #打开图片文件
    ${fileData}    Open MediaFile    ${file}
    #上传图片
    ${resp}=    /v1/tenants/{tenantId}/mediafiles/amr    ${agent}    ${fileData}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Open MediaFile
    [Arguments]    ${file}
    [Documentation]    打开富媒体
    #打开图片
    ${file_data}    evaluate    ('${file.filename}', open('${file.filepath}','rb'),'${file.contentType}',{'Expires': '0'})
    &{fileEntity}    Create Dictionary    file=${file_data}
    return from keyword    ${fileEntity}

Get Processing Conversation With Nickname
    [Arguments]    ${agent}    ${nickname}
    [Documentation]    根据访客昵称查找进行中的会话
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${nickname} | 必填 | 访客昵称，例如：634-09049 |
    ...
    ...    【返回值】
    ...    | 接口调用成功返回值：会话id |
    ...
    ...    【调用方式】
    ...    | 坐席发送文本消息给访客 | ${serviceSessionId} | Get Processing Conversation With Nickname | ${AdminUser} | 634-09049 |
    ...
    ...    【函数操作步骤】
    ...    | 暂无，后续补充 |
    #查询会话
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    isAgent=false    state=Processing%2CWait    customerName=${nickname}    sortField=createDatetime
    #根据访客昵称查找会话
    ${session}    Get History    ${agent}    ${filter}    ${DateRange}
    ${length}    get length    ${session['items']}
    #如果搜索到的数据为空的话，返回{}
    Return From Keyword If    ${length} == 0    {}
    #获取会话id、会话状态、坐席id
    ${serviceSessionId}    set variable    ${session['items'][0]['serviceSessionId']}
    ${status}    set variable    ${session['items'][0]['state']}
    ${agentUserId}    set variable    ${session['items'][0]['agentUserId']}
    #将会话处理到当前操作坐席进行中会话列表
    Run Keyword If    '${status}' == 'Wait'    Access Conversation    ${agent}    ${serviceSessionId}
    Run Keyword If    ('${status}' == 'Processing') and ('${agentUserId}' != '${agent.userId}')    Tansfer Processing Conversation To Agent    ${agent}    ${serviceSessionId}    ${agent.userId}
    Return From Keyword    ${serviceSessionId}

Tansfer Processing Conversation To Agent
    [Arguments]    ${agent}    ${serviceSessionId}    ${agentUserId}
    [Documentation]    在当前会话列表，将会话转接给其他坐席
    #创建转接请求体
    ${transferData}    set variable    {"queueId":null}
    #在当前会话列表，将会话转接给其他坐席
    ${j}    Admin Tansfer Conversation To Agent    ${agent}    ${serviceSessionId}    ${agentUserId}    ${transferData}
    should be true    '${j['status']}' == 'OK'    获取接口返回status不是OK: ${j}

Should Contain Visitor Message In Processing Conversation
    [Arguments]    ${agent}    ${nickname}    ${type}    ${msg}=
    [Documentation]    判断进行中会话中，是否包含指定访客消息
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${nickname} | 必填 | 访客昵称，例如：634-09049 |
    ...    | ${type} | 必填 | 消息类型：txt、img、file、audio、loc |
    ...    | ${msg} | 选填 | 文本消息内容，例如：坐席消息 |
    ...
    ...    【返回值】
    ...    | 接口调用成功返回值：True |
    ...
    ...    【调用方式】
    ...    | 访客的进行中会话包含文本消息 | ${j} | Should Contain Visitor Message In Processing Conversation | ${AdminUser} | 634-09049 | txt | 坐席消息 |
    ...    | 访客的进行中会话包含图片消息 | ${j} | Should Contain Visitor Message In Processing Conversation | ${AdminUser} | 634-09049 | img |
    ...    | 访客的进行中会话包含文件消息 | ${j} | Should Contain Visitor Message In Processing Conversation | ${AdminUser} | 634-09049 | file |
    ...    | 访客的进行中会话包含语音消息 | ${j} | Should Contain Visitor Message In Processing Conversation | ${AdminUser} | 634-09049 | audio |
    ...    | 访客的进行中会话包含位置消息 | ${j} | Should Contain Visitor Message In Processing Conversation | ${AdminUser} | 634-09049 | loc |
    ...    | Should Be True | ${j} | 进行中会话，并未找到指定的loc类型消息：${j} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据访客昵称查找进行中的会话 |
    ...    | Step 2 | 获取接口/v1/Agents/me/Visitors，如果返回的进行中数据，每个会话id均不是发起的会话，尝试重试取10次。 |
    ...    | Step 3 | 获取该会话的所有消息 |
    ...    | Step 4 | 将索要查询的指定格式的消息，添加到列表中。 |
    ...    | Step 5 | 判断不同格式的消息，检查是否在访客消息列表中 |
    ...    | Step 6 | 返回值：True |
    #Step 1、根据访客昵称查找进行中的会话
    ${serviceSessionId}    Get Processing Conversation With Nickname    ${agent}    ${nickname}
    Return From Keyword If    "${serviceSessionId}" == "{}"    {}
    #获取进行中会话
    &{searchDic}    create dictionary    fieldName=serviceSessionId    fieldValue=${serviceSessionId}    fieldConstruction=['serviceSessionId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${agent}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['serviceSessionId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${serviceSessionId}    #该参数为获取接口某字段的预期值
    #Step2、获取接口/v1/Agents/me/Visitors，如果返回的进行中数据，每个会话id均不是发起的会话，尝试重试取10次。
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    坐席进行中接口返回结果中，根据会话id搜索不到相应的会话
    ${visitorUserId}    set variable    ${j[0]['user']['userId']}
    #Step 3、获取该会话的所有消息
    &{filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    page=0    size=50
    ${j}    Get Servicesession Message    ${AdminUser}    ${serviceSessionId}    ${filter}
    ${messagesList}    set variable    ${j['entities']}
    #Step 4、将索要查询的指定格式的消息，添加到列表中。
    @{visitorMessageList}    Check Visitor Message Is Exsit    ${messagesList}    ${type}
    ${messageLength}    Get Length    ${visitorMessageList}
    #Step 5、判断不同格式的消息，是否在访客消息列表中
    Run Keyword And Return If    '${type}' == 'txt'    Run Keyword And Return Status    List Should Contain Value    ${visitorMessageList}    ${msg}
    Run Keyword And Return If    '${type}' == 'img' or '${type}' == 'file' or '${type}' == 'audio'    Run Keyword And Return Status    Should Be True    ${messageLength} > 0
    Run Keyword And Return If    '${type}' == 'loc'    Run Keyword And Return Status    Should Be True    ${messageLength} > 0

Check Visitor Message Is Exsit
    [Arguments]    ${messagesList}    ${type}
    [Documentation]    将不同格式的所有访客消息的列表进行返回
    @{visitorMessageList}    create list
    : FOR    ${message}    IN    @{messagesList}
    \    ${userType}    set variable    ${message['fromUser']['userType']}
    \    ${messageType}    set variable    ${message['body']['bodies'][0]['type']}
    \    ${visitorMessageList}    Collect Multiple Type Visitor Message    ${userType}    ${messageType}    ${message}    ${visitorMessageList}
    \    ...    ${type}
    Return From Keyword    ${visitorMessageList}

Collect Multiple Type Visitor Message
    [Arguments]    ${userType}    ${messageType}    ${message}    ${visitorMessageList}    ${type}
    [Documentation]    将不同格式的访客消息，添加到列表中，将列表进行返回
    run keyword if    ('${messageType}' == '${type}' == 'txt') and ("${userType}" == "Visitor")    Append To List    ${visitorMessageList}    ${message['body']['bodies'][0]['msg']}
    run keyword if    (('${messageType}' == '${type}' == 'file') or ('${messageType}' == '${type}' == 'img') or ('${messageType}' == '${type}' == 'audio')) and ("${userType}" == "Visitor")    Append To List    ${visitorMessageList}    ${message['body']['bodies'][0]['filename']}
    run keyword if    ('${messageType}' == '${type}' == 'loc') and ("${userType}" == "Visitor")    Append To List    ${visitorMessageList}    ${message['body']['bodies'][0]['addr']}
    Return From Keyword    ${visitorMessageList}

Get Servicesession Message
    [Arguments]    ${agent}    ${serviceSessionId}    ${filter}
    [Documentation]    获取会话的所有消息内容
    #查询会话的消息
    ${resp}=    /tenants/{tenantId}/servicesessions/{serviceSessionId}/messages    ${agent}    ${serviceSessionId}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Should Be Rated
    [Arguments]    ${agent}    ${nickname}    ${score}    ${detail}=    ${tag}=
    [Documentation]    判断会话是否已被评价
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${nickname} | 必填 | 访客昵称，例如：634-09049 |
    ...    | ${score} | 必填 | 满意度评价分数：1、2、3、4、5 |
    ...    | ${detail} | 选填 | 满意度评价内容，例如：工作态度认真 |
    ...    | ${tag} | 选填 | 满意度评价标签，例如：非常满意 |
    ...
    ...    【返回值】
    ...    | 接口调用成功返回值：True |
    ...
    ...    【调用方式】
    ...    | 会话被评价：5分 | ${j} | Should Be Rated | ${AdminUser} | 634-09049 | 5 |
    ...    | 会话被评价：5分，评价内容：工作态度认真 | ${j} | Should Be Rated | ${AdminUser} | 634-09049 | 5 | 工作态度认真 |
    ...    | 会话被评价：5分，评价内容：工作态度认真，满意度标签：非常满意 | ${j} | Should Be Rated | ${AdminUser} | 634-09049 | 5 | 工作态度认真 | 非常满意 |
    ...    | Should Be True | ${j} | 访客评分有误，或评价内容有误，或评价标签有误：${j} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据访客昵称查找进行中的会话 |
    ...    | Step 2 | 调用接口/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiries，获取会话的满意度评价信息，最多尝试重试取10次。 |
    ...    | Step 3 | 如果数据为空，则返回False |
    ...    | Step 4 | 返回值：True |
    #Step 1、根据访客昵称查找进行中的会话
    ${serviceSessionId}    Get Processing Conversation With Nickname    ${agent}    ${nickname}
    Return From Keyword If    "${serviceSessionId}" == "{}"    {}
    #Step 2、调用接口/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiries，获取会话的满意度评价信息，最多尝试重试取10次。
    ${j}    Get Servicesession Enquiries Repeatly    ${agent}    ${serviceSessionId}
    Return From Keyword If    ${j} == []    False
    #Step3、检查返回结果与给定是否一致，一致则返回True。
    ${scoreStatus}    Run Keyword And Return Status    Should Be Equal    ${j['data'][0]['summary']}    ${score}
    ${detailStatus}    Run Keyword And Return Status    Should Be Equal    ${j['data'][0]['detail']}    ${detail}
    Run Keyword And Return    Run Keyword And Return Status    Should Be True    "${scoreStatus}" == "${detailStatus}" == "True"
