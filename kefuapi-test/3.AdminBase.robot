*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        admin
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          AgentRes.robot
Resource          api/BaseApi/Settings/SingleSignOnApi.robot
Resource          api/BaseApi/Settings/SystemSettingsApi.robot
Resource          JsonDiff/KefuJsonDiff.robot
Resource          api/BaseApi/Settings/WebhookApi.robot
Resource          api/BaseApi/Settings/SatisfactionSurveyApi.robot
Resource          api/MicroService/Daas/StatisticsApi.robot
Resource          api/BaseApi/Review/QualityReviews_Api.robot
Resource          api/MicroService/IntegrationSysinfoManage/GrowingIOApi.robot
Resource          api/BaseApi/Customers/Customers_Api.robot
Resource          api/MicroService/Webapp/OutDateApi.robot

*** Test Cases ***
获取organ的token值(/v1/organs/{orgName}/token)
    [Tags]    org
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${data}    set variable    {"username": "${tadmin.username}","password": "${tadmin.password}"}
    ${resp}=    /v1/organs/{orgName}/token    ${tadmin}    ${AdminUser}    ${data}    ${timeout}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["entity"]["name"]}    token    获取organ的token值不正确:${resp.content}
    set global variable    ${orgToken}    ${j["entity"]["value"]}

今日新会话数(/v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount)
    [Tags]    unused
    log    ${RestEntity}
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日新会话数不正确：${resp.content}

新今日新会话数(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/total)
    [Tags]    unused
    log    ${RestEntity}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    新今日新会话数不正确：${resp.content}

处理中会话数(/v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount)
    [Tags]    unused
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    处理中会话数不正确：${resp.content}

新处理中会话数(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/processing)
    [Tags]    unused
    log    ${RestEntity}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    新处理中会话数不正确：${resp.content}

在线客服数(/v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount)
    [Tags]    unused
    ${resp}=    /v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    在线客服数不正确：${resp.content}

新在线客服数(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/agent/online)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/agent/online    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    新在线客服数不正确：${resp.content}

今日消息数(/v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount)
    [Tags]    unused
    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    今日消息数不正确：${resp.content}

新今日消息数(/v1/statistics/tenant/{tenantId}/message/today/total)
    [Tags]    unused
    ${resp}=    /v1/statistics/tenant/{tenantId}/message/today/total    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    新今日消息数不正确：${resp.content}

今日客服新进会话数(/v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent)
    [Tags]    unused
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}

新今日客服新进会话数(/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/session/today)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/session/today    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be True    ${resp.content}>=0    新今日客服新进会话数不正确：${resp.content}

首页会话量趋势数据(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

首页消息量趋势数据(/v1/statistics/tenant/{tenantId}/message/trend)
    [Tags]    unused
    ${resp}=    /v1/statistics/tenant/{tenantId}/message/trend    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

获取客服状态分布信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/status/dist)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/status/dist    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['entities'][0]['online']}>=0    返回的客服状态分布信息不正确：${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的客服状态分布信息不正确：${resp.content}

获取客服负载情况信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/load)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/load    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的客服负载情况不正确：${resp.content}
    Should Be Equal    '${j['entity']['tenantId']}'    '${AdminUser.tenantId}'    返回的客服负载情况不正确：${resp.content}

获取访客排队情况信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/wait/count)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/wait/count    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的访客排队情况信息不正确：${resp.content}
    Should Be Equal    '${j['entities'][0]['key']}'    'wait'    返回的访客排队情况信息不正确：${resp.content}

获取会话数信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的会话数不正确：${resp.content}
    Should Be True    ${j['entities'][0]['cnt_csc']}>=0    返回的会话数不正确：${resp.content}

获取访客来源信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的访客来源信息不正确：${resp.content}
    Should Be True    ${j['entities'][0]['app']}>=0    返回的访客来源信息不正确：${resp.content}

获取服务质量信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/quality/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/quality/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的服务质量信息不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_ar']}>=0    返回的服务质量信息不正确：${resp.content}

