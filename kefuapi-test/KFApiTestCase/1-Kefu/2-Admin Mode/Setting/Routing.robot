*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/MicroService/Webapp/OutDateApi.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot

*** Test Cases ***
获取是否入口指定优先(/tenants/{tenantId}/options/userSpecifiedQueueId)
    [Tags]    unused
    log    ${easemobtechchannel}
    log    ${targetchannel}
    ${resp}=    /tenants/{tenantId}/options/userSpecifiedQueueId    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${userSpecifiedQueueIdJson}
    set to dictionary    ${temp}    tenantId=${AdminUser.tenantId}
    ${r}=    userSpecifiedQueueIdJsonDiff    ${temp}    ${j['data'][0]}
    Should Be True    ${r['ValidJson']}    获取是否入口指定优先信息失败：${r}
    set global variable    ${userSpecifiedQueueIdJson}    ${j['data'][0]}
