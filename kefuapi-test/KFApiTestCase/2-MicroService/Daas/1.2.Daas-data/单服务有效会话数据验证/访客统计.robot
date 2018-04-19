*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Library           json
Library           requests
Library           RequestsLibrary

*** Test Cases ***
独立访客数
    #验证访客统计-独立访客数按渠道
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${conCreateTime}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数不正确:${j["entities"][0]["count"]}

独立访客趋势图
    #验证访客统计-独立访客趋势图按渠道
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${conCreateTime}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数趋势图不正确:${resp.content}
    should be equal    ${j["entities"][2]["type"]}    weixin    独立访客数趋势图不正确:${j["entities"][2]["type"]}
    should be true    ${j["entities"][2]["value"][0]["${todayDateRange.beginDateTime}"]}==1    独立访客数趋势图不正确:${j["entities"][2]["value"][0]["${todayDateRange.beginDateTime}"]}

按渠道展示列表
    #验证访客统计-按渠道展示列表
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${conCreateTime}    ${FilterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数按渠道展示列表不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数按渠道展示列表不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    weixin    独立访客数按渠道展示列表不正确:${j["entities"][3]["key"]}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数按渠道展示列表不正确:${j["entities"][3]["count"]}
