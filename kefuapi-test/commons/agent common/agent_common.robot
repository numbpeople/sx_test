*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../api/KefuApi.robot
Resource          ../../api/RoutingApi.robot
Resource          ../../api/SystemSwitch.robot

*** Keywords ***
Access Conversation
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    手动从待接入接入会话
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #根据查询结果接入会话
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/{waitingId}    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Processing Conversation
    [Arguments]    ${agent}
    [Documentation]    获取进行中的所有会话
    ...
    ...    Arguments：
    ...
    ...    ${agent}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查询进行中会话是否有该访客
    :FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Agents/me/Visitors    ${agent}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    ${listlength}    Get Length    ${j}
    \    Exit For Loop If    ${listlength} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}

Get Attribute
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    获取会话的attribute的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查看attribute是否调用成功
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessions}/attributes    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Track
    [Arguments]    ${agent}    ${servicesessionid}
    [Documentation]    获取会话的track的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查看track是否调用成功
    ${resp}=    /v1/integration/tenants/{tenantId}/servicesessions/{serviceSessions}/tracks    ${agent}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Single Visitor
    [Arguments]    ${agent}    ${userid}
    [Documentation]    获取单个访客的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${userid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查询访客会话信息是否正确
    ${resp}=    /v1/Tenant/VisitorUsers/{visitorUserId}    ${agent}    ${userid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Messages
    [Arguments]    ${agent}    ${chatgroupid}    ${msgfilter}
    [Documentation]    获取会话的所有消息信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${chatgroupid} | ${msgfilter}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查询访客历史消息是否正确
    ${resp}=    /v1/Tenant/me/ChatGroup/{ChatGroupId}/Messages    ${agent}    ${chatgroupid}    ${msgfilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Stop Processing Conversation
    [Arguments]    ${agent}    ${visitoruserid}    ${servicesessionid}
    [Documentation]    手动结束进行中的会话
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${visitoruserid} | ${servicesessionid}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #关闭会话
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop    ${agent}    ${visitoruserid}    ${servicesessionid}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${resp.content}    true    会话关闭失败：${resp.content}

Get Admin Customers
    [Arguments]    ${agent}    ${filter}    ${date}
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
    [Arguments]    ${agent}    ${filter}    ${date}
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
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}

Agent Send Message
    [Arguments]    ${agent}    ${visitoruserid}    ${servicesessionid}    ${msg}
    [Documentation]    坐席发送消息给访客
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${visitoruserid} | ${servicesessionid} | ${msg}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #坐席发送消息
    ${resp}=    /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages    ${agent}    ${visitoruserid}    ${servicesessionid}    ${msg}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
