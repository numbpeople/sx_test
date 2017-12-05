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
    [Arguments]    ${method}    ${agent}    ${filter}    ${range}
    [Documentation]    导出自己的历史会话数据
    ...
    ...    Arguments：
    ...
    ...    ${method} | ${agent} | ${filter} | ${date}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #导出自己的历史会话数据
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles    ${method}    ${agent}    ${timeout}    ${filter}    ${range}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}:${resp.text}
