*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Queue/WaitApi.robot

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
