*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Library           pabot.PabotLib
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
    #设置超管token
    ${specificBestTokenAndAppkeyStatus}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}") and ("${RunModelCaseConditionDic.orgName}" == "${EMPTY}")    #检查配置超管token，但未配置orgName
    ${bestTokenNotEmpty}    evaluate    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    #检查超管token不为空
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
    # Comment    ${orgName}    set variable    ${orgNameList[0]}
    ${orgName}    run keyword if    ("${RunModelCaseConditionDic.orgName}" != "${EMPTY}") and ("${RunModelCaseConditionDic.appName}" != "${EMPTY}")    Set Variable    ${RunModelCaseConditionDic.orgName}
    ...    ELSE    Set Variable    ${orgNameList[0]}
    set to dictionary    ${Token}    orgToken=${text['access_token']}
    #设置全局的有效、无效基本数据
    set to dictionary    ${baseRes}    validOrgName=${orgName}    invalidOrgName=${randomNumber}
    set global variable    ${RestRes}    ${RestRes}
    set global variable    ${Token}    ${Token}
    set global variable    ${baseRes}    ${baseRes}
    Set Parallel Value For Key    ParallelRestRes    ${RestRes}
    Set Parallel Value For Key    ParallelToken    ${Token}
    Set Parallel Value For Key    ParallelbaseRes    ${baseRes}

Get BestToken And Set Global Variable
    [Arguments]    ${randomNumber}=
    [Documentation]    ${RunModelCaseConditionDic}配置了超管token，超管token和orgName为全局变量
    #设置全局变量
    set to dictionary    ${Token}    bestToken=${RunModelCaseConditionDic.specificBestToken}
    set to dictionary    ${baseRes}    validOrgName=${RunModelCaseConditionDic.orgName}    invalidOrgName=${randomNumber}
    set global variable    ${RestRes}    ${RestRes}
    set global variable    ${Token}    ${Token}
    set global variable    ${baseRes}    ${baseRes}
    Set Parallel Value For Key    ParallelRestRes    ${RestRes}
    Set Parallel Value For Key    ParallelToken    ${Token}
    Set Parallel Value For Key    ParallelbaseRes    ${baseRes}
    
# Set App Token Expire Tmplate
#     [Documentation]    设置apptoken过期时间
#     [Arguments]    ${method}
#     #获取app token
#     token
Set User Token Expire Tmplate