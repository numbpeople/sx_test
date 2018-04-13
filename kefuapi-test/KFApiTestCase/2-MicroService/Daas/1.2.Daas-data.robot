*** Settings ***
Default Tags      daas
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Daas/Daas_Common.robot
Resource          ../../../api/MicroService/Daas/DaasApi.robot
Library           DateTime
Resource          ../../../api/BaseApi/Review/QualityReviews_Api.robot

*** Test Cases ***
单服务有效会话数据验证
    [Documentation]    会话：单服务有效会话、有满意度评分
    ...    验证模块：工作量、工作质量、访客统计、排队统计、客服模式下个人统计
    [Tags]    daas
    #创建单服务有效会话
    ${conInfo}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    ${queueentity}    set variable    ${conInfo.queueentityAA}
    ${daasCreateTime}    set variable    ${conInfo.daasCreateTime}
    sleep    2000ms
    set to dictionary    ${FilterEntity}    queueId=${queueentity.queueId}
    #验证工作量-客服工作量接口返回值
    ${resp}=    /daas/internal/agent/kpi/wl    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
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
    #验证工作量-技能组工作量接口返回值
    ${resp}=    /daas/internal/group/kpi/wl    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作量不正确:${resp.content}
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
    #验证工作量-会话量和消息量趋势图返回值
    ${resp}=    /daas/internal/session/trend/total    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话量和消息量趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    会话量和消息量趋势图不正确:${resp.content}
    ${todaytime}    Get Today Begin Time
    ${todayBeginTime}    convert to string    ${todaytime}
    should be true    ${j["entities"][0]["value"][0]["${todayBeginTime}"]}==1    会话量和消息量趋势图-会话数不正确:${j["entities"][0]["value"][0]["${todayBeginTime}"]}
    should be true    ${j["entities"][1]["value"][0]["${todayBeginTime}"]}>=3    会话量和消息量趋势图-消息数不正确:${j["entities"][0]["value"][0]["${todayBeginTime}"]}
    #验证工作量-会话数分布图(按会话消息数维度)返回值
    ${resp}=    /daas/internal/session/dist/message/count    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话消息数维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按会话消息数维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按会话消息数维度)-会话数不正确:${j["entities"][0]["count"]}
    #验证工作量-会话数分布图(按会话消息数维度)返回值
    ${resp}=    /daas/internal/session/dist/session/time    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话消息数维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按会话消息数维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按会话消息数维度)-会话数不正确:${j["entities"][0]["count"]}
    #验证工作质量-客服工作质量接口返回值
    ${resp}=    /daas/internal/agent/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作质量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${AdminUser.userId}    客服工作质量-客服有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["avg_ar"]}>=2    客服工作质量-响应时长平均值有误:${j["entities"][0]["avg_ar"]}
    should be true    ${j["entities"][0]["max_ar"]}>=2    客服工作质量-响应时长最大值有误:${j["entities"][0]["max_ar"]}
    should be true    ${j["entities"][0]["avg_fr"]}>=2    客服工作质量-首响时长平均值有误:${j["entities"][0]["avg_fr"]}
    should be true    ${j["entities"][0]["max_fr"]}>=2    客服工作质量-首响时长最大值有误:${j["entities"][0]["max_fr"]}
    should be true    ${j["entities"][0]["avg_qm"]}==0    客服工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be true    ${j["entities"][0]["avg_vm"]}==1    客服工作质量-满意度有误:${j["entities"][0]["avg_vm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    0%    客服工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be equal    ${j["entities"][0]["pct_vm"]}    100%    客服工作质量-满意度参评率有误:${j["entities"][0]["pct_vm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==1    客服工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==0    客服工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==0    客服工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    客服工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    客服工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}
    #验证工作质量-技能组工作质量接口返回值
    ${resp}=    /daas/internal/group/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作质量不正确:${resp.content}
    ${key}    evaluate    int(${j["entities"][0]["key"]})
    should be equal    ${key}    ${queueentity.queueId}    技能组工作量-技能组有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["avg_ar"]}>=2    技能组工作质量-响应时长平均值有误:${j["entities"][0]["avg_ar"]}
    should be true    ${j["entities"][0]["max_ar"]}>=2    技能组工作质量-响应时长最大值有误:${j["entities"][0]["max_ar"]}
    should be true    ${j["entities"][0]["avg_fr"]}>=2    技能组工作质量-首响时长平均值有误:${j["entities"][0]["avg_fr"]}
    should be true    ${j["entities"][0]["max_fr"]}>=2    技能组工作质量-首响时长最大值有误:${j["entities"][0]["max_fr"]}
    should be true    ${j["entities"][0]["avg_qm"]}==0    技能组工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be true    ${j["entities"][0]["avg_vm"]}==1    技能组工作质量-满意度有误:${j["entities"][0]["avg_vm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    0%    技能组工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be equal    ${j["entities"][0]["pct_vm"]}    100%    技能组工作质量-满意度参评率有误:${j["entities"][0]["pct_vm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==1    技能组工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==0    技能组工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==0    技能组工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    技能组工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    技能组工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}
    #验证工作质量-工作质量综合接口返回值
    ${resp}=    /daas/internal/session/wq/total    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作质量综合不正确:${resp.content}
    should be true    ${j["entities"][0]["avg_ar"]}>=2    工作质量综合-响应时长平均值有误:${j["entities"][0]["avg_ar"]}
    should be true    ${j["entities"][0]["max_ar"]}>=2    工作质量综合-响应时长最大值有误:${j["entities"][0]["max_ar"]}
    should be true    ${j["entities"][0]["avg_fr"]}>=2    工作质量综合-首响时长评价值有误:${j["entities"][0]["avg_fr"]}
    should be true    ${j["entities"][0]["max_fr"]}>=2    工作质量综合-首响时长最大值有误:${j["entities"][0]["max_fr"]}
    should be true    ${j["entities"][0]["avg_vm"]}==1    工作质量综合-满意度有误:${j["entities"][0]["avg_vm"]}
    #验证工作质量-满意度评分分布
    ${resp}=    /daas/internal/session/dist/vm    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-满意度评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-满意度评分分布不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==0    工作质量-满意度评分分布图未评数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==1    工作质量-满意度评分分布图已评数不正确:${j["entities"][1]["count"]}
    #验证工作质量-有效人工会话占比
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==0    工作质量-有效人工会话占比无效数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==1    工作质量-有效人工会话占比有效数不正确:${j["entities"][1]["count"]}
    #验证工作质量-会话数分布图(按首次响应时长维度)返回值
    ${resp}=    /daas/internal/session/dist/response/first    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按首次响应时长维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按首次响应时长维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按首次响应时长维度)-会话数不正确:${j["entities"][0]["count"]}
    #验证工作质量-会话数分布图(按响应时长维度)返回值
    ${resp}=    /daas/internal/session/dist/response/avg    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按响应时长维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按响应时长维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按响应时长维度)-会话数不正确:${j["entities"][0]["count"]}
    #验证访客统计-独立访客数按渠道
    ${conCreateTime}    create dictionary    beginDateTime=${daasCreateTime}    endDateTime=${ConDateRange.endDateTime}
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${conCreateTime}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数不正确:${j["entities"][0]["count"]}
    #验证访客统计-独立访客趋势图按渠道
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${conCreateTime}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数趋势图不正确:${resp.content}
    should be equal    ${j["entities"][2]["type"]}    weixin    独立访客数趋势图不正确:${j["entities"][2]["type"]}
    should be true    ${j["entities"][2]["value"][0]["${todayBeginTime}"]}==1    独立访客数趋势图不正确:${j["entities"][2]["value"][0]["${todayBeginTime}"]}
    #验证访客统计-按渠道展示列表
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${conCreateTime}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数按渠道展示列表不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数按渠道展示列表不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    weixin    独立访客数按渠道展示列表不正确:${j["entities"][3]["key"]}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数按渠道展示列表不正确:${j["entities"][3]["count"]}
    #排队统计-排队次数与平均排队时间
    ${filterEntity}    create dictionary    waitTime=1000
    ${resp}    /daas/internal/wait/total    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队次数与平均排队时间不正确:${resp.content}
    should be true    ${j["entities"][0]["cnt_wc"]}==1    排队次数与平均排队时间不正确:${j["entities"][0]["cnt_wc"]}
    should be true    ${j["entities"][0]["avg_wt"]}>=2    排队次数与平均排队时间不正确:${j["entities"][0]["avg_wt"]}
    #排队统计-24小时进线量
    ${daasCreateTime1}    evaluate    ${daasCreateTime}/1000
    ${createTimeHour}    Get Time    \    ${daasCreateTime1}
    ${hour}    Get Time    hour    ${createTimeHour}
    ${resp}    /daas/internal/wait/hour/create    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时进线量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    session    24小时进线量会话数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][${hour}]["${hour}"]}==1    24小时进线量会话数不正确:${j["entities"][0]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][1]["key"]}    message    24小时进线量消息数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][${hour}]["${hour}"]}>=3    24小时进线量消息数不正确:${j["entities"][1]["value"][${hour}]["${hour}"]}
    #排队统计-进线量趋势
    ${resp}    /daas/internal/wait/day/create    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    进线量趋势不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    session    进线量趋势会话数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][0]["${todayBeginTime}"]}==1    进线量趋势会话数不正确:${j["entities"][0]["value"][0]["${todayBeginTime}"]}
    should be equal    ${j["entities"][1]["key"]}    message    进线量趋势消息数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][0]["${todayBeginTime}"]}>=3    进线量趋势消息数不正确:${j["entities"][1]["value"][0]["${todayBeginTime}"]}
    #排队统计-24小时排队趋势
    ${resp}    /daas/internal/wait/hour/wait    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时排队趋势:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    cnt_wc    24小时排队趋势排队次数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][${hour}]["${hour}"]}==1    24小时排队趋势排队次数不正确:${j["entities"][0]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][1]["key"]}    avc_wc    24小时排队趋势平均排队次数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][${hour}]["${hour}"]}==1    24小时排队趋势平均排队次数不正确:${j["entities"][1]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][2]["key"]}    avg_wt    24小时排队趋势平均排队时间不正确:${j["entities"][2]["key"]}
    should be true    ${j["entities"][2]["value"][${hour}]["${hour}"]}>=2    24小时排队趋势平均排队时间不正确:${j["entities"][2]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][3]["key"]}    max_wt    24小时排队趋势最大排队时间不正确:${j["entities"][3]["key"]}
    should be true    ${j["entities"][3]["value"][${hour}]["${hour}"]}>=2    24小时排队趋势最大排队时间不正确:${j["entities"][3]["value"][${hour}]["${hour}"]}
    #排队统计-排队趋势
    ${resp}    /daas/internal/wait/trend    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队趋势不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    cnt_wc    排队趋势排队次数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][0]["${todayBeginTime}"]}==1    排队趋势排队次数不正确:${j["entities"][0]["value"][0]["${todayBeginTime}"]}
    should be equal    ${j["entities"][1]["key"]}    avg_wt    排队趋势平均排队时间不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][0]["${todayBeginTime}"]}>=2    排队趋势平均排队时间不正确:${j["entities"][1]["value"][0]["${todayBeginTime}"]}
    should be equal    ${j["entities"][2]["key"]}    max_wt    排队趋势最大排队时间不正确:${j["entities"][2]["key"]}
    should be true    ${j["entities"][2]["value"][0]["${todayBeginTime}"]}>=2    排队趋势最大排队时间不正确:${j["entities"][2]["value"][0]["${todayBeginTime}"]}
    #客服模式-工作综合
    ${resp}=    /daas/internal/agent/detail/total    ${AdminUser}    ${timeout}    ${conCreateTime}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服模式工作综合不正确:${resp.content}
    should be true    ${j["entities"][0]["avg_ar"]}>=2    客服模式工作综合-平均响应时长不正确:${j["entities"][0]["avg_ar"]}
    should be true    ${j["entities"][0]["avg_fr"]}>=2    客服模式工作综合-平均首响时长不正确:${j["entities"][0]["avg_fr"]}
    should be true    ${j["entities"][0]["avg_vm"]}==1    客服模式工作综合-满意度不正确:${j["entities"][0]["avg_vm"]}
    should be true    ${j["entities"][0]["avg_wt"]}>=2    客服模式工作综合-平均会话时长不正确:${j["entities"][0]["avg_wt"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    客服模式工作综合-接起会话数不正确:${j["entities"][0]["cnt_sc"]}
    should be true    ${j["entities"][0]["cnt_tc"]}==1    客服模式工作综合-结束会话数不正确:${j["entities"][0]["cnt_tc"]}
    #客服模式-消息/会话趋势
    ${resp}=    /daas/internal/agent/detail/trend    ${AdminUser}    ${timeout}    ${conCreateTime}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服模式消息/会话趋势不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    session    客服模式消息/会话趋势-会话数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][0]["${todayBeginTime}"]}==1    客服模式消息/会话趋势-会话数不正确:${j["entities"][0]["value"][0]["${todayBeginTime}"]}
    should be equal    ${j["entities"][1]["key"]}    message    客服模式消息/会话趋势-消息数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][0]["${todayBeginTime}"]}>=3    客服模式消息/会话趋势-消息数不正确:${j["entities"][1]["value"][0]["${todayBeginTime}"]}

