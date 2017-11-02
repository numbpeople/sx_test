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
    [Documentation]    获取时间计划列表，并取默认时间的${scheduleId}作为全局变量
    #获取时间计划列表
    ${j}=    Business hours    ${AdminUser}
    ${scheduleId}    set variable    ${j['entities'][0]['scheduleId']}
    set global variable    ${timeScheduleId}    ${scheduleId}

Set Roles
    [Arguments]    ${method}    ${data}
    [Documentation]    获取权限列表
    #获取权限列表
    ${resp}=    /v1/permission/tenants/{tenantId}/roles    ${AdminUser}    ${timeout}    ${method}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Delete Roles
    [Arguments]    ${roleId}
    [Documentation]    获取权限列表
    #获取权限列表
    ${resp}=    /v1/permission/tenants/{tenantId}/roles/{roleId}    ${AdminUser}    ${timeout}    ${roleId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Resource Categories
    [Documentation]    获取权限列表
    #获取权限列表
    ${resp}=    /v1/permission/tenants/{tenantId}/users/{userId}/resource_categories    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Set Resource Categories Via RoleId
    [Arguments]    ${method}    ${roleId}    ${data}
    [Documentation]    根据roleId设置菜单
    #根据roleId设置菜单
    ${resp}=    /v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories    ${AdminUser}    ${timeout}    ${method}    ${roleId}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Clear Roles
    [Documentation]    清除包含指定关键字的角色
    #设置技能组名称模板
    ${preRoleName}=    convert to string    ${AdminUser.tenantId}
    #获取角色列表
    ${j}    Set Roles    get    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #循环删除包含${preRoleName}的角色
    :FOR    ${i}    IN    @{j['entities']}
    \    ${roleName}=    convert to string    ${i['role_name']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${roleName}    ${preRoleName}
    \    Run Keyword If    '${status}' == 'True'    Delete Roles    ${i['role_id']}
