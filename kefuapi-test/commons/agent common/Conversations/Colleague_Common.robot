*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/MicroService/Webapp/InitApi.robot
Resource          ../../../api/BaseApi/Conversations/ColleagueApi.robot

*** Keywords ***
Set Agent StatusOrMaxServiceUserNumber
    [Arguments]    ${agent}
    [Documentation]    客服设置状态&接待数
    #客服设置状态&接待数
    ${resp}=    /v1/Agents/{agentId}    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Colleagues
    [Arguments]    ${agent}
    [Documentation]    获取同事列表
    #获取同事列表
    ${resp}=    /v1/Agents/{AdminUserId}/Agents    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Set Agent Status
    [Arguments]    ${agent}    ${status}
    [Documentation]    客服设置状态
    ${postdata}    set variable    {"agent_status":"${status}"}
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/status    ${agent}    ${postdata}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Set Agent MaxServiceUserNumber
    [Arguments]    ${agent}    ${MaxServiceUserNumber}
    [Documentation]    客服设置最大接待数
    ${postdata}    set variable    {"number":${MaxServiceUserNumber}}
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/max-service-number    ${agent}    ${postdata}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Agent Status&MaxServiceUserNumber
    [Arguments]    ${agent}
    [Documentation]    获取客服状态&最大接待数
    ${resp}=    /v1/Agents/me    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}
