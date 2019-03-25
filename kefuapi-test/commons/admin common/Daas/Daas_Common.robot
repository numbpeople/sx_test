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
Resource          ../Review/Review_Common.robot
Resource          ../../../api/BaseApi/Conversations/ConversationApi.robot
Resource          ../../Base Common/Base_Common.robot
Resource          ../../agent common/Conversations/Conversations_Common.robot
Resource          ../Setting/ConversationTags_Common.robot

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
    ${conInfo}    create dictionary    queueentityAA=${queueentityAA}    daasCreateTime=${daasCreateTime}    userId=${userId}    userName=${guestEntity.userName}    serviceSessionId=${serviceSessionId}
    ...    chatGroupId=${chatGroupId}    queueId=${queueentityAA.queueId}    originType=${originType}
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
    #坐席发送满意度评价邀请
    Send InviteEnquiry    ${agent}    ${serviceSessionId}
    sleep    50ms
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
    #    #根据queueId筛选当天质检数据,检查质检评分
    #    ${range}    copy dictionary    ${DateRange}
    #    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    #    ${dn}=    Convert To Integer    ${day}
    #    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    #    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    #    set to dictionary    ${filter}    groupId=${queueentityAA.queueId}
    #    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    #    run keyword if    ${j} == {}    Fail    根据技能组id(queueId)筛选当天质检数据，没有找到数据
    #    should be equal    ${j['status']}    OK    接口返回值status不正确, ${j}
    #    should be true    '${j['totalElements']}' == '1'    接口返回数据不唯一, ${j}
    #    Should Be Equal    ${j["entities"][0]["sessionId"]}    ${serviceSessionId}    会话不正确:${j["entities"][0]["sessionId"]}
    #    ${totalScore}    set variable    ${j["entities"][0]["qualityReview"]["totalScore"]}
    #验证质检成功,并记录质检总分
    ${method}    set variable    get
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview    ${method}    ${AdminUser}    ${timeout}    ${sessionInfo}    ${data}=
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    质检评分不正确:${resp.content}
    Should Be Equal    ${j["entity"]["serviceSessionId"]}    ${serviceSessionId}    会话不正确:${j["entity"]["serviceSessionId"]}
    ${totalScore}    set variable    ${j["entity"]["totalScore"]}
    #保存会话接起的时间范围
    ${conInfo}    create dictionary    queueentityAA=${queueentityAA}    daasCreateTime=${daasCreateTime}    totalScore=${totalScore}    userId=${userId}    userName=${guestEntity.userName}
    ...    serviceSessionId=${serviceSessionId}    chatGroupId=${chatGroupId}    queueId=${queueentityAA.queueId}    originType=${originType}    qmActorId=${AdminUser.userId}    vmsgCount=1
    ...    amsgCount=0    qualityMark=${totalScore}
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
    sleep    ${daasDelay}

