*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Search/Search_Api.robot

*** Test Cases ***
获取搜索默认信息(/v1/tenants/{tenantId}/searchrecords)
    ${resp}=    /v1/tenants/{tenantId}/searchrecords    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    搜索默认信息不正确：${resp.content}
