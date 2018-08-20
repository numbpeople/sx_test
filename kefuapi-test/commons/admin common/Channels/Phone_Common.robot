*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           ../../../lib/KefuUtils.py
Resource          ../../../api/BaseApi/Channels/PhoneApi.robot

*** Keywords ***
Get PhoneTechChannel
    [Arguments]    ${agent}
    ${resp}=    /v1/tenants/{tenantId}/phone-tech-channel    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Agent Phone Data
    [Arguments]    ${agent}
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}
    