单服务无效会话数据验证
    [Documentation]    会话：单服务无效会话、有质检评分
    ...    验证模块：工作质量
    #创建单服务无效会话
    ${conInfo}    One Service Unvalid Conversation    ${AdminUser}    ${restentity}
    ${totalScore}    set variable    ${conInfo.totalScore}
    ${queueentity}    set variable    ${conInfo.queueentityAA}
    ${daasCreateTime}    set variable    ${conInfo.daasCreateTime}
    sleep    2000ms
    set to dictionary    ${FilterEntity}    queueId=${queueentity.queueId}
    #验证工作质量-客服工作质量接口返回值
    ${resp}=    /daas/internal/agent/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作质量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${AdminUser.userId}    客服工作质量-客服有误:${j["entities"][0]["key"]}
    should be equal    ${j["entities"][0]["avg_qm"]}    ${totalScore}    客服工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    100%    客服工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==0    客服工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==1    客服工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==1    客服工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    客服工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    客服工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}
    #验证工作质量-技能组工作质量接口返回值
    ${resp}=    /daas/internal/group/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作质量不正确:${resp.content}
    ${key}    evaluate    int(${j["entities"][0]["key"]})
    should be equal    ${key}    ${queueentity.queueId}    技能组工作量-技能组有误:${j["entities"][0]["key"]}
    should be equal    ${j["entities"][0]["avg_qm"]}    ${totalScore}    技能组工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    100%    技能组工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==0    技能组工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==1    技能组工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==1    技能组工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    技能组工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    技能组工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}
    #验证工作质量-有效人工会话占比
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    工作质量-有效人工会话占比无效数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==0    工作质量-有效人工会话占比有效数不正确:${j["entities"][1]["count"]}
