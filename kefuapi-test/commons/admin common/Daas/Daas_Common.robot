*** Settings ***
Library           json
Library           requests
Library           Collections
Library           String
Library           RequestsLibrary
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../BaseKeyword.robot
Library           DateTime
Resource          ../Setting/ReviewSettings_Common.robot
Resource          ../Review/Review_Common.robot

*** Keywords ***
One Service Valid Conversation
    [Arguments]    ${agent}    ${rest}
    [Documentation]    创建一个单服务有效会话，并进行满意度评价，记录会话创建时间、结束时间
    ${originType}    set variable    weixin
    ${curTime}    get time    epoch
    ${guestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #创建技能组
    ${agentqueue}    create dictionary    queueName=${AdminUser.tenantId}${curTime}AA
    ${queueentityAA}    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}
    set global variable    ${FilterEntity.queueId}    ${queueentityAA.queueId}
    #创建指定技能组的扩展消息体
    ${msgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityAA.queueName}"}}
    #将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客
    Send Message    ${rest}    ${guestEntity}    ${msgEntity}
    #根据访客昵称查询待接入列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${guestEntity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j["total_entries"]} == 1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestEntity.userName}    访客名称不正确：${resp.content}
    #根据查询结果接入会话,此处sleep是为了增加排队时长
    sleep    2000ms
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #坐席回复消息并发送邀请评价,此处sleep是为了增加会话时长,根据Vistiors接口获取会话接起时间createDateTime和创建时间visitorFirstMessageTime
    sleep    2000ms
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    ${startTime1}    set variable    ${j[0]['createDateTime']}
    ${startTime2}    evaluate    ${startTime1}/1000
    ${startTime3}    evaluate    ${startTime2}+3
    ${daasStartTime}    set variable    ${startTime2}000
    ${daasEndTime}    set variable    ${startTime3}000
    ${createTime1}    set variable    ${j[0]['visitorFirstMessageTime']}
    ${createTime2}    evaluate    ${createTime1}/1000-1
    ${daasCreateTime}    set variable    ${createTime2}000
    ${curTimeAgent}    get time    epoch
    ${userId}    set variable    ${j[0]['user']['userId']}
    ${serviceSessionId}    set variable    ${j[0]['serviceSessionId']}
    ${chatGroupId}    set variable    ${j[0]['chatGroupId']}
    ${AgentMsgEntity}    create dictionary    msg=${curTimeAgent}:agent test msg!    type=txt
    Agent Send Message    ${agent}    ${userId}    ${serviceSessionId}    ${AgentMsgEntity}
    sleep    50ms
    Send InviteEnquiry    ${agent}    ${serviceSessionId}
    sleep    50ms
    #关闭进行中会话
    Stop Processing Conversation    ${agent}    ${userId}    ${serviceSessionId}
    #访客发送评价
    set to dictionary    ${msgEntity}    msg=5
    Send Message    ${rest}    ${guestEntity}    ${msgEntity}
    #保存会话接起的时间范围
    set to dictionary    ${ConDateRange}    beginDateTime=${daasStartTime}    endDateTime=${daasEndTime}
    set global variable    ${ConDateRange}    ${ConDateRange}
    ${conInfo}    create dictionary    queueentityAA=${queueentityAA}    daasCreateTime=${daasCreateTime}    userId=${userId}    userName=${guestEntity.userName}    serviceSessionId=${serviceSessionId}    chatGroupId=${chatGroupId}    queueId=${queueentityAA.queueId}    originType=${originType}
    return from keyword    ${conInfo}

Get Today Begin Time
    [Documentation]    获取当天零点的时间戳，毫秒级
    ${yyyy}    ${mm}    ${day}    Get Time    year,month,day
    ${time}    convert date    ${yyyy}${mm}${day} 0:0:0    epoch
    ${time1}    convert to string    ${time}
    ${time2}    split string from right    ${time1}    .    1
    ${time3}    set variable    ${time2[0]}000
    return from keyword    ${time3}

