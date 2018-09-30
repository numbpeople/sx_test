*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Supervision/SupervisionApi.robot
Resource          ../../Base Common/Base_Common.robot

*** Keywords ***
Get Monitor Agentqueues
    [Arguments]    ${agent}
    [Documentation]    获取现场管理的技能组列表
    #获取现场管理的技能组列表
    ${resp}=    /v1/monitor/agentqueues    ${agent}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取现场管理的技能组列表，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Get Monitor Agentqueues Data
    [Arguments]    ${agent}    ${queueId}
    [Documentation]    获取现场管理的技能组列表
    #获取现场管理的技能组列表
    ${resp}=    /v1/monitor/agentusers    ${agent}    ${queueId}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取现场管理的技能组列表，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Get Monitor Agentusers
    [Arguments]    ${agent}    ${queueId}
    [Documentation]    获取现场管理的技能组中的坐席列表
    #获取现场管理的技能组中的坐席列表
    :FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${apiResponse}    Get Monitor Agentqueues Data    ${agent}    ${queueId}
    \    Should Be Equal As Integers    ${apiResponse.statusCode}    200    发生异常，状态不等于200：${apiResponse.describetion}
    \    ${j}    set variable    ${apiResponse.text}
    \    ${length}    get length    ${j['entities']}
    \    Return From Keyword If    ${length} > 0    ${apiResponse}
    set to dictionary    ${apiResponse}    status=${ResponseStatus.FAIL}
    Return From Keyword    ${apiResponse}
