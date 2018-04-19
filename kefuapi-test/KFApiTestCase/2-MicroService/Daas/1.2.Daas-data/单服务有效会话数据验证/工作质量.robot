*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Library           json
Library           requests
Library           RequestsLibrary

*** Test Cases ***
客服工作质量
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

技能组工作质量
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

工作质量综合
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

满意度评分分布
    #验证工作质量-满意度评分分布
    ${resp}=    /daas/internal/session/dist/vm    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-满意度评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-满意度评分分布不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==0    工作质量-满意度评分分布图未评数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==1    工作质量-满意度评分分布图已评数不正确:${j["entities"][1]["count"]}

有效人工会话占比
    #验证工作质量-有效人工会话占比
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==0    工作质量-有效人工会话占比无效数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==1    工作质量-有效人工会话占比有效数不正确:${j["entities"][1]["count"]}

会话数分布图(按首次响应时长维度)
    #验证工作质量-会话数分布图(按首次响应时长维度)返回值
    ${resp}=    /daas/internal/session/dist/response/first    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按首次响应时长维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按首次响应时长维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按首次响应时长维度)-会话数不正确:${j["entities"][0]["count"]}

会话数分布图(按响应时长维度)
    #验证工作质量-会话数分布图(按响应时长维度)返回值
    ${resp}=    /daas/internal/session/dist/response/avg    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按响应时长维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按响应时长维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按响应时长维度)-会话数不正确:${j["entities"][0]["count"]}
