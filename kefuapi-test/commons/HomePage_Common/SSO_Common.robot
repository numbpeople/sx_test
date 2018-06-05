*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../AgentRes.robot
Resource          ../../api/BaseApi/Settings/SingleSignOnApi.robot

*** Keywords ***
Get Access Config
    [Arguments]    ${agent}
    [Documentation]    获取单点登录配置
    ${resp}=    /v1/access/config    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get Access
    [Arguments]    ${agent}    ${path}=${EMPTY}
    [Documentation]    获取单点登录地址信息
    ${resp}=    /v1/access    ${agent}    ${path}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}
