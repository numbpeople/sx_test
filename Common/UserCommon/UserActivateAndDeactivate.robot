*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/User/UserApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../AppCommon/AppCommon.robot
Resource          UserCommon.robot

*** Keywords ***
Activate User
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    用户账号禁用
    #用户账号禁用
    ${resp}=    /{orgName}/{appName}/users/{userName}/deactivate    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Deactivate User
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    用户账号解禁
    #用户账号解禁
    ${resp}=    /{orgName}/{appName}/users/{userName}/activate    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Activate Temp User
    [Arguments]    ${userName}
    [Documentation]    用户账号禁用
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #用户账号禁用
    &{apiResponse}    Activate User    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    用户账号禁用失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Activate User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    用户账号禁用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${user}    Create Temp User
    ${username}    set variable    ${user['entities'][0]['username']}
    ${nickname}    set variable    ${user['entities'][0]['nickname']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Activate User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${uuid}'    '${username}'    '${nickname}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Deactivate User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    用户账号解禁
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${user}    Create Temp User
    ${username}    set variable    ${user['entities'][0]['username']}
    ${nickname}    set variable    ${user['entities'][0]['nickname']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    #用户账号禁用
    ${activateUser}    Activate Temp User    ${username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Deactivate User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
