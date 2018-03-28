*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Supervision/SupervisionApi.robot

*** Keywords ***
Get Monitor Agentqueues
    [Arguments]    ${agent}
    [Documentation]    获取现场管理的技能组列表
    #获取现场管理的技能组列表
    ${resp}=    /v1/monitor/agentqueues    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} ,${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Monitor Agentusers
    [Arguments]    ${agent}    ${queueId}
    [Documentation]    获取现场管理的技能组中的坐席列表
    #获取现场管理的技能组中的坐席列表
    :FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/monitor/agentusers    ${agent}    ${queueId}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} ,${resp.text}
    \    ${j}    to json    ${resp.text}
    \    ${length}    get length    ${j['entities']}
    \    Return From Keyword If    ${length} > 0    ${j}
    Return From Keyword    {}
