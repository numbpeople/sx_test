*** Settings ***
Suite Setup       Run Keywords    Create Channel
...               AND    log    agent-chat case 执行开始
Suite Teardown    Run Keywords    Delete Agentusers
...               AND    Delete Queues
...               AND    Delete Channels
...               AND    log    agent-chat case 执行结束
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          AgentRes.robot
Resource          api/KefuApi.robot
Resource          JsonDiff/KefuJsonDiff.robot
Resource          commons/admin common/Members/AgentQueue_Common.robot
Resource          commons/agent common/agent_common.robot
Resource          kefutool/Tools-Resource.robot
Resource          commons/admin common/BaseKeyword.robot
Resource          commons/admin common/Setting/Routing_Common.robot

*** Test Cases ***
从待接入接起会话查看attribute、track、会话信息、历史消息接口并关闭，查看历史会话、访客中心
    [Documentation]    从待接入接起会话，查看attribute和track信息，查看会话信息和历史消息接口并关闭；
    ...    管理员和坐席模式下的历史会话中均有该会话；管理员和坐席模式下的访客中心中均有该访客
    #初始化参数：消息、渠道信息、客户信息
    set test variable    ${originType}    weixin
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
    #查看attribute是否调用成功
    ${j}    Get Attribute    ${AdminUser}    ${GuestEntity.sessionServiceId}
    Should Be Equal    ${j['status']}    OK    获取attribute失败：${j}
    #查看track是否调用成功
    ${j}    Get Track    ${AdminUser}    ${GuestEntity.sessionServiceId}
    Should Not Be Empty    ${j['status']}    获取track失败：${j}
    #查询访客会话信息是否正确
    ${j}    Get Single Visitor    ${AdminUser}    ${GuestEntity.userId}
    Should Be Equal    ${j['chatGroupId']}    ${GuestEntity.chatGroupId}    chatGroupId不正确：${j}
    Should Be Equal    ${j['techChannelId']}    ${restentity.channelId}    关联id不正确：${j}
    Should Be Equal    ${j['tenantId']}    ${AdminUser.tenantId}    tenantId不正确：${j}
    Should Be Equal    ${j['nicename']}    ${GuestEntity.userName}    tenantId不正确：${j}
    Should Be Equal    ${j['userId']}    ${GuestEntity.userId}    tenantId不正确：${j}
    #查询访客历史消息是否正确
    set to dictionary    ${MsgFilter}    size=50
    ${j}    Get Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}
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
    Should Be Equal    ${a['body']['channel_id']}    ${restentity.channelId}    关联id不正确：${a}
    #关闭会话
    Stop Processing Conversation    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}
    #获取管理员模式下客户中心
    set to dictionary    ${FilterEntity}    page=0
    ${j}    Get Admin Customers    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    ${j['numberOfElements']} ==1    访客中心人数不正确：${j}
    #获取坐席模式下客户中心
    ${j}    Get Agent Customers    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    ${j['numberOfElements']} ==1    访客中心人数不正确：${j}
    set to dictionary    ${FilterEntity}    page=1
    #6.管理员模式下查询该访客的历史会话
    set to dictionary    ${FilterEntity}    isAgent=false
    ${j}    Get History    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话未查到该会话：${j}
    #7.坐席模式下查询该访客的会话
    set to dictionary    ${FilterEntity}    isAgent=true
    ${j}    Get History    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话：${j}
    #以下为统计相关的代码注释掉
    #以下为统计相关的代码注释掉
    #查询今日会话数，今日消息数，今日坐席消息数
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${todayNewsession}    Convert To Integer    ${resp.content}
    Comment    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${todayMsgCount}=    Convert To Integer    ${resp.content}
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${j}    to json    ${resp.content}
    Comment    :FOR    ${i}    IN    @{j}
    Comment    \    Exit For Loop If    '${i['agentNiceName']}'=='${AdminUser.nicename}'
    Comment    ${todayAgentSession}=    Convert To Integer    ${i['count']}
    #查询今日会话数，今日消息数，今日客服新进会话数
    Comment    :FOR    ${i}    IN RANGE    ${retryTimes}
    Comment    \    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    Comment    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    \    Exit For Loop If    ${resp.content} >${todayMsgCount}
    Comment    \    sleep    ${delay}
    Comment    Should Be True    ${resp.content} >${todayMsgCount}    今日消息不正确：测试前消息数(${resp.content})，测试后消息数(${todayMsgCount})
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    Should Be True    ${resp.content} ==${todayNewsession}+1    今日新进会话数不正确：测试会话数(${resp.content})，测试后会话数(${todayNewsession})
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${j}    to json    ${resp.content}
    Comment    :FOR    ${i}    IN    @{j}
    Comment    \    Exit For Loop If    '${i['agentNiceName']}'=='${AdminUser.nicename}'
    Comment    Should Be True    ${i['count']}==${todayAgentSession}+1    今日客服新进会话数不正确：${i['count']}==${todayAgentSession}+1

