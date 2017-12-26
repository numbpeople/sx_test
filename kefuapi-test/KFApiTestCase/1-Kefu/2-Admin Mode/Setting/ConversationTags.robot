*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/ConversationTagApi.robot

*** Test Cases ***
获取所有会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree)
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree    ${AdminUser}    0    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j[0]['children']}    会话标签为空
