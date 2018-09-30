*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Library           json
Library           requests
Library           RequestsLibrary

*** Test Cases ***
消息/会话趋势
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服模式-工作综合，调用接口：/daas/internal/agent/detail/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    客服模式-工作综合接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段avg_ar大于等于2、字段avg_fr大于等于2等等、字段avg_vm等于1等等。
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

工作综合
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客服模式-消息/会话趋势，调用接口：/daas/internal/agent/detail/trend，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    客服模式-消息/会话趋势接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、["entities"][0]["key"]字段值等于session、["entities"][1]["key"]字段的值等于message等等。
    #客服模式-消息/会话趋势
    ${resp}=    /daas/internal/agent/detail/trend    ${AdminUser}    ${timeout}    ${conCreateTime}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    客服模式消息/会话趋势不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    session    客服模式消息/会话趋势-会话数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}==1    客服模式消息/会话趋势-会话数不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}
    should be equal    ${j["entities"][1]["key"]}    message    客服模式消息/会话趋势-消息数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][0]["${todayDateRange.beginDateTime}"]}>=3    客服模式消息/会话趋势-消息数不正确:${j["entities"][1]["value"][0]["${todayDateRange.beginDateTime}"]}
