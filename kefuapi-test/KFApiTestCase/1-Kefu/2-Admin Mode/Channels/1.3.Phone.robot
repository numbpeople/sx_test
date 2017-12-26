*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../api/BaseApi/Channels/PhoneApi.robot
Resource          ../../../../AgentRes.robot

*** Test Cases ***
获取callcenter属性(/v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs)
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    callcenter属性数据不正确：${resp.content}

获取呼叫中心信息(/v1/tenants/{tenantId}/phone-tech-channel)
    ${resp}=    /v1/tenants/{tenantId}/phone-tech-channel    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无呼叫中心信息
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    呼叫中心信息不正确：${resp.content}
