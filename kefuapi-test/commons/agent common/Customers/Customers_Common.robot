*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/KefuApi.robot
Resource          ../../../api/RoutingApi.robot

*** Keywords ***
Get Admin Customers
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}=10
    [Documentation]    获取管理模式下访客的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${filter} | ${date}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #获取管理员模式下客户中心
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/crm/tenants/{tenantId}/customers    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['numberOfElements']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}

Get Agent Customers
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}=10
    [Documentation]    获取坐席模式下访客的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${filter} | ${date}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #获取客服模式下客户中心
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/crm/tenants/{tenantId}/agents/{agentId}/customers    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['numberOfElements']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}
