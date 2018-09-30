*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/MicroService/Daas/DaasApi.robot

*** Test Cases ***
管理首页-在线客服数(/daas/internal/agent/online)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取管理员首页-在线客服数，调用接口：/daas/internal/agent/online，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    管理员首页-在线客服数接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/online    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    在线客服数不正确：${resp.content}

管理首页-今日新进会话数(/daas/internal/session/today/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取管理首页-今日新进会话数，调用接口：/daas/internal/session/today/total，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    管理首页-今日新进会话数接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日新进会话数不正确：${resp.content}

管理首页-今日处理中会话数(/daas/internal/session/today/processing)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取管理首页-今日处理中会话数，调用接口：/daas/internal/session/today/processing，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    管理首页-今日处理中会话数接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/today/processing    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日处理中会话数不正确：${resp.content}

管理首页-今日消息数(/daas/internal/message/today/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取管理首页-今日消息数，调用接口：/daas/internal/message/today/total，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    管理首页-今日消息数接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/message/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日消息数不正确：${resp.content}

管理首页-会话量趋势(/daas/internal/session/trend)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取管理首页-会话量趋势，调用接口：/daas/internal/session/trend，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    管理首页-会话量趋势接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/trend    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

管理首页-消息量趋势(/daas/internal/message/trend)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取管理首页-消息量趋势，调用接口：/daas/internal/message/trend，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    管理首页-消息量趋势接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/message/trend    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

管理首页-今日客服新进会话数报表(/daas/internal/agent/kpi/session/today)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取管理首页-今日客服新进会话数报表，调用接口：/daas/internal/agent/kpi/session/today，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    管理首页-今日客服新进会话数报表接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/kpi/session/today    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

工作量-客服工作量(/daas/internal/agent/kpi/wl)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-客服工作量，调用接口：/daas/internal/agent/kpi/wl，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作量-客服工作量接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/kpi/wl    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服工作量不正确:${resp.content}

工作量-技能组工作量(/daas/internal/group/kpi/wl)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-技能组工作量，调用接口：/daas/internal/group/kpi/wl，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作量-技能组工作量接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/group/kpi/wl    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    技能组工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    技能组工作量不正确:${resp.content}

工作量-工作量综合(/daas/internal/session/wl/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-工作量综合，调用接口：/daas/internal/session/wl/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作量-工作量综合接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/wl/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作量综合不正确:${resp.content}

工作量-会话量和消息量趋势图(/daas/internal/session/trend/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-会话量和消息量趋势图，调用接口：/daas/internal/session/trend/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作量-会话量和消息量趋势图接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/trend/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话量和消息量趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    会话量和消息量趋势图不正确:${resp.content}

工作量-会话数分布按会话标签维度(/daas/internal/session/dist/session/tag)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-会话数分布按会话标签维度，调用接口：/daas/internal/session/dist/session/tag，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作量-会话数分布按会话标签维度接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/session/tag    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按会话标签维度不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    会话数分布按会话标签维度不正确:${resp.content}

工作量-会话数分布按消息数维度(/daas/internal/session/dist/message/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-会话数分布按消息数维度，调用接口：/daas/internal/session/dist/message/count，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作量-会话数分布按消息数维度接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/message/count    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按消息数维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按消息数维度不正确:${resp.content}

工作量-会话数分布按会话时长维度(/daas/internal/session/dist/session/time)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-会话数分布按会话时长维度，调用接口：/daas/internal/session/dist/session/time，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作量-会话数分布按会话时长维度接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/session/time    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按会话时长维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按会话时长维度不正确:${resp.content}

工作质量-客服工作质量(/daas/internal/agent/kpi/wq)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-客服工作质量，调用接口：/daas/internal/agent/kpi/wq，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-客服工作质量接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/kpi/wq    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服工作质量不正确:${resp.content}

工作质量-技能组工作质量(/daas/internal/group/kpi/wq)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-技能组工作质量，调用接口：/daas/internal/group/kpi/wq，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-技能组工作质量接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/group/kpi/wq    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    技能组工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    技能组工作质量不正确:${resp.content}

工作质量-工作质量综合(/daas/internal/session/wq/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-工作质量综合，调用接口：/daas/internal/session/wq/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-工作质量综合接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/wq/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作质量综合不正确:${resp.content}

工作质量-满意度评分分布(/daas/internal/session/dist/vm)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-满意度评分分布，调用接口：/daas/internal/session/dist/vm，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-满意度评分分布接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/vm    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    满意度评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    满意度评分分布不正确:${resp.content}

工作质量-质检评分分布(/daas/internal/session/dist/qm)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-质检评分分布，调用接口：/daas/internal/session/dist/qm，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-质检评分分布接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/qm    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    质检评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    质检评分分布不正确:${resp.content}

工作质量-有效人工会话占比(/daas/internal/session/dist/effective)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-有效人工会话占比，调用接口：/daas/internal/session/dist/effective，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-有效人工会话占比接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    有效人工会话占比不正确:${resp.content}

工作质量-会话数分布按首响时长维度(/daas/internal/session/dist/response/first)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-会话数分布按首响时长维度，调用接口：/daas/internal/session/dist/response/first，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-会话数分布按首响时长维度接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/response/first    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按首响时长维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按首响时长维度不正确:${resp.content}

工作质量-会话数分布按响应时长维度(/daas/internal/session/dist/response/avg)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-会话数分布按响应时长维度，调用接口：/daas/internal/session/dist/response/avg，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    工作质量-会话数分布按响应时长维度接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/session/dist/response/avg    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布按响应时长维度不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布按响应时长维度不正确:${resp.content}

客服时长统计-客服在线时长(/daas/internal/agent/serve)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服时长统计-客服在线时长，调用接口：/daas/internal/agent/serve，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    客服时长统计-客服在线时长接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/serve    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服在线时长不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服在线时长不正确:${resp.content}

客服时长统计-客服在线时长明细(/daas/internal/agent/serve/detail)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服时长统计-客服在线时长明细，调用接口：/daas/internal/agent/serve/detail，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    客服时长统计-客服在线时长明细接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/serve/detail    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服在线时长明细不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    客服在线时长明细不正确:${resp.content}

访客统计-独立访客数(/daas/internal/visitor/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客数，调用接口：/daas/internal/visitor/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客数接口请求，状态码正常，有返回值。
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_ORIGINTYPE
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${DateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=1    独立访客数不正确:${resp.content}

访客统计-独立访客数趋势图(/daas/internal/visitor/trend)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客数趋势图，调用接口：/daas/internal/visitor/trend，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客数趋势图接口请求，状态码正常，有返回值。
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_ORIGINTYPE
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${DateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数趋势图不正确:${resp.content}

访客统计-独立访客数列表(/daas/internal/visitor/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客数列表，调用接口：/daas/internal/visitor/count，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客数列表接口请求，状态码正常，有返回值。
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_ORIGINTYPE
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${DateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数列表不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数列表不正确:${resp.content}

排队统计-排队综合(/daas/internal/wait/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-排队综合，调用接口：/daas/internal/wait/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    排队统计-排队综合接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/wait/total    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队综合不正确:${resp.content}
    should be true    ${j["entities"][0]["cnt_wc"]}>=0    排队综合不正确:${resp.content}

排队统计-24小时进线量(/daas/internal/wait/hour/create)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-24小时进线量，调用接口：/daas/internal/wait/hour/create，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    排队统计-24小时进线量接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/wait/hour/create    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时进线量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    24小时进线量不正确:${resp.content}

排队统计-进线量趋势(/daas/internal/wait/day/create)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-进线量趋势，调用接口：/daas/internal/wait/day/create，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    排队统计-进线量趋势接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/wait/day/create    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    进线量趋势不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    进线量趋势不正确:${resp.content}

排队统计-24小时排队趋势(/daas/internal/wait/hour/wait)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-24小时排队趋势，调用接口：/daas/internal/wait/hour/wait，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    排队统计-24小时排队趋势接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/wait/hour/wait    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时排队趋势不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    24小时排队趋势不正确:${resp.content}

排队统计-排队趋势(/daas/internal/wait/trend)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-排队趋势，调用接口：/daas/internal/wait/trend，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    排队统计-排队趋势接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/wait/trend    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队趋势不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    排队趋势不正确:${resp.content}

排队统计-排队次数分布按会话标签维度(/daas/internal/wait/session/tag)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-排队次数分布按会话标签维度，调用接口：/daas/internal/wait/session/tag，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    排队统计-排队次数分布按会话标签维度接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/wait/session/tag    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队次数分布按会话标签维度不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    排队次数分布按会话标签维度不正确:${resp.content}

实时监控-客服状态分布(/daas/internal/monitor/agent/status/dist)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-客服状态分布，调用接口：/daas/internal/monitor/agent/status/dist，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-客服状态分布接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/agent/status/dist    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服状态分布不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服状态分布不正确:${resp.content}
    should be true    ${j["entities"][0]["offline"]}>=0    客服状态分布不正确:${resp.content}

实时监控-客服负载情况(/daas/internal/monitor/agent/load)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-客服负载情况，调用接口：/daas/internal/monitor/agent/load，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-客服负载情况接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/agent/load    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服负载情况不正确:${resp.content}
    should be equal    ${j["entity"]["tenantId"]}    ${AdminUser.tenantId}    客服负载情况不正确:${resp.content}

实时监控-访客排队情况(/daas/internal/monitor/wait/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-访客排队情况，调用接口：/daas/internal/monitor/wait/count，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-访客排队情况接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/wait/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    访客排队情况不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    访客排队情况不正确:${resp.content}

实时监控-会话数(/daas/internal/monitor/session/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-会话数，调用接口：/daas/internal/monitor/session/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-会话数接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/session/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    会话数不正确:${resp.content}

实时监控-访客来源(/daas/internal/monitor/visitor/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-访客来源，调用接口：/daas/internal/monitor/visitor/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-访客来源接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/visitor/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    访客来源不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    访客来源不正确:${resp.content}

实时监控-服务质量(/daas/internal/monitor/quality/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-服务质量分布，调用接口：/daas/internal/monitor/quality/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-服务质量接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/quality/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    服务质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    服务质量不正确:${resp.content}

实时监控-接起会话数(/daas/internal/monitor/list/session/start)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-接起会话数，调用接口：/daas/internal/monitor/list/session/start，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-接起会话数接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/list/session/start    ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    接起会话数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    接起会话数不正确:${resp.content}

实时监控-平均首次响应时长(/daas/internal/monitor/list/first/response)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-平均首次响应时长，调用接口：/daas/internal/monitor/list/first/response，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-平均首次响应时长接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/list/first/response    ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    平均首次响应时长不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    平均首次响应时长不正确:${resp.content}

实时监控-满意度(/daas/internal/monitor/list/visitor/mark)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-满意度，调用接口：/daas/internal/monitor/list/visitor/mark，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-满意度接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/list/visitor/mark    ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    满意度不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    满意度不正确:${resp.content}

实时监控-平均响应时长(/daas/internal/monitor/list/response/time)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取实时监控-平均响应时长，调用接口：/daas/internal/monitor/list/response/time，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    实时监控-平均响应时长接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/monitor/list/response/time    ${AdminUser}    ${timeout}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    平均响应时长不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    平均响应时长不正确:${resp.content}

统计文件导出-工作量(/daas/internal/session/file/wl)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计文件导出-工作量，调用接口：/daas/internal/session/file/wl，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    统计文件导出-工作量接口请求，状态码正常。
    ${resp}=    /daas/internal/session/file/wl    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-工作质量(/daas/internal/session/file/wq)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计文件导出-工作质量，调用接口：/daas/internal/session/file/wq，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    统计文件导出-工作质量接口请求，状态码正常。
    ${resp}=    /daas/internal/session/file/wq    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-访客统计(/daas/internal/visitor/file)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计文件导出-访客统计，调用接口：/daas/internal/visitor/file，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    统计文件导出-访客统计接口请求，状态码正常。
    ${resp}=    /daas/internal/visitor/file    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-排队统计(/daas/internal/wait/file)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计文件导出-排队统计，调用接口：/daas/internal/wait/file，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    统计文件导出-排队统计接口请求，状态码正常。
    ${resp}=    /daas/internal/wait/file    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-客服时长(/daas/internal/agent/file/serve)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计文件导出-客服时长，调用接口：/daas/internal/agent/file/serve，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    统计文件导出-客服时长接口请求，状态码正常。
    ${resp}=    /daas/internal/agent/file/serve    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-客服时长明细(/daas/internal/agent/file/serve/detail)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计文件导出-客服时长明细，调用接口：/daas/internal/agent/file/serve/detail，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    统计文件导出-客服时长明细接口请求，状态码正常。
    ${resp}=    /daas/internal/agent/file/serve/detail    ${AdminUser}    ${timeout}    ${DateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

客服模式-工作综合(/daas/internal/agent/detail/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服模式-工作综合，调用接口：/daas/internal/agent/detail/total，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    客服模式-工作综合接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/detail/total    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作综合不正确:${resp.content}

客服模式-工作时长(/daas/internal/agent/detail/serve)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服模式-工作时长，调用接口：/daas/internal/agent/detail/serve，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    客服模式-工作时长接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/detail/serve    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作时长不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作时长不正确:${resp.content}

客服模式-工作趋势(/daas/internal/agent/detail/trend)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服模式-工作趋势，调用接口：/daas/internal/agent/detail/trend，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    客服模式-工作趋势接口请求，状态码正常，有返回值。
    ${resp}=    /daas/internal/agent/detail/trend    ${AdminUser}    ${timeout}    ${DateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作时长不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    工作时长不正确:${resp.content}
