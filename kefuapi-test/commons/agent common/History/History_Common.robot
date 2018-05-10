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
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles    ${method}    ${agent}    ${timeout}    ${filter}    ${range}    ${userId}    ${language}
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