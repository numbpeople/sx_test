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
    Should Be True    ${resp.content}>=0    在线客服数不正确：${resp.content}

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


工作量-客服工作量(/daas/internal/agent/kpi/wl)
    ${resp}=    /daas/internal/agent/kpi/wl    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服工作量不正确:${resp.content}

工作量-技能组工作量(/daas/internal/group/kpi/wl)
    ${resp}=    /daas/internal/group/kpi/wl    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    技能组工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    技能组工作量不正确:${resp.content}

工作量-工作量综合(/daas/internal/session/wl/total)
    ${resp}=    /daas/internal/session/wl/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作量综合不正确:${resp.content}

工作量-会话量和消息量趋势图(/daas/internal/session/trend/total)
    ${resp}=    /daas/internal/session/trend/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话量和消息量趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    会话量和消息量趋势图不正确:${resp.content}

工作量-会话数分布按会话标签维度(/daas/internal/session/dist/session/tag)
    ${resp}=    /daas/internal/session/dist/session/tag    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按会话标签维度不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    会话数分布按会话标签维度不正确:${resp.content}

工作量-会话数分布按消息数维度(/daas/internal/session/dist/message/count)
    ${resp}=    /daas/internal/session/dist/message/count    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按消息数维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按消息数维度不正确:${resp.content}

工作量-会话数分布按会话时长维度(/daas/internal/session/dist/session/time)
    ${resp}=    /daas/internal/session/dist/session/time    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按会话时长维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按会话时长维度不正确:${resp.content}


工作质量-客服工作质量(/daas/internal/agent/kpi/wq)
    ${resp}=    /daas/internal/agent/kpi/wq    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服工作质量不正确:${resp.content}

工作质量-技能组工作质量(/daas/internal/group/kpi/wq)
    ${resp}=    /daas/internal/group/kpi/wq    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    技能组工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    技能组工作质量不正确:${resp.content}

工作质量-工作质量综合(/daas/internal/session/wq/total)
    ${resp}=    /daas/internal/session/wq/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作质量综合不正确:${resp.content}

工作质量-满意度评分分布(/daas/internal/session/dist/vm)
    ${resp}=    /daas/internal/session/dist/vm    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    满意度评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    满意度评分分布不正确:${resp.content}

工作质量-质检评分分布(/daas/internal/session/dist/qm)
    ${resp}=    /daas/internal/session/dist/qm    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    质检评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    质检评分分布不正确:${resp.content}

工作质量-有效人工会话占比(/daas/internal/session/dist/effective)
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    有效人工会话占比不正确:${resp.content}

工作质量-会话数分布按首响时长维度(/daas/internal/session/dist/response/first)
    ${resp}=    /daas/internal/session/dist/response/first    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按首响时长维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按首响时长维度不正确:${resp.content}

工作质量-会话数分布按响应时长维度(/daas/internal/session/dist/response/avg)
    ${resp}=    /daas/internal/session/dist/response/avg    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按响应时长维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按响应时长维度不正确:${resp.content}


客服时长统计-客服在线时长(/daas/internal/agent/serve)
    ${resp}=    /daas/internal/agent/serve    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服在线时长不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服在线时长不正确:${resp.content}

客服时长统计-客服在线时长明细(/daas/internal/agent/serve/detail)
    ${resp}=    /daas/internal/agent/serve/detail    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服在线时长明细不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服在线时长明细不正确:${resp.content}


访客统计-独立访客数(/daas/internal/visitor/total)
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    独立访客数不正确:${resp.content}

访客统计-独立访客数趋势图(/daas/internal/visitor/trend)
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数趋势图不正确:${resp.content}

访客统计-独立访客数列表(/daas/internal/visitor/count)
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数列表不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数列表不正确:${resp.content}


排队统计-排队综合(/daas/internal/wait/total)
    ${resp}=    /daas/internal/wait/total    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队综合不正确:${resp.content}
    should be true    ${j["entities"][0]["cnt_wc"]}>=0    排队综合不正确:${resp.content}

