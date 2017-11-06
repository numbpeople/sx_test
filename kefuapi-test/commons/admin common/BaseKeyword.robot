*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/KefuApi.robot
Library           uuid
Library           urllib
Resource          Setting/Business-Hours_Common.robot

*** Keywords ***
InitFilterTime
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${yn}=    Convert To Integer    ${yyyy}
    ${mn}=    Convert To Integer    ${mm}
    ${dn}=    Convert To Integer    ${day}
    ${mr}=    Monthrange    ${yn}    ${mn}
    ${sec1}=    Get Time    epoch    ${yyyy}-${mm}-01 0:0:0
    ${sec2}=    Get Time    epoch    ${yyyy}-${mm}-${mr[1]} 23:59:59
    &{DR}=    create dictionary    beginMonthDateTime=${sec1}000    endMonthDateTime=${sec2}000    beginMonthDate=${yyyy}-${mm}-01T00%3A00%3A00.000Z    endMonthDate=${yyyy}-${mm}-${mr[1]}T23%3A59%3A59.000Z    beginDateTime=${sec1}000
    ...    endDateTime=${sec2}000    beginDate=${yyyy}-${mm}-01T00%3A00%3A00.000Z    endDate=${yyyy}-${mm}-${mr[1]}T23%3A59%3A59.000Z    stopDateFrom=${yyyy}-${mm}-01T00%3A00%3A00.000Z    stopDateTo=${yyyy}-${mm}-${mr[1]}T23%3A59%3A59.000Z
    Return From Keyword    &{DR}
    #set global variable    ${DateRange.beginMonthDateTime}    ${sec1}000
    #set global variable    ${DateRange.endMonthDateTime}    ${sec2}000
    #set global variable    ${DateRange.beginMonthDate}    ${yyyy}-${mm}-01T00%3A00%3A00.000Z
    #set global variable    ${DateRange.endMonthDate}    ${yyyy}-${mm}-${mr[1]}T23%3A59%3A59.000Z
    #周算法有问题，默认值暂时用月
    #set global variable    ${DateRange.beginDate}    ${DateRange.beginMonthDate}
    #set global variable    ${DateRange.endDate}    ${DateRange.endMonthDate}
    #set global variable    ${DateRange.beginDateTime}    ${DateRange.beginMonthDateTime}
    #set global variable    ${DateRange.endDateTime}    ${DateRange.endMonthDateTime}
    #${wn}=    weekday    ${yn}    ${mn}    ${dn}
    #${fown}=    Evaluate    ${dn}-1-${wn}
    #${lown}=    Evaluate    ${fown}+6
    #${fow}=    Evaluate    "%02d" % ${fown}
    #${low}=    Evaluate    "%02d" % ${lown}
    #set global variable    ${DateRange.beginWeekDate}    ${yyyy}-${mm}-${fow}T00%3A00%3A00.000Z
    #set global variable    ${DateRange.endWeekDate}    ${yyyy}-${mm}-${low}T23%3A59%3A59.000Z
    #${sec1}=    Get Time    epoch    ${yyyy}-${mm}-${fow} 0:0:0
    #${sec2}=    Get Time    epoch    ${yyyy}-${mm}-${low} 23:59:59
    #set global variable    ${DateRange.beginWeekDateTime}    ${sec1}000
    #set global variable    ${DateRange.endWeekDateTime}    ${sec2}000
    #set global variable    ${DateRange.beginDate}    ${DateRange.beginWeekDate}
    #set global variable    ${DateRange.endDate}    ${DateRange.endWeekDate}
    #set global variable    ${DateRange.beginDateTime}    ${DateRange.beginWeekDateTime}
    #set global variable    ${DateRange.endDateTime}    ${DateRange.endWeekDateTime}

