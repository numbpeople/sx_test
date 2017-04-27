*** Settings ***
Suite Setup
Force Tags        tool
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../AgentRes.robot
Resource          ../api/KefuApi.robot
Resource          ../commons/admin common/BaseKeyword.robot
Library           uuid
Resource          ../api/RoutingApi.robot
Resource          ../commons/admin common/admin_common.robot
Resource          ../commons/agent common/agent_common.robot
Library           OperatingSystem

*** Test Cases ***
批量删除技能组
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

批量删除坐席
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

批量删除关联
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

批量创建待接入
    set test variable    ${originType}    webim
    : FOR    ${t}    IN RANGE    3000
    \    ${curTime}    get time    epoch
    \    set to dictionary    ${MsgEntity}    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}"}}
    \    #set to dictionary    ${MsgEntity}    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"agentUsername":"0222test1@t.com"}}
    \    set to dictionary    ${GuestEntity}    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    \    #1.发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    \    ${resp}=    send msg    ${RestEntity}    ${GuestEntity}    ${MsgEntity}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    ${j}    to json    ${resp.content}
    \    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    \    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}    originType=${GuestEntity.originType}
    \    set test variable    ${FilterEntity}    ${FilterEntity}
    \    sleep    300ms

批量创建会话、接入并关闭
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    : FOR    ${i}    IN RANGE    200
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}-${curTime}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN RANGE    ${j['total_entries']}
    \    Access Conversation    ${AdminUser}    ${j['items'][${i}]['userWaitQueueId']}
    \    sleep    50ms
    sleep    1s
    #关闭进行中会话
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${AdminUser}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms
