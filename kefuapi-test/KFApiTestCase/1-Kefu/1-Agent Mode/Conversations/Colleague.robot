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
客服设置状态&接待数(/v1/Agents/{agentId})
    #设置局部变量使用
    ${agent}    copy dictionary    ${AdminUser}
    #客服设置状态&接待数
    : FOR    ${s}    IN    @{kefustatus}
    \    set to dictionary    ${agent}    status    ${s}
    \    ${j}    Set Agent StatusOrMaxServiceUserNumber    ${agent}
    \    Should Be Equal    ${j['status']}    ${s}    设置状态失败：${j}

获取当前客服列表(/v1/Agents/{AdminUserId}/Agents)
    #获取同事列表
    ${j}    Get Colleagues    ${AdminUser}
    Run Keyword If    ${j}==[]    Fail    租户下仅有一个Admin坐席来测试？需要确认，如有只有一个，忽略case：${j}
    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取同事列表失败，返回值中tenantId不正确:${j}
