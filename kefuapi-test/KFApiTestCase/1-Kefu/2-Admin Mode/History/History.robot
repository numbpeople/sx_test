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
获取默认历史会话数据(/v1/Tenant/me/ServiceSessionHistorys)
    log    ${DateRange}
    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} >= 0    历史会话数不正确
