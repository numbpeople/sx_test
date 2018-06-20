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
    #验证工作质量-客服工作质量接口返回值
    log dictionary    ${ConDateRange}
    ${resp}=    /daas/internal/agent/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
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

技能组工作质量
    #验证工作质量-技能组工作质量接口返回值
    ${resp}=    /daas/internal/group/kpi/wq    ${AdminUser}    ${timeout}    ${ConDateRange}    ${FilterEntity}
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
    #验证工作质量-有效人工会话占比
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    工作质量-有效人工会话占比无效数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==0    工作质量-有效人工会话占比有效数不正确:${j["entities"][1]["count"]}
