*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/MicroService/Permission/PermissionApi.robot

*** Test Cases ***
获取客服权限(/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服权限，调用接口：/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    ${resp}=    /v1/permission/tenants/{tenantId}/users/{userId}/resource_categories    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    不正确的返回值：${j}
