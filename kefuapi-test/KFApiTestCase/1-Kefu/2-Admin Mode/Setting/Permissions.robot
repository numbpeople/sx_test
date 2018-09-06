*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Setting/Permissions_Common.robot

*** Test Cases ***
获取权限角色列表(/v1/permission/tenants/{tenantId}/roles)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取权限角色列表，调用接口：/v1/permission/tenants/{tenantId}/roles，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为、status字段值等于OK、其他各字段值等于预期值。
    #获取角色列表
    ${j}    Set Roles    get    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entities'][0]['role_name']}    admin    返回值中role_name不正确: ${j}
    should be equal    ${j['entities'][0]['role_type']}    SYSTEM    返回值中role_type不正确: ${j}
    should be equal    ${j['entities'][0]['role_description']}    管理员    返回值中role_description不正确: ${j}
    should be equal    ${j['entities'][1]['role_name']}    agent    返回值中role_name不正确: ${j}
    should be equal    ${j['entities'][1]['role_description']}    座席    返回值中role_description不正确: ${j}
    should be equal    ${j['entities'][0]['status']}    ENABLE    返回值中status不正确: ${j}

获取权限菜单列表(/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取权限菜单列表，调用接口：/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为、status字段值等于OK、其他各字段值等于预期值。
    #获取菜单列表
    ${j}    Get Resource Categories
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['user_id']}    ${AdminUser.userId}    返回值中user_id不正确: ${j}

新增权限角色(/v1/permission/tenants/{tenantId}/roles)
    [Documentation]    【操作步骤】：
    ...    - Step1、新增权限角色，调用接口：/v1/permission/tenants/{tenantId}/roles，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为、status字段值等于OK、其他各字段值等于预期值。
    #新增角色
    ${uuid}    Uuid 4
    ${role_name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"role_name":"${role_name}"}
    ${j}    Set Roles    post    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['role_name']}    ${role_name}    返回值中role_name不正确: ${j}
    should be equal    ${j['entity']['role_type']}    CUSTOMIZED    返回值中role_type不正确: ${j}
    should be equal    ${j['entity']['status']}    ENABLE    返回值中status不正确: ${j}

根据roleId查询菜单(/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories)
    [Documentation]    【操作步骤】：
    ...    - Step1、新增权限角色，调用接口：/v1/permission/tenants/{tenantId}/roles，接口请求状态码为200。
    ...    - Step2、根据roleId查询菜单，调用接口：/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为、status字段值等于OK。
    #新增角色
    ${uuid}    Uuid 4
    ${role_name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"role_name":"${role_name}"}
    ${j}    Set Roles    post    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['role_name']}    ${role_name}    返回值中role_name不正确: ${j}
    should be equal    ${j['entity']['role_type']}    CUSTOMIZED    返回值中role_type不正确: ${j}
    should be equal    ${j['entity']['status']}    ENABLE    返回值中status不正确: ${j}
    #根据roleId设置菜单
    ${j}    Set Resource Categories Via RoleId    get    ${j['entity']['role_id']}    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

添加角色的菜单权限(/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories)
    [Documentation]    【操作步骤】：
    ...    - Step1、新增权限角色，调用接口：/v1/permission/tenants/{tenantId}/roles，接口请求状态码为200。
    ...    - Step2、添加角色的菜单权限，调用接口：/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为、status字段值等于OK。
    #新增角色
    ${uuid}    Uuid 4
    ${role_name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"role_name":"${role_name}"}
    ${j}    Set Roles    post    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['role_name']}    ${role_name}    返回值中role_name不正确: ${j}
    should be equal    ${j['entity']['role_type']}    CUSTOMIZED    返回值中role_type不正确: ${j}
    should be equal    ${j['entity']['status']}    ENABLE    返回值中status不正确: ${j}
    #根据roleId设置菜单
    ${data}    set variable    {"resource_categories":["agent_currentsession"]}
    ${j}    Set Resource Categories Via RoleId    post    ${j['entity']['role_id']}    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
