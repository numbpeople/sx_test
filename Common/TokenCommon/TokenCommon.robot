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
    [Arguments]    ${method}    ${session}    ${header}    ${data}
    # 获取console后台的登录token
    ${resp}=    /management/token    ${method}    ${session}    ${header}    data=${data}
    # 断言接口是否为200
    ${apiStatus}    Run Keyword And Return Status    Should Be Equal As Integers    ${resp.status_code}    200
    &{apiResponse}    Return Result    ${resp}
    # 如果接口不为200，则设置返回status为FAIL，并将错误结果置入返回值中
    run keyword if    not ${apiStatus}    set to dictionary    ${apiResponse}    status=${ResponseStatus.FAIL}    errorDescribetion=【实际结果】：获取进行中会话接口，返回状态码不等于200，实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Get Org Token
    Create Session    session    ${RestRes.RestUrl}
    set to dictionary    ${RestRes}    alias=session
    #设置超管token
    ${specificBestTokenAndAppkeyStatus}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}") and ("${RunModelCaseConditionDic.orgName}" == "${EMPTY}")
    ${bestTokenNotEmpty}    evaluate    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"
    Run Keyword If    ${specificBestTokenAndAppkeyStatus}    FAIL    配置了指定超管token，但是没有配置orgName，请检查变量：RunModelCaseConditionDic 配置
    ${randomNumber}    Generate Random String    10    [NUMBERS]
    Run Keyword If    ${bestTokenNotEmpty}    set to dictionary    ${Token}    bestToken=${RunModelCaseConditionDic.specificBestToken}
    Run Keyword If    ${bestTokenNotEmpty}    set to dictionary    ${baseRes}    validOrgName=${RunModelCaseConditionDic.orgName}    invalidOrgName=${randomNumber}
    Run Keyword If    ${bestTokenNotEmpty}    set global variable    ${RestRes}    ${RestRes}
    Run Keyword If    ${bestTokenNotEmpty}    set global variable    ${Token}    ${Token}
    Run Keyword If    ${bestTokenNotEmpty}    set global variable    ${baseRes}    ${baseRes}
    Return From Keyword If    ${bestTokenNotEmpty}
    #创建获取token的请求体
    ${data}    set variable    {"username":"${RestRes.username}","password":"${RestRes.password}","grant_type":"password"}
    #获取Management Token
    &{apiResponse}    Get Management Token    POST    ${RestRes.alias}    ${requestHeader}    ${data}
    Should Be Equal    ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
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
