*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../AgentRes.robot
Resource          ../AgentRes.robot
Resource          ../api/KefuApi.robot
Resource          ../commons/admin common/BaseKeyword.robot
Resource          ../api/RoutingApi.robot
Resource          ../commons/admin common/admin_common.robot

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
    #设置关联对比模板
    ${preChannelname}=    convert to string    ${AdminUser.tenantId}
    #获取所有关联列表
    ${channellist}=    Get Channels    #返回字典
    ${channelNameList}=    Get Dictionary Keys    ${channellist}
    ${listlength}=    Get Length    ${channelNameList}
    log    ${channellist}
    #循环判断返回值中是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${channelname}=    convert to string    ${channelNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${channelname}    ${preChannelname}
    \    ${channelIdValue}=    Get From Dictionary    ${channellist}    ${channelNameList[${i}]}
    \    Run Keyword If    ${status}    Close Conversations By ChannelId    ${channelIdValue}
    \    Run Keyword If    ${status}    Delete Channel    ${channelIdValue}

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
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    #添加坐席到技能组
    ${resp}=    /v1/AgentQueue/{queueId}/AgentUser    ${agent}    ${j['queueId']}    ${agentslist}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}
    @{agentslist}    create list    ${empty}
    set global variable    @{agentslist}

Close Valid New Session
    [Arguments]    ${agent}    ${rest}    ${originType}    ${maxcount}=200
    : FOR    ${i}    IN RANGE    ${maxcount}
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${agent.tenantId}-${i}-${curTime}    originType=${originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${guestentity.originType}"}}
    \    Send Message    ${rest}    ${guestentity}    ${msgentity}
    \    sleep    200ms
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
    \    Agent Send Message    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}    ${AgentMsgEntity}
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
    :FOR    ${i}    IN RANGE    ${maxcount}
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
    :FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${agent}    ${i['userWaitQueueId']}
    \    sleep    50ms
    sleep    1
    #坐席回复消息并发送邀请评价
    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    :FOR    ${i}    IN    @{j}
    \    ${curTime}    get time    epoch
    \    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    \    Agent Send Message    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}    ${AgentMsgEntity}
    \    sleep    50ms
    \    Send InviteEnquiry    ${agent}    ${i['serviceSessionId']}
    \    sleep    50ms
    sleep    1
    #访客发送评价
    :FOR    ${i}    IN    @{guestlist}
    \    log    ${i}
    \    set to dictionary    ${msgentity}    msg=5
    \    Send Message    ${rest}    ${i}    ${msgentity}
    \    sleep    200ms
    sleep    1
    #关闭进行中会话
    :FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${agent}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms
