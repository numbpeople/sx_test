*** Settings ***
Default Tags      daas
Resource          ../../../../../commons/admin common/Daas/Daas_Common.robot
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           DateTime
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Resource          ../../../../../api/BaseApi/Review/QualityReviews_Api.robot

*** Test Cases ***
客服工作质量
    [Documentation]    【操作步骤】：
    ...    （废弃get接口，改用post）- Step1、获取工作质量-客服工作质量，调用接口：/daas/internal/agent/kpi/wq，接口请求状态码为200。
    ...    - Step1、获取工作质量-客服工作质量，调用接口：/daas/internal/post/agent/kpi/wq，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-客服工作质量接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、key字段的值等于AdminUser.userId，字段avg_qm等于totalScore等等。
    #验证工作质量-客服工作质量接口返回值
    log dictionary    ${ConDateRange}
    #get接口
    #${resp}=    /daas/internal/agent/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    #post接口
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"","sessionType":"${FilterEntity.sessionType}","originType":[],"agentId":["${AdminUser.userId}"],"objectType":"O_AGENT","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/agent/kpi/wq    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作质量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${AdminUser.userId}    客服工作质量-客服有误:${j["entities"][0]["key"]}
    should be equal    ${j["entities"][0]["avg_qm"]}    ${totalScore}    客服工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    100.00%    客服工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==0    客服工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==1    客服工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==1    客服工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    客服工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    客服工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}
    #验证评价率
    should be equal    ${j["entities"][0]["pct_eva"]}    0.00%    客服工作质量-客服评价率有误:${j["entities"][0]["pct_eva"]}
    should be true    "${j["entities"][0]["cnt_vm"]}"=="0"    客服工作质量-有效评价数有误:${j["entities"][0]["cnt_vm"]}
    should be true    "${j["entities"][0]["cnt_eva"]}"=="1.0"    客服工作质量-有效邀请数有误:${j["entities"][0]["cnt_eva"]}

技能组工作质量
    [Documentation]    【操作步骤】：
    ...    （废弃get接口，改用post）- Step1、获取工作质量-技能组工作质量，调用接口：/daas/internal/group/kpi/wq，接口请求状态码为200。
    ...    - Step1、获取工作质量-技能组工作质量，调用接口：/daas/internal/post/group/kpi/wq，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-技能组工作质量接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、key字段的值等于FilterEntity.queueId，字段avg_qm等于totalScore等等。
    #验证工作质量-技能组工作质量接口返回值
    #get接口
    #${resp}=    /daas/internal/group/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
    #post接口
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"satisfactionTag":"all","sessionTag":"all","sessionType":"${FilterEntity.sessionType}","originType":[],"groupId":["${FilterEntity.queueId}"],"objectType":"O_GROUP","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/group/kpi/wq    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服工作质量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作质量不正确:${resp.content}
    ${key}    evaluate    int(${j["entities"][0]["key"]})
    should be equal    ${key}    ${FilterEntity.queueId}    技能组工作量-技能组有误:${j["entities"][0]["key"]}
    should be equal    ${j["entities"][0]["avg_qm"]}    ${totalScore}    技能组工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    100.00%    技能组工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==0    技能组工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==1    技能组工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==1    技能组工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    技能组工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    技能组工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}

有效人工会话占比
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-有效人工会话占比，调用接口：/daas/internal/session/dist/effective，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-有效人工会话占比接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于2等等。
    #验证工作质量-有效人工会话占比
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    工作质量-有效人工会话占比无效数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==0    工作质量-有效人工会话占比有效数不正确:${j["entities"][1]["count"]}
