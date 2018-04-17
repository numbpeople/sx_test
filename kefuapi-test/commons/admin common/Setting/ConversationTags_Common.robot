*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/ConversationTagApi.robot

*** Keywords ***
Get Conversation Tags
    [Arguments]    ${method}    ${agent}    ${summaryId}    ${conversationTagEntity}
    [Documentation]    获取会话标签
    #获取会话标签
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree    ${method}    ${agent}    ${summaryId}    ${conversationTagEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Get Conversation TagId
    [Arguments]    @{ServiceSessionSummaryList}
    [Documentation]    获取标签中第一个根节点的叶子标签id值
    #设置初始值为0，代表租户下没有会话标签
    ${id}    set variable    0
    ${length}    get length    @{ServiceSessionSummaryList}
    return from Keyword if    ${length} == 0    ${id}
    #递归取数据中叶子节点的值
    : FOR    ${i}    IN    @{ServiceSessionSummaryList}
    \    set suite variable    ${id}    ${i[0]['id']}
    \    Exit For Loop If    ${i[0]['children']} is None
    \    Get Conversation TagId    ${i[0]['children']}
    return from keyword    ${id}
