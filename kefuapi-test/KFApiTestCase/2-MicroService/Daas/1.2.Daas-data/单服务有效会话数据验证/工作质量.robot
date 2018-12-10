*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Library           json
Library           requests
Library           RequestsLibrary

*** Test Cases ***
客服工作质量
    [Documentation]    【操作步骤】：
    ...    （废弃get接口，改用post）- Step1、获取工作质量-客服工作质量，调用接口：/daas/internal/agent/kpi/wq，接口请求状态码为200。
    ...    - Step1、获取工作质量-客服工作质量，调用接口：/daas/internal/post/agent/kpi/wq，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-客服工作质量接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、key字段的值等于AdminUser.userId，字段avg_ar大于等于2，字段max_ar大于等于2等等。
    #验证工作质量-客服工作质量接口返回值
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
    should be true    ${j["entities"][0]["avg_ar"]}>=2    客服工作质量-响应时长平均值有误:${j["entities"][0]["avg_ar"]}
    should be true    ${j["entities"][0]["max_ar"]}>=2    客服工作质量-响应时长最大值有误:${j["entities"][0]["max_ar"]}
    should be true    ${j["entities"][0]["avg_fr"]}>=2    客服工作质量-首响时长平均值有误:${j["entities"][0]["avg_fr"]}
    should be true    ${j["entities"][0]["max_fr"]}>=2    客服工作质量-首响时长最大值有误:${j["entities"][0]["max_fr"]}
    should be equal    ${j["entities"][0]["avg_qm"]}    ${score}    客服工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be true    ${j["entities"][0]["avg_vm"]}==1    客服工作质量-满意度有误:${j["entities"][0]["avg_vm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    100.00%    客服工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be equal    ${j["entities"][0]["pct_vm"]}    100.00%    客服工作质量-满意度参评率有误:${j["entities"][0]["pct_vm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==1    客服工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==0    客服工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==0    客服工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    客服工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    客服工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}

技能组工作质量
    [Documentation]    【操作步骤】：
    ...    （废弃get接口，改用post）- Step1、获取工作质量-技能组工作质量，调用接口：/daas/internal/group/kpi/wq，接口请求状态码为200。
    ...    - Step1、获取工作质量-技能组工作质量，调用接口：/daas/internal/post/group/kpi/wq，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-技能组工作质量接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、key字段的值等于queueentity.queueId，字段avg_ar大于等于2，字段max_ar大于等于2等等。
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
    should be equal    ${key}    ${queueentity.queueId}    技能组工作量-技能组有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["avg_ar"]}>=2    技能组工作质量-响应时长平均值有误:${j["entities"][0]["avg_ar"]}
    should be true    ${j["entities"][0]["max_ar"]}>=2    技能组工作质量-响应时长最大值有误:${j["entities"][0]["max_ar"]}
    should be true    ${j["entities"][0]["avg_fr"]}>=2    技能组工作质量-首响时长平均值有误:${j["entities"][0]["avg_fr"]}
    should be true    ${j["entities"][0]["max_fr"]}>=2    技能组工作质量-首响时长最大值有误:${j["entities"][0]["max_fr"]}
    should be equal    ${j["entities"][0]["avg_qm"]}    ${score}    技能组工作质量-质检评分有误:${j["entities"][0]["avg_qm"]}
    should be true    ${j["entities"][0]["avg_vm"]}==1    技能组工作质量-满意度有误:${j["entities"][0]["avg_vm"]}
    should be equal    ${j["entities"][0]["pct_qm"]}    100.00%    技能组工作质量-质检参评率有误:${j["entities"][0]["pct_qm"]}
    should be equal    ${j["entities"][0]["pct_vm"]}    100.00%    技能组工作质量-满意度参评率有误:${j["entities"][0]["pct_vm"]}
    should be true    ${j["entities"][0]["cnt_ea"]}==1    技能组工作质量-有效人工会话有误:${j["entities"][0]["cnt_ea"]}
    should be true    ${j["entities"][0]["cnt_ua"]}==0    技能组工作质量-无效人工会话有误:${j["entities"][0]["cnt_ua"]}
    should be true    ${j["entities"][0]["cnt_uaa"]}==0    技能组工作质量-无效人工会话(客服无消息)有误:${j["entities"][0]["cnt_uaa"]}
    should be true    ${j["entities"][0]["cnt_uaav"]}==0    技能组工作质量-无效人工会话有误(均无消息):${j["entities"][0]["cnt_uaav"]}
    should be true    ${j["entities"][0]["cnt_uav"]}==0    技能组工作质量-无效人工会话有误(访客无消息):${j["entities"][0]["cnt_uav"]}

