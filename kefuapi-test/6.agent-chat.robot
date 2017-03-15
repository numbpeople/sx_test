*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          AgentRes.robot
Resource          api/KefuApi.robot
Resource          BaseKeyword.robot

*** Test Cases ***
从待接入接起会话查看attribute、track、会话信息、历史消息接口并关闭，查看历史会话、访客中心及统计指标
    [Documentation]    从待接入接起会话，查看attribute和track信息，查看会话信息和历史消息接口并关闭；管理员和坐席模式下的历史会话中均有该会话；管理员和坐席模式下的访客中心中均有该访客；首页统计今日新会话数+1，今日消息数增加，今日客服新进会话数+1
    set test variable    ${originType}    weixin
    ${curTime}    get time    epoch
    set to dictionary    ${MsgEntity}    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}"}}
    set to dictionary    ${GuestEntity}    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #查询今日会话数，今日消息数，今日坐席消息数
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${todayNewsession}    Convert To Integer    ${resp.content}
    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${todayMsgCount}=    Convert To Integer    ${resp.content}
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    :FOR    ${i}    IN    @{j}
    \    Exit For Loop If    '${i['agentNiceName']}'=='${AdminUser.nicename}'
    ${todayAgentSession}=    Convert To Integer    ${i['count']}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    ${resp}=    send msg    ${RestEntity}    ${GuestEntity}    ${MsgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    #根据查询结果接入会话
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/{waitingId}    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    #根据访客昵称查询待接入列表是否已无该访客
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==0
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==0    会话未接入：${resp.content}
    #查询进行中会话是否有该访客
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    log    ${a}
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    访客昵称不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${RestEntity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${RestEntity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}
    #查看attribute是否调用成功
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessions}/attributes    ${AdminUser}    ${GuestEntity.sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取attribute失败：${resp.content}
    #查看track是否调用成功
    ${resp}=    /v1/integration/tenants/{tenantId}/servicesessions/{serviceSessions}/tracks    ${AdminUser}    ${GuestEntity.sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j['status']}    获取track失败：${resp.content}
    #查询访客会话信息是否正确
    ${resp}=    /v1/Tenant/VisitorUsers/{visitorUserId}    ${AdminUser}    ${GuestEntity.userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['chatGroupId']}    ${GuestEntity.chatGroupId}    chatGroupId不正确：${j}
    Should Be Equal    ${j['techChannelId']}    ${RestEntity.channelId}    关联id不正确：${j}
    Should Be Equal    ${j['tenantId']}    ${AdminUser.tenantId}    tenantId不正确：${j}
    Should Be Equal    ${j['nicename']}    ${GuestEntity.userName}    tenantId不正确：${j}
    Should Be Equal    ${j['userId']}    ${GuestEntity.userId}    tenantId不正确：${j}
    #查询访客历史消息是否正确
    ${resp}=    /v1/Tenant/me/ChatGroup/{ChatGroupId}/Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    : FOR    ${a}    IN    @{j['messages']}
    \    ${tmsg}=    set variable if    '${a['body']['bodies'][0]['type']}'=='txt'    ${a['body']['bodies'][0]['msg']}    ${empty}
    \    ${diff1}=    replace string    ${tmsg}    \n    ${empty}
    \    ${diff2}=    replace string    ${MsgEntity.msg}    \n    ${empty}
    \    Exit For Loop If    '${diff1}'=='${diff2}'
    Should Be Equal    ${a['body']['bodies'][0]['msg']}    ${MsgEntity.msg}    消息内容不正确：${a}
    Should Be Equal    ${a['body']['bodies'][0]['type']}    ${MsgEntity.type}    消息类型不正确：${a}
    Should Be Equal    ${a['body']['serviceSessionId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    ${a['sessionServiceId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    '${a['tenantId']}'    '${AdminUser.tenantId}'    tenantId不正确：${a}
    Should Be Equal    ${a['body']['visitorUserId']}    ${GuestEntity.userId}    访客id不正确：${a}
    Should Be Equal    ${a['body']['channel_id']}    ${RestEntity.channelId}    关联id不正确：${a}
    #关闭会话
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${resp.content}    true    会话关闭失败：${resp.content}
    sleep    ${delay}
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    ${rs}=    Should Be Not Contain In JsonList    ['user']['nicename']    ${GuestEntity.userName}    @{j}
    Should Be True    ${rs}    会话关闭失败
    #获取管理员模式下客户中心
    set to dictionary    ${FilterEntity}    page=0
    :FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/crm/tenants/{tenantId}/customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['numberOfElements']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['numberOfElements']} ==1    访客中心人数不正确：${resp.content}
    #获取坐席模式下客户中心
    ${resp}=    /v1/crm/tenants/{tenantId}/agents/{agentId}/visitors    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['numberOfElements']} ==1    访客中心人数不正确：${resp.content}
    set to dictionary    ${FilterEntity}    page=1
    #6.管理员模式下查询该访客的会话
    set to dictionary    ${FilterEntity}    isAgent=false
    :FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话未查到该会话：${resp.content}
    #7.坐席模式下查询该访客的会话
    set to dictionary    ${FilterEntity}    isAgent=true
    set test variable    ${FilterEntity}    ${FilterEntity}
    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话：${resp.content}
    #查询今日会话数，今日消息数，今日客服新进会话数
    :FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    Exit For Loop If    ${resp.content} >${todayMsgCount}
    \    sleep    ${delay}
    Should Be True    ${resp.content} >${todayMsgCount}    今日消息不正确：测试前消息数(${resp.content})，测试后消息数(${todayMsgCount})
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content} ==${todayNewsession}+1    今日新进会话数不正确：测试会话数(${resp.content})，测试后会话数(${todayNewsession})
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    :FOR    ${i}    IN    @{j}
    \    Exit For Loop If    '${i['agentNiceName']}'=='${AdminUser.nicename}'
    Should Be True    ${i['count']}==${todayAgentSession}+1    今日客服新进会话数不正确：${i['count']}==${todayAgentSession}+1

从待接入接起会话，接收访客消息并回复后关闭
    set test variable    ${originType}    weixin
    ${curTime}    get time    epoch
    set to dictionary    ${MsgEntity}    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}"}}
    set to dictionary    ${GuestEntity}    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #1.发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    ${resp}=    send msg    ${RestEntity}    ${GuestEntity}    ${MsgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    set to dictionary    ${DateRange}    beginDate=${empty}    endDate=${empty}
    #2.根据访客昵称查询待接入列表（每3秒一次，最多查询3次）
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    #3.根据查询结果接入会话
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/{waitingId}    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    #4.根据访客昵称查询待接入列表是否已无该访客（每3秒一次，最多查询3次）
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==0
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==0    会话未接入：${resp.content}
    #5.查询进行中会话是否有该访客
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    坐席信息不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${RestEntity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${RestEntity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}
    #6.查询访客历史消息是否正确
    ${resp}=    /v1/Tenant/me/ChatGroup/{ChatGroupId}/Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    : FOR    ${a}    IN    @{j['messages']}
    \    ${tmsg}=    set variable if    '${a['body']['bodies'][0]['type']}'=='txt'    ${a['body']['bodies'][0]['msg']}    ${empty}
    \    ${diff1}=    replace string    ${tmsg}    \n    ${empty}
    \    ${diff2}=    replace string    ${MsgEntity.msg}    \n    ${empty}
    \    Exit For Loop If    '${diff1}'=='${diff2}'
    Should Be Equal    ${a['body']['bodies'][0]['msg']}    ${MsgEntity.msg}    消息内容不正确：${a}
    set to dictionary    ${GuestEntity}    startSessionTimestamp=${j['startSessionTimestamp']}    sessionServiceSeqId=${a['sessionServiceSeqId']}
    #7.坐席查收访客发送的新消息
    ${curTime}    get time    epoch
    set to dictionary    ${MsgEntity}    msg=消息${curTime}    type=txt    ext={}
    ${resp}=    send msg    ${RestEntity}    ${GuestEntity}    ${MsgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    log    ${GuestEntity}
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/SessionServices/{sessionId}/Messages    ${AdminUser}    ${GuestEntity}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['messages']}!=[]
    \    sleep    ${delay}
    : FOR    ${a}    IN    @{j['messages']}
    \    ${tmsg}=    set variable if    '${a['body']['bodies'][0]['type']}'=='txt'    ${a['body']['bodies'][0]['msg']}    ${empty}
    \    ${diff1}=    replace string    ${tmsg}    \n    ${empty}
    \    ${diff2}=    replace string    ${MsgEntity.msg}    \n    ${empty}
    \    Exit For Loop If    '${diff1}'=='${diff2}'
    Should Be Equal    ${a['body']['bodies'][0]['msg']}    ${MsgEntity.msg}    消息内容不正确：${a}
    Should Be Equal    ${a['body']['bodies'][0]['type']}    ${MsgEntity.type}    消息类型不正确：${a}
    Should Be Equal    ${a['body']['serviceSessionId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    ${a['sessionServiceId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    '${a['tenantId']}'    '${AdminUser.tenantId}'    tenantId不正确：${a}
    Should Be Equal    ${a['body']['visitorUserId']}    ${GuestEntity.userId}    访客id不正确：${a}
    Should Be Equal    ${a['body']['channel_id']}    ${RestEntity.channelId}    关联id不正确：${a}
    #坐席发送消息
    ${curTime}    get time    epoch
    set to dictionary    ${AgentMsgEntity}    msg=${curTime}:agent test msg!    type=txt    ext=${a['body']['ext']}
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}    ${AgentMsgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['fromUser']['bizId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['tenantId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['nicename']}'    '${AdminUser.nicename}'    坐席nicename信息不正确：${j}
    Should Be Equal    '${j['fromUser']['username']}'    '${AdminUser.username}'    坐席username信息不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['msg']}'    '${AgentMsgEntity.msg}'    消息内容不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['type']}'    '${AgentMsgEntity.type}'    消息类型不正确：${j}
    #8.关闭会话
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${resp.content}    true    会话关闭失败：${resp.content}
    sleep    ${delay}
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    ${rs}=    Should Be Not Contain In JsonList    ['user']['nicename']    ${GuestEntity.userName}    @{j}
    Should Be True    ${rs}    会话关闭失败
