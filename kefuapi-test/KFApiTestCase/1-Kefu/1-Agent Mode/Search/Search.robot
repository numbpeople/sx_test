*** Settings ***
Force Tags        agentSearch
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
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、获取会话搜索记录，查询刚刚结束的会话访客消息，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，total_entries字段的值等于1，tenantId字段等于租户id，agentUserId字段等于接待的坐席Id，等等。
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
    Should Be Equal    ${j['items'][0]['agentUserNiceName']}    ${AdminUser.nicename}    坐席模式历史会话的昵称不正确：${j}
    Should Be Equal    ${j['items'][0]['messageDetail']}    ${msg}    坐席模式历史会话的messageDetail不正确：${j}