工作质量综合
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-工作质量综合，调用接口：/daas/internal/session/wq/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-工作质量综合接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段avg_ar大于等于2，字段max_ar大于等于2等等。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-满意度评分分布，调用接口：/daas/internal/session/dist/vm，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-满意度评分分布接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于2、字段["entities"][0]["count"]的值等于0，字段["entities"][1]["count"]的值等于1。
    #验证工作质量-满意度评分分布
    ${resp}=    /daas/internal/session/dist/vm    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-满意度评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-满意度评分分布不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==0    工作质量-满意度评分分布图未评数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==1    工作质量-满意度评分分布图已评数不正确:${j["entities"][1]["count"]}

质检评分分布
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-质检评分分布，调用接口：/daas/internal/session/dist/qm，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-质检评分分布接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于2、字段["entities"][0]["count"]的值等于0，字段["entities"][1]["count"]的值等于1等等。
    #验证工作质量-质检评分分布
    ${resp}=    /daas/internal/session/dist/qm    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-质检评分分布不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-质检评分分布不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==0    工作质量-质检评分分布图未评数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==1    工作质量-质检评分分布图已评数不正确:${j["entities"][1]["count"]}
    should be true    ${j["entities"][1]["list"][4]["count"]}==1    工作质量-质检评分分布图已评数的级别不正确:${j["entities"][1]["list"][4]["count"]}

有效人工会话占比
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-有效人工会话占比，调用接口：/daas/internal/session/dist/effective，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-有效人工会话占比接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于2、字段["entities"][0]["count"]的值等于0，字段["entities"][1]["count"]的值等于1。
    #验证工作质量-有效人工会话占比
    ${resp}=    /daas/internal/session/dist/effective    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["totalElements"]}==2    工作质量-有效人工会话占比不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==0    工作质量-有效人工会话占比无效数不正确:${j["entities"][0]["count"]}
    should be true    ${j["entities"][1]["count"]}==1    工作质量-有效人工会话占比有效数不正确:${j["entities"][1]["count"]}

会话数分布图(按首次响应时长维度)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-会话数分布图(按首次响应时长维度)，调用接口：/daas/internal/session/dist/response/first，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-会话数分布图(按首次响应时长维度)接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于5、字段["entities"][0]["count"]的值等于1。
    #验证工作质量-会话数分布图(按首次响应时长维度)返回值
    ${resp}=    /daas/internal/session/dist/response/first    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按首次响应时长维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按首次响应时长维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按首次响应时长维度)-会话数不正确:${j["entities"][0]["count"]}

会话数分布图(按响应时长维度)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取工作质量-会话数分布图(按响应时长维度)，调用接口：/daas/internal/agent/kpi/wq，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作质量-会话数分布图(按响应时长维度)接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于5、字段["entities"][0]["count"]的值等于1。
    #验证工作质量-会话数分布图(按响应时长维度)返回值
    ${resp}=    /daas/internal/session/dist/response/avg    ${AdminUser}    ${timeout}    ${ConDateRange}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按响应时长维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==5    会话数分布图(按响应时长维度)不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    会话数分布图(按响应时长维度)-会话数不正确:${j["entities"][0]["count"]}
