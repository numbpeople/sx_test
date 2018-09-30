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
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取单点登录配置，包括增删查，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Get Access
    [Arguments]    ${agent}    ${path}=${EMPTY}
    [Documentation]    获取单点登录地址信息
    ${resp}=    /v1/access    ${agent}    ${path}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取单点登录地址信息，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}
