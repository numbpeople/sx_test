*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Library           json
Library           requests
Library           RequestsLibrary
Library           Collections

*** Test Cases ***
客服工作量
    [Documentation]    【操作步骤】：
    ...    （废弃get接口，改用post）- Step1、获取工作量-客服工作量，调用接口：/daas/internal/agent/kpi/wl，接口请求状态码为200。
    ...    - Step1、获取工作量-客服工作量，调用接口：/daas/internal/post/agent/kpi/wl，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-客服工作量接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、key字段的值等于AdminUser.userId，字段avg_mc大于等于3，字段max_mc大于等于3等等。
    #验证工作量-客服工作量接口返回值
    #get接口
    #${resp}=    /daas/internal/agent/kpi/wl    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    #post接口
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"","sessionType":"${FilterEntity.sessionType}","originType":[],"agentId":["${AdminUser.userId}"],"objectType":"O_AGENT","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/agent/kpi/wl    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    should be equal    ${j["status"]}    OK    客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${AdminUser.userId}    客服工作量-客服有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["avg_mc"]}>=3    客服工作量-单会话消息数平均值有误:${j["entities"][0]["avg_mc"]}
    should be true    ${j["entities"][0]["max_mc"]}>=3    客服工作量-单会话消息数最大值有误:${j["entities"][0]["max_mc"]}
    should be true    ${j["entities"][0]["avg_wt"]}>=2    客服工作量-会话时长平均值有误:${j["entities"][0]["avg_wt"]}
    should be true    ${j["entities"][0]["max_wt"]}>=2    客服工作量-会话时长最大值有误:${j["entities"][0]["max_wt"]}
    should be true    ${j["entities"][0]["cnt_oc"]}==1    客服工作量-接入会话数有误:${j["entities"][0]["cnt_oc"]}
    should be true    ${j["entities"][0]["cnt_sac"]}==0    客服工作量-回呼会话数有误:${j["entities"][0]["cnt_sac"]}
    should be true    ${j["entities"][0]["cnt_svc"]}==1    客服工作量-呼入会话数有误:${j["entities"][0]["cnt_svc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    客服工作量-接起会话数有误:${j["entities"][0]["cnt_sc"]}
    should be true    ${j["entities"][0]["cnt_sdc"]}==1    客服工作量-接起次数有误:${j["entities"][0]["cnt_sdc"]}
    should be true    ${j["entities"][0]["cnt_tc"]}==1    客服工作量-结束会话数有误:${j["entities"][0]["cnt_tc"]}
    should be true    ${j["entities"][0]["cnt_tic"]}==0    客服工作量-转入会话数有误:${j["entities"][0]["cnt_tic"]}
    should be true    ${j["entities"][0]["cnt_toc"]}==0    客服工作量-转出会话数有误:${j["entities"][0]["cnt_toc"]}
    should be true    ${j["entities"][0]["sum_am"]}==1    客服工作量-客服消息数有误:${j["entities"][0]["sum_am"]}
    should be true    ${j["entities"][0]["sum_vm"]}==1    客服工作量-访客消息数有误:${j["entities"][0]["sum_vm"]}
    should be true    ${j["entities"][0]["sum_sm"]}>=1    客服工作量-系统消息数有误:${j["entities"][0]["sum_sm"]}

技能组工作量
    [Documentation]    【操作步骤】：
    ...    （废弃get接口，改用post）- Step1、获取工作量-技能组工作量，调用接口：/daas/internal/group/kpi/wl，接口请求状态码为200。
    ...    - Step1、获取工作量-技能组工作量，调用接口：/daas/internal/post/group/kpi/wl，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-技能组工作量接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、key字段的值等于queueentity.queueId，字段avg_mc大于等于3，字段max_mc大于等于3等等。
    #验证工作量-技能组工作量接口返回值
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    groupId=${queueentity.queueId}
    #get接口
    #${resp}=    /daas/internal/group/kpi/wl    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    #post接口
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"all","sessionType":"${FilterEntity.sessionType}","originType":[],"groupId":["${filter.groupId}"],"objectType":"O_GROUP","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/group/kpi/wl    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    技能组工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    技能组工作量不正确:${resp.content}
    ${key}    evaluate    int(${j["entities"][0]["key"]})
    should be equal    ${key}    ${queueentity.queueId}    技能组工作量-技能组有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["avg_mc"]}>=3    技能组工作量-单会话消息数平均值有误:${j["entities"][0]["avg_mc"]}
    should be true    ${j["entities"][0]["max_mc"]}>=3    技能组工作量-单会话消息数最大值有误:${j["entities"][0]["max_mc"]}
    should be true    ${j["entities"][0]["avg_wt"]}>=2    技能组工作量-会话时长平均值有误:${j["entities"][0]["avg_wt"]}
    should be true    ${j["entities"][0]["max_wt"]}>=2    技能组工作量-会话时长最大值有误:${j["entities"][0]["max_wt"]}
    should be true    ${j["entities"][0]["cnt_oc"]}==1    技能组工作量-接入会话数有误:${j["entities"][0]["cnt_oc"]}
    should be true    ${j["entities"][0]["cnt_sac"]}==0    技能组工作量-回呼会话数有误:${j["entities"][0]["cnt_sac"]}
    should be true    ${j["entities"][0]["cnt_svc"]}==1    技能组工作量-呼入会话数有误:${j["entities"][0]["cnt_svc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    技能组工作量-接起会话数有误:${j["entities"][0]["cnt_sc"]}
    should be true    ${j["entities"][0]["cnt_sdc"]}==1    技能组工作量-接起次数有误:${j["entities"][0]["cnt_sdc"]}
    should be true    ${j["entities"][0]["cnt_tc"]}==1    技能组工作量-结束会话数有误:${j["entities"][0]["cnt_tc"]}
    should be true    ${j["entities"][0]["cnt_tic"]}==0    技能组工作量-转入会话数有误:${j["entities"][0]["cnt_tic"]}
    should be true    ${j["entities"][0]["cnt_toc"]}==0    技能组工作量-转出会话数有误:${j["entities"][0]["cnt_toc"]}
    should be true    ${j["entities"][0]["sum_am"]}==1    技能组工作量-客服消息数有误:${j["entities"][0]["sum_am"]}
    should be true    ${j["entities"][0]["sum_vm"]}==1    技能组工作量-访客消息数有误:${j["entities"][0]["sum_vm"]}
    should be true    ${j["entities"][0]["sum_sm"]}>=1    技能组工作量-系统消息数有误:${j["entities"][0]["sum_sm"]}

工作量综合
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-工作量综合，调用接口：/daas/internal/session/wl/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-工作量综合接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段avg_mc大于等于3，字段max_mc大于等于3等等。
    #验证工作量-工作量综合接口返回值
    ${resp}=    /daas/internal/session/wl/total    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作量综合不正确:${resp.content}
    should be true    ${j["entities"][0]["avg_mc"]}>=3    工作量综合-单会话消息数平均值有误:${j["entities"][0]["avg_mc"]}
    should be true    ${j["entities"][0]["max_mc"]}>=3    工作量综合-单会话消息数最大值有误:${j["entities"][0]["max_mc"]}
    should be true    ${j["entities"][0]["avg_st"]}>=2    工作量综合-会话时长平均值有误:${j["entities"][0]["avg_st"]}
    should be true    ${j["entities"][0]["max_st"]}>=2    工作量综合-会话时长最大值有误:${j["entities"][0]["max_st"]}
    should be true    ${j["entities"][0]["cnt_mc"]}>=3    工作量综合-消息数有误:${j["entities"][0]["cnt_mc"]}
    should be true    ${j["entities"][0]["cnt_ssc"]}==1    客服工作量-接起会话数有误:${j["entities"][0]["cnt_ssc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    客服工作量-结束会话数有误:${j["entities"][0]["cnt_sc"]}

会话量和消息量趋势图
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-会话量和消息量趋势图，调用接口：/daas/internal/session/trend/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-会话量和消息量趋势图接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于2等等。
    #验证工作量-会话量和消息量趋势图返回值
    ${resp}=    /daas/internal/session/trend/total    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话量和消息量趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    会话量和消息量趋势图不正确:${resp.content}
    should be true    ${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}==1    会话量和消息量趋势图-会话数不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}
    should be true    ${j["entities"][1]["value"][0]["${todayDateRange.beginDateTime}"]}>=3    会话量和消息量趋势图-消息数不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}

会话数分布图(按会话消息数维度)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-会话数分布图(按会话消息数维度)，调用接口：/daas/internal/session/dist/message/count，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-会话数分布图(按会话消息数维度)接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于5、字段["entities"][0]["count"]的值等于1。
    #验证工作量-会话数分布图(按会话消息数维度)返回值
    ${resp}=    /daas/internal/session/dist/message/count    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话消息数维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按会话消息数维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按会话消息数维度)-会话数不正确:${j["entities"][0]["count"]}

会话数分布图(按会话时长维度)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作量-会话数分布图(按会话时长维度)，调用接口：/daas/internal/session/dist/session/time，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-会话数分布图(按会话时长维度)接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于5、字段["entities"][0]["count"]的值等于1。
    #验证工作量-会话数分布图(按会话时长维度)返回值
    ${resp}=    /daas/internal/session/dist/session/time    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话时长维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按会话时长维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按会话时长维度)-会话数不正确:${j["entities"][0]["count"]}