获取接起会话前三名信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/start/top)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/start/top    ${AdminUser}    ${orgEntity}    true    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的接起会话前三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的接起会话前三名信息不正确：${resp.content}

获取平均首次响应时长前三名信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/first/response/top)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/first/response/top    ${AdminUser}    ${orgEntity}    true    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的平均首次响应时长前三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的平均首次响应时长前三名信息不正确：${resp.content}

获取满意度前三名信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/mark/top)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/mark/top    ${AdminUser}    ${orgEntity}    true    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的满意度前三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的满意度前三名信息不正确：${resp.content}

获取接起会话后三名信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/start/top)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/start/top    ${AdminUser}    ${orgEntity}    false    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'
    Should Be True    ${j['totalElements']}>=0    返回的接起会话后三名信息不正确：${resp.content}

获取平均首次响应时长后三名信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/first/response/top)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/first/response/top    ${AdminUser}    ${orgEntity}    false    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的平均首次响应时长后三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的平均首次响应时长后三名信息不正确：${resp.content}

获取满意度后三名信息(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/mark/top)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/mark/top    ${AdminUser}    ${orgEntity}    false    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的满意度后三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的满意度后三名信息不正确：${resp.content}

获取默认质量检查数据(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/qualityreviews    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    质量检查数不正确：${resp.content}
    Should Be True    ${j['totalElements']} >= 0    质量检查数不正确：${resp.content}

获取排队统计(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的排队统计信息不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_wt']}>=0    返回的排队统计信息不正确：${resp.content}

获取排队统计-排队总数(/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的排队统计-排队总数不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_wt']}>=0    返回的排队统计-排队总数不正确：${resp.content}

获取排队统计-24小时进线(/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/hour/create)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/hour/create    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的排队统计-24小时进线不正确：${resp.content}
    should be true    ${j['totalElements']}>=0    返回的排队统计-24小时进线不正确：${resp.content}

获取排队统计-24小时排队(/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/hour/wait)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/hour/wait    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的排队统计-24小时排队不正确：${resp.content}
    should be true    ${j['totalElements']}>=0    返回的排队统计-24小时排队不正确：${resp.content}

获取排队统计-按天进线(/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/day/create)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/day/create    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的排队统计-按天进线不正确：${resp.content}
    should be true    ${j['totalElements']}>=0    返回的排队统计-按天进线不正确：${resp.content}

获取排队统计-排队趋势(/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/trend)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/trend    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的排队统计-排队趋势不正确：${resp.content}
    should be true    ${j['totalElements']}>=0    返回的排队统计-排队趋势不正确：${resp.content}

获取排队统计-会话标签分布(/statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/session/tag)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/wait/session/tag    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的排队统计-会话标签分布不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的排队统计-会话标签分布不正确：${resp.content}

获取24小时进线量(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/hour)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/hour    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的24小时进线量不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的24小时进线量不正确：${resp.content}

获取24小时排队趋势(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/hour)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/hour    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的24小时排队趋势不正确：${resp.content}
    Should Be Equal    ${j['entities'][0]['key']}    cnt_wc    返回的24小时排队趋势不正确：${resp.content}

获取排队趋势(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/trend)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/trend    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的24小时排队趋势不正确：${resp.content}
    Should Be Equal    ${j['entities'][0]['key']}    cnt_Wc    返回的24小时排队趋势不正确：${resp.content}

获取独立访客总数(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/total    ${AdminUser}    ${orgEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的独立访客总数信息不正确：${resp.content}
    Should Be True    ${j['entities'][0]['count']}>=0    返回的独立访客总数信息不正确：${resp.content}

获取独立访客详情(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的独立访客详情不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的独立访客详情不正确：${resp.content}

获取独立访客数趋势(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/trend)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/trend    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的独立访客数趋势不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的独立访客数趋势不正确：${resp.content}

获取是否开启全站统计(/v1/integration/tenants/{tenantId}/userinfo)
    ${resp}=    /v1/integration/tenants/{tenantId}/userinfo    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的全站统计信息不正确：${resp.content}

获取growing io信息(/v1/integration/tenants/{tenantId}/dashboard)
    ${resp}=    /v1/integration/tenants/{tenantId}/dashboard    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的growing io信息不正确：${resp.content}

获取客服工作量详情(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的客服工作量信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的客服工作量信息不正确：${resp.content}

获取客服工作量详情导出文件(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent/file)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent/file    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be Equal    ${resp.headers['Content-Type']}    application/vnd.ms-excel;charset=utf-8    获取客服工作详情导出文件不正确

获取工作量会话指标(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的工作量会话指标不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_mc']}>=0    返回的工作量会话指标不正确：${resp.content}

获取会话量和消息量趋势(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话量和消息量不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的会话量和消息量不正确：${resp.content}

获取会话数分布（按会话标签维度）(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTag)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTag    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按会话标签维度）：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的会话数分布（按会话标签维度）：${resp.content}

获取会话数分布（按会话消息数维度）(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/messageCount)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/messageCount    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按会话消息数维度）：${resp.content}
    Should Be True    ${j['entities'][0]['count']}>=0    返回的会话数分布（按会话消息数维度）：${resp.content}

获取会话数分布（按会话时长维度）(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTime)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTime    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按会话时长维度）：${resp.content}
    Should Be True    ${j['entities'][0]['count']}>=0    返回的会话数分布（按会话时长维度）：${resp.content}

获取客服工作质量详情(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent)
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的客服工作质量详情不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的客服工作质量详情不正确：${resp.content}

获取工作质量指标(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/total)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的工作质量指标不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_vm']}>=0    返回的工作质量指标不正确：${resp.content}

获取满意度评分分布(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/visitorMark)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/visitorMark    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的满意度评分分布不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的满意度评分分布不正确：${resp.content}

获取质检评分分布(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/qualityMark)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/qualityMark    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的质检评分分布不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的质检评分分布不正确：${resp.content}

获取有效人工会话占比(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/effective)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/effective    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的有效人工会话占比不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的有效人工会话占比不正确：${resp.content}

获取会话数分布（按首次响应时长维度）(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/firstResTime)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/firstResTime    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按首次响应时长维度）不正确：${resp.content}
    Should Be True    ${j['entities'][0]['count']}>=0    返回的会话数分布（按首次响应时长维度）不正确：${resp.content}

获取会话数分布（按响应时长维度）(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/avgResTime)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/avgResTime    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的获取会话数分布（按响应时长维度）不正确：${resp.content}
    Should Be True    ${j['entities'][0]['count']}>=0    返回的获取会话数分布（按响应时长维度）不正确：${resp.content}

获取客服工作质量详情导出文件(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent/file)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent/file    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be Equal    ${resp.headers['Content-Type']}    application/vnd.ms-excel;charset=utf-8    获取客服工作详情导出文件不正确

获取独立访客详情导出文件(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count/file)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count/file    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be Equal    ${resp.headers['Content-Type']}    application/vnd.ms-excel;charset=utf-8    获取独立访客详情导出文件不正确

获取排队统计导出文件(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/file)
    [Tags]    unused
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/file    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be Equal    ${resp.headers['Content-Type']}    application/vnd.ms-excel;charset=utf-8    获取排队统计导出文件不正确

获取上下班时间(/v1/tenants/{tenantId}/timeplans)
    ${resp}=    /v1/tenants/{tenantId}/timeplans    get    ${AdminUser}    ${timeout}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    获取上下班时间状态不正确：${resp.content}
    : FOR    ${i}    IN    @{j['entities']}
    \    Should Be Equal    '${i['tenantId']}'    '${AdminUser.tenantId}'    获取上下班时间信息不正确：${resp.content}

获取客服状态分布信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/agent/status/dist)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/agent/status/dist    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['entities'][0]['online']}>=0    返回的客服状态分布信息不正确：${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的客服状态分布信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    返回的客服状态分布数量不正确：${resp.content}

获取访客排队情况信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/wait/count)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/wait/count    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的访客排队情况信息不正确：${resp.content}
    Should Be Equal    '${j['entities'][0]['key']}'    'wait'    返回的访客排队情况信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    返回的访客排队情况信息不正确：${resp.content}

获取会话数信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/session/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/session/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的会话数不正确：${resp.content}
    Should Be True    ${j['entities'][0]['cnt_csc']}>=0    返回的会话数不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    返回的会话数不正确：${resp.content}

获取访客来源信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/visitor/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/visitor/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的访客来源信息不正确：${resp.content}
    Should Be True    ${j['entities'][0]['app']}>=0    返回的访客来源信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    返回的访客来源信息不正确：${resp.content}

获取服务质量信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/quality/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/quality/total    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的服务质量信息不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_ar']}>=0    返回的服务质量信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    返回的服务质量信息不正确：${resp.content}

获取接起会话前三名信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/session/start)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/session/start    ${AdminUser}    ${orgEntity}    true    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的接起会话前三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的接起会话前三名信息不正确：${resp.content}

获取平均首次响应时长前三名信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/first/response)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/first/response    ${AdminUser}    ${orgEntity}    true    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的平均首次响应时长前三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的平均首次响应时长前三名信息不正确：${resp.content}

获取满意度前三名信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/visitor/mark)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/visitor/mark    ${AdminUser}    ${orgEntity}    true    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的满意度前三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的满意度前三名信息不正确：${resp.content}

获取接起会话后三名信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/session/start)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/session/start    ${AdminUser}    ${orgEntity}    false    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的接起会话后三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的接起会话后三名信息不正确：${resp.content}

获取平均首次响应时长后三名信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/first/response)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/first/response    ${AdminUser}    ${orgEntity}    false    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的平均首次响应时长后三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的平均首次响应时长后三名信息不正确：${resp.content}

获取满意度后三名信息new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/visitor/mark)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/visitor/mark    ${AdminUser}    ${orgEntity}    false    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的满意度后三名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的满意度后三名信息不正确：${resp.content}

实时监控接起会话数排名(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/session/start)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/session/start    ${AdminUser}    ${orgEntity}    true    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的接起会话数排名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的接起会话数排名信息不正确：${resp.content}

实时监控平均首次响应时长排名(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/first/response)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/first/response    ${AdminUser}    ${orgEntity}    true    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的平均首次响应时长排名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的平均首次响应时长排名信息不正确：${resp.content}

实时监控满意度排名(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/visitor/mark)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/visitor/mark    ${AdminUser}    ${orgEntity}    true    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的满意度排名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的满意度排名信息不正确：${resp.content}

实时监控平均响应时长排名(/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/response/time)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/response/time    ${AdminUser}    ${orgEntity}    true    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    返回的平均响应时长排名信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的平均响应时长排名信息不正确：${resp.content}

获取工作量会话指标new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wl/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wl/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的工作量会话指标不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_mc']}>=0    返回的工作量会话指标不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    返回的工作量会话指标不正确：${resp.content}

获取会话量和消息量趋势new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/trend/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/trend/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话量和消息量不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的会话量和消息量不正确：${resp.content}

获取会话数分布（按会话标签维度）new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/tag)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/tag    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按会话标签维度）：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的会话数分布（按会话标签维度）：${resp.content}