Should Be Not Contain In JsonList
    [Arguments]    ${keyname}    ${diffvalue}    @{list}
    ${l}    Get Length    ${list}
    Return From Keyword If    ${l}==0    ${true}
    : FOR    ${a}    IN    @{list}
    \    Exit For Loop If    '${a${keyname}}'=='${diffvalue}'
    Return From Keyword If    '${a${keyname}}'=='${diffvalue}'    ${false}
    Return From Keyword If    '${a${keyname}}'!='${diffvalue}'    ${true}

Return QueueName From QueueList By QueueId
    [Arguments]    ${queueId}    @{list}
    log    ${queueId}__${list}
    : FOR    ${a}    IN    @{list}
    \    log    ${a}—@{list}
    \    Exit For Loop If    '${a['agentQueue']['queueId']}'=='${queueId}'
    Return From Keyword    ${a['agentQueue']['queueName']}

Return QueueId From QueueList By QueueName
    [Arguments]    ${queueName}    @{list}
    log    ${queueName}__${list}
    : FOR    ${a}    IN    @{list}
    \    log    ${a}—@{list}
    \    Exit For Loop If    '${a['agentQueue']['queueName']}'=='${queueName}'
    Return From Keyword    ${a['agentQueue']['queueId']}

Create Agent TxtMsg
    [Arguments]    ${msg}
    ${uuid}=    Uuid1
    Return From Keyword    {"msg":"${msg}","type":"txt","ext":{"weichat":{"msgId":"${uuid}","originType":null,"visitor":null,"agent":null,"queueId":null,"queueName":null,"agentUsername":null,"ctrlType":null,"ctrlArgs":null,"event":null,"metadata":null,"callcenter":null,"language":null,"service_session":null,"html_safe_body":{"type":"txt","msg":""},"msg_id_for_ack":null,"ack_for_msg_id":null}}}

Close All Session In Waitlist
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    #查询待接入总数
    set to dictionary    ${FilterEntity}    originType=${empty}    techChannelId=${empty}    techChannelType=${empty}    visitorName=${empty}
    set to dictionary    ${DateRange}    beginDate=${empty}    endDate=${empty}
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    log    ${j}

Close Conversations By ChannelId
    [Arguments]    ${techChannelId}    ${techChannelType}=easemob
    [Documentation]    根据channelId查找所有processing或wait的会话
    #查询会话
    set to dictionary    ${FilterEntity}    isAgent=false    techChannelId=${techChannelId}    techChannelType=${techChannelType}    state=Processing%2CWait    per_page=150
    ...    visitorName=${EMPTY}    sortField=startDateTime
    set to dictionary    ${DateRange}    beginDate=${EMPTY}    endDate=${EMPTY}
    #根据channelId查询会话
    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    ${listlength}=    set variable    ${j['total_entries']}
    Return From Keyword If    ${listlength} == 0
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${state}=    set variable    ${j['items'][${i}]['state']}
    \    ${serviceSessionId}=    set variable    ${j['items'][${i}]['serviceSessionId']}
    \    ${visitoruserid}=    set variable    ${j['items'][${i}]['visitorUser']['userId']}
    \    Close Conversation    ${state}    ${serviceSessionId}    ${visitoruserid}

Close Conversation
    [Arguments]    ${status}    ${sessionServiceId}    ${userId}
    [Documentation]    根据channelId查找所有processing或wait的会话
    #关闭processing或wait的会话
    Run Keyword If    '${status}' == 'Wait'    Close Waiting Conversation    ${sessionServiceId}
    Run Keyword If    '${status}' == 'Processing'    Close Processing Conversation    ${sessionServiceId}    ${userId}

Close Waiting Conversation
    [Arguments]    ${sessionServiceId}
    [Documentation]    关闭待接入的会话
    #清理待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}

