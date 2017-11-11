*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          JsonDiff/KefuJsonDiff.robot
Library           uuid
Resource          commons/admin common/BaseKeyword.robot
Resource          api/BaseApi/SessionCurrent/SessionCurrent_Api.robot
Resource          tool/Tools-Resource.robot

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
