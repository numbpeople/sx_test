*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/MicroService/Webapp/InitApi.robot
Resource          ../../../../api/BaseApi/Conversations/ColleagueApi.robot

*** Test Cases ***
客服设置状态&接待数(/v1/Agents/{agentId})
    : FOR    ${s}    IN    @{kefustatus}
    \    set to dictionary    ${AdminUser}    status    ${s}
    \    ${resp}=    /v1/Agents/{agentId}    ${AdminUser}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    ${j}    to json    ${resp.content}
    \    Should Be Equal    ${j['status']}    ${s}    设置状态失败：${resp.status_code}

获取当前客服列表(/v1/Agents/{AdminUserId}/Agents)
    ${resp}=    /v1/Agents/{AdminUserId}/Agents    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无同事
    ...    ELSE    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取同事列表失败:${resp.content}
