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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取多租户的token，调用接口：/v1/organs/{orgName}/token，接口请求状态码为200。
    ...    - Step2、创建全局变量${orgToken}
    ...    【预期结果】：
    ...    获取多租户的token接口请求，状态码正常，可取到返回值中的token。
    [Tags]    org
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${data}    set variable    {"username": "${tadmin.username}","password": "${tadmin.password}"}
    ${resp}=    /v1/organs/{orgName}/token    ${tadmin}    ${AdminUser}    ${data}    ${timeout}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["entity"]["name"]}    token    获取organ的token值不正确:${resp.content}
    set global variable    ${orgToken}    ${j["entity"]["value"]}

获取客服工作质量详情(/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服工作质量详情，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    客服工作质量详情接口请求，状态码正常，有返回值。
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    返回的客服工作质量详情不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的客服工作质量详情不正确：${resp.content}

统计内部调用-质检查询(/statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计内部调用-质检查询，调用接口：/statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计内部调用-质检查询接口请求，状态码正常，有返回值。
    ${resp}=    /statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计内部调用-质检查询不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计内部调用-质检查询不正确:${resp.content}
    #统计内部调用-质检会话查询(/statistics/feign/orgs/{organId}/tenants/{tenantId}/quality/mark/session/{sessionId})

统计内部调用-无效服务(/statistics/feign/orgs/{organId}/tenants/{tenantId}/data/detail/invalid)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计内部调用-无效服务，调用接口：/statistics/feign/orgs/{organId}/tenants/{tenantId}/data/detail/invalid，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计内部调用-无效服务接口请求，状态码正常，有返回值。
    ${resp}=    /statistics/feign/orgs/{organId}/tenants/{tenantId}/data/detail/invalid    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计内部调用-无效服务不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计内部调用-无效服务不正确:${resp.content}

统计内部调用-排队详情(/statistics/feign/orgs/{organId}/tenants/{tenantId}/wait/detail)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计内部调用-排队详情，调用接口：/statistics/feign/orgs/{organId}/tenants/{tenantId}/wait/detail，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计内部调用-排队详情接口请求，状态码正常，有返回值。
    ${resp}=    /statistics/feign/orgs/{organId}/tenants/{tenantId}/wait/detail    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计内部调用-排队详情不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计内部调用-排队详情不正确:${resp.content}

统计外部接口-独立访客数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-独立访客数，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/count，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-独立访客数接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/count    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-独立访客数不正确:${resp.content}

统计外部接口-独立访客总数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-独立访客总数，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/total，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-独立访客总数接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/total    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-独立访客总数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-独立访客总数不正确:${resp.content}

统计外部接口-进行中会话(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/processing)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-进行中会话，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/processing，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-进行中会话接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/processing    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-进行中会话不正确:${resp.content}
    should be true    ${j["entity"]}>=0    获取统计外部接口-进行中会话不正确:${resp.content}

统计外部接口-各类消息数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/count/type)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-各类消息数，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/count/type，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-各类消息数接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/count/type    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-各类消息数不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-各类消息数不正确:${resp.content}

统计外部接口-消息总数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-消息总数，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/total，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-消息总数接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/total    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-消息总数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    获取统计外部接口-消息总数不正确:${resp.content}

统计外部接口-今日消息数(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/today/total)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-今日消息数，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/today/total，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-今日消息数接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/today/total    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-今日消息数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    获取统计外部接口-今日消息数不正确:${resp.content}

统计外部接口-消息趋势(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/trend)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-消息趋势，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/trend，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-消息趋势接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/trend    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-消息趋势不正确:${resp.content}

统计外部接口-v2客服工作量(/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workLoad)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-v2客服工作量，调用接口：/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workLoad，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-v2客服工作量接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workLoad    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v2客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v2客服工作量不正确:${resp.content}

统计外部接口-v2客服工作质量(/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workQuality)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-v2客服工作质量，调用接口：/v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workQuality，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-v2客服工作质量接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v2/organs/{organName}/tenants/{tenantId}/statistics/external/session/workQuality    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v2客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v2客服工作质量不正确:${resp.content}

统计外部接口-v1客服工作量(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workload)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-v1客服工作量，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workload，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-v1客服工作量接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workload    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v1客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v1客服工作量不正确:${resp.content}

统计外部接口-v1客服工作质量(/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workquality)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取统计外部接口-v1客服工作质量，调用接口：/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workquality，接口请求状态码为200，content>=0。
    ...
    ...    【预期结果】：
    ...    统计外部接口-v1客服工作质量接口请求，状态码正常，有返回值。
    [Tags]    org
    ${Cookie}    catenate    token=    ${orgToken}
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workquality    ${AdminUser}    ${OrgAdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    ...    ${Cookie}
    should be equal as integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    获取统计外部接口-v1客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}>=0    获取统计外部接口-v1客服工作质量不正确:${resp.content}