Get Today End Time
    [Documentation]    获取当天23点59分00秒的时间戳，毫秒级
    ${yyyy}    ${mm}    ${day}    Get Time    year,month,day
    ${time}    convert date    ${yyyy}${mm}${day} 23:59:00    epoch
    ${time1}    convert to string    ${time}
    ${time2}    split string from right    ${time1}    .    1
    ${time3}    set variable    ${time2[0]}000
    return from keyword    ${time3}

One Service Unvalid Conversation
    [Arguments]    ${agent}    ${rest}
    [Documentation]    创建一个单服务无效会话（客服无消息），并进行质检评分
    ${originType}    set variable    weixin
    ${curTime}    get time    epoch
    ${guestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #创建技能组
    ${agentqueue}    create dictionary    queueName=${AdminUser.tenantId}${curTime}AA
    ${queueentityAA}    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}
    set global variable    ${FilterEntity.queueId}    ${queueentityAA.queueId}
    #创建指定技能组的扩展消息体
    ${msgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityAA.queueName}"}}
    #将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客
    Send Message    ${rest}    ${guestEntity}    ${msgEntity}
    #根据访客昵称查询待接入列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${guestEntity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j["total_entries"]} == 1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestEntity.userName}    访客名称不正确：${resp.content}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #根据Vistiors接口获取会话接起时间createDateTime和创建时间visitorFirstMessageTime,此处sleep增加会话时长
    sleep    2000ms
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    ${startTime1}    set variable    ${j[0]['createDateTime']}
    ${startTime2}    evaluate    ${startTime1}/1000
    ${startTime3}    evaluate    ${startTime2}+3
    ${daasStartTime}    set variable    ${startTime2}000
    ${daasEndTime}    set variable    ${startTime3}000
    ${createTime1}    set variable    ${j[0]['visitorFirstMessageTime']}
    ${createTime2}    evaluate    ${createTime1}/1000-1
    ${daasCreateTime}    set variable    ${createTime2}000
    set to dictionary    ${ConDateRange}    beginDateTime=${daasStartTime}    endDateTime=${daasEndTime}
    set global variable    ${ConDateRange}    ${ConDateRange}
    ${userId}    set variable    ${j[0]['user']['userId']}
    ${serviceSessionId}    set variable    ${j[0]['serviceSessionId']}
    ${chatGroupId}    set variable    ${j[0]['chatGroupId']}
    #关闭进行中会话
    Stop Processing Conversation    ${agent}    ${userId}    ${serviceSessionId}
    #获取租户的质检评分项id并进行质检评分
    ${qualityResults}    Get Qualityitems
    ${sessionInfo}    create dictionary    serviceSessionId=${serviceSessionId}    stepNum=1
    ${data}    set variable    {"agentId":"${AdminUser.userId}", "attachments": [], "comment":"", "qualityResults": ${qualityResults}}
    ${data}    Replace String    ${data}    '    ${EMPTY}
    ${method}    set variable    post
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview    ${method}    ${AdminUser}    ${timeout}    ${sessionInfo}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    质检评分不正确:${resp.content}
    #筛选质检记录获取最新一条数据,检查质检评分,此处sleep因为质检数据从统计而来
    sleep    2000ms
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/qualityreviews    ${AdminUser}    ${filter}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    质检记录不正确:${resp.content}
    Should Be Equal    ${j["entities"][0]["serviceSessionId"]}    ${serviceSessionId}    会话不正确:${j["entities"][0]["serviceSessionId"]}
    ${totalScore}    set variable    ${j["entities"][0]["qualityReview"]["totalScore"]}
    #保存会话接起的时间范围
    ${conInfo}    create dictionary    queueentityAA=${queueentityAA}    daasCreateTime=${daasCreateTime}    totalScore=${totalScore}    userId=${userId}    userName=${guestEntity.userName}    serviceSessionId=${serviceSessionId}    chatGroupId=${chatGroupId}    queueId=${queueentityAA.queueId}    originType=${originType}    qmActorId=${AdminUser.userId}
    return from keyword    ${conInfo}

