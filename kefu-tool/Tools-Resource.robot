*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../kefuapi-test/AgentRes.robot
Resource          ../kefuapi-test/AgentRes.robot
Resource          ../kefuapi-test/commons/admin common/BaseKeyword.robot
Resource          ../kefuapi-test/commons/admin common/Members/AgentQueue_Common.robot
Resource          ../kefuapi-test/commons/admin common/Members/Agents_Common.robot
Resource          ../kefuapi-test/commons/admin common/Channels/App_Common.robot
Resource          ../kefuapi-test/commons/agent common/Queue/Queue_Common.robot
Resource          ../kefuapi-test/commons/agent common/Conversations/Conversations_Common.robot
Resource          ../kefuapi-test/api/BaseApi/Members/Queue_Api.robot
Resource          ../kefuapi-test/api/MicroService/Webapp/InitApi.robot
Resource          ../kefuapi-test/api/BaseApi/Queue/WaitApi.robot
Resource          ../kefuapi-test/api/HomePage/Login/Login_Api.robot

*** Keywords ***
Delete Agentusers
    #设置客服账号名称模板
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #获取所有客服列表
    ${agentlist}=    Get Agents    #返回字典
    ${userNameList}=    Get Dictionary Keys    ${agentlist}
    ${listlength}=    Get Length    ${userNameList}
    log    ${agentlist}
    #循环判断技能组名称是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${username}=    convert to string    ${userNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}=    Get From Dictionary    ${agentlist}    ${userNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Agent    ${userIdValue}

Delete Queues
    #设置技能组名称模板
    ${preQueuename}=    convert to string    ${AdminUser.tenantId}
    #获取所有技能组列表
    ${queuelist}=    Get Agentqueue    #返回字典
    ${queueNameList}=    Get Dictionary Keys    ${queuelist}
    ${listlength}=    Get Length    ${queueNameList}
    log    ${queuelist}
    #循环判断技能组名称是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${queueName}=    convert to string    ${queueNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${queueName}    ${preQueuename}
    \    ${queueIdValue}=    Get From Dictionary    ${queuelist}    ${queueNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Agentqueue    ${queueIdValue}

Delete Channels
    [Arguments]    ${agent}=${AdminUser}
    #设置关联对比模板
    ${preChannelname}=    convert to string    ${agent.tenantId}
    #获取所有关联列表
    ${channellist}=    Get Channels    ${agent}    #返回字典
    ${channelNameList}=    Get Dictionary Keys    ${channellist}
    ${listlength}=    Get Length    ${channelNameList}
    log    ${channellist}
    #循环判断返回值中是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${channelname}=    convert to string    ${channelNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${channelname}    ${preChannelname}
    \    ${channelIdValue}=    Get From Dictionary    ${channellist}    ${channelNameList[${i}]}
    \    Run Keyword If    ${status}    Close Conversations By ChannelId    ${channelIdValue}    ${agent}
    \    Run Keyword If    ${status}    Delete Channel    ${channelIdValue}    ${agent}

Decode Bytes To String In Dict
    [Arguments]    ${dict}    ${encoding}=UTF-8
    ${keys}    Get Dictionary Keys    ${dict}
    : FOR    ${i}    IN    @{keys}
    \    ${s}    Decode Bytes To String    ${dict['${i}']}    ${encoding}
    \    Set To Dictionary    ${dict}    ${i}=${s}
    Return From Keyword    ${dict}

Create Queue And Add Agents To Queue
    [Arguments]    ${agent}    ${agentslist}    ${queuename}
    #添加技能组
    ${data}=    set variable    {"queueName":"${queuename}"}
    ${resp}=    /v1/AgentQueue    post    ${agent}    ${data}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    #更新技能组的时间计划、下班提示语开关及下班提示语内容
    ${data}=    set variable    {"tenantId":${agent.tenantId},"queueId":${j['queueId']},"timeScheduleId":0,"timeOffWorkEnable":"false","timeOffWorkMessage":""}
    ${resp}=    Put Time-Options    ${agent}    ${j['queueId']}    ${data}
    #设置问候语开关
    ${data}=    set variable    {"name":"GreetingMsgAgentQueueEnable_${j['queueId']}","value":false}
    ${resp}=    Post Option Value    ${agent}    ${data}
    #设置问候语内容
    ${data}=    set variable    {"name":"GreetingMsgAgentQueueContent_${j['queueId']}","value":""}
    ${resp}=    Post Option Value    ${agent}    ${data}
    #添加坐席到技能组
    ${resp}=    /v1/AgentQueue/{queueId}/AgentUser    ${agent}    ${j['queueId']}    ${agentslist}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}
    set global variable    @{agentslist}    ${empty}
    remove from list    ${agentslist}    0

