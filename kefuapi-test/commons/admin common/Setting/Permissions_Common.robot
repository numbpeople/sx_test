*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/PermissionApi.robot

*** Keywords ***
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
    : FOR    ${i}    IN    @{j['entities']}
    \    ${roleName}=    convert to string    ${i['role_name']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${roleName}    ${preRoleName}
    \    Run Keyword If    '${status}' == 'True'    Delete Roles    ${i['role_id']}
