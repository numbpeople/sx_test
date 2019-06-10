*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/Token/TokenApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot

*** Keywords ***
Get Management Token
    [Arguments]    ${session}    ${header}    ${data}
    #获取console后台的登录token
    ${resp}=    /management/token    POST    ${session}    ${header}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get OrgToken Or BestToken Init
    [Documentation]    初始化console后台管理token或设置超管token
    Create Session    session    ${RestRes.RestUrl}
    set to dictionary    ${RestRes}    alias=session
    #设置超管token
    ${specificBestTokenAndAppkeyStatus}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}") and ("${RunModelCaseConditionDic.orgName}" == "${EMPTY}")
    ${bestTokenNotEmpty}    evaluate    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"
    Run Keyword If    ${specificBestTokenAndAppkeyStatus}    FAIL    配置了指定超管token，但是没有配置orgName，请检查变量：RunModelCaseConditionDic 配置
    ${randomNumber}    Generate Random String    10    [NUMBERS]
    Run Keyword And Return If    ${bestTokenNotEmpty}    Get BestToken And Set Global Variable    ${randomNumber}
    #创建获取token的请求体
    ${data}    set variable    {"username":"${RestRes.username}","password":"${RestRes.password}","grant_type":"password"}
    #获取Management Token
    &{apiResponse}    Get Management Token    ${RestRes.alias}    ${requestHeader}    ${data}
    ${expectedStatusCode}    set variable    200
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取console后台token失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    #获取orgName
    @{orgNameList}    Get Dictionary Keys    ${text['user']['organizations']}
    ${orgName}    set variable    ${orgNameList[0]}
    set to dictionary    ${Token}    orgToken=${text['access_token']}
    #设置全局的有效、无效基本数据
    set to dictionary    ${baseRes}    validOrgName=${orgName}    invalidOrgName=${randomNumber}
    set global variable    ${RestRes}    ${RestRes}
    set global variable    ${Token}    ${Token}
    set global variable    ${baseRes}    ${baseRes}

Get BestToken And Set Global Variable
    [Arguments]    ${randomNumber}=
    #设置全局变量
    set to dictionary    ${Token}    bestToken=${RunModelCaseConditionDic.specificBestToken}
    set to dictionary    ${baseRes}    validOrgName=${RunModelCaseConditionDic.orgName}    invalidOrgName=${randomNumber}
    set global variable    ${RestRes}    ${RestRes}
    set global variable    ${Token}    ${Token}
    set global variable    ${baseRes}    ${baseRes}
