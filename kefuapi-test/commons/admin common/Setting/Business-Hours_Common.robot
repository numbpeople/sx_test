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
    [Documentation]    获取时间计划列表，并取默认时间的${scheduleId}作为全局变量
    #获取时间计划列表
    ${j}=    Business hours    ${AdminUser}
    ${scheduleId}    set variable    ${j['entities'][0]['scheduleId']}
    set global variable    ${timeScheduleId}    ${scheduleId}

Set Worktime
    [Arguments]    ${iswork}    ${weekend}    ${agent}
    [Documentation]    设置工作时间
    ...
    ...    Describtion：
    ...
    ...    参数：${iswork} | ${weekend} | ${agent}
    ...
    ...    ${iswork}代表是否上班， 值为on，则为上班，为off，则为下班
    ...
    ...    ${weekend}代表当前是礼拜几
    #获取上下班时间
    ${r1}    create list
    &{timePlanIds}=    create dictionary
    ${data}=    set variable    NULL
    ${resp}=    /v1/tenants/{tenantId}/timeplans    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    #存储timePlanId值
    ${listlength}=    Get Length    ${j['entities']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${day}=    convert to string    ${j['entities'][${i}]['day']}
    \    ${timePlanId}=    convert to integer    ${j['entities'][${i}]['timePlanId']}
    \    set to dictionary    ${timePlanIds}    ${day}=${timePlanId}
    log    ${timePlanIds}
    #修改工作时间为上班或者下班时间
    ${weekend}=    convert to string    ${weekend}
    ${keys}=    Get Dictionary Keys    ${timePlanIds}
    ${Values}=    Get Dictionary Values    ${timePlanIds}
    ${timePlanId}=    Get From Dictionary    ${timePlanIds}    ${weekend}
    Run Keyword If    '${iswork}' == 'on'    set test variable    ${data}    {"timePlans":[{"timePlanId":${timePlanId},"tenantId":${agent.tenantId},"day":"${weekend}","timePlanItems":[{"startTime":"00:00:00","stopTime":"23:59:59"}]}]}
    Run Keyword If    '${iswork}' == 'off'    set test variable    ${data}    {"timePlans":[]}
    ${resp}=    /v1/tenants/{tenantId}/timeplans    put    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

Set Worktime Ext
    [Arguments]    ${iswork}    ${agent}    ${scheduleId}
    [Documentation]    设置工作时间
    ...
    ...    Describtion：
    ...
    ...    参数：${iswork} | ${agent} | ${scheduleId}
    ...
    ...    ${iswork}代表是否上班， 值为on，则为上班，为off，则为下班
    ...
    ...    ${scheduleId}代表哪个时间计划
    #设置上下班的时间
    Run Keyword If    '${iswork}' == 'on'    Set Work Day    ${agent}    ${scheduleId}
    Run Keyword If    '${iswork}' == 'off'    Set Non-work Day    ${agent}    ${scheduleId}
