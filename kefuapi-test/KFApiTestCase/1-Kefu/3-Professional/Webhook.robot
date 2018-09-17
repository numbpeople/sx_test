*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | showCallback | 自定义事件推送 | redis灰度租户 | 登录主redis机器上，执行：sadd kf:callback:enable 11699，命令来添加灰度 |
Default Tags      showCallback
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/WebhookApi.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取回调(/tenants/{tenantId}/webhook)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【自定义事件回调】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取回调配置信息，调用接口：/tenants/{tenantId}/webhook，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    ${resp}=    /tenants/{tenantId}/webhook    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
