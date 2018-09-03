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
    ${resp}=    /tenants/{tenantId}/webhook    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
