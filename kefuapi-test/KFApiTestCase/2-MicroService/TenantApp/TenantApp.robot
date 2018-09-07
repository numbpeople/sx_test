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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服App登录IMSDK的账号和密码，调用接口：/v1/tenantapp/imUser，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    ${resp}=    /v1/tenantapp/imUser    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j['appKey']}    appkey为空
