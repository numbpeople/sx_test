*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/KefuApi.robot

*** Test Cases ***
关闭待接入列表search出的指定访客
    [Documentation]    关闭待接入中search出来的访客，历史会话中查询（坐席模式无该会话，管理员模式应该有该会话），访客中心中查询（坐席模式无该访客，管理员模式应该有该访客），首页统计查询（新进会话数不增加，消息数增加）
    log    ${RestEntity}
    set test variable    ${originType}    weixin
    ${curTime}    get time    epoch
    set to dictionary    ${MsgEntity}    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}"}}
    set to dictionary    ${GuestEntity}    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #查询今日会话数和今日消息数
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${todayNewsession}    Convert To Integer    ${resp.content}
    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${todayMsgCount}=    Convert To Integer    ${resp.content}
    #1.发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    ${resp}=    send msg    ${RestEntity}    ${GuestEntity}    ${MsgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}    originType=${GuestEntity.originType}
    set test variable    ${FilterEntity}    ${FilterEntity}
    #3.根据访客昵称查询待接入列表（每3秒一次，最多查询3次）
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${GuestEntity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${RestEntity.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #4.根据查询结果关闭待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    #获取管理员模式下客户中心
    set to dictionary    ${FilterEntity}    page=0
    : FOR    ${i}    IN RANGE    ${retryTimes}
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
    Should Be True    ${j['numberOfElements']} ==0    访客中心人数不正确：${resp.content}
    #5.根据访客昵称查询待接入列表是否已无该访客（每3秒一次，最多查询3次）
    set to dictionary    ${FilterEntity}    page=1
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==0
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==0    会话未关闭：${resp.content}
    #6.管理员模式下查询该访客的会话
    set to dictionary    ${FilterEntity}    isAgent=false
    set test variable    ${FilterEntity}    ${FilterEntity}
    : FOR    ${i}    IN RANGE    ${retryTimes}
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
    Should Be True    ${j['total_entries']} ==0    坐席模式历史会话查询到该会话：${resp.content}
    #查询今日会话数和今日消息数
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    Exit For Loop If    ${resp.content} >${todayMsgCount}
    \    sleep    ${delay}
    Should Be True    ${resp.content} >${todayMsgCount}    今日消息不正确：测试前消息数(${resp.content})，测试后消息数(${todayMsgCount})
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content} ==${todayNewsession}    今日新进会话数不正确：测试会话数(${resp.content})，测试后会话数(${todayNewsession})

批量创建待接入
    [Documentation]    关闭待接入中search出来的访客，历史会话中查询（坐席模式无该会话，管理员模式应该有该会话），访客中心中查询（坐席模式无该访客，管理员模式应该有该访客），质检中查询
    [Tags]    batch
    set test variable    ${originType}    webim
    : FOR    ${t}    IN RANGE    20
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
