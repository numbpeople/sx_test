*** Settings ***
Force Tags        businessHours
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Setting/Business-Hours_Common.robot

*** Test Cases ***
获取所有的时间计划(/v1/tenants/{tenantId}/timeplans/schedules)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取所有的时间计划，调用接口：/v1/tenants/{tenantId}/timeplans/schedules，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值中status字段等于OK。
    #获取时间计划
    ${j}=    Business hours    ${AdminUser}
    should be equal    ${j['status']}    OK
    #将返回的时间列表设置为全局变量
    set global variable    ${timePlanSchedulesIds}    ${j}

获取工作日设置(/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/weekdays)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作日设置，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/weekdays，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值中status字段等于OK。
    #使用第一个时间计划数据
    ${scheduleId}    set variable    ${timePlanSchedulesIds['entities'][0]['scheduleId']}
    #根据时间计划获取工作日设置
    ${j}=    Workdays    ${AdminUser}    ${scheduleId}
    should be equal    ${j['status']}    OK

获取自定义工作日设置(/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取自定义工作日设置，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值中status字段等于OK。
    #使用第一个时间计划数据
    ${scheduleId}    set variable    ${timePlanSchedulesIds['entities'][0]['scheduleId']}
    #根据时间计划获取自定义工作设置
    ${j}=    Custom Workdays    ${AdminUser}    ${scheduleId}
    should be equal    ${j['status']}    OK

获取节假日设置(/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取节假日设置，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值中status字段等于OK。
    #使用第一个时间计划数据
    ${scheduleId}    set variable    ${timePlanSchedulesIds['entities'][0]['scheduleId']}
    #根据时间计划获取节假日设置
    ${j}=    Holidays    ${AdminUser}    ${scheduleId}
    should be equal    ${j['status']}    OK
