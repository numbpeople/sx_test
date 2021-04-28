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
Resource          ../SendMessageCommon/SendMessageCommon.robot

*** Keywords ***
Get User Status
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取用户在线状态
    #获取用户在线状态
    ${resp}=    /{orgName}/{appName}/users/{userName}/status    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get User Batch Status
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    批量获取用户在线状态
    #批量获取用户在线状态
    ${resp}=    /{orgName}/{appName}/users/batch/status    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get User Offline Msg Count
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取用户离线消息数
    #获取用户离线消息数
    ${resp}=    /{orgName}/{appName}/users/{userName}/offline_msg_count    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get User Offline Msg Status
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取某条离线消息状态
    #获取某条离线消息状态
    ${resp}=    /{orgName}/{appName}/users/{userName}/offline_msg_status/{msgId}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get User Status Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取用户在线状态
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
    ${uuid}    set variable    ${validIMUserInfo.uuid}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${userName}    set variable    ${baseRes.validIMUser}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get User Status
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'    'offline'
    @{argumentValue}    create list    '${userName}'    'offline'
    @{argumentValueUnauthorized}    create list    'get'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Inexistent User Status Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取不存在IM用户在线状态
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
    ${userName}    set variable    ${baseRes.validIMUser}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get User Status
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get User Batch Status Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取用户在线状态
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
    ${user1}    set variable    ${user['entities'][0]['username']}
    ${user2}    set variable    ${validIMUserInfo.username}
    ${data}    set variable    {"usernames":["${user1}","${user2}"]}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${userName}    set variable    ${baseRes.validIMUser}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get User Batch Status
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${user1}'    'offline'    '${user2}'    'offline'
    @{argumentValue}    create list    '${user1}'    'offline'    '${user2}'    'offline'
    @{argumentValueUnauthorized}    create list
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get User Offline Msg Count Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取用户离线消息数
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #发送文本消息
    &{msgEntity}    create dictionary    fromUser=${userName}    targetUser=${userName}    msg=${userName}
    ${times}    set variable    1
    Repeat Keyword    ${times} times    Send Text Message    ${msgEntity}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    sleep    1s
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get User Offline Msg Count
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'    '${times}'
    @{argumentValue}    create list    '${userName}'    '${times}'
    @{argumentValueUnauthorized}    create list    'get'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get User Offline Msg Status Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取某条离线消息状态
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    return from keyword    True
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${uuid}    set variable    ${user['entities'][0]['uuid']}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #发送文本消息
    &{msgEntity}    create dictionary    fromUser=${userName}    targetUser=${userName}    msg=${userName}
    ${times}    set variable    1
    Repeat Keyword    ${times} times    Send Text Message    ${msgEntity}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}    msgId=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get User Offline Msg Status
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'    '${times}'
    @{argumentValue}    create list    '${userName}'    '${times}'
    @{argumentValueUnauthorized}    create list    'get'    '${applicationUUID}'    '/${uuid}'
    Run Keyword If    ${statusCode} == 401    set suite variable    ${argumentValue}    ${argumentValueUnauthorized}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
强制用户下线
    [Arguments]    ${session}
    [Documentation]    强制用户下线
    #创建一个新的用户
    ${user}    Create Temp User
    #获取创建的用户名称
    ${userName}    set variable    ${user['entities'][0]['username']}
    #设置请求的header
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    #设置orgname和appname
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    #强制用户下线接口
    ${resp}=    /{org_name}/{app_name}/users/{user_name}/disconnect    ${session}    ${orgName}    ${appName}    ${userName}    ${newRequestHeader}    ${timeout}
    [Return]    ${resp}
查看用户在线设备状态
    [Arguments]    ${session}
    [Documentation]    查看用户在线设备状态，如果用户离线，获取的data为空，主要验证接口请求成功
    #创建一个新的用户
    ${user}    Create Temp User
    #获取创建的用户名称
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    #设置请求的header
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    #设置orgname和appname
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    #查看用户在线设备状态
    ${resp}=    /{org_name}/{app_name}/users/{user_name}/resources    ${session}    ${orgName}    ${appName}    ${userName}    ${newRequestHeader}    ${timeout}
    [Return]    ${resp}    ${orgName}    ${appName}