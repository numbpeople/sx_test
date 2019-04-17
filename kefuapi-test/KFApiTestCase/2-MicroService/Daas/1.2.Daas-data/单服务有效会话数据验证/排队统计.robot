*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Library           json
Library           requests
Library           RequestsLibrary

*** Test Cases ***
排队次数与平均排队时间
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-排队次数与平均排队时间，调用接口：/daas/internal/wait/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    排队统计-排队次数与平均排队时间接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段cnt_wc的值等于1，字段avg_wt的值大于等于2。
    #排队统计-排队次数与平均排队时间
    ${filterEntity}    create dictionary    waitTime=1000
    set suite variable    ${filterEntity}    ${filterEntity}
    ${resp}    /daas/internal/wait/total    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队次数与平均排队时间不正确:${resp.content}
    should be true    ${j["entities"][0]["cnt_wc"]}==1    排队次数与平均排队时间不正确:${j["entities"][0]["cnt_wc"]}
    should be true    ${j["entities"][0]["avg_wt"]}>=2    排队次数与平均排队时间不正确:${j["entities"][0]["avg_wt"]}

24小时进线量
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-24小时进线量，调用接口：/daas/internal/wait/hour/create，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    排队统计-24小时进线量接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段["entities"][0]["key"]的值等于session、字段["entities"][1]["key"]的值等于message等等。
    #排队统计-24小时进线量
    ${daasCreateTime1}    evaluate    ${daasCreateTime}/1000
    ${createTimeHour}    Get Time    \    ${daasCreateTime1}
    ${hour}    Get Time    hour    ${createTimeHour}
    set suite variable    ${hour}    ${hour}
    ${resp}    /daas/internal/wait/hour/create    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时进线量不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    session    24小时进线量会话数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][${hour}]["${hour}"]}==1    24小时进线量会话数不正确:${j["entities"][0]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][1]["key"]}    message    24小时进线量消息数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][${hour}]["${hour}"]}>=3    24小时进线量消息数不正确:${j["entities"][1]["value"][${hour}]["${hour}"]}

进线量趋势
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-进线量趋势，调用接口：/daas/internal/wait/day/create，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    排队统计-进线量趋势接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段["entities"][0]["key"]的值等于session、字段["entities"][1]["key"]的值等于message等等。
    #排队统计-进线量趋势
    ${resp}    /daas/internal/wait/day/create    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    进线量趋势不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    session    进线量趋势会话数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}==1    进线量趋势会话数不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}
    should be equal    ${j["entities"][1]["key"]}    message    进线量趋势消息数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][0]["${todayDateRange.beginDateTime}"]}>=3    进线量趋势消息数不正确:${j["entities"][1]["value"][0]["${todayDateRange.beginDateTime}"]}

24小时排队趋势
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-24小时排队趋势，调用接口：/daas/internal/wait/hour/wait，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    排队统计-24小时排队趋势接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段["entities"][0]["key"]的值等于cnt_wc、字段["entities"][1]["key"]的值等于avc_wc等等。
    #排队统计-24小时排队趋势
    ${resp}    /daas/internal/wait/hour/wait    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    24小时排队趋势:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    cnt_wt    24小时排队趋势排队次数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][${hour}]["${hour}"]}==1    24小时排队趋势排队次数不正确:${j["entities"][0]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][1]["key"]}    cnt_avg_wt    24小时排队趋势平均排队次数不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][${hour}]["${hour}"]}==1    24小时排队趋势平均排队次数不正确:${j["entities"][1]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][2]["key"]}    avg_wtt    24小时排队趋势平均排队时间不正确:${j["entities"][2]["key"]}
    should be true    ${j["entities"][2]["value"][${hour}]["${hour}"]}>=2    24小时排队趋势平均排队时间不正确:${j["entities"][2]["value"][${hour}]["${hour}"]}
    should be equal    ${j["entities"][3]["key"]}    max_wtt    24小时排队趋势最大排队时间不正确:${j["entities"][3]["key"]}
    should be true    ${j["entities"][3]["value"][${hour}]["${hour}"]}>=2    24小时排队趋势最大排队时间不正确:${j["entities"][3]["value"][${hour}]["${hour}"]}

排队趋势
    [Documentation]    【操作步骤】：
    ...    - Step1、获取排队统计-排队趋势，调用接口：/daas/internal/wait/trend，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    排队统计-排队趋势接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段["entities"][0]["key"]的值等于cnt_wc、字段["entities"][1]["key"]的值等于avg_wt等等。
    #排队统计-排队趋势
    ${resp}    /daas/internal/wait/trend    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filterEntity}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    排队趋势不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    cnt_wt    排队趋势排队次数不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}==1    排队趋势排队次数不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}
    should be equal    ${j["entities"][1]["key"]}    avg_wtt    排队趋势平均排队时间不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["value"][0]["${todayDateRange.beginDateTime}"]}>=2    排队趋势平均排队时间不正确:${j["entities"][1]["value"][0]["${todayDateRange.beginDateTime}"]}
    should be equal    ${j["entities"][2]["key"]}    max_wtt    排队趋势最大排队时间不正确:${j["entities"][2]["key"]}
    should be true    ${j["entities"][2]["value"][0]["${todayDateRange.beginDateTime}"]}>=2    排队趋势最大排队时间不正确:${j["entities"][2]["value"][0]["${todayDateRange.beginDateTime}"]}
