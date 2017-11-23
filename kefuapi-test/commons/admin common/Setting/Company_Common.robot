*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/MicroService/Webapp/InitApi.robot

*** Keywords ***
Get ExpireInfo
    [Arguments]    ${agent}
    [Documentation]    查询租户是否到期
    #查询租户是否到期
    ${resp}=    /v1/tenants/{tenantId}/expire_info    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