Get Current Session Count
    [Arguments]    ${orignType}    ${json}
    [Documentation]    获取首页趋势图对应渠道的当前会话数或消息数
    ${todayTrend}    set variable    0
    ${length}    get length    ${json["result"]}
    return from keyword if    ${length}==0    ${todayTrend}
    : FOR    ${n}    IN RANGE    ${length}
    \    run keyword if    '${json["result"][${n}]["type"]}'=='${orignType}'    set suite variable    ${todayTrend}    ${json["result"][${n}]["value"][0]["value"]}
    \    return from keyword if    '${json["result"][${n}]["type"]}'=='${orignType}'    ${todayTrend}
    return from keyword    ${todayTrend}

Get Agent Current Session Count
    [Arguments]    ${agentId}    ${json}
    [Documentation]    获取首页今日客服当前会话数
    ${sessionCount}    set variable    0
    ${length}    get length    ${json}
    return from keyword if    ${length}==0    ${sessionCount}
    : FOR    ${n}    IN RANGE    ${length}
    \    run keyword if    '${json[${n}]["key"]}'=='${agentId}'    set suite variable    ${sessionCount}    ${json[${n}]["count"]}
    \    return from keyword if    '${json[${n}]["key"]}'=='${agentId}'    ${sessionCount}
    return from keyword    ${sessionCount}

Unvalid Conversation Setup
    [Documentation]    创建一个单服务无效会话
    #创建单服务无效会话
    ${conInfo}    One Service Unvalid Conversation    ${AdminUser}    ${restentity}
    ${totalScore}    set variable    ${conInfo.totalScore}
    ${queueentity}    set suite variable    ${conInfo.queueentityAA}
    ${daasCreateTime}    set suite variable    ${conInfo.daasCreateTime}
    set global variable    ${totalScore}    ${totalScore}
    set global variable    ${queueentity}    ${queueentity}
    set global variable    ${daasCreateTime}    ${daasCreateTime}
    sleep    2000ms

Valid Conversation Setup
    [Documentation]    获取首页当前数据，并创建一个单服务有效会话
    #创建新会话前记录首页数据,待单服务有效会话创建完成后再验证首页数据的增量,"处理中会话数"与"在线客服数"暂未做验证
    ${beginTime}    Get Today Begin Time
    ${todayBeginTime}    convert to string    ${beginTime}
    ${endTime}    Get Today End Time
    ${todayEndTime}    convert to string    ${endTime}
    ${todayDateRange}    create dictionary    beginDateTime=${todayBeginTime}    endDateTime=${todayEndTime}
    set global variable    ${todayDateRange}    ${todayDateRange}
    #获取首页-今日新会话数
    ${resp}=    /daas/internal/session/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    ${todaySession}    set variable    ${resp.content}
    #获取首页-今日消息数
    ${resp}=    /daas/internal/message/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    ${todayMessage}    set variable    ${resp.content}
    #获取首页-会话量趋势,按当天筛选
    ${resp}=    /daas/internal/session/trend    ${AdminUser}    ${timeout}    ${todayDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${todaySessionTrend}    Get Current Session Count    weixin    ${j}
    #获取首页-消息量趋势,按当天筛选
    ${resp}=    /daas/internal/message/trend    ${AdminUser}    ${timeout}    ${todayDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${todayMessageTrend}    Get Current Session Count    weixin    ${j}
    #获取首页-今日客服新进会话数报表
    ${resp}=    /daas/internal/agent/kpi/session/today    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${todayAgentSessionCount}    Get Agent Current Session Count    ${AdminUser.userId}    ${j}
    ${todayInfo}    create dictionary    todaySession=${todaySession}    todayMessage=${todayMessage}    todaySessionTrend=${todaySessionTrend}    todayMessageTrend=${todayMessageTrend}    todayAgentSessionCount=${todayAgentSessionCount}
    set global variable    ${todayInfo}    ${todayInfo}
    #创建单服务有效会话
    ${conInfo}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    ${queueentity}    set variable    ${conInfo.queueentityAA}
    ${daasCreateTime}    set variable    ${conInfo.daasCreateTime}
    set global variable    ${queueentity}    ${queueentity}
    set global variable    ${daasCreateTime}    ${daasCreateTime}
    ${conCreateTime}    create dictionary    beginDateTime=${daasCreateTime}    endDateTime=${ConDateRange.endDateTime}
    set global variable    ${conCreateTime}    ${conCreateTime}
    sleep    2000ms
