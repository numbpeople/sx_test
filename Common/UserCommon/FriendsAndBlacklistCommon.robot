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
Add Friend
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    添加好友
    #添加好友
    ${resp}=    /{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername}    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Friend For User
    [Arguments]    ${ownerUsername}    ${friendUsername}
    [Documentation]    添加好友
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}    friendUsername=${friendUsername}
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #添加好友
    &{apiResponse}    Add Friend    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    添加好友失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${user}    set variable    ${text}
    return from keyword    ${user}

Remove Friend
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    移除好友
    #移除好友
    ${resp}=    /{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Friend
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取好友列表
    #获取好友列表
    ${resp}=    /{orgName}/{appName}/users/{ownerUsername}/contacts/users    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Blacklist
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    向 IM 用户的黑名单列表中添加一个或者多个用户
    #向 IM 用户的黑名单列表中添加一个或者多个用户
    ${resp}=    /{orgName}/{appName}/users/{ownerUsername}/blocks/users    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Blacklist For User
    [Arguments]    ${ownerUsername}    ${blacklistUser}
    [Documentation]    向IM用户的黑名单列表中添加用户
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${data}    set variable    {"usernames":["${blacklistUser}"]}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #添加好友
    &{apiResponse}    Add Blacklist    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    添加黑名单失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${user}    set variable    ${text}
    return from keyword    ${user}

Remove Blacklist
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    从IM用户的黑名单列表中移除用户
    #从IM用户的黑名单列表中移除用户
    ${resp}=    /{orgName}/{appName}/users/{ownerUsername}/blocks/users/{blockedUsername}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Blacklist
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取用户的黑名单列表
    #获取用户的黑名单列表
    ${resp}=    /{orgName}/{appName}/users/{ownerUsername}/blocks/users    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Friend Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加好友
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${user}    Create Temp User
    ${ownerUUID}    set variable    ${user['entities'][0]['uuid']}
    ${ownerUserNameAccount}    set variable    ${user['entities'][0]['username']}
    ${username}    set variable    ${validIMUserInfo.username}
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${nickname}    set variable    ${validIMUserInfo.nickname}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    ${friendUsername}    set variable    ${ownerUserNameAccount}    ${username}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}    friendUsername=${friendUsername}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUserNameAccount}    ${token} 
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Friend
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${uuid}'    '${username}'    '${nickname}'    '${orgName}'
    ...    '${appName}'
    @{argumentValueUnauthorized}    create list    'post'    '${applicationUUID}'    '/${ownerUUID}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Inexistent Friend Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个不存在的好友
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    ${friendUsername}    set variable    ${baseRes.validIMUser}    ${randomNumber}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUsername}    ${token}
    
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}    friendUsername=${friendUsername}

    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Friend
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    @{argumentValueUnauthorized}    create list    'post'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Friend Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个不存在的好友
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${user}    Create Temp User
    ${ownerUUID}    set variable    ${user['entities'][0]['uuid']}
    ${ownerUserNameAccount}    set variable    ${user['entities'][0]['username']}
    ${username}    set variable    ${validIMUserInfo.username}
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${nickname}    set variable    ${validIMUserInfo.nickname}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    ${friendUsername}    set variable    ${ownerUserNameAccount}    ${username}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}    friendUsername=${friendUsername}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUserNameAccount}    ${token} 
    #添加好友操作
    ${userInfo}    Add Friend For User    ${ownerUsername}    ${friendUsername}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Friend
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${uuid}'    '${username}'    '${nickname}'    '${orgName}'
    ...    '${appName}'
    @{argumentValueUnauthorized}    create list    'delete'    '${applicationUUID}'    '/${ownerUUID}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Friend Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取好友列表
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个新的用户
    ${user}    Create Temp User
    ${username}    set variable    ${user['entities'][0]['username']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${ownerUsername}    ${friendUsername}    set variable    ${username}    ${baseRes.validIMUser}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUsername}    ${token} 
    #添加好友操作
    Add Friend For User    ${ownerUsername}    ${friendUsername}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Friend
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${friendUsername}'    '1'
    @{argumentValueUnauthorized}    create list    'get'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Inexistent Friend Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取不存在用户的好友列表
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    set variable    ${randomNumber}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Friend
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    @{argumentValueUnauthorized}    create list    'get'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add User Blacklist Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    向 IM 用户的黑名单列表中添加一个或者多个用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    set variable    ${baseRes.validIMUser}
    ${data}    set variable    {"usernames":["${ownerUsername}"]}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUsername}    ${token} 
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Blacklist
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    '${ownerUsername}'    '${orgName}'    '${appName}'
    @{argumentValueUnauthorized}    create list    'post'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Inexistent User Blacklist Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加IM用户的黑名单-黑名单用户不存在
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    set variable    ${baseRes.validIMUser}
    ${data}    set variable    {"usernames":["${randomNumber}"]}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUsername}    ${token} 
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Blacklist
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'    '${ownerUsername}'    '${randomNumber}'
    @{argumentValueUnauthorized}    create list    'post'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove User Blacklist Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    从IM用户的黑名单列表中移除用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    Add Blacklist For User    ${baseRes.validIMUser}    ${baseRes.validIMUser}
    ${username}    set variable    ${validIMUserInfo.username}
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${nickname}    set variable    ${validIMUserInfo.nickname}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    ${blockedUsername}    set variable    ${baseRes.validIMUser}    ${baseRes.validIMUser}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}    blockedUsername=${blockedUsername}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUsername}    ${token} 
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Blacklist
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${uuid}'    '${username}'    '${nickname}'    '${orgName}'
    ...    '${appName}'
    @{argumentValueUnauthorized}    create list    'delete'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Inexistent User Blacklist Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    从IM用户的黑名单列表中移除用户
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${ownerUsername}    set variable    ${baseRes.validIMUser}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}    blockedUsername=${randomNumber}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUsername}    ${token} 
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Blacklist
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    @{argumentValueUnauthorized}    create list    'delete'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get User BlacklistTemplate
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取用户的黑名单列表
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个新的用户
    ${user}    Create Temp User
    ${username}    set variable    ${user['entities'][0]['username']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${ownerUsername}    ${blacklistUser}    set variable    ${username}    ${username}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${ownerUsername}    ${token} 
    #添加黑名单操作
    Add Blacklist For User    ${ownerUsername}    ${blacklistUser}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${ownerUsername}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Blacklist
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'get'    '${username}'    '1'
    @{argumentValueUnauthorized}    create list    'get'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Inexistent User BlacklistTemplate
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取不存在用户的黑名单列表
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    ownerUsername=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Blacklist
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
