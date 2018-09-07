*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/WebhookApi.robot

*** Test Cases ***
获取回调(/tenants/{tenantId}/webhook)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【自定义事件回调】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取回调配置信息，调用接口：/tenants/{tenantId}/webhook，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    ${resp}=    /tenants/{tenantId}/webhook    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