Close Processing Conversation
    [Arguments]    ${sessionServiceId}    ${userId}
    [Documentation]    关闭processing的会话
    #关闭进行中会话
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop    ${AdminUser}    ${userId}    ${sessionServiceId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${resp.content}    true    会话关闭失败：${resp.content}

Search Waiting Conversation
    [Arguments]    ${agent}    ${filter}    ${date}
    [Documentation]    根据筛选条件查询待接入会话
    ...
    ...    Arguments：
    ...
    ...    ${AdminUser}、${FilterEntity}、${DateRange}
    ...
    ...    Return：
    ...
    ...    返回符合筛选的符合结果：resp
    #根据访客昵称查询待接入列表
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/search    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${resp}

Get Current Conversation
    [Arguments]    ${agent}    ${filter}    ${date}
    [Documentation]    获取当前会话，返回符合筛选条件的值并返回
    ...
    ...    Arguments：
    ...
    ...    ${AdminUser}、${FilterEntity}、${DateRange}
    ...
    ...    Return：
    ...
    ...    返回符合筛选的符合结果：resp
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/tenants/{tenantId}/servicesessioncurrents    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${resp}

Close Processing Conversations By SessionList
    [Arguments]    @{SessionList}
    [Documentation]    根据channelId查找所有processing或wait的会话
    : FOR    ${i}    IN RANGE    @{SessionList}
    \    Close Conversation    ${state}    ${i.serviceSessionId}    ${i.visitoruserid}

Get Appkey Token
    [Arguments]    ${session}    ${channelJson}
    [Documentation]    获取appkey的管理员token
    ...
    ...    Arguments：
    ...
    ...    ${session} 、${channelJson}
    ...
    ...    Return：
    ...
    ...    ${resp}
    #获取管理员的token
    ${resp1}    get token by credentials    restsession    ${channelJson}    ${timeout}
    ${j}    to json    ${resp1.content}
    Return From Keyword    ${j}

Send Message
    [Arguments]    ${rest}    ${guest}    ${msg}
    [Documentation]    模拟访客发送消息
    ...
    ...    Arguments：
    ...
    ...    ${restentity} ${guestentity} ${msgentity}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    ${resp}=    Send Msg    ${rest}    ${guest}    ${msg}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${rest.serviceEaseMobIMNumber}']}    success    发送消息失败

Get Current Weekend
    [Documentation]    获取当前日期是星期几
    #返回当前日期是星期几
    @{time} =    get time    year month day hour min sec
    ${r1}=    create list
    : FOR    ${i}    IN    @{time}
    \    ${r2}=    Convert To Integer    ${i}
    \    Append To List    ${r1}    ${r2}
    log    ${r1}
    ${weekday}=    Weekday    ${r1[0]}    ${r1[1]}    ${r1[2]}
    ${weekday}=    Convert To Integer    ${weekday}
    ${weekday}=    Evaluate    ${weekday}+1
    Return From Keyword    ${weekday}

Get Current Date
    [Documentation]    获取当前日期
    #返回当前日期
    @{time} =    get time    year month day
    ${s}    set variable    ${EMPTY}
    : FOR    ${i}    IN    @{time}
    \    ${s}    evaluate    '${s}-${i}'
    ${s}    Strip String    ${s}    mode=left    characters=-
    log    ${s}
    Return From Keyword    ${s}

Set Work Day
    [Arguments]    ${agent}    ${scheduleId}
    #设置自定义工作时间
    ${currentdate}    Get Current Date
    ${data}    set variable    [{"name":"自定义上班时间","beginDate":"${currentdate}","endDate":"${currentdate}","timePlanItems":[{"startTime":"00:00:00","stopTime":"23:59:59"}]}]
    ${j}=    Custom Workdays    ${agent}    ${scheduleId}    put    ${data}
    should be equal    ${j['status']}    OK
    #设置节假日时间为空，避免下班
    ${data1}    set variable    []
    ${j}=    Holidays    ${agent}    ${scheduleId}    put    ${data1}
    should be equal    ${j['status']}    OK

Set Non-work Day
    [Arguments]    ${agent}    ${scheduleId}
    #设置节假日时间为当日
    ${currentdate}    Get Current Date
    ${data}    set variable    [{"name":"今天放假","beginDate":"${currentdate}","endDate":"${currentdate}"}]
    ${j}=    Holidays    ${agent}    ${scheduleId}    put    ${data}
    should be equal    ${j['status']}    OK