Valid Conversation Setup
    [Documentation]    获取首页当前数据，并创建一个单服务有效会话并进行质检评分
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
    #进行质检评分
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    groupId=${conInfo.queueId}
    #根据queueId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    run keyword if    ${j} == {}    Fail    根据技能组id(queueId)筛选当天质检数据，没有找到数据
    should be equal    ${j['status']}    OK    接口返回值status不正确, ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不唯一, ${j}
    should be equal    ${j['entities'][0]['sessionId']}    ${conInfo.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    #获取租户的质检评分项
    ${qualityResults}    Get Qualityitems
    #对该服务进行质检评分
    ${sessionInfo}    create dictionary    serviceSessionId=${conInfo.serviceSessionId}    stepNum=1
    ${j}=    Quality Review    ${sessionInfo}    ${qualityResults}
    #检查该服务的质检结果是否与预期一致
    ${j}=    Get Quality Review    ${sessionInfo}
    should be equal    ${j["status"]}    OK    质检评分不正确:${j}
    Should Be Equal    ${j['entity']['reviewerId']}    ${AdminUser.userId}    质检接口返回值的reviewerId不正确：${j}
    Should Be Equal    ${j['entity']['totalScore']}    ${score}    质检接口返回值的totalScore不正确：${j}
    sleep    ${daasDelay}

Agent CallingBack Conversation Setup
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、坐席在历史会话中，回呼刚刚结束的会话，调用接口：/v6/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/{visitorUserId}/CreateServiceSession，接口请求状态码为200。
    ...    - Step3、在进行中列表中，验证进行中会话，调用接口：/v1/Agents/me/Visitors，接口请求状态码为200。
    ...    - Step4、关闭进行中会话。
    ...    - Step5、按会话id筛选坐席模式下的历史会话，验证会话已关闭。
    ...    - Step6、将会话的时间戳及技能组id等信息保存至全局变量${ConInfo}中，供case使用。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #坐席回呼刚刚创建并结束的会话
    ${callBackSession}    Agent CallingBack Conversation    ${AdminUser}    ${session.userId}
    Should Be True    "${callBackSession['status']}" == "OK"    回呼会话返回后的status值不对，正常的结果OK：${callBackSession}
    Should Be True    "${callBackSession['entity']['state']}" == "Processing"    回呼会话返回后的接口state值不对，正常的结果为Processing：${callBackSession}
    Should Be True    "${callBackSession['entity']['visitorUser']['userId']}" == "${session.userId}"    回呼会话返回后的接口userId值不对，正常的结果为${session.userId}：${callBackSession}
    #获取进行中会话列表
    &{searchDic}    create dictionary    fieldName=${session.userId}    fieldValue=${session.userId}    fieldConstruction=['user']['userId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['user']['userId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.userId}    #该参数为获取接口某字段的预期值
    #验证进行中会话是否与期望一致
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    回呼会话后，进行中会话不是预期值
    should be equal    ${j[0]['user']['nicename']}    ${session.userName}    获取到的访客昵称不正确, ${j}
    ${serviceSessionId}    set variable    ${j[0]['serviceSessionId']}
    #关闭进行中会话
    Stop Processing Conversation    ${AdminUser}    ${session.userId}    ${serviceSessionId}
    #坐席模式下历史会话按照会话id筛选
    sleep    ${daasDelay}
    set to dictionary    ${filter}    isAgent=true    serviceSessionId=${serviceSessionId}
    ${j}    Get History    ${AdminUser}    ${filter}    ${DateRange}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话未查询到该会话：${j}
    #将需要的信息保存至全局变量${ConInfo}中
    ${daasStartTime}    convert date    ${j['items'][0]['createDatetime']}    epoch
    ${daasEndTime}    evaluate    ${daasStartTime}+1
    ${daasStartTime}    convert to integer    ${daasStartTime}
    ${daasEndTime}    convert to integer    ${daasEndTime}
    ${daasStartTime}    set variable    ${daasStartTime}000
    ${daasEndTime}    set variable    ${daasEndTime}000
    set to dictionary    ${ConDateRange}    beginDateTime=${daasStartTime}    endDateTime=${daasEndTime}
    #由于stopDateTime经常不能立即获取到，所以下面的ConInfo先不记录stopDateTime了，目前没有影响
    ${ConInfo}    create dictionary    ConDateRange=${ConDateRange}    queueId=${j['items'][0]['queueId']}    createDatetime=${j['items'][0]['createDatetime']}    startDateTime=${j['items'][0]['startDateTime']}    agentUserId=${j['items'][0]['agentUserId']}
    ...    serviceSessionId=${serviceSessionId}    #stopDateTime=${j['items'][0]['stopDateTime']}
    set global variable    ${ConInfo}
    sleep    ${daasDelay}

Transfer Conversation Setup
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #将转接预调度关闭掉
    ${data}    set variable    {"value":false}
    ${optionResult}    Set Option Value    ${AdminUser}    put    serviceSessionTransferPreScheduleEnable    ${data}
    Should Be Equal    '${optionResult['status']}'    'OK'    设置转接预调度结果status不为OK：${optionResult}
    #设置创建坐席请求参数
    ${uuid}    Uuid 4
    ${name}    set variable    ${AdminUser.tenantId}${uuid}
    &{agent}=    create dictionary    username=${name}@qq.com    password=test2015    maxServiceSessionCount=10    nicename=${name}    permission=1
    ...    roles=admin,agent
    ${data}=    set variable    {"nicename":"${agent.nicename}","username":"${agent.username}","password":"${agent.password}","confirmPassword":"${agent.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${agent.maxServiceSessionCount}","permission":${agent.permission},"roles":"${agent.roles}"}
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #创建坐席并获取坐席id
    ${agentInfo}    Create Agent    ${AdminUser}    ${agentFilter}    ${data}
    ${transferAgentUserId}    set variable    ${agentInfo['userId']}
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
    Send Message    ${restentity}    ${guestEntity}    ${msgEntity}
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
    ${nicename}    set variable    ${j[0]['user']['nicename']}
    ${serviceSessionId}    set variable    ${j[0]['serviceSessionId']}
    ${chatGroupId}    set variable    ${j[0]['chatGroupId']}
    ${queueId}    set variable    ${FilterEntity.queueId}
    ${agentUserId}    set variable    ${AdminUser.userId}
    #将会话转接给新创建的坐席
    ${data}    set variable    {"agentUserId":"${transferAgentUserId}","queueId":${queueId}}
    ${resp}=    /v6/tenants/{tenantId}/servicesessions/{serviceSessionId}/transfer    ${AdminUser}    ${serviceSessionId}    ${queueId}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    转接会话失败:${resp.content}
    #设置查询当前会话的参数
    set to dictionary    ${filter}    state=Processing    isAgent=${False}    visitorName=${nicename}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get EnquiryStatus接口的参数值
    ${expectConstruction}    set variable    ['items'][0]['agentUserId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${transferAgentUserId}    #该参数为获取接口某字段的预期值
    #验证当前会话数据是否为期望值
    ${j}    Repeat Keyword Times    Get Current Conversation    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中会话不属于转接后的坐席
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${serviceSessionId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['items'][0]['agentUserNiceName']}    ${name}    获取接口返回agentUserNiceName不正确: ${j}
    ${curTime}    get time    epoch
    ${daasTransferStartTime}    set variable    ${curTime}000
    #获取会话标签数据
    &{conversationTagEntity}    create dictionary    systemOnly=false    buildCount=true
    ${j}    Get Conversation Tags    get    ${AdminUser}    0    ${conversationTagEntity}
    ${tagLength}    Get Length    ${j}
    ${tagRootId}    Set Variable    ${j[0]["id"]}
    #获取标签中第一个根节点的叶子标签id值
    ${tagId}    Get Conversation TagId    ${j}
    ${data}    set variable    [${tagId}]
    #会话打标签
    ${j}    Set ServiceSessionSummaryResults    post    ${AdminUser}    ${serviceSessionId}    ${data}
    Should Be True    '${j}' == '${EMPTY}'    获取接口返回结果不正确: ${j}
    #AdminUser关闭transferAgentUser的当前会话
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/stop    ${AdminUser}    ${serviceSessionId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    结束会话失败:${resp.content}
    #保存会话接起的时间范围:begin是第一个服务的接起时间，end是第二个服务的接起时间
    set to dictionary    ${ConDateRange}    beginDateTime=${daasStartTime}    endDateTime=${daasTransferStartTime}
    set global variable    ${ConDateRange}    ${ConDateRange}
    ${transferConversationInfo}    Create Dictionary    transferAgentUserId=${transferAgentUserId}    tagId=${tagId}    tagLength=${tagLength}    tagRootId=${tagRootId}
    Set Global Variable    ${transferConversationInfo}    ${transferConversationInfo}
    ${conInfo}    create dictionary    queueentityAA=${queueentityAA}    daasCreateTime=${daasCreateTime}    userId=${userId}    userName=${guestEntity.userName}    serviceSessionId=${serviceSessionId}
    ...    chatGroupId=${chatGroupId}    queueId=${queueentityAA.queueId}    originType=${originType}    transferAgentUserId=${transferAgentUserId}
    sleep    ${daasDelay}
    return from keyword    ${conInfo}

Find Tag Count
    [Arguments]    @{entities}
    : FOR    ${n}    IN    @{entities}
    \    Return From Keyword If    ${n["key"]} == ${transferConversationInfo.tagRootId}    ${n["count"]}
    Return From Keyword    False