排队统计-24小时进线量(/daas/internal/wait/hour/create)
    ${resp}=    /daas/internal/wait/hour/create   ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时进线量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    24小时进线量不正确:${resp.content}

排队统计-进线量趋势(/daas/internal/wait/day/create)
    ${resp}=    /daas/internal/wait/day/create   ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    进线量趋势不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    进线量趋势不正确:${resp.content}

排队统计-24小时排队趋势(/daas/internal/wait/hour/wait)
    ${resp}=    /daas/internal/wait/hour/wait   ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时排队趋势不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    24小时排队趋势不正确:${resp.content}

排队统计-排队趋势(/daas/internal/wait/trend)
    ${resp}=    /daas/internal/wait/trend   ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队趋势不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    排队趋势不正确:${resp.content}

排队统计-排队次数分布按会话标签维度(/daas/internal/wait/session/tag)
    ${resp}=    /daas/internal/wait/session/tag   ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队次数分布按会话标签维度不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    排队次数分布按会话标签维度不正确:${resp.content}


实时监控-客服状态分布(/daas/internal/monitor/agent/status/dist)
    ${resp}=    /daas/internal/monitor/agent/status/dist   ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服状态分布不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服状态分布不正确:${resp.content}
    should be true    ${j["entities"][0]["offline"]}>=0    客服状态分布不正确:${resp.content}

实时监控-客服负载情况(/daas/internal/monitor/agent/load)
    ${resp}=    /daas/internal/monitor/agent/load   ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服负载情况不正确:${resp.content}
    should be equal    ${j["entity"]["tenantId"]}    ${AdminUser.tenantId}    客服负载情况不正确:${resp.content}

实时监控-访客排队情况(/daas/internal/monitor/wait/count)
    ${resp}=    /daas/internal/monitor/wait/count   ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    访客排队情况不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    访客排队情况不正确:${resp.content}

实时监控-会话数(/daas/internal/monitor/session/total)
    ${resp}=    /daas/internal/monitor/session/total   ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    会话数不正确:${resp.content}

实时监控-访客来源(/daas/internal/monitor/visitor/total)
    ${resp}=    /daas/internal/monitor/visitor/total   ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    访客来源不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    访客来源不正确:${resp.content}

实时监控-服务质量(/daas/internal/monitor/quality/total)
    ${resp}=    /daas/internal/monitor/quality/total   ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    服务质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    服务质量不正确:${resp.content}

实时监控-接起会话数(/daas/internal/monitor/list/session/start)
    ${resp}=    /daas/internal/monitor/list/session/start   ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    接起会话数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    接起会话数不正确:${resp.content}

实时监控-平均首次响应时长(/daas/internal/monitor/list/first/response)
    ${resp}=    /daas/internal/monitor/list/first/response   ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    平均首次响应时长不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    平均首次响应时长不正确:${resp.content}

实时监控-满意度(/daas/internal/monitor/list/visitor/mark)
    ${resp}=    /daas/internal/monitor/list/visitor/mark   ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    满意度不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    满意度不正确:${resp.content}

实时监控-平均响应时长(/daas/internal/monitor/list/response/time)
    ${resp}=    /daas/internal/monitor/list/response/time   ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    平均响应时长不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    平均响应时长不正确:${resp.content}


统计文件导出-工作量(/daas/internal/session/file/wl)
    ${resp}=    /daas/internal/session/file/wl    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-工作质量(/daas/internal/session/file/wq)
    ${resp}=    /daas/internal/session/file/wq    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-访客统计(/daas/internal/visitor/file)
    ${resp}=    /daas/internal/visitor/file    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-排队统计(/daas/internal/wait/file)
    ${resp}=    /daas/internal/wait/file    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-客服时长(/daas/internal/agent/file/serve)
    ${resp}=    /daas/internal/agent/file/serve    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-客服时长明细(/daas/internal/agent/file/serve/detail)
    ${resp}=    /daas/internal/agent/file/serve/detail    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
