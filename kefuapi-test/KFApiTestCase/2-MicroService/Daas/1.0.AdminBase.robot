*** Settings ***
Force Tags        admin
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/MicroService/Daas/StatisticsApi.robot

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

获取客服工作质量详情(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent)
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的客服工作质量详情不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的客服工作质量详情不正确：${resp.content}

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
