*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Supervision/AlarmRecordsApi.robot

*** Keywords ***
Get Monitor Alarms
    [Arguments]    ${agent}
    [Documentation]    获取告警记录列表
    #获取告警记录列表
    ${resp}=    /v1/monitor/alarms    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} ,${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}
