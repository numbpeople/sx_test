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
    ...
    ...    【参数值】：
    ...    - ${functionName} ，代表接口封装后的关键字
    ...    - ${expectConstruction} ，接口返回值中应取的字段结构
    ...    - ${expectValue} ，获取接口某字段的预期值
    ...    - @{paramList}，接口封装后所需要传入的参数值
    ...
    ...    【返回值】：
    ...    - 调用${functionName}接口，返回结果中，匹配${expectConstruction}字段结构，值等于${expectValue}的数据结构
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    run keyword    ${functionName}    @{paramList}
    \    Continue For Loop If    "${j}" == "[]"
    \    ${dataRes}    set variable    ${j${expectConstruction}}    #想要获取返回值中应取的字段结构，即${j}返回值中，获取${expectConstruction}结构的值 ，例如：${j['data'][0]}
    \    return from keyword if    "${dataRes}" == "${expectValue}"    ${j}
    \    sleep    ${delay}
    return from keyword    {}

Set Option
    [Arguments]    ${agent}    ${optionname}    ${value}
    [Documentation]    1.${optionname} \ ${value} 的值不能加引号
    ...    2.${value}的值只能为小写的true和false
    ${data}    set variable    {"value":${value}}
    ${resp}=    /tenants/{tenantId}/options/{optionName}    ${agent}    put    ${optionname}    ${data}    ${timeout}

Return Result
    [Arguments]    ${resp}
    [Documentation]    封装返回值结果
    ...
    ...    【参数值】：
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${resp} | 必填 | 接口返回的对象，其中包含请求地址、状态码、返回值，例如：${AdminUser} |
    ...
    ...    【返回值】
    ...    | 进行二次封装，将请求地址、状态码、返回值进行返回：url、status、text |
    ...
    ...    【调用方式】
    ...    | 获取进行中会话 | ${j} | Return Result | ${resp} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 构造返回字典，返回请求地址、状态码、返回值：url、status、text |
    ...    | Step 2 | 如果请求返回值为空，则返回值为空字符串 |
    #构造返回字典
    &{result}    create dictionary
    ${text}    set variable    ${EMPTY}
    #如果返回值resp.text不为空，则设置返回值，否则text设置为空值
    ${status}    Run Keyword And Return Status    Should Not Be Equal    "${resp.text}"    "${EMPTY}"
    set to dictionary    ${result}    url=${resp.url}    status=${resp.status_code}    text=${text}
    Run Keyword And Return If    not ${status}    ${result}
    #设置请求返回值
    ${text}    to json    ${resp.text}
    set to dictionary    ${result}    url=${resp.url}    status=${resp.status_code}    text=${text}
    Return From Keyword    ${result}
