*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/Chatroom/Chatroom.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../UserCommon/UserCommon.robot

*** Keywords ***
Create Chatroom
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    创建一个聊天室
    #创建一个聊天室
    ${resp}=    /{orgName}/{appName}/chatrooms    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Modify Chatroom
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    修改聊天室信息
    #修改聊天室信息
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}    PUT    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Delete Chatroom
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    删除聊天室
    #删除聊天室
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Specific Chatroom Detail
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取聊天室详情
    #获取聊天室详情
    ${resp}=    /{orgName}/{appName}/chatrooms/{chatroomId}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get All Chatrooms
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取 APP 中所有的聊天室
    #获取APP中所有的聊天室
    ${resp}=    /{orgName}/{appName}/chatrooms    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get IMUser Joined Chatroom
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取用户加入的聊天室
    #获取用户加入的聊天室
    ${resp}=    /{orgName}/{appName}/users/{userName}/joined_chatrooms    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Create Temp Chatroom
    [Arguments]    ${userName}=${validIMUserInfo.username}    ${maxusers}=200
    [Documentation]    创建一个聊天室
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=${userName}    description=${userName}    owner=${userName}    members=${membersList}    maxusers=${maxusers}
    ${data}    dumps    ${chatRoomEntity}
    #创建一个聊天室
    &{apiResponse}    Create Chatroom    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建一个聊天室失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Get Chatroom Init
    [Documentation]    创建一个聊天室，初始化聊天室信息
    #创建一个聊天室
    ${userName}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data["id"]}
    ${validChatroom}    create dictionary    chatroomId=${chatroomId}    name=${userName}    desc=${userName}    owner=${userName}    maxusers=${maxusers}
    #设置全局的有效
    set to dictionary    ${baseRes}    validChatroom=${validChatroom}
    set global variable    ${baseRes}    ${baseRes}
    Set Parallel Value For Key    ParallelbaseRes    ${baseRes}

