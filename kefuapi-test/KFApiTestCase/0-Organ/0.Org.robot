*** Settings ***
Suite Setup
Force Tags        org
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../AgentRes.robot
Resource          ../../JsonDiff/OrgJsonDiff.robot
Resource          ../../api/MicroService/Organ/OrgApi.robot
Resource          ../../commons/admin common/BaseKeyword.robot

*** Test Cases ***
org管理员登录(/v2/orgs/{orgId}/token)
    Create Session    orgadminsession    ${orgurl}
    set to dictionary    ${OrgAdminUser}    session=orgadminsession
    ${resp}=    /v2/orgs/{orgId}/token    post    ${OrgAdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    log    ${OrgAdminUser}
    ${temp}    to json    ${OrgtokenJson}
    set to dictionary    ${temp['entity']['user']}    username=${OrgAdminUser.username}    orgId=${OrgAdminUser.orgId}
    log    ${temp}
    ${r}=    OrgtokenJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    登录返回值不正确：${r}
    set global variable    ${OrgtokenJson}    ${j}
    set to dictionary    ${OrgAdminUser}    cookies=${resp.cookies}    userId=${j['entity']['user']['userId']}    nicename=${j['entity']['user']['nicename']}
    set global variable    ${OrgAdminUser}    ${OrgAdminUser}
    ${DR}=    InitFilterTime
    set global variable    ${OrgDateRange}    ${DR}

获取初始化数据(/v2/orgs/initdata)
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${resp}=    /v2/orgs/initdata    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${OrginitdataJson}
    set to dictionary    ${temp['entity']['orguser']}    username=${OrgAdminUser.username}    orgId=${OrgAdminUser.orgId}    nicename=${OrgAdminUser.nicename}
    log    ${temp}
    ${r}=    OrginitdataJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取初始化数据不正确：${r}
    set global variable    ${OrginitdataJson}    ${j}

获取首页数据(/v2/orgs/{orgId}/count/total)
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${resp}=    /v2/orgs/{orgId}/count/total    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${OrgcounttotalJson}
    ${r}=    OrgcounttotalJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取首页数据不正确：${r}
    set global variable    ${OrgcounttotalJson}    ${j}

获取管理员列表数据(/v2/orgs/{orgId}/users)
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${resp}=    /v2/orgs/{orgId}/users    ${tadmin}    ${OrgFilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${OrgusersJson}
    set to dictionary    ${temp}    size=${OrgFilterEntity.size}    number=${OrgFilterEntity.page}
    ${r}=    OrgusersJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取管理员列表数据不正确：${r}
    set global variable    ${OrgusersJson}    ${j}
    : FOR    ${d}    IN    @{j['entities']}
    \    Run Keyword If    '${OrgtokenJson['entity']['user']['username']}' == '${d['username']}'    Exit For Loop
    should be true    '${OrgtokenJson['entity']['user']['userId']}' == '${d['userId']}'    用户信息不正确
    should be true    '${OrgtokenJson['entity']['user']['orgId']}' == '${d['orgId']}'    用户信息不正确

获取统计数据(/v2/orgs/{orgId}/metrics)
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${resp}=    /v2/orgs/{orgId}/metrics    ${tadmin}    ${OrgFilterEntity}    ${OrgDateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${OrgmetricsJson}
    set to dictionary    ${temp}    size=${OrgFilterEntity.size}    number=${OrgFilterEntity.page}
    ${r}=    OrgmetricsJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取统计数据不正确：${r}
    set global variable    ${OrgmetricsJson}    ${j}

获取导出数据(/v2/orgs/{orgId}/downloadmetrics)
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${resp}=    /v2/orgs/{orgId}/downloadmetrics    ${tadmin}    ${OrgFilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${OrgdownloadmetricsJson}
    set to dictionary    ${temp}    size=${OrgFilterEntity.size}    number=${OrgFilterEntity.page}
    ${r}=    OrgdownloadmetricsJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取导出数据不正确：${r}
    set global variable    ${OrgdownloadmetricsJson}    ${j}
    #获取租户管理数据(/v2/orgs/{orgId}/tenants)
    #    set test variable    ${tadmin}    ${OrgAdminUser}
    #    ${resp}=    /v2/orgs/{orgId}/tenants    ${tadmin}    ${OrgFilterEntity}    ${timeout}
    #    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #    Should Not Be Empty    ${resp.content}    返回值为空
    #    ${j}    to json    ${resp.content}
    #    ${temp}    to json    ${OrgtenantsJson}
    #    set to dictionary    ${temp}    size=${OrgFilterEntity.size}    number=${OrgFilterEntity.page}
    #    ${r}=    OrgtenantsJsonDiff    ${temp}    ${j}
    #    Should Be True    ${r['ValidJson']}    获取租户管理数据不正确：${r}
    #    set global variable    ${OrgtenantsJsonDiff}    ${j}

新增租户(/v2/orgs/{orgId}/tenants)
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${curTime}    get time    epoch
    set to dictionary    ${OrgUser1}    username=${tadmin.orgId}${curTime}@test.com    password=test2015    name=${tadmin.orgId}${curTime}@test.com    phone=111222333
    ${data}=    set variable    {"name":"${OrgUser1.username}","username":"${OrgUser1.username}","password":"${OrgUser1.password}","phone":"${OrgUser1.phone}"}
    ###新增租户
    ${resp}=    /v2/orgs/{OrgId}/tenants    post    ${tadmin}    ${OrgFilterEntity}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j["entity"]["tenant"]["orgId"]}'=='${tadmin.orgId}'    返回的OrgId不正确：${resp.content}
    set to dictionary    ${OrgUser1}    tenantId=${j["entity"]["tenant"]["tenantId"]}    username=${j["entity"]["agentUser"]["username"]}
    set global variable    ${OrgUser1}    ${OrgUser1}
    ###获取租户列表
    set to dictionary    ${AgentFilterEntity}    keyValue=${curTime}
    ${resp}=    /v2/orgs/{OrgId}/tenants    get    ${tadmin}    ${OrgFilterEntity}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=1    获取租户列表不正确：${resp.content}
    Should Be True    '${j['entities'][0]['tenantId']}'=='${OrgUser1.tenantId}'    获取租户列表不正确：${resp.content}
    set to dictionary    ${AdminUser}    username=${OrgUser1.username}    password=${OrgUser1.password}
    set global variable    ${AdminUser}    ${AdminUser}

获取设置基本信息(/v2/orgs/{orgId})
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${resp}=    /v2/orgs/{orgId}    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${OrgJson}
    set to dictionary    ${temp['entity']}    orgId=${OrgAdminUser.orgId}
    ${r}=    OrgJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取设置基本信息不正确：${r}
    set global variable    ${OrgJson}    ${j}
    set to dictionary    ${OrgAdminUser}    orgname=${j["entity"]["name"]}

获取设置模板(/v2/orgs/{orgId}/template)
    set test variable    ${tadmin}    ${OrgAdminUser}
    ${resp}=    /v2/orgs/{orgId}/template    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${OrgtemplateJson}
    ${r}=    OrgtemplateJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    获取设置基本信息不正确：${r}
    set global variable    ${OrgtemplateJson}    ${j}
