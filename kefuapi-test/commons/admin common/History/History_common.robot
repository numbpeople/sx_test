*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/KefuApi.robot
Resource          ../../../api/RoutingApi.robot

*** Keywords ***
Search History
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}
    [Documentation]    根据查询条件查询历史会话
    ...
    ...    describtion：
    ...    ${agent}:坐席信息
    ...    ${filter}:筛选条件
    ...    ${date}:日期条件
    ...    ${retryTimes}:请求重试次数
    ...
    ...    返回值：
    ...    ${true}|${false}：有|无查询结果
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['total_entries']} ==1
    \    sleep    ${delay}
    Return From Keyword if    ${j['total_entries']} ==1    ${true}    ${false}