Get All Chatrooms List
    [Documentation]    获取APP中所有的聊天室
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #获取APP中所有的聊天室
    &{apiResponse}    Get All Chatrooms    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取APP中所有的聊天室失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Create Chatroom Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个聊天室
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
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=${userName}    description=${userName}    owner=${ownerUserName}    members=${membersList}    maxusers=200
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create Chatroom With Owner Is The Same As Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个聊天室-聊天室管理员与成员为同一个用户
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
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    Comment    ${user}    Create Temp User
    ${userName}    set variable    ${ownerUserName}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=${userName}    description=${userName}    owner=${ownerUserName}    members=${membersList}    maxusers=200
    ${data}    dumps    ${chatRoomEntity}
    Comment    ${data}    set variable    {"name":"${chatRoomEntity.name}","description":"${chatRoomEntity.description}","owner":"${chatRoomEntity.owner}","members":${chatRoomEntity.members},"maxusers":${chatRoomEntity.maxusers}}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create Chatroom With Inexistent Owner Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个聊天室-聊天室管理员不存在
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
    ${randomNumber}    Generate Random Specified String
    ${ownerUserName}    set variable    ${randomNumber}
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=${userName}    description=${userName}    owner=${ownerUserName}    members=${membersList}    maxusers=200
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${ownerUserName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create Chatroom With Inexistent Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个聊天室-聊天室成员不存在
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
    ${randomNumber}    Generate Random Specified String
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    ${userName}    set variable    ${randomNumber}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=${userName}    description=${userName}    owner=${ownerUserName}    members=${membersList}    maxusers=200
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create Chatroom With Name Filed Discarded Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个聊天室-聊天室名称字段缺失
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
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=${userName}    description=${userName}    owner=${ownerUserName}    members=${membersList}    maxusers=200
    Remove From Dictionary    ${chatRoomEntity}    name
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create Chatroom With Owner Filed Discarded Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个聊天室-聊天室管理员字段缺失
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
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=${userName}    description=${userName}    owner=${ownerUserName}    members=${membersList}    maxusers=200
    Remove From Dictionary    ${chatRoomEntity}    owner
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify Chatroom Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改聊天室信息
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom
    ${chatroomId}    set variable    ${chatroom.data.id}
    #设置请求数据
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=modify_${userName}    description=modify_${userName}    maxusers=199
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify Chatroom With MaxUser Larger Than Current User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改聊天室信息-最大成员数大于当前用户数
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom
    ${chatroomId}    set variable    ${chatroom.data.id}
    #设置请求数据
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=modify_${userName}    description=modify_${userName}    maxusers=0
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Modify Chatroom With Inexistent ChatroomIdTemplate
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改聊天室信息-聊天室ID不存在
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个聊天室
    ${randomNumber}    Generate Random Specified String
    Comment    ${chatroom}    Create Temp Chatroom
    ${chatroomId}    set variable    ${randomNumber}
    #设置请求数据
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    #创建请求数据
    @{membersList}    Create List    ${userName}
    &{chatRoomEntity}    Create Dictionary    name=modify_${userName}    description=modify_${userName}    maxusers=199
    ${data}    dumps    ${chatRoomEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Modify Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${chatroomId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Chatroom Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    删除聊天室
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom
    ${chatroomId}    set variable    ${chatroom.data.id}
    #设置请求数据
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${chatroomId}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Specific Chatroom Detail Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取聊天室详情
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个聊天室
    ${userName}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Specific Chatroom Detail
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${chatroomId}'    '${userName}'    '${userName}'    'false'
    ...    'false'    '${maxusers}'    '${userName}'    '1'    '${userName}'    'true'
    ...    '${orgName}'    '${appName}'    '1'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get All Chatrooms Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取 APP 中所有的聊天室
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #获取所有聊天室列表
    &{chatroom}    Get All Chatrooms List
    ${chatroomList}    get length    ${chatroom.data}
    run keyword if    ${chatroomList} == 0    Create Temp Chatroom
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get All Chatrooms
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get IMUser Joined Chatroom Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取用户加入的聊天室
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    #创建一个聊天室
    ${chatroom}    Create Temp Chatroom    ${userName}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get IMUser Joined Chatroom
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${chatroomId}'    '${userName}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

 
 Get Chatroom Detail By Page
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${params}    Set Variable    limit=1
    ${resp}=    /{orgName}/{appName}/chatrooms    GET    ${session}    ${header}    pathParamter=${pathParamter}    params=${params}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
 
 
 Get Chatroom Detail By Page Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #创建一个聊天室
    ${userName}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data.id}
    
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatroom Detail By Page
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


Update Chatroom Announment
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${data}    Set Variable    {"announcement":"test"}
    ${resp}=    /{orgName}/{appName}/chatrooms/{roomId}/announcement    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}    
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
 
 
Update Chatroom Announment Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #创建一个聊天室
    ${userName}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #参数
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Update Chatroom Announment
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${applicationUUID}'    '${chatroomId}'    'true'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatroom Announment
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/chatrooms/{roomId}/announcement    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
 
 
Get Chatroom Announment Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #创建一个聊天室
    ${userName}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #参数
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #更新公告
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Update Chatroom Announment
    ...    @{arguments}
    #获取公告
    &{apiResponse2}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatroom Announment
    ...    @{arguments}
    Log Dictionary    ${apiResponse2}
    @{argumentField}    create list
    @{argumentValue}    create list    'get'    '${applicationUUID}'    'test'    '${orgName}'    
    Assert Request Result    ${apiResponse2}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Ban Chatroom
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/chatrooms/{roomId}/ban    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
 
 
Ban Chatroom Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #创建一个聊天室
    ${userName}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #参数
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Ban Chatroom    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'put'    '${applicationUUID}'    'true'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Allow Chatroom
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/chatrooms/{roomId}/ban    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Allow Chatroom Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #创建一个聊天室
    ${userName}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${chatroom}    Create Temp Chatroom    ${userName}    ${maxusers}
    ${chatroomId}    set variable    ${chatroom.data.id}
    #参数
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    chatroomId=${chatroomId}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Ban Chatroom    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'put'    '${applicationUUID}'    'true'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

