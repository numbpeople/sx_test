*** Settings ***
Force Tags
Resource          ../../../AgentRes.robot
Resource          ../../../commons/agent common/Customers/Customers_Common.robot
Resource          ../../../commons/agent common/Conversations/Conversations_Common.robot

*** Test Cases ***
获取访客的黑名单列表(/v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客黑名单列表
    ${j}    Get Visitor Blacklists    ${AdminUser}    ${sessionInfo.userId}
    Should Be Equal    ${j['status']}    OK    获取接口返回status不是OK: ${j}

获取会话的会话标签信息(/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客黑名单列表
    ${j}    Get ServiceSessionSummaryResults    ${AdminUser}    ${sessionInfo.userId}
    should be equal    '${j}'    '[]'    获取接口返回结果不正确: ${j}

获取会话的会话备注信息(/tenants/{tenantId}/serviceSessions/{serviceSessionId}/comment)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客黑名单列表
    ${j}    Get Comment    ${AdminUser}    ${sessionInfo.sessionServiceId}
    run keyword if    ${j} == {}    Pass Execution    会话没有会话备注信息
    run keyword if    ${j} != {}    Should Be Equal    ${j['serviceSessionId']}    ${data}    获取接口返回会话id不正确: ${j}

标记消息为已读(/v1/tenants/{tenantId}/sessions/{serviceSessionId}/messages/read)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #标记消息为已读
    ${data}    set variable    lastSeqId=0
    ${j}    Read Message    ${AdminUser}    ${sessionInfo.sessionServiceId}    ${data}
    ${state}    Run Keyword And Return Status    Should Be True    '${j}' == 'True' or '${j}' == 'False'
    should be true    ${state}    获取接口返回结果不正确: ${j}
