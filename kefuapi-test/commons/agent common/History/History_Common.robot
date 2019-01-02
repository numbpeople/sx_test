*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/History/HistoryApi.robot

*** Keywords ***
Get History
    [Arguments]    ${agent}    ${filter}    ${date}
    [Documentation]    获取历史会话的会话信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${filter} | ${date}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #管理员模式下查询该访客的历史会话
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    \    ${j}    to json    ${resp.text}
    \    Exit For Loop If    ${j['total_entries']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}

Export My History
    [Arguments]    ${method}    ${agent}    ${filter}    ${range}    ${userId}=    ${language}=en-US
    [Documentation]    导出自己的历史会话数据
    ...
    ...    Arguments：
    ...
    ...    ${method} | ${agent} | ${filter} | ${date} | ${language}:值为en-US或zh-CN
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #导出自己的历史会话数据
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles    ${method}    ${agent}    ${timeout}    ${filter}    ${range}
    ...    ${userId}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}:${resp.text}

Agent CallingBack Conversation
    [Arguments]    ${agent}    ${visitorUserId}
    [Documentation]    历史会话回呼会话
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${visitorUserId}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #历史会话回呼会话
    ${resp}=    /v6/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/{visitorUserId}/CreateServiceSession    ${agent}    ${visitorUserId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Check Agent History Detail
    [Arguments]    ${agent}    ${j}    ${session}
    [Documentation]    判断坐席模式下历史会话接口返回字段值
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${agent.tenantId}    坐席模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    坐席模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${agent.userId}    坐席模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    坐席模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    坐席模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    坐席模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    坐席模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    坐席模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    坐席模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    坐席模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    坐席模式历史会话transfered值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    坐席模式历史会话enquirySummary值不正确：${j}

Check Agent History Transfered Detail
    [Arguments]    ${agent}    ${j}    ${session}
    [Documentation]    判断坐席模式下历史会话，转接类型会话中接口返回字段值
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话不是唯一：${j}
    Should Be True    ${j['items'][0]['transfered']}    坐席模式历史会话transfered值不正确：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${agent.tenantId}    坐席模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    坐席模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${agent.userId}    坐席模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    坐席模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    坐席模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    坐席模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    坐席模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    坐席模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    坐席模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    坐席模式历史会话fromAgentCallback值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    坐席模式历史会话enquirySummary值不正确：${j}
