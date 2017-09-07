*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../api/KefuApi.robot
Resource          ../../api/RoutingApi.robot
Resource          ../../api/SystemSwitch.robot
Resource          ../../api/SessionCurrentApi.robot
Resource          ../../api/SettingsApi.robot

*** Keywords ***
Business hours
    [Arguments]    ${agent}    ${method}=get    ${data}=
    [Documentation]    获取工作日列表
    #获取时间计划
    ${resp}=    /v1/tenants/{tenantId}/timeplans/schedules    ${AdminUser}    ${timeout}    ${method}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Workdays
    [Arguments]    ${agent}    ${scheduleId}    ${method}=get    ${data}=
    [Documentation]    \#根据时间计划获取工作日设置
    #根据时间计划获取工作日设置
    ${resp}=    /v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/weekdays    ${AdminUser}    ${timeout}    ${scheduleId}    ${method}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Custom Workdays
    [Arguments]    ${agent}    ${scheduleId}    ${method}=get    ${data}=
    [Documentation]    \#根据时间计划获取自定义工作日设置
    #根据时间计划获取自定义工作日设置
    ${resp}=    /v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes    ${AdminUser}    ${timeout}    ${scheduleId}    ${method}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Holidays
    [Arguments]    ${agent}    ${scheduleId}    ${method}=get    ${data}=
    [Documentation]    \#根据时间计划获取节假日设置
    #根据时间计划获取节假日设置
    ${resp}=    /v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays    ${AdminUser}    ${timeout}    ${scheduleId}    ${method}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get ScheduleId
    #获取时间计划列表
    ${j}=    Business hours    ${AdminUser}
    ${scheduleId}    set variable    ${j['entities'][0]['scheduleId']}
    set global variable    ${timeScheduleId}    ${scheduleId}
