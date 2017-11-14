*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/History/HistoryApi.robot

*** Test Cases ***
获取默认导出管理数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles    get    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['numberOfElements']} >= 0    导出管理数据不正确
