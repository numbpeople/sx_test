*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot

*** Test Cases ***
获取坐席模式的历史会话数据(/v1/Tenant/me/ServiceSessionHistorys)
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    isAgent=true    visitorName=${session.userName}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    坐席模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    坐席模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    坐席模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    坐席模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    坐席模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    坐席模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    坐席模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    坐席模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    坐席模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    坐席模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    坐席模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    坐席模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    坐席模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    坐席模式历史会话enquirySummary值不正确：${j}