Close Valid New Session
    [Arguments]    ${agent}    ${rest}    ${originType}    ${maxcount}=200
    : FOR    ${i}    IN RANGE    ${maxcount}
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${agent.tenantId}-${i}-1    originType=${originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${guestentity.originType}"}}
    \    Comment    Repeat Keyword    5    Send Message    ${rest}    ${guestentity}    ${msgentity}
    \    Repeat Keyword    5    Send SecondGateway Msg    ${AdminUser}    ${restentity}    ${GuestEntity}    ${MsgEntity}
    \    sleep    10ms
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${agent}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${agent}    ${i['userWaitQueueId']}
    \    sleep    50ms
    sleep    1
    #坐席回复消息
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    ${curTime}    get time    epoch
    \    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    \    Repeat Keyword    5    Agent Send Message    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}    ${AgentMsgEntity}
    \    sleep    50ms
    sleep    1
    #关闭进行中会话
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms

Close Waiting Sessions
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${maxcount}=200
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=${maxcount}
    ${resp}    Search Waiting Conversation    ${agent}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${i['userWaitQueueId']}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    sleep    1s

Close And Create Valid Rated Session
    [Arguments]    ${agent}    ${rest}    ${originType}    ${maxcount}=200
    [Documentation]    创建有效会话，发送邀请评价，关闭会话后评价
    @{guestlist}    Create List    ${empty}
    : FOR    ${i}    IN RANGE    ${maxcount}
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${agent.tenantId}-${i}-${curTime}    originType=${originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${guestentity.originType}"}}
    \    Send Message    ${rest}    ${guestentity}    ${msgentity}
    \    Append to list    ${guestlist}    ${guestentity}
    \    log    ${guestlist}
    \    sleep    200ms
    remove from list    ${guestlist}    0
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${agent}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${agent}    ${i['userWaitQueueId']}
    \    sleep    50ms
    sleep    1
    #坐席回复消息并发送邀请评价
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    ${curTime}    get time    epoch
    \    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    \    Agent Send Message    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}    ${AgentMsgEntity}
    \    sleep    50ms
    \    Send InviteEnquiry    ${agent}    ${i['serviceSessionId']}
    \    sleep    50ms
    sleep    1
    #关闭进行中会话
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms
    #访客发送评价
    sleep    1
    : FOR    ${i}    IN    @{guestlist}
    \    log    ${i}
    \    set to dictionary    ${msgentity}    msg=5
    \    Send Message    ${rest}    ${i}    ${msgentity}
    \    sleep    200ms

Encode String To Bytes In Dict
    [Arguments]    ${dict}    ${encoding}=UTF-8
    ${keys}    Get Dictionary Keys    ${dict}
    : FOR    ${i}    IN    @{keys}
    \    ${s}    encode String To Bytes    ${dict['${i}']}    ${encoding}
    \    Set To Dictionary    ${dict}    ${i}=${s}
    Return From Keyword    ${dict}

Close Valid Rated Session
    [Arguments]    ${agent}    ${rest}    ${originType}    ${maxcount}=200
    [Documentation]    创建有效会话，发送邀请评价，评价后关闭会话
    @{guestlist}    Create List    ${empty}
    : FOR    ${i}    IN RANGE    ${maxcount}
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${agent.tenantId}-${i}-${curTime}    originType=${originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${guestentity.originType}"}}
    \    Send Message    ${rest}    ${guestentity}    ${msgentity}
    \    Append to list    ${guestlist}    ${guestentity}
    \    log    ${guestlist}
    \    sleep    200ms
    remove from list    ${guestlist}    0
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${agent}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${agent}    ${i['userWaitQueueId']}
    \    sleep    50ms
    sleep    1
    #坐席回复消息并发送邀请评价
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    ${curTime}    get time    epoch
    \    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    \    Agent Send Message    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}    ${AgentMsgEntity}
    \    sleep    50ms
    \    Send InviteEnquiry    ${agent}    ${i['serviceSessionId']}
    \    sleep    50ms
    sleep    1
    #访客发送评价
    : FOR    ${i}    IN    @{guestlist}
    \    log    ${i}
    \    set to dictionary    ${msgentity}    msg=5
    \    Send Message    ${rest}    ${i}    ${msgentity}
    \    sleep    200ms
    sleep    1
    #关闭进行中会话
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms

Login And Callin Session
    [Arguments]    ${agent}    ${maxcount}=200
    [Documentation]    创建有效会话，发送邀请评价，关闭会话后评价
    #登录
    Create Session    tmpsession    ${kefuurl}
    ${resp}=    /login    tmpsession    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${agent}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=tmpsession    nicename=${j['agentUser']['nicename']}
    set to dictionary    ${DateRange}    beginDate=2015-08-01T00%3A00%3A00.000Z    endDate=2027-08-31T23%3A59%3A00.000Z
    set global variable    ${DateRange}    ${DateRange}
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=${maxcount}
    ${resp}    Search Waiting Conversation    ${agent}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    log    ${j}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${agent}    ${i['userWaitQueueId']}
    \    sleep    50ms
