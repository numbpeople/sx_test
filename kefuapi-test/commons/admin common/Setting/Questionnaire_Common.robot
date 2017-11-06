*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/KefuApi.robot
Resource          ../../../api/RoutingApi.robot
Resource          ../../../api/SystemSwitch.robot
Resource          ../../../api/SessionCurrentApi.robot
Resource          ../../../api/SettingsApi.robot
Resource          ../../../api/WebimChannels.robot

*** Keywords ***
Set Questionnaire
    [Arguments]    ${agent}    ${method}    ${data}
    [Documentation]    操作问卷调查，包括增删查
    #操作问卷调查
    ${resp}=    /v1/tenants/{tenantId}/questionnaires/accounts    ${AdminUser}    ${timeout}    ${method}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Questionnaires List
    [Arguments]    ${type}
    [Documentation]    \#获取问卷调查列表
    #获取问卷调查列表
    ${resp}=    /v1/tenants/{tenantId}/questionnaires/list    ${AdminUser}    ${timeout}    ${type}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
