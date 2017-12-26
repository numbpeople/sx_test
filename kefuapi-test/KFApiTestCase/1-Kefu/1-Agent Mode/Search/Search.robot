*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Search/Search_Common.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot

*** Test Cases ***
获取坐席模式下会话记录(/v1/Tenant/me/ServiceSessionHistorys)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建结束的会话
    ${session}    Create Terminal Conversation
    ${msg}    set variable    ${session.msg.msg}
    #获取会话搜索记录
    set to dictionary    ${filter}    isAgent=true    message=${msg}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    坐席模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    坐席模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    坐席模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['messageDetail']}    ${msg}    坐席模式历史会话的messageDetail不正确：${j}