获取会话数分布（按会话消息数维度）new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/message/count)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/message/count    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按会话消息数维度）：${resp.content}
    Should Be True    ${j['entities'][0]['count']}>=0    返回的会话数分布（按会话消息数维度）：${resp.content}
    Should Be True    ${j['totalElements']}==5    返回的会话数分布（按会话消息数维度）：${resp.content}

获取会话数分布（按会话时长维度）new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/time)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/time    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按会话时长维度）：${resp.content}
    Should Be True    ${j['entities'][0]['count']}>=0    返回的会话数分布（按会话时长维度）：${resp.content}
    Should Be True    ${j['totalElements']}==5    返回的会话数分布（按会话时长维度）：${resp.content}

获取客服工作量详情new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wl)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wl    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的客服工作量信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的客服工作量信息不正确：${resp.content}

获取客服工作量详情导出文件new(/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wl)
    [Tags]    unused
    ${resp}=    /statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wl    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Be Equal    ${resp.headers['Content-Type']}    application/vnd.ms-excel;charset=utf-8    获取客服工作详情导出文件不正确

获取工作质量指标new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wq/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wq/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的工作质量指标不正确：${resp.content}
    Should Be True    ${j['entities'][0]['avg_vm']}>=0    返回的工作质量指标不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    返回的工作质量指标不正确：${resp.content}

