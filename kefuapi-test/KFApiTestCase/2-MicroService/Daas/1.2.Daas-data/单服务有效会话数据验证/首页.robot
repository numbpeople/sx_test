*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Resource          ../../../../../commons/admin common/Daas/Daas_Common.robot
Library           json
Library           requests
Library           RequestsLibrary

*** Test Cases ***
今日新会话数
    #获取首页-今日新会话数
    ${newTodaySession}    evaluate    ${todayInfo.todaySession}+1
    ${resp}=    /daas/internal/session/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    should be true    ${resp.content}==${newTodaySession}    首页-今日新会话数不正确:${resp.status_code}

今日消息数
    #获取首页-今日消息数
    ${newTodayMessage}    evaluate    ${todayInfo.todaySession}+3
    ${resp}=    /daas/internal/message/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    should be true    ${resp.content}>=${newTodayMessage}    首页-今日消息数不正确:${resp.status_code}

会话量趋势
    #获取首页-会话量趋势,按当天筛选
    ${newTodaySessionTrend}    evaluate    ${todayInfo.todaySessionTrend}+1
    ${resp}=    /daas/internal/session/trend    ${AdminUser}    ${timeout}    ${todayDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${todaySessionTrend}    Get Current Session Count    weixin    ${j}
    should be true    ${todaySessionTrend}==${newTodaySessionTrend}    首页-会话量趋势不正确:${resp.status_code}

消息量趋势
    #获取首页-消息量趋势,按当天筛选
    ${newTodayMessageTrend}    evaluate    ${todayInfo.todayMessageTrend}+3
    ${resp}=    /daas/internal/message/trend    ${AdminUser}    ${timeout}    ${todayDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    首页不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${todayMessageTrend}    Get Current Session Count    weixin    ${j}
    should be true    ${todayMessageTrend}>=${newTodayMessageTrend}    首页-消息量趋势不正确:${resp.status_code}

今日客服新进会话数报表
    #获取首页-今日客服新进会话数报表
    ${newTodayAgentSessionCount}    evaluate    ${todayInfo.todayAgentSessionCount}+1
    ${resp}=    /daas/internal/agent/kpi/session/today    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${todayAgentSessionCount}    Get Agent Current Session Count    ${AdminUser.userId}    ${j}
    should be true    ${todayAgentSessionCount}==${newTodayAgentSessionCount}    首页-今日客服新进会话数报表不正确:${resp.status_code}
