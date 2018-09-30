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
    [Documentation]    获取呼叫中心信息
    ${resp}=    /v1/tenants/{tenantId}/phone-tech-channel    ${agent}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取呼叫中心信息，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Get Agent Phone Data
    [Arguments]    ${agent}
    [Documentation]    获取单个坐席呼叫中心配置属性
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs    ${agent}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取单个坐席呼叫中心配置属性，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}
    