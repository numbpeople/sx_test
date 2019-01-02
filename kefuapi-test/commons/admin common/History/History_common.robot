*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/History/HistoryApi.robot

*** Keywords ***
Search History
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}=${retryTimes}
    [Documentation]    根据查询条件查询历史会话
    ...
    ...    describtion：
    ...    ${agent}:坐席信息
    ...    ${filter}:筛选条件
    ...    ${date}:日期条件
    ...    ${retryTimes}:请求重试次数
    ...
    ...    返回值：
    ...    查到数据则返回结果，否则返回：{}
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Return From Keyword if    ${j['total_entries']} ==1    ${j}
    \    sleep    ${delay}
    Return From Keyword    {}

Check Admin History Detail
    [Arguments]    ${agent}    ${j}    ${session}
    [Documentation]    判断管理员模式下历史会话接口返回字段值
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${agent.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${agent.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

Check Admin History Transfered Detail
    [Arguments]    ${agent}    ${j}    ${session}
    [Documentation]    判断管理员模式下历史会话，转接类型会话中接口返回字段值
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

Check Admin History FromAgentCallback Detail
    [Arguments]    ${agent}    ${j}    ${session}
    [Documentation]    判断管理员模式下历史会话，转接类型会话中接口返回字段值
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${agent.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${agent.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}
