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
Library           jsonschema
Library           urllib

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
    ...    endDateTime=${sec2}000    beginDate=${yyyy}-${mm}-01T00%3A00%3A00.000Z    endDate=${yyyy}-${mm}-${mr[1]}T23%3A59%3A59.000Z
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