获取满意度评分分布new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/vm)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/vm    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的满意度评分分布不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的满意度评分分布不正确：${resp.content}

获取质检评分分布new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/qm)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/qm    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的质检评分分布不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的质检评分分布不正确：${resp.content}

获取有效人工会话占比new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/effective)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/effective    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的有效人工会话占比不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的有效人工会话占比不正确：${resp.content}

获取会话数分布（按首次响应时长维度）new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/first)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/first    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的会话数分布（按首次响应时长维度）不正确：${resp.content}
    Should Be True    ${j['totalElements']}==5    返回的会话数分布（按首次响应时长维度）不正确：${resp.content}

获取会话数分布（按响应时长维度）new(/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/avg)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/avg    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的获取会话数分布（按响应时长维度）不正确：${resp.content}
    Should Be True    ${j['totalElements']}==5    返回的获取会话数分布（按响应时长维度）不正确：${resp.content}

获取工作质量详情(/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wq)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wq    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取工作质量详情：${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取工作质量详情：${resp.content}

获取技能组工作质量(/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/group/wq)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/group/wq    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取技能组工作质量详情：${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取技能组工作质量详情：${resp.content}

获取客服时长统计(/statistics/internal/orgs/{organId}/tenants/{tenantId}/serve/agent)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/serve/agent    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取客服时长统计：${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取客服时长统计：${resp.content}

获取客服在线时长明细(/statistics/internal/orgs/{organId}/tenants/{tenantId}/serve/agent/detail)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/serve/agent/detail    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取客服在线时长明细：${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取客服在线时长明细：${resp.content}

获取独立访客数(/statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/total)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取独立访客数：${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取独立访客数：${resp.content}

获取独立访客数趋势(/statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/trend)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/trend    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取独立访客数趋势：${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取独立访客数趋势：${resp.content}

获取独立访客数列表(/statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/count)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/visitor/count    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取独立访客数列表：${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取独立访客数列表：${resp.content}

获取技能组工作量(/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/group/wl)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/group/wl    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的技能组工作量信息不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的技能组工作量信息不正确：${resp.content}

统计文件导出-工作量(/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wl)
    [Tags]    unused
    ${resp}=    /statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wl    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-工作质量(/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wq)
    [Tags]    unused
    ${resp}=    /statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wq    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-访客统计(/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/visitor)
    [Tags]    unused
    ${resp}=    /statistics/internal/file/orgs/{organId}/tenants/{tenantId}/visitor    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-排队统计(/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wait)
    [Tags]    unused
    ${resp}=    /statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wait    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-客服时长(/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/agent/serve)
    [Tags]    unused
    ${resp}=    /statistics/internal/file/orgs/{organId}/tenants/{tenantId}/agent/serve    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计文件导出-客服时长明细(/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/agent/serve/detail)
    [Tags]    unused
    ${resp}=    /statistics/internal/file/orgs/{organId}/tenants/{tenantId}/agent/serve/detail    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

统计内部调用-质检查询(/statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark)
    ${resp}=    /statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计内部调用-质检查询不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计内部调用-质检查询不正确:${resp.content}
    #统计内部调用-质检会话查询(/statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark/session/{sessionId})

统计内部调用-无效服务(/statistics/feign/orgs/{organId}/tenants/{tenantId}/data/detail/invalid)
    ${resp}=    /statistics/feign/orgs/{organId}/tenants/{tenantId}/data/detail/invalid    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计内部调用-无效服务不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计内部调用-无效服务不正确:${resp.content}

统计内部调用-客服今日数据(/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/today)
    [Tags]    unused
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/today    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${timeout}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计内部调用-客服今日数据不正确:${resp.content}
    should be true    ${j["entities"][0]["cnt_tc"]}>=0    获取统计内部调用-客服今日数据不正确:${resp.content}

统计内部调用-排队详情(/statistics/feign/orgs/{organId}/tenants/{tenantId}/wait/detail)
    ${resp}=    /statistics/feign/orgs/{organId}/tenants/{tenantId}/wait/detail    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计内部调用-排队详情不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计内部调用-排队详情不正确:${resp.content}

统计外部接口-独立访客数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/count)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/count    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-独立访客数不正确:${resp.content}

统计外部接口-独立访客总数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/total)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/total    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-独立访客总数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-独立访客总数不正确:${resp.content}

统计外部接口-进行中会话(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/processing)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/processing    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-进行中会话不正确:${resp.content}
    should be true    ${j["entity"]}>=0    获取统计外部接口-进行中会话不正确:${resp.content}

统计外部接口-各类消息数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/count/type)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/count/type    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-各类消息数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-各类消息数不正确:${resp.content}

统计外部接口-消息总数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/total)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/total    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-消息总数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    获取统计外部接口-消息总数不正确:${resp.content}

统计外部接口-今日消息数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/today/total)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/today/total    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-今日消息数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    获取统计外部接口-今日消息数不正确:${resp.content}

统计外部接口-消息趋势(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/trend)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/trend    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-消息趋势不正确:${resp.content}

统计外部接口-v2客服工作量(/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workLoad)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workLoad    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v2客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v2客服工作量不正确:${resp.content}

统计外部接口-v2客服工作质量(/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workQuality)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workQuality    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v2客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v2客服工作质量不正确:${resp.content}

统计外部接口-v1客服工作量(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workload)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workload    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v1客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v1客服工作量不正确:${resp.content}

统计外部接口-v1客服工作质量(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workquality)
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workquality    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v1客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v1客服工作质量不正确:${resp.content}

获取客户中心列表(/v1/crm/tenants/{tenantId}/customers)
    ${resp}=    /v1/crm/tenants/{tenantId}/customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} >= 0    访客中心人数不正确：${resp.content}

获取是否入口指定优先(/tenants/{tenantId}/options/userSpecifiedQueueId)
    [Tags]    unused
    log    ${easemobtechchannel}
    log    ${targetchannel}
    ${resp}=    /tenants/{tenantId}/options/userSpecifiedQueueId    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${userSpecifiedQueueIdJson}
    set to dictionary    ${temp}    tenantId=${AdminUser.tenantId}
    ${r}=    userSpecifiedQueueIdJsonDiff    ${temp}    ${j['data'][0]}
    Should Be True    ${r['ValidJson']}    获取是否入口指定优先信息失败：${r}
    set global variable    ${userSpecifiedQueueIdJson}    ${j['data'][0]}

获取单点登录(/v1/access/config)
    ${resp}=    /v1/access/config    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${resp.content}

获取回调(/tenants/{tenantId}/webhook)
    ${resp}=    /tenants/{tenantId}/webhook    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}

获取满意度评价级别（/v1/tenants/{tenantId}/evaluationdegrees）
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #获取评价级别id
    log    ${j['entities'][0]['id']}
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    Append To List    ${r1}    ${r2}
    \    ${level}=    Convert To String    ${j['entities'][${i}]['level']}
    set global variable    ${degreeId}    ${r1}
    set global variable    ${evaluationdegreeId}    ${degreeId[0]}

获取租户满意度评价标签(/v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags)
    set global variable    ${evaluationdegreeId}    ${degreeId}
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags    ${AdminUser}    ${timeout}    ${evaluationdegreeId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    ${name}=    Convert To String    ${j['entities'][${i}]['name']}
