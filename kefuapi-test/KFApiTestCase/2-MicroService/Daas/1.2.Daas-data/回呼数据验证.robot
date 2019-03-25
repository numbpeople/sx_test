*** Settings ***
Suite Setup       Agent CallingBack Conversation Setup
Force Tags        daas
Resource          ../../../../commons/admin common/Daas/Daas_Common.robot
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           DateTime
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/MicroService/Daas/DaasApi.robot

*** Test Cases ***
工作量-客服回呼会话数
    [Documentation]    【操作步骤】：
    ...    - Step1、suite的setup负责创建一个已结束的会话，并进行回呼，关闭回呼的会话，记录会话的接起时间范围。
    ...    （废弃get接口，改用post）- Step2、根据会话接起时间范围、会话类型，筛选客服工作量的统计数据，调用接口：/daas/internal/agent/kpi/wl，接口请求状态码为200。
    ...    - Step2、根据会话接起时间范围、会话类型，筛选客服工作量的统计数据，调用接口：/daas/internal/post/agent/kpi/wl，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、key字段值等于服务的坐席id、cnt_sac字段值等于回呼会话数。
    #验证工作量-客服工作量接口返回值
    ${ConDateRange}    set variable    ${ConInfo.ConDateRange}
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    sessionType=S_AGENT
    #get接口
    #${resp}=    /daas/internal/agent/kpi/wl    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    #post接口
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"","sessionType":"${filter.sessionType}","originType":[],"agentId":["${AdminUser.userId}"],"objectType":"O_AGENT","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/agent/kpi/wl    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${AdminUser.userId}    客服工作量-客服有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["cnt_sac"]}==1    客服工作量-回呼会话数有误:${j["entities"][0]["cnt_sac"]}

工作量-技能组回呼会话数
    [Documentation]    【操作步骤】：
    ...    - Step1、suite的setup负责创建一个已结束的会话，并进行回呼，关闭回呼的会话，记录会话的接起时间范围。
    ...    （废弃get接口，改用post）- Step2、根据会话接起时间范围、会话类型，筛选技能组工作量的统计数据，调用接口：/daas/internal/group/kpi/wl，接口请求状态码为200。
    ...    - Step2、根据会话接起时间范围、会话类型，筛选技能组工作量的统计数据，调用接口：/daas/internal/post/group/kpi/wl，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、key字段值等于服务的技能组id、cnt_sac字段值等于回呼会话数。
    #验证工作量-技能组工作量接口返回值
    ${ConDateRange}    set variable    ${ConInfo.ConDateRange}
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    sessionType=S_AGENT    groupId=${ConInfo.queueId}
    #get接口
    #${resp}=    /daas/internal/group/kpi/wl    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    #post接口
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"all","sessionType":"${filter.sessionType}","originType":[],"groupId":["${filter.groupId}"],"objectType":"O_GROUP","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/group/kpi/wl    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    技能组工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    技能组工作量不正确:${resp.content}
    ${key}    evaluate    int(${j["entities"][0]["key"]})
    should be equal    ${key}    ${ConInfo.queueId}    技能组工作量-技能组有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["cnt_sac"]}==1    技能组工作量-回呼会话数有误:${j["entities"][0]["cnt_sac"]}

工作质量-客服评价率
    [Documentation]    【操作步骤】：
    ...    - Step1、suite的setup负责创建一个已结束的会话，并进行回呼，关闭回呼的会话，记录会话的接起时间范围。(该会话未发起满意度评价邀请)
    ...    - Step2、根据会话接起时间范围、会话类型，筛选客服工作量的统计数据，调用接口：/daas/internal/agent/kpi/wq，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、key字段值等于服务的坐席id、pct_eva、cnt_vm、cnt_eva均为0。
    #验证客服工作质量的评价率等指标
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"","sessionType":"${FilterEntity.sessionType}","originType":[],"agentId":["${AdminUser.userId}"],"objectType":"O_AGENT","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/agent/kpi/wq    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作质量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${AdminUser.userId}    客服工作质量-客服有误:${j["entities"][0]["key"]}
    #验证评价率
    should be equal    ${j["entities"][0]["pct_eva"]}    0.00%    客服工作量-客服评价率有误:${j["entities"][0]["pct_eva"]}
    should be true    "${j["entities"][0]["cnt_vm"]}"=="0"    客服工作量-有效评价数有误:${j["entities"][0]["cnt_vm"]}
    should be true    "${j["entities"][0]["cnt_eva"]}"=="0.0"    客服工作量-有效邀请数有误:${j["entities"][0]["cnt_eva"]}
