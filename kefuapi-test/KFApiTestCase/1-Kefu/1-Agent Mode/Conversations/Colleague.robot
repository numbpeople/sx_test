*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Colleague_Common.robot

*** Test Cases ***
获取当前客服列表(/v1/Agents/{AdminUserId}/Agents)
    #获取同事列表
    ${j}    Get Colleagues    ${AdminUser}
    Run Keyword If    ${j}==[]    Fail    租户下仅有一个Admin坐席来测试？需要确认，如有只有一个，忽略case：${j}
    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取同事列表失败，返回值中tenantId不正确:${j}

客服设置状态(/v1/tenants/{tenantId}/agents/{agentId}/status)
    : FOR    ${s}    IN    @{kefustatus}
    \    ${j}    Set Agent Status    ${AdminUser}    ${s}
    \    Should Be Equal    ${j['status']}    OK    设置状态失败：${j}
    \    ${j}    Get Agent Status&MaxServiceUserNumber    ${AdminUser}
    \    Should Be Equal    ${j['status']}    ${s}    设置状态不正确：${j}

客服设置最大接待数(/v1/tenants/{tenantId}/agents/{agentId}/max-service-number)
    @{numlist}    create list    ${1}    ${2}
    : FOR    ${i}    IN    @{numlist}
    \    ${j}    Set Agent MaxServiceUserNumber    ${AdminUser}    ${i}
    \    Should Be Equal    ${j['status']}    OK    设置最大接待数失败：${j}
    \    ${j}    Get Agent Status&MaxServiceUserNumber    ${AdminUser}
    \    Should Be Equal    ${j['maxServiceUserNumber']}    ${i}    设置最大接待数不正确：${j}
