*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/Chatroom/Chatroom.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../UserCommon/UserCommon.robot
Resource          ChatroomCommon.robot

*** Keywords ***
Add Single Chatroom Member
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    添加单个聊天室成员
    #添加单个聊天室成员
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName}    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Delete Single Chatroom Member
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    删除单个聊天室成员
    #删除单个聊天室成员
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Chatroom Member
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    分页获取聊天室成员
    #分页获取聊天室成员
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/users    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Multi Chatroom Member
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    批量添加聊天室成员
    #批量添加聊天室成员
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/users    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Delete Multi Chatroom Member
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    批量删除聊天室成员
    #批量删除聊天室成员
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Chatroom Admin
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    添加聊天室管理员
    #添加聊天室管理员
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/admin    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Add Chatroom SuperAdmin
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    添加聊天室管理员
    #添加聊天室管理员
    ${resp}=    /{orgName}/{appName}/chatrooms/super_admin    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Remove Chatroom Admin
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    移除聊天室管理员
    #移除聊天室管理员
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/admin/{userName}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Remove Chatroom SuperAdmin
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    移除聊天室超级管理员
    #移除聊天室管理员
    ${resp}=    /{orgName}/{appName}/chatrooms/super_admin/{super_admin}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Get Chatroom Admin List
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取聊天室管理员列表
    #获取聊天室管理员列表
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/admin    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
Get Chatroom SuperAdmin list
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取聊天室超级管理员列表
    #获取聊天室超级管理员列表
    ${resp}=    /{orgName}/{appName}/chatrooms/super_admin    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Temp Single Chatroom Member
    [Arguments]    ${chatroomId}=${baseRes.validChatroom.chatroomId}    ${userName}=${validIMUserInfo.username}
    [Documentation]    添加单个聊天室成员
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}    userName=${userName}
    #添加单个聊天室成员
    &{apiResponse}    Add Single Chatroom Member    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    添加单个聊天室成员失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Add Temp Chatroom Admin
    [Arguments]    ${chatroomId}=${baseRes.validChatroom.chatroomId}    ${userName}=${validIMUserInfo.username}
    [Documentation]    添加聊天室管理员
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #添加聊天室管理员
    &{apiResponse}    Add Chatroom Admin    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    添加聊天室管理员失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Add Single Chatroom Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个聊天室成员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatroom Member
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    'add_member'    '${chatroomId}'    '${userName}'
    ...    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Single Chatroom Member With Inexistent ChatroomId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个聊天室成员-聊天室ID不存在
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建一个聊天室
    Comment    ${chatroomId}    set variable    ${baseRes.validChatroom.chatroomId}    #获取初始化的有效聊天室信息
    ${randomNumber}    Generate Random Specified String
    Comment    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${randomNumber}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatroom Member
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${chatroomId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Single Chatroom Member With Inexistent Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个聊天室成员-聊天室成员不存在
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
    ${userName}    set variable    ${randomNumber}
    #创建一个聊天室
    ${chatroomId}    set variable    ${baseRes.validChatroom.chatroomId}    #获取初始化的有效聊天室信息
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatroom Member
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Single Chatroom Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个聊天室成员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #添加单个聊天室成员
    ${chatroomMember}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete Single Chatroom Member
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'delete'    '${applicationUUID}'    'remove_member'    '${chatroomId}'    '${userName}'
    ...    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatroom Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    分页获取聊天室成员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建新的用户
    ${user}    Create Temp User
    ${userName1}    set variable    ${user['entities'][0]['username']}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #添加单个聊天室成员
    ${chatroomMember}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName}
    ${chatroomMember1}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName1}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatroom Member
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${userName1}'    '${userName}'    '${orgName}'    '${appName}'
    ...    '2'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Multi Chatroom Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    批量添加聊天室成员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建新的用户
    ${user}    Create Temp User
    ${userName1}    set variable    ${user['entities'][0]['username']}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${data}    set variable    {"usernames":["${userName}","${userName1}"]}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Multi Chatroom Member
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${orgName}'    '${appName}'    #'${userName1}'    '${userName}'
    ...    # 'add_member'    '${chatroomId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Multi Chatroom Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    批量删除聊天室成员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建新的用户
    ${user}    Create Temp User
    ${userName1}    set variable    ${user['entities'][0]['username']}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #添加单个聊天室成员
    ${chatroomMember}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName}
    ${chatroomMember1}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName1}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}    userName=${userName}%2C${userName1}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete Multi Chatroom Member
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    'remove_member'    '${chatroomId}'    'remove_member'    '${chatroomId}'
    ...    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatroom Admin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加聊天室管理员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #添加单个聊天室成员
    ${chatroomMember}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatroom Admin
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    'newadmin'
    @{argumentValue}    create list    'post'    '${applicationUUID}'    'success'    'newadmin'    '${userName}'
    ...    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatroom Admin With Inexistent ChatroomId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加聊天室管理员-聊天室ID不存在
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建一个聊天室
    Comment    ${chatroomId}    set variable    ${baseRes.validChatroom.chatroomId}    #获取初始化的有效聊天室信息
    ${randomNumber}    Generate Random Specified String
    Comment    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${randomNumber}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatroom Admin
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${chatroomId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatroom Admin With Inexistent Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加聊天室管理员-聊天室成员不存在
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
    ${userName}    set variable    ${randomNumber}
    #创建一个聊天室
    ${chatroomId}    set variable    ${baseRes.validChatroom.chatroomId}    #获取初始化的有效聊天室信息
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatroom Admin
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatroom Admin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除聊天室管理员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #添加单个聊天室成员
    ${chatroomMember}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName}
    #添加聊天室管理员
    ${chatroomAdmin}    Add Temp Chatroom Admin    ${chatroomId}    ${userName}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatroom Admin
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    'oldadmin'
    @{argumentValue}    create list    'delete'    '${applicationUUID}'    'success'    'oldadmin'    '${userName}'
    ...    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatroom Admin List Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取聊天室管理员列表
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建新的用户
    ${user}    Create Temp User
    ${userName1}    set variable    ${user['entities'][0]['username']}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #添加单个聊天室成员
    ${chatroomMember}    Add Temp Single Chatroom Member    ${chatroomId}    ${userName1}
    #添加聊天室管理员
    ${chatroomAdmin}    Add Temp Chatroom Admin    ${chatroomId}    ${userName1}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatroom Admin List
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${userName1}'    '${orgName}'    '${appName}'    '1'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Shield Chatroom
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}/shield    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Shield Chatroom Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #创建用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    
    #获取该用户user token
    ${gettokendata}    set variable    {"grant_type":"password","username":"${userName}","password":"${userName}"}
    &{pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${resp}=    /{orgName}/{appName}/token    POST    ${RestRes.alias}    ${requestHeader}    pathParamter=${pathParamter1}    data=${gettokendata}
    ${r}    loads    ${resp.text}   
    ${usertoken}    Get From Dictionary    ${r}    access_token
    
    #创建一个聊天室
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #参数
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${usertoken}    ${statusCode}    ${keywordDescribtion}    Shield Chatroom    @{arguments}
    Log Dictionary    ${apiResponse}
    
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    'true'    'add_shield'    '${userName}'    '${chatroomId}'    '${orgName}'      
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatroom SuperAdminZero Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取聊天室超级管理员列表——未添加超级管理员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建新的用户
    ${user}    Create Temp User
    ${userName1}    set variable    ${user['entities'][0]['username']}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatroom SuperAdmin list
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${appName}'    0    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


Get Chatroom SuperAdmin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取聊天室管理员列表——已添加超级管理员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建新的用户
    ${user}    Create Temp User
    ${userName1}    set variable    ${user['entities'][0]['username']}
    #添加聊天室管理员用户
    Add Temp Chatroom SuperAdmin    ${userName1}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatroom SuperAdmin list
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${appName}'    '${userName}'    1    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    #移除聊天室超级管理员
    Remove Temp Chatroom SuperAdmin    ${userName1}
    
Add Temp Chatroom SuperAdmin
    [Documentation]    添加聊天室超级管理员
    [Arguments]    ${username}  
    ${expectedStatusCode}    Set Variable    200
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${data}    Set Variable    {"superadmin": "${username}"}
    &{ApiResponse}    Add Chatroom SuperAdmin    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    
Add Chatroom SuperAdmin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加聊天室超级管理员
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
    # ${userName}    set variable    ${validIMUserInfo.username}
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${data}    set variable    {"superadmin": "${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatroom SuperAdmin
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    
    @{argumentValue}    create list    '${applicationUUID}'    '${appName}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Remove Chatroom SuperAdmin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除聊天室超级管理员
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${username}    Set Variable     ${validIMUserInfo.username}
    #添加聊天室超级管理员
    ${text}    Add Temp Chatroom SuperAdmin    ${username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    super_admin=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatroom SuperAdmin
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    
    @{argumentValue}    create list    '${applicationUUID}'    '${appName}'    '${username}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
Remove Temp Chatroom SuperAdmin
    [Documentation]    添加聊天室超级管理员
    [Arguments]    ${username}  
    ${expectedStatusCode}    Set Variable    200
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    super_admin=${username}

    &{ApiResponse}    Remove Chatroom SuperAdmin    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}