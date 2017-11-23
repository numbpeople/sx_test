*** Settings ***
Force Tags
Resource          ../../../AgentRes.robot
Resource          ../../../commons/agent common/Conversations/Conversations_Common.robot

*** Test Cases ***
获取访客的黑名单列表(/v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客黑名单列表
    ${j}    Get EnquiryStatus    ${AdminUser}    ${sessionInfo.userId}
    Should Be Equal    ${j['status']}    OK    获取接口返回status不是OK: ${j}
    Should Be Equal    '${j['count']}'    '1'    获取接口返回count不是1: ${j}
