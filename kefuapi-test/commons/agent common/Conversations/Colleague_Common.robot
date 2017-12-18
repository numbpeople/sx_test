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
