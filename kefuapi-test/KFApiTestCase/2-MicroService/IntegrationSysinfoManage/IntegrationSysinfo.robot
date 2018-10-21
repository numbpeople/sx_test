*** Settings ***
Force Tags        integrationSysinfo
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../api/MicroService/IntegrationSysinfoManage/CheckisnewuserApi.robot
Resource          ../../../api/MicroService/IntegrationSysinfoManage/GrowingIOApi.robot
Resource          ../../../AgentRes.robot

*** Test Cases ***
获取版本更新信息(/v1/tenants/{tenantId}/agents/{agentId}/news/latest)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取版本更新信息，调用接口：/v1/tenants/{tenantId}/agents/{agentId}/news/latest，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/news/latest    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    ${status}    Run Keyword And Return Status    Should Not Be Empty    ${j['entity']['content']}    获取版本更新信息不正确：${resp.content}
    #断言结果是None或者不为空
    Should Be True    ('${j['entity']['content']}' == 'None') or ${status}

获取新手任务信息(/v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取新手任务信息，调用接口：/v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取新手任务信息不正确：${resp.content}
