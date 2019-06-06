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

Get User
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${params}=
    [Documentation]    创建应用app下的用户
    # 创建应用app
    ${resp}=    /{orgName}/{appName}/users    GET    ${session}    ${header}    pathParamter=${pathParamter}    params=${params}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Specific User
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取应用app下的指定用户
    #获取指定用户
    ${resp}=    /{orgName}/{appName}/users/{userName}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Delete Specific User
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    删除指定用户
    #删除指定用户
    ${resp}=    /{orgName}/{appName}/users/{userName}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Delete User
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${params}=
    [Documentation]    删除用户
    # 创建应用app
    ${resp}=    /{orgName}/{appName}/users    DELETE    ${session}    ${header}    pathParamter=${pathParamter}    params=${params}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Modify User Password
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    重置IM用户密码
    #重置IM用户密码
    ${resp}=    /{orgName}/{appName}/users/{imUser}/password    PUT    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Modify Specific User
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    修改指定用户信息
    #修改指定用户信息
    ${resp}=    /{orgName}/{appName}/users/{userName}    PUT    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Create Temp User
    [Arguments]    ${specificPreString}=
    [Documentation]    创建一个新的用户
    #创建获取token的请求体
    ${randomNumber}    Generate Random Specified String    ${specificPreString}
    ${data}    set variable    {"username":"${randomNumber}","password":"${randomNumber}","nickname":"${randomNumber}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建用户
    &{apiResponse}    Create User    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Delete Temp Specific User
    [Arguments]    ${userName}
    [Documentation]    删除指定用户
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #删除指定用户
    &{apiResponse}    Delete Specific User    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    删除指定用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Delete Temp Specific User For Loop
    [Documentation]    循环删除指定用户
    #获取app下所有的用户
    @{userList}    Get Users And Return User    100
    #批量删除测试用户数据
    : FOR    ${i}    IN    @{userList}
    \    #获取用户username
    \    ${userName}    set variable    ${i['username']}
    \    ${status}    Run Keyword And Return Status    Should Contain    ${userName}    ${preRandomString}
    \    #删除指定用户
    \    run keyword if    ${status}    Delete Temp Specific User    ${userName}

Get Users With Params
    [Arguments]    ${limit}    ${cursor}=
    [Documentation]    获取应用下的用户，并返回一个正常用户
    #创建请求体
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${params}    set variable    limit=${limit}&cursor=${cursor}
    Run Keyword If    "${cursor}" == "${EMPTY}"    set suite variable    ${params}    limit=${limit}
    #给相应变量赋值
    ${newToken}    set variable    ${Token.orgToken}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set suite variable    ${newToken}    ${RunModelCaseConditionDic.specificBestToken}
    set to dictionary    ${requestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${requestHeader}    Authorization=Bearer ${newToken}
    ${expectedStatusCode}    set variable    200
    #获取用户列表
    &{apiResponse}    Get User    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${params}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取用户列表失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${application}    set variable    ${text}
    return from keyword    ${application}

Get Users And Return User
    [Arguments]    ${limit}=10
    [Documentation]    获取应用下的用户
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${params}    set variable    limit=${limit}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #获取用户列表
    &{apiResponse}    Get User    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${params}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取用户列表失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${application}    set variable    ${text['entities']}
    return from keyword    ${application}

Get Valid And Invalid User Init
    [Documentation]    初始化应用下用户信息
    #创建新的用户
    ${user}    Create Temp User    initvaliduser
    ${validIMUser}    set variable    ${user['entities'][0]['username']}
    &{validIMUserInfo}    create dictionary    uuid=${user['entities'][0]['uuid']}    created=${user['entities'][0]['created']}    modified=${user['entities'][0]['modified']}    username=${user['entities'][0]['username']}    nickname=${user['entities'][0]['nickname']}
    #设置全局的有效、无效基本数据
    ${randomNumber}    Generate Random Specified String
    set to dictionary    ${baseRes}    validIMUser=${validIMUser}    invalidIMUser=invalidUser${randomNumber}    validIMUserInfo=${validIMUserInfo}
    set global variable    ${baseRes}    ${baseRes}

Create Exist User Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
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
    ...    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${data}    set variable    {"username":"${randomNumber}","password":"${randomNumber}","nickname":"${randomNumber}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'    '${randomNumber}'    '${baseRes.validOrgName}'    '${baseRes.validAppName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New User With Illegal UserName Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${username}    set variable    ${EMPTY}
    ${password}    set variable    ${randomNumber}
    ${data}    set variable    {"username":"${username}","password":"${password}","nickname":"${randomNumber}"}
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
    ...    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${username}    set variable    ${randomNumber}
    ${password}    set variable    ${EMPTY}
    ${data}    set variable    {"username":"${username}","password":"${password}","nickname":"${username}"}
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
    ...    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${randomNumber1}    Generate Random Specified String
    &{user1}    create dictionary    username=${randomNumber}    password=${randomNumber}
    &{user2}    create dictionary    username=${randomNumber1}    password=${randomNumber1}
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
    @{argumentValue}    create list    '${user1.username}'    '${user2.username}'    '${baseRes.validOrgName}'    '${baseRes.validAppName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New Multi User With Illegal UserName Template
    [Arguments]    ${contentType}    ${token}    ${openRegistration}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${randomNumber1}    Generate Random Specified String
    ${username}    set variable    ${randomNumber}
    ${password}    set variable    ${randomNumber1}
    ${username1}    set variable    ${randomNumber1}!@#$%^
    ${password1}    set variable    ${randomNumber1}
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
    ...    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #开放注册、授权注册修改
    Update App AllowOpenRegistration    ${openRegistration}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${randomNumber1}    Generate Random Specified String
    ${username}    set variable    ${randomNumber}
    ${password}    set variable    ${randomNumber}
    ${username1}    set variable    ${randomNumber1}
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

Get Single User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
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
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${created}    set variable    ${user['entities'][0]['created']}
    ${modified}    set variable    ${user['entities'][0]['modified']}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Specific User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${uuid}'    '${created}'    '${modified}'    '${username}'    '${username}'
    @{argumentValueUnauthorized}    create list    '${applicationUUID}'    '${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Single Inexistent User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Specific User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Multi User With Non-Paged Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    批量获取用户(不分页)
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${params}    set variable    limit=1
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${params}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    @{argumentValueUnauthorized}    create list    '${applicationUUID}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Multi User With Paged Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    批量获取用户(分页)
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #避免无数据，创建用户
    ${currentUsers}    Get Users With Params    limit=2
    ${createUserCounts}    evaluate    2-${currentUsers.count}
    Run Keyword If    ${currentUsers.count} < 2    Repeat Keyword    ${createUserCounts} times    Create Temp User
    #设置请求数据
    ${users}    Get Users With Params    limit=1
    ${cursor}    set variable    ${users.cursor}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${params}    set variable    limit=1&cursor=${cursor}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${params}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    @{argumentValueUnauthorized}    create list    '${applicationUUID}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Single User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    删除单个用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
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
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${created}    set variable    ${user['entities'][0]['created']}
    ${modified}    set variable    ${user['entities'][0]['modified']}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete Specific User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${uuid}'    '${created}'    '${modified}'    '${username}'    '${username}'
    ...    '${baseRes.validOrgName}'    '${baseRes.validAppName}'
    @{argumentValueUnauthorized}    create list    '${applicationUUID}'    '${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Single Inexistent User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    删除单个不存在的用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete Specific User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Multi User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    删除多个用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    return from keyword    True    #发现批量删除不能指定用户方式去删除，他是按照创建时间正序去批量删除，所以避免为了造成数据误删除，该用例暂时不执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #避免无数据，创建用户
    ${currentUsers}    Get Users With Params    limit=2
    ${createUserCounts}    evaluate    2-${currentUsers.count}
    Run Keyword If    ${currentUsers.count} < 2    Repeat Keyword    ${createUserCounts} times    Create Temp User
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${params}    set variable    limit=2
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${params}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${baseRes.validOrgName}'    '${baseRes.validAppName}'
    @{argumentValueUnauthorized}    create list    '${applicationUUID}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify User Password Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改IM用户密码
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
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
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    imUser=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${data}    set variable    {"newpassword":"new_${username}"}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify User Password
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    Comment    @{argumentValueUnauthorized}    create list
    Comment    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify Inexistent User Password Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改不存在的IM用户密码
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${randomNumber}    Generate Random Specified String
    ${username}    set variable    ${randomNumber}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    imUser=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${data}    set variable    {"newpassword":"new_${username}"}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify User Password
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    Comment    @{argumentValueUnauthorized}    create list
    Comment    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify User Nickname Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    设置推送消息显示昵称
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${created}    set variable    ${user['entities'][0]['created']}
    ${modified}    set variable    ${user['entities'][0]['modified']}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${randomNumber}    Generate Random Specified String
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    ${newNickname}    set variable    change-${userName}
    ${data}    set variable    {"nickname":"${newNickname}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify Specific User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${uuid}'    '${userName}'    'true'    '${newNickname}'
    ...    '${orgName}'    '${appName}'
    @{argumentValueUnauthorized}    create list    'put'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify User Notification_Display_Style Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    设置推送消息展示方式
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${created}    set variable    ${user['entities'][0]['created']}
    ${modified}    set variable    ${user['entities'][0]['modified']}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    ${notification_display_style}    set variable    1
    ${data}    set variable    {"notification_display_style": "${notification_display_style}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify Specific User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${uuid}'    '${userName}'    'true'    '${notification_display_style}'
    ...    '${userName}'    '${orgName}'    '${appName}'
    @{argumentValueUnauthorized}    create list    'put'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify User Notification_No_Disturbing Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    设置免打扰
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${created}    set variable    ${user['entities'][0]['created']}
    ${modified}    set variable    ${user['entities'][0]['modified']}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    ${notification_no_disturbing}    ${notification_no_disturbing_start}    ${notification_no_disturbing_end}    set variable    true    1    3
    ${data}    set variable    {"notification_no_disturbing":${notification_no_disturbing},"notification_no_disturbing_start":"${notification_no_disturbing_start}","notification_no_disturbing_end":"${notification_no_disturbing_end}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify Specific User
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${uuid}'    '${userName}'    'true'    '${notification_no_disturbing}'
    ...    '${notification_no_disturbing_start}'    '${notification_no_disturbing_end}'    '${userName}'    '${orgName}'    '${appName}'
    @{argumentValueUnauthorized}    create list    'put'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
