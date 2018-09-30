*** Settings ***
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../api/MicroService/Daas/DaasApi.robot
Library           json
Library           requests
Library           RequestsLibrary
Library           Collections

*** Test Cases ***
独立访客数-按渠道
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客数按渠道，调用接口：/daas/internal/visitor/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客数按渠道接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段["entities"][0]["count"]的值等于1。
    #验证访客统计-独立访客数按渠道
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_ORIGINTYPE
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数不正确:${j["entities"][0]["count"]}

独立访客趋势图-按渠道
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客趋势图按渠道，调用接口：/daas/internal/visitor/trend，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客趋势图按渠道接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于7、字段["entities"][2]["type"]的值等于weixin等等。
    #验证访客统计-独立访客趋势图按渠道
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_ORIGINTYPE
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数趋势图不正确:${resp.content}
    should be equal    ${j["entities"][2]["type"]}    weixin    独立访客数趋势图不正确:${j["entities"][2]["type"]}
    should be true    ${j["entities"][2]["value"][0]["${todayDateRange.beginDateTime}"]}==1    独立访客数趋势图不正确:${j["entities"][2]["value"][0]["${todayDateRange.beginDateTime}"]}

按渠道展示列表
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-按渠道展示列表，调用接口：/daas/internal/visitor/count，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-按渠道展示列表接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于7、字段["entities"][0]["key"]的值等于weixin等等。
    #验证访客统计-按渠道展示列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_ORIGINTYPE
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数按渠道展示列表不正确:${resp.content}
    should be true    ${j["totalElements"]}==7    独立访客数按渠道展示列表不正确:${resp.content}
    should be equal    ${j["entities"][0]["key"]}    weixin    独立访客数按渠道展示列表不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数按渠道展示列表不正确:${j["entities"][0]["count"]}

独立访客数-按关联
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客数按关联，调用接口：/daas/internal/visitor/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客数按关联接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段["entities"][0]["count"]的值等于1。
    #验证访客统计-独立访客数按关联
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_CHANNEL
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数不正确:${j["entities"][0]["count"]}

独立访客趋势图-按关联
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客趋势图按关联，调用接口：/daas/internal/visitor/trend，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客趋势图按关联接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段["entities"][0]["type"]的值等于channelId等等。
    #验证访客统计-独立访客趋势图按关联
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_CHANNEL
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数趋势图不正确:${resp.content}
    should be equal    ${j["entities"][0]["type"]}    channelId    独立访客数趋势图不正确:${j["entities"][0]["type"]}
    should be true    ${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}==1    独立访客数趋势图不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}

按关联展示列表
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-按关联展示列表，调用接口：/daas/internal/visitor/count，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-按关联展示列表接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段["entities"][0]["key"]的值等于restentity.channelId等等。
    #验证访客统计-按关联展示列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_CHANNEL
    log    ${restentity.channelId}
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数按关联展示列表不正确:${resp.content}
    should be equal    "${j["entities"][0]["key"]}"    "${restentity.channelId}"    独立访客数按关联展示列表不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数按关联展示列表不正确:${j["entities"][0]["count"]}

独立访客数-按客户标签
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客数按客户标签，调用接口：/daas/internal/visitor/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客数按客户标签接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段["entities"][0]["count"]的值等于1。
    #验证访客统计-独立访客数按客户标签
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_VISITORTAG
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数不正确:${j["entities"][0]["count"]}

独立访客趋势图-按客户标签
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客趋势图按客户标签，调用接口：/daas/internal/visitor/trend，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客趋势图按客户标签接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段["entities"][0]["type"]的值等于visitorTag等等。
    #验证访客统计-独立访客趋势图按客户标签
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_VISITORTAG
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数趋势图不正确:${resp.content}
    should be equal    ${j["entities"][0]["type"]}    visitorTag    独立访客数趋势图不正确:${j["entities"][0]["type"]}
    should be true    ${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}==1    独立访客数趋势图不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}

按客户标签展示列表
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-按客户标签展示列表，调用接口：/daas/internal/visitor/count，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-按客户标签展示列表接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段["entities"][0]["key"]的值等于-1等等。
    #验证访客统计-按客户标签展示列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_VISITORTAG
    log    ${restentity.channelId}
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数按客户标签展示列表不正确:${resp.content}
    should be true    ${j["entities"][0]["key"]}==-1    独立访客数按客户标签展示列表不正确:${j["entities"][0]["key"]}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数按客户标签展示列表不正确:${j["entities"][0]["count"]}

独立访客数-按访问次数
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客数按访问次数，调用接口：/daas/internal/visitor/total，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客数按访问次数接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于1、字段["entities"][0]["count"]的值等于1。
    #验证访客统计-独立访客数按访问次数
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_VISITCOUNT
    ${resp}=    /daas/internal/visitor/total    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数不正确:${resp.content}
    should be true    ${j["totalElements"]}==1    独立访客数不正确:${resp.content}
    should be true    ${j["entities"][0]["count"]}==1    独立访客数不正确:${j["entities"][0]["count"]}

独立访客趋势图-按访问次数
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-独立访客趋势图按访问次数，调用接口：/daas/internal/visitor/trend，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-独立访客趋势图按访问次数接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、totalElements字段值等于3、字段["entities"][0]["type"]的值等于one等等。
    #验证访客统计-独立访客趋势图按访问次数
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_VISITCOUNT
    ${resp}=    /daas/internal/visitor/trend    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数趋势图不正确:${resp.content}
    should be true    ${j["totalElements"]}==3    独立访客数趋势图不正确:${resp.content}
    should be equal    ${j["entities"][0]["type"]}    one    独立访客数趋势图不正确:${j["entities"][0]["type"]}
    should be true    ${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}==1    独立访客数趋势图不正确:${j["entities"][0]["value"][0]["${todayDateRange.beginDateTime}"]}

按访问次数展示列表
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客统计-按访问次数展示列表，调用接口：/daas/internal/visitor/count，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    访客统计-按访问次数展示列表接口请求，状态码正常，返回值与期望一致。
    ...    status字段的值等于OK、字段["entities"][1]["key"]的值等于cnt_vc1等等。
    #验证访客统计-按访问次数展示列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    queryType=V_VISITCOUNT
    log    ${restentity.channelId}
    ${resp}=    /daas/internal/visitor/count    ${AdminUser}    ${timeout}    ${conCreateTime}    ${filter}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j["status"]}    OK    独立访客数按客户标签展示列表不正确:${resp.content}
    should be equal    ${j["entities"][1]["key"]}    cnt_vc1    独立访客数按访问次数展示列表不正确:${j["entities"][1]["key"]}
    should be true    ${j["entities"][1]["count"]}==1    独立访客数按访问次数展示列表不正确:${j["entities"][1]["count"]}
