*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/User/UserApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../AppCommon/AppCommon.robot

*** Keywords ***
Create User
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    创建应用app下的用户
    # 创建应用app
    ${resp}=    /{orgName}/{appName}/users    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Create Temp User
    [Documentation]    创建一个新的应用APP
    #创建获取token的请求体
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    ${data}    set variable    {"username":"${randoNumber}","password":"${randoNumber}","nickname":"${randoNumber}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #给相应变量赋值
    log    ${Token}
    ${newToken}    set variable    ${Token.orgToken}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set suite variable    ${newToken}    ${RunModelCaseConditionDic.specificBestToken}
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${newRequestHeader}    Authorization=Bearer ${newToken}
    #创建用户
    &{apiResponse}    Create User    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal    ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Create Exist User Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    创建已存在用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 存在指定APPKEY后，是否执行该条用例
    ...    - 指定超级管理员token，是否执行该条用例
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${data}    set variable    {"username":"${baseRes.validIMUser}","password":"${baseRes.validIMUser}","nickname":"${baseRes.validIMUser}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    ${argument}    set variable    '${baseRes.validAppUUID}'
    @{argumentField}    create list    ${argument}
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New User Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    创建新的用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 存在指定appkey
    ...    - 存在指定APPKEY后，是否执行该条用例
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    ${data}    set variable    {"username":"${randoNumber}","password":"${randoNumber}","nickname":"${randoNumber}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randoNumber}'    '${randoNumber}'    '${baseRes.validOrgName}'    '${baseRes.validAppName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New User With Illegal UserName Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    创建新的用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 存在指定appkey
    ...    - 存在指定APPKEY后，是否执行该条用例
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    ${username}    set variable    ${EMPTY}
    ${password}    set variable    ${randoNumber}
    ${data}    set variable    {"username":"${username}","password":"${password}","nickname":"${randoNumber}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${username}'
    @{argumentValue}    create list    '${username}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New User With Illegal Password Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    创建新的用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 存在指定appkey
    ...    - 存在指定APPKEY后，是否执行该条用例
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    ${username}    set variable    ${randoNumber}
    ${password}    set variable    ${EMPTY}
    ${data}    set variable    {"username":"${username}","password":"${password}","nickname":"${randoNumber}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New Multi User Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    创建新的用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 存在指定appkey
    ...    - 存在指定APPKEY后，是否执行该条用例
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    ${randoNumber1}    Generate Random String    10    [NUMBERS]
    &{user1}    create dictionary    username=${randoNumber}    password=${randoNumber}
    &{user2}    create dictionary    username=${randoNumber1}    password=${randoNumber1}
    @{data}    create list    ${user1}    ${user2}
    Comment    ${data}    set variable    {"username":"${randoNumber}","password":"${randoNumber}","nickname":"${randoNumber}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${user1.username}'    '${user2.username}'    '${baseRes.validOrgName}'    '${baseRes.validAppName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New Multi User With Illegal UserName Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    创建新的用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 存在指定appkey
    ...    - 存在指定APPKEY后，是否执行该条用例
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    ${randoNumber1}    Generate Random String    10    [NUMBERS]
    ${username}    set variable    ${randoNumber}
    ${password}    set variable    ${randoNumber}
    ${username1}    set variable    ${randoNumber1}!@#$%^
    ${password1}    set variable    ${randoNumber1}
    &{user1}    create dictionary    username=${username}    password=${password}
    &{user2}    create dictionary    username=${username1}    password=${password1}
    @{data}    create list    ${user1}    ${user2}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${username1}'
    @{argumentValue}    create list    '${username1}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New Multi User With Illegal PassWord Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    创建新的用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 存在指定appkey
    ...    - 存在指定APPKEY后，是否执行该条用例
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    ${randoNumber1}    Generate Random String    10    [NUMBERS]
    ${username}    set variable    ${randoNumber}
    ${password}    set variable    ${randoNumber}
    ${username1}    set variable    ${randoNumber1}
    ${password1}    set variable    ${EMPTY}
    &{user1}    create dictionary    username=${username}    password=${password}
    &{user2}    create dictionary    username=${username1}    password=${password1}
    @{data}    create list    ${user1}    ${user2}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get User
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    创建应用app下的用户
    # 创建应用app
    ${resp}=    /{orgName}/{appName}/users    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Users And Return User
    [Documentation]    获取应用下的用户，并返回一个正常用户
    #创建获取token的请求体
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #给相应变量赋值
    set to dictionary    ${requestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${requestHeader}    Authorization=Bearer ${Token.orgToken}
    ${expectedStatusCode}    set variable    200
    #获取用户列表
    &{apiResponse}    Get User    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取用户列表失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${application}    set variable    ${text['entities']}
    return from keyword    ${application}

Get Valid And Invalid User
    #创建新的用户
    ${user}    Create Temp User
    ${validIMUser}    set variable    ${user['entities'][0]['username']}
    #设置全局的有效、无效基本数据
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    set to dictionary    ${baseRes}    validIMUser=${validIMUser}    invalidIMUser=invalidUser${randoNumber}
    set global variable    ${baseRes}    ${baseRes}
