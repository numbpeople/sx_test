*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Supervision/AlarmRecordsApi.robot
Resource          ../../Base Common/Base_Common.robot

*** Keywords ***
Get Monitor Alarms
    [Arguments]    ${agent}
    [Documentation]    获取告警记录列表
    #获取告警记录列表
    ${resp}=    /v1/monitor/alarms    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} ,${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Monitor Unreadalarmcount
    [Arguments]    ${agent}
    [Documentation]    获取告警记录未读数
    #获取告警记录未读数
    ${resp}=    /v1/monitor/unreadalarmcount    ${agent}    get    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取耳语消息，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Clear Monitor Unreadalarmcount
    [Arguments]    ${agent}
    [Documentation]    清空告警记录未读数
    #清空告警记录未读数
    ${resp}=    /v1/monitor/unreadalarmcount    ${agent}    put    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取耳语消息，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}
