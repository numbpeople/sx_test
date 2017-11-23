*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Customers/Customers_Api.robot
Resource          ../../../api/MicroService/Webapp/WebappApi.robot

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

Get Visitor Tags
    [Arguments]    ${agent}    ${userId}
    [Documentation]    查询访客的客户标签信息
    #查询访客的客户标签信息
    ${resp}=    /v1/crm/tenants/{tenantId}/visitors/{visitorId}/tags    ${agent}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Filters
    [Arguments]    ${agent}
    [Documentation]    获取租户的客户的filters
    #获取租户的客户的filters
    ${resp}=    /v1/crm/tenants/{tenantId}/filters    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Visitor Filters
    [Arguments]    ${agent}    ${userId}
    [Documentation]    获取客户的filters
    #获取客户的filters
    ${resp}=    /v1/crm/tenants/{tenantId}/visitor/{visitorId}/filters    ${agent}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Visitor Blacklists
    [Arguments]    ${agent}    ${userId}
    [Documentation]    获取访客的黑名单列表
    #获取访客的黑名单列表
    ${resp}=    /v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists    ${agent}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
