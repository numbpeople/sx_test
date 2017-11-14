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
    ${resp}=    /v1/tenants/{tenantId}/servicesessioncurrents    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    log    ${j}

查询指定状态的会话数(/v1/tenants/{tenantId}/processingsessions/count)
    : FOR    ${i}    IN    @{SessionState}
    \    ${resp}=    /v1/tenants/{tenantId}/processingsessions/count    ${AdminUser}    ${i}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    log    ${resp.content}
    \    ${j}    to json    ${resp.content}
    \    log    ${j}

获取当前会话信息(/v1/tenants/{tenantId}/servicesessioncurrents)
    set suite variable    ${FilterEntity.state}    Processing,Resolved
    set suite variable    ${FilterEntity.isAgent}    ${False}
    set suite variable    ${AgentEntity.username}    ${Empty}
    ${resp}=    /v1/tenants/{tenantId}/servicesessioncurrents    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']}>=0    获取当前会话数不正确：${resp.content}
