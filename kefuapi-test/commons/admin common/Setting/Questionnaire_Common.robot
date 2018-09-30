*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/QuestionnaireApi.robot

*** Keywords ***
Set Questionnaire
    [Arguments]    ${agent}    ${method}    ${data}
    [Documentation]    操作问卷调查，包括增删查
    #操作问卷调查
    ${resp}=    /v1/tenants/{tenantId}/questionnaires/accounts    ${AdminUser}    ${timeout}    ${method}    ${data}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：操作问卷调查，包括增删查，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Get Questionnaires List
    [Arguments]    ${type}
    [Documentation]    获取问卷调查列表
    #获取问卷调查列表
    ${resp}=    /v1/tenants/{tenantId}/questionnaires/list    ${AdminUser}    ${timeout}    ${type}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取问卷调查列表，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}
