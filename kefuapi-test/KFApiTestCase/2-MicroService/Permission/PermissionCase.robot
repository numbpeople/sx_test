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
    ${resp}=    /v1/permission/tenants/{tenantId}/users/{userId}/resource_categories    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    不正确的返回值：${j}