从待接入接起会话，接收访客消息并回复后关闭
    #初始化参数：消息、渠道信息、客户信息
    set test variable    ${originType}    weixin
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
    set to dictionary    ${DateRange}    beginDate=${empty}    endDate=${empty}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${j}
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
    #查询访客历史消息是否正确
    set to dictionary    ${MsgFilter}    size=50
    ${j}    Get Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}
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
    Should Be Equal    ${a['body']['channel_id']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    startSessionTimestamp=${j['startSessionTimestamp']}    sessionServiceSeqId=${a['sessionServiceSeqId']}
    #坐席发送消息
    ${curTime}    get time    epoch
    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    ${j}    Agent Send Message    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}    ${AgentMsgEntity}
    Should Be Equal    '${j['fromUser']['bizId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['tenantId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['nicename']}'    '${AdminUser.nicename}'    坐席nicename信息不正确：${j}
    Should Be Equal    '${j['fromUser']['username']}'    '${AdminUser.username}'    坐席username信息不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['msg']}'    '${AgentMsgEntity.msg}'    消息内容不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['type']}'    '${AgentMsgEntity.type}'    消息类型不正确：${j}
    #8.关闭会话
    ${j}    Stop Processing Conversation    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    ${rs}=    Should Be Not Contain In JsonList    ['user']['nicename']    ${GuestEntity.userName}    @{j}
    Should Be True    ${rs}    会话关闭失败

从待接入接起会话，发送满意度评价，关闭会话后，历史会话中查询满意度评价信息
    #初始化参数：消息、渠道信息、客户信息
    set test variable    ${originType}    weixin
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
    set to dictionary    ${DateRange}    beginDate=${empty}    endDate=${empty}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
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
    #查询访客历史消息是否正确
    set to dictionary    ${MsgFilter}    size=50
    ${j}    Get Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}
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
    Should Be Equal    ${a['body']['channel_id']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    startSessionTimestamp=${j['startSessionTimestamp']}    sessionServiceSeqId=${a['sessionServiceSeqId']}
    #坐席发送消息
    ${curTime}    get time    epoch
    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    ${j}    Agent Send Message    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}    ${AgentMsgEntity}
    Should Be Equal    '${j['fromUser']['bizId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['tenantId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['nicename']}'    '${AdminUser.nicename}'    坐席nicename信息不正确：${j}
    Should Be Equal    '${j['fromUser']['username']}'    '${AdminUser.username}'    坐席username信息不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['msg']}'    '${AgentMsgEntity.msg}'    消息内容不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['type']}'    '${AgentMsgEntity.type}'    消息类型不正确：${j}
    #发送满意度评价
    ${j}    Send InviteEnquiry    ${AdminUser}    ${GuestEntity.sessionServiceId}
    Should Be Equal    ${j['status']}    OK    消息内容不正确：${j}
    #关闭会话
    ${j}    Stop Processing Conversation    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    ${rs}=    Should Be Not Contain In JsonList    ['user']['nicename']    ${GuestEntity.userName}    @{j}
    Should Be True    ${rs}    会话关闭失败
    #访客评价会话
    set to dictionary    ${MsgEntity}    msg=1    # 1代表5星、2代表4星 ......
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #坐席模式下查询该访客的会话
    set to dictionary    ${FilterEntity}    isAgent=true
    ${j}    Get History    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话：${j}
    #管理员模式下查询该访客的历史会话
    set to dictionary    ${FilterEntity}    isAgent=false
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    Get History    ${AdminUser}    ${FilterEntity}    ${DateRange}
    \    Exit For Loop If    (${j['items'][0]['enquirySummary']} > 0) & (${j['total_entries']} == 1)
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话未查到该会话：${j}
    Should Be True    ${j['items'][0]['enquirySummary']} == 5    管理员模式历史会话下会话满意度评价不正确：${j}
