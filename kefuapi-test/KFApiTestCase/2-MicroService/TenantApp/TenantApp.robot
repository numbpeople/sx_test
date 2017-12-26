*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/MicroService/TenantApp/TenantAppApi.robot

*** Test Cases ***
获取客服App登录IMSDK的账号和密码(/v1/tenantapp/imUser)
    ${resp}=    /v1/tenantapp/imUser    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j['appKey']}    appkey为空
