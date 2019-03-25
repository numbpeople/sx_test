*** Settings ***
Suite Setup       Transfer Conversation Setup
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
客服工作量
    [Documentation]    【操作步骤】：
    ...    - Step1、suite的setup负责创建一个转接的会话，最终为会话打标签并关闭会话，记录会话的接起时间范围。
    ...    - Step2、根据会话接起时间范围及坐席id，筛选出第一个服务的客服工作量的统计数据，调用接口：/daas/internal/agent/kpi/wl，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...    - Step4、根据会话接起时间范围及坐席id，筛选出第二个服务的客服工作量的统计数据，调用接口：/daas/internal/agent/kpi/wl，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、key字段值等于服务的坐席id、cnt_oc字段值等于接入会话数等。
    #验证转接会回话的第一个服务数据是否正确
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"","sessionType":"${FilterEntity.sessionType}","originType":[],"agentId":["${AdminUser.userId}"],"objectType":"O_AGENT","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/agent/kpi/wl    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    should be equal    ${j["status"]}    OK    客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${AdminUser.userId}    客服工作量-客服有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["cnt_oc"]}==1    客服工作量-接入会话数有误:${j["entities"][0]["cnt_oc"]}
    should be true    ${j["entities"][0]["cnt_sac"]}==0    客服工作量-回呼会话数有误:${j["entities"][0]["cnt_sac"]}
    should be true    ${j["entities"][0]["cnt_svc"]}==1    客服工作量-呼入会话数有误:${j["entities"][0]["cnt_svc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    客服工作量-接起会话数有误:${j["entities"][0]["cnt_sc"]}
    should be true    ${j["entities"][0]["cnt_sdc"]}==1    客服工作量-接起次数有误:${j["entities"][0]["cnt_sdc"]}
    should be true    ${j["entities"][0]["cnt_tc"]}==0    客服工作量-结束会话数有误:${j["entities"][0]["cnt_tc"]}
    should be true    ${j["entities"][0]["cnt_tic"]}==0    客服工作量-转入会话数有误:${j["entities"][0]["cnt_tic"]}
    should be true    ${j["entities"][0]["cnt_toc"]}==1    客服工作量-转出会话数有误:${j["entities"][0]["cnt_toc"]}
    #验证转接会回话的第二个服务数据是否正确
    ${data}    set variable    {"beginDateTime":${ConDateRange.beginDateTime},"endDateTime":${ConDateRange.endDateTime},"channelId":[],"sessionTag":"","sessionType":"${FilterEntity.sessionType}","originType":[],"agentId":["${transferConversationInfo.transferAgentUserId}"],"objectType":"O_AGENT","page":${FilterEntity.page},"pageSize":${FilterEntity.per_page},"order":""}
    ${resp}=    /daas/internal/post/agent/kpi/wl    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    should be equal    ${j["status"]}    OK    客服工作量不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    客服工作量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    ${transferConversationInfo.transferAgentUserId}    客服工作量-客服有误:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["cnt_oc"]}==0    客服工作量-接入会话数有误:${j["entities"][0]["cnt_oc"]}
    should be true    ${j["entities"][0]["cnt_sac"]}==0    客服工作量-回呼会话数有误:${j["entities"][0]["cnt_sac"]}
    should be true    ${j["entities"][0]["cnt_svc"]}==1    客服工作量-呼入会话数有误:${j["entities"][0]["cnt_svc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    客服工作量-接起会话数有误:${j["entities"][0]["cnt_sc"]}
    should be true    ${j["entities"][0]["cnt_sdc"]}==1    客服工作量-接起次数有误:${j["entities"][0]["cnt_sdc"]}
    should be true    ${j["entities"][0]["cnt_tc"]}==1    客服工作量-结束会话数有误:${j["entities"][0]["cnt_tc"]}
    should be true    ${j["entities"][0]["cnt_tic"]}==1    客服工作量-转入会话数有误:${j["entities"][0]["cnt_tic"]}
    should be true    ${j["entities"][0]["cnt_toc"]}==0    客服工作量-转出会话数有误:${j["entities"][0]["cnt_toc"]}

工作量-按会话标签(全部会话)筛选
    [Documentation]    【操作步骤】：
    ...    - Step1、设置筛选条件会话标签的的值为all。
    ...    - Step2、获取工作量-工作量综合，调用接口：/daas/internal/session/wl/total，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...    - Step4、获取工作量-会话数分布按标签维度，调用接口：/daas/internal/session/dist/session/tag，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-工作量综合接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1等。
    ...    工作量-会话数分布按标签维度接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK等。
    #按会话标签（全部会话）筛选
    ${filter}    Copy Dictionary    ${FilterEntity}
    Set To Dictionary    ${filter}    sessionTag=all
    #验证工作量综合接口的返回值
    ${resp}=    /daas/internal/session/wl/total    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作量综合不正确:${resp.content}
    should be true    ${j["entities"][0]["cnt_ssc"]}==1    工作量综合-接起会话数有误:${j["entities"][0]["cnt_ssc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    工作量综合-结束会话数有误:${j["entities"][0]["cnt_sc"]}
    #验证会话数分布（按会话标签维度）接口返回值
    ${resp}=    /daas/internal/session/dist/session/tag    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话标签维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==${transferConversationInfo.tagLength}    会话数分布图（按会话标签维度）不正确:${resp.content}
    ${count}=    Find Tag Count    @{j["entities"]}
    should be true    ${count}    会话数分布图（按会话标签维度）key不正确:${j}
    should be true    ${count} == 1    会话数分布图（按会话标签维度）count不正确:${j}

工作量-按会话标签(全部会话标签)筛选
    [Documentation]    【操作步骤】：
    ...    - Step1、设置筛选条件会话标签的的值为yes。
    ...    - Step2、获取工作量-工作量综合，调用接口：/daas/internal/session/wl/total，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...    - Step4、获取工作量-会话数分布按标签维度，调用接口：/daas/internal/session/dist/session/tag，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-工作量综合接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1等。
    ...    工作量-会话数分布按标签维度接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK等。
    #按会话标签（全部会话标签）筛选
    ${filter}    Copy Dictionary    ${FilterEntity}
    Set To Dictionary    ${filter}    sessionTag=yes
    #验证工作量综合接口的返回值
    ${resp}=    /daas/internal/session/wl/total    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作量综合不正确:${resp.content}
    should be true    ${j["entities"][0]["cnt_ssc"]}==1    工作量综合-接起会话数有误:${j["entities"][0]["cnt_ssc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    工作量综合-结束会话数有误:${j["entities"][0]["cnt_sc"]}
    #验证会话数分布（按会话标签维度）接口返回值
    ${resp}=    /daas/internal/session/dist/session/tag    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话标签维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==${transferConversationInfo.tagLength}    会话数分布图（按会话标签维度）不正确:${resp.content}
    ${count}=    Find Tag Count    @{j["entities"]}
    should be true    ${count}    会话数分布图（按会话标签维度）key不正确:${j}
    should be true    ${count} == 1    会话数分布图（按会话标签维度）count不正确:${j}

工作量-按会话标签(指定标签)筛选
    [Documentation]    【操作步骤】：
    ...    - Step1、设置筛选条件会话标签的的值为suite setup 中为会话所打的标签id。
    ...    - Step2、获取工作量-工作量综合，调用接口：/daas/internal/session/wl/total，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...    - Step4、获取工作量-会话数分布按标签维度，调用接口：/daas/internal/session/dist/session/tag，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-工作量综合接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1等。
    ...    工作量-会话数分布按标签维度接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK等。
    #按会话标签（指定标签）筛选
    ${filter}    Copy Dictionary    ${FilterEntity}
    Set To Dictionary    ${filter}    sessionTag=${transferConversationInfo.tagId}
    #验证工作量综合接口的返回值
    ${resp}=    /daas/internal/session/wl/total    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作量综合不正确:${j}
    should be true    ${j["entities"][0]["cnt_ssc"]}==1    工作量综合-接起会话数有误:${j["entities"][0]["cnt_ssc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==1    工作量综合-结束会话数有误:${j["entities"][0]["cnt_sc"]}
    #验证会话数分布（按会话标签维度）接口返回值
    ${resp}=    /daas/internal/session/dist/session/tag    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话标签维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    会话数分布图（按会话标签维度）不正确:${j}
    should be equal    "${j["entities"][0]["key"]}"    "${transferConversationInfo.tagId}"    会话数分布图（按会话标签维度）不正确:${j}
    should be equal    ${${j["entities"][0]["count"]}}    ${1}    会话数分布图（按会话标签维度）不正确:${j}

工作量-按会话标签(无标签)筛选
    [Documentation]    【操作步骤】：
    ...    - Step1、设置筛选条件会话标签的的值为no。
    ...    - Step2、获取工作量-工作量综合，调用接口：/daas/internal/session/wl/total，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...    - Step4、获取工作量-会话数分布按标签维度，调用接口：/daas/internal/session/dist/session/tag，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    工作量-工作量综合接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1等。
    ...    工作量-会话数分布按标签维度接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK等。
    #按会话标签（无标签）筛选
    ${filter}    Copy Dictionary    ${FilterEntity}
    Set To Dictionary    ${filter}    sessionTag=no
    #验证工作量综合接口的返回值
    ${resp}=    /daas/internal/session/wl/total    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    工作量综合不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    工作量综合不正确:${j}
    should be true    ${j["entities"][0]["cnt_ssc"]}==0    工作量综合-接起会话数有误:${j["entities"][0]["cnt_ssc"]}
    should be true    ${j["entities"][0]["cnt_sc"]}==0    工作量综合-结束会话数有误:${j["entities"][0]["cnt_sc"]}
    #验证会话数分布（按会话标签维度）接口返回值
    ${resp}=    /daas/internal/session/dist/session/tag    ${AdminUser}    ${timeout}    ${ConDateRange}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    会话数分布图(按会话标签维度)不正确:${resp.content}
    should be true    ${j["totalElements"]}==0    会话数分布图（按会话标签维度）不正确:${j}
