*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/SessionCurrent/SessionCurrent_Api.robot

*** Test Cases ***
查询当前会话(/v1/tenants/{tenantId}/servicesessioncurrents)
    [Documentation]    【操作步骤】：
    ...    - Step1、管理员面板-查询当前会话数据，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    ${resp}=    /v1/tenants/{tenantId}/servicesessioncurrents    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    log    ${j}

查询指定状态的会话数(/v1/tenants/{tenantId}/processingsessions/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、查询指定状态的会话数，调用接口：/v1/tenants/{tenantId}/processingsessions/count，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，会话状态为Wait、Processing的请求状态码为200。
    @{SessionState}    create list    ${empty}    Wait    Processing
    : FOR    ${i}    IN    @{SessionState}
    \    ${resp}=    /v1/tenants/{tenantId}/processingsessions/count    ${AdminUser}    ${i}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    log    ${resp.content}
    \    ${j}    to json    ${resp.content}
    \    log    ${j}

获取当前会话信息(/v1/tenants/{tenantId}/servicesessioncurrents)
    [Documentation]    【操作步骤】：
    ...    - Step1、查询指定状态的会话数，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，会话状态为Processing,Resolved的请求状态码为200。
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set suite variable    ${filter.state}    Processing,Resolved
    set suite variable    ${filter.isAgent}    ${False}
    set suite variable    ${filter.username}    ${Empty}
    ${resp}=    /v1/tenants/{tenantId}/servicesessioncurrents    ${AdminUser}    ${filter}    ${range}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
