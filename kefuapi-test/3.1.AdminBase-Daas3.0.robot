*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Resource          AgentRes.robot
Resource          api/DaasApi.robot
Library           requests
Library           RequestsLibrary

*** Test Cases ***
管理首页-在线客服数(/daas/internal/agent/online)
    ${resp}=    /daas/internal/agent/online    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=1    在线客服数不正确：${resp.content}

管理首页-今日新进会话数(/daas/internal/session/today/total)
    ${resp}=    /daas/internal/session/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日新进会话数不正确：${resp.content}

管理首页-今日处理中会话数(/daas/internal/session/today/processing)
    ${resp}=    /daas/internal/session/today/processing    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日处理中会话数不正确：${resp.content}

管理首页-今日消息数(/daas/internal/message/today/total)
    ${resp}=    /daas/internal/message/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日消息数不正确：${resp.content}

管理首页-会话量趋势(/daas/internal/session/trend)
    ${resp}=    /daas/internal/session/trend    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

管理首页-消息量趋势(/daas/internal/message/trend)
    ${resp}=    /daas/internal/message/trend    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

管理首页-今日客服新进会话数报表(/daas/internal/agent/kpi/session/today)
    ${resp}=    /daas/internal/agent/kpi/session/today    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
