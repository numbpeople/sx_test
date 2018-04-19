*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/InitApi.robot

*** Keywords ***
Get Option Value
    [Arguments]    ${agent}    ${optionname}
    ${resp}=    /tenants/{tenantId}/options/{optionName}    ${agent}    get    ${optionname}    ${empty}    ${timeout}
    return from Keyword if    ${resp.status_code}==404    false
    ${j}    to json    ${resp.text}
    Return from Keyword    ${j['data'][0]['optionValue']}

Repeat Keyword Times
    [Arguments]    ${functionName}    ${expectConstruction}    ${expectValue}    @{paramList}
    [Documentation]    重试调用接口多次，判断结果是否包含预期的值，包含则返回结果，否则返回{}
    ...    - param：${functionName} ，代表接口封装后的关键字
    ...    - param：${expectConstruction} ，接口返回值中应取的字段结构
    ...    - param： ${expectValue} ，获取接口某字段的预期值
    ...    - param：@{paramList}，接口封装后所需要传入的参数值
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    run keyword    ${functionName}    @{paramList}
    \    Continue For Loop If    "${j}" == "[]"
    \    ${dataRes}    set variable    ${j${expectConstruction}}    #想要获取返回值中应取的字段结构，即${j}返回值中，获取${expectConstruction}结构的值 ，例如：${j['data'][0]}
    \    return from keyword if    "${dataRes}" == "${expectValue}"    ${j}
    \    sleep    ${delay}
    return from keyword    {}
