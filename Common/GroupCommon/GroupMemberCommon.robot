*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/Chatgroup/ChatgroupApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../AppCommon/AppCommon.robot
Resource          ../UserCommon/UserCommon.robot
Resource          GroupCommon.robot

*** Keywords ***
Add Single Chatgroup Member
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    添加单个群组成员
    #添加单个群组成员
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/users/{userName}    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


Remove Chatgroup Member
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    移除群组成员
    #移除群组成员
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/users/{userName}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Temp Single Chatgroup Member
    [Arguments]    ${groupId}    ${userName}
    [Documentation]    添加单个群组成员
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #创建用户
    &{apiResponse}    Add Single Chatgroup Member    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    添加组内成员失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Get Multi Chatgroup Member
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    分页获取一个群组的群成员列表
    #分页获取一个群组的群成员列表
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/users    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Multi Chatgroup Member
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    批量添加群组成员
    #批量添加群组成员
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/users    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Chatgroup Admin
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    添加群管理员
    #添加群管理员
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/admin    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Chatgroup Admin
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取群管理员列表
    #获取群管理员列表
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/admin    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Remove Chatgroup Admin
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    移除群管理员
    #移除群管理员
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/admin/{adminName}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Transfer Chatgroup
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    转让群组
    #转让群组
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}    PUT    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Temp Chatgroup Admin
    [Arguments]    ${groupId}    ${userName}
    [Documentation]    添加群管理员
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #添加群管理员
    &{apiResponse}    Add Chatgroup Admin    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    添加群管理员，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Create New Chatgroup And Set Group Admin
    [Arguments]    ${owner}=${validIMUserInfo.username}    ${userName}=    ${groupId}=
    [Documentation]    创建新的群组、添加普通成员并设置群管理
    #创建一个群组
    ${newGroupId}    set variable    ${groupId}
    &{chatGroup}    run keyword if    "${groupId}" == "${EMPTY}"    Create Temp Chatgroup    owner=${owner}
    run keyword if    "${groupId}" == "${EMPTY}"    set test variable    ${newGroupId}    ${chatGroup.groupId}
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${newGroupId}    ${userName}
    #添加群管理员
    ${result1}    Add Temp Chatgroup Admin    ${newGroupId}    ${userName}
    &{group}    create dictionary    groupId=${newGroupId}    groupName=
    run keyword if    "${groupId}" == "${EMPTY}"    set to dictionary    ${group}    groupName=${chatGroup.groupName}
    set to dictionary    ${group}    userName=${userName}
    Return From Keyword    ${group}

Add Single Chatgroup Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个群组成员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${baseRes.validAppUUID}'    '${groupId}'    'add_member'    '${userName}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Single Chatgroup Member With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个群组成员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${randomNumber}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Single Chatgroup Member With Inexistent IMUser Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加单个群组成员
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
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Single Chatgroup Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除单个群组成员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'delete'    '${baseRes.validAppUUID}'    '${groupId}'    'remove_member'    '${userName}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Not Belong Single Chatgroup Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除单个群组成员-用户不属于群组成员
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
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Single Chatgroup Member With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除单个群组成员
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${randomNumber}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Multi Chatgroup Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取群组成员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Multi Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'get'    '${baseRes.validAppUUID}'    '${userName}'    '${ownerUserName}'    '${orgName}'    '2'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Multi Chatgroup Member With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取群组成员
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
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Multi Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Multi Chatgroup Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    批量添加群组成员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"usernames":["${userName}"]}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Multi Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${baseRes.validAppUUID}'    '${userName}'    '${groupId}'    'add_member'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Multi Chatgroup Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除单个群组成员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${user1}    Create Temp User
    ${userName1}    set variable    ${user1['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName1}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName},${userName1}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Member    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'delete'    '${baseRes.validAppUUID}'    'remove_member'    '${groupId}'    'remove_member'    '${groupId}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatgroup Admin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加群管理员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    'newadmin'
    @{argumentValue}    create list    'post'    '${baseRes.validAppUUID}'    'newadmin'    '${userName}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatgroup Admin With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加群管理员-群组ID不存在
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
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${randomNumber}
    ${data}    set variable    {"newadmin":"${randomNumber}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Not Belong Chatgroup Admin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加群管理员-用户不属于群成员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    #创建一个群组
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'    '${groupId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatgroup Admin With Inexistent IMUser Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加群管理员-用户不存在
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
    #创建一个群组
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"newadmin":"${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'    '${groupId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatgroup Admin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除群管理员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #添加群管理员
    ${result1}    Add Temp Chatgroup Admin    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    adminName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    'oldadmin'
    @{argumentValue}    create list    'delete'    '${baseRes.validAppUUID}'    'oldadmin'    '${userName}'    '${orgName}'   
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatgroup Admin With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除群管理员-群组ID不存在
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #创建一个群组
    ${groupId}    set variable    ${randomNumber}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    adminName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${groupId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatgroup Admin With IMUser Not Admin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除群管理员-用户不属于群管理员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    adminName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'    '${groupId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatgroup Admin With IMUser Not Admin And Member Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除群管理员-用户不属于群管理员
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    adminName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'    '${groupId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatgroup Admin Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取群管理员列表
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    #添加组内成员
    ${result}    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #添加群管理员
    ${result1}    Add Temp Chatgroup Admin    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup Admin    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'get'    '${baseRes.validAppUUID}'    '${userName}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Transfer Chatgroup Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    转让群组
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
    ${userName}    set variable    ${user['entities'][0]['username']}
    #添加普通成员并设置群管理
    ${chatGroup}    Create New Chatgroup And Set Group Admin    userName=${userName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"newowner":"${userName}"}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Transfer Chatgroup    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'put'    '${baseRes.validAppUUID}'    'newowner'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Invite to group
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    邀请加入群组
    ...    created by wudi
    #转让群组
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/invite    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Invite to group Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    邀请加入群组
    ...    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    #创建一个用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #获取该用户user token
    ${gettokendata}    set variable    {"grant_type":"password","username":"${userName}","password":"${userName}"}
    ${resp}=    /{orgName}/{appName}/token    POST    ${RestRes.alias}    ${requestHeader}    pathParamter=${pathParamter1}    data=${gettokendata}
    ${r}    loads    ${resp.text}   
    ${usertoken}    Get From Dictionary    ${r}    access_token
    log    ${usertoken}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    #创建第二个用户
    ${user2}    Create Temp User
    ${userName2}    set variable    ${user2['entities'][0]['username']}
    #设置请求集和
    ${data}    set variable    {"usernames":["${userName2}"],"welcome":"你好啊"}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Invite to group    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    'true'    '${userName2}'    '${groupId}'    '${orgName}'                
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
  
Apply to join in group
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    申请加入群组
    ...    created by wudi
    #转让群组
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/apply2    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}    
    
Apply to join in group Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    邀请加入群组
    ...    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    #创建一个用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${ownerUserName}    set variable    ${validIMUserInfo.username}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup    owner=${ownerUserName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}  
    #创建第二个用户
    ${user2}    Create Temp User
    ${userName2}    set variable    ${user2['entities'][0]['username']}
    #获取该用户user token
    ${gettokendata}    set variable    {"grant_type":"password","username":"${userName2}","password":"${userName2}"}
    &{pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${resp}=    /{orgName}/{appName}/token    POST    ${RestRes.alias}    ${requestHeader}    pathParamter=${pathParamter1}    data=${gettokendata}
    ${r}    loads    ${resp.text}   
    ${usertoken}    Get From Dictionary    ${r}    access_token
    #设置请求集和
    ${data}    set variable    {"message":"join group123"}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${usertoken}    ${statusCode}    ${keywordDescribtion}    Apply to join in group    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    'true'    '${userName2}'    '${groupId}'    '${orgName}'               
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
 

Quit Group
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    离开群组
     #离开群组
    ${resp}=    /{org_name}/{app_name}/chatgroups/{groupid}/quit    ${session}    ${pathParamter.orgName}    ${pathParamter.appName}    ${pathParamter.groupId}    ${header}    2000    
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse} 
    
Quit Group Template 
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    离开群组
    ...    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    #创建一个新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    #获取该用户user token
    ${gettokendata}    set variable    {"grant_type":"password","username":"${userName}","password":"${userName}"}
    &{pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${resp}=    /{orgName}/{appName}/token    POST    ${RestRes.alias}    ${requestHeader}    pathParamter=${pathParamter1}    data=${gettokendata}
    ${r}    loads    ${resp.text}   
    ${usertoken}    Get From Dictionary    ${r}    access_token
    #获取初始化的有效群组
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    #将新建的用户加入初始化群组
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatgroup Member    @{arguments}
    #该用户退出群组
    &{pathParamter2}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    
    @{arguments1}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter2}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${usertoken}    ${statusCode}    ${keywordDescribtion}    Quit Group    @{arguments1}
    Log Dictionary    ${apiResponse}
    
    @{argumentField}    create list
    @{argumentValue}    create list    'delete'    '${baseRes.validAppUUID}'    'true'    '${orgName}'                
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
    
Apply Verify
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data2}   
    ${resp}=    /{org_name}/{app_name}/chatgroups/{groupid}/apply_verify    ${session}    ${pathParamter.orgName}    ${pathParamter.appName}    ${pathParamter.groupId}    ${header}    ${data2}    500        
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse} 


Apply Verify Template
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
    
    #创建一个群
    ${randomNumber}    Generate Random Specified String
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    desc=${randomNumber}    public=true    maxusers=800    approval=true    owner=${validIMUserInfo.username} 
    ${group_data}    set variable    {"groupname":"${chatGroupEntity.groupname}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"public":${chatGroupEntity.public},"allowinvites":false,"approval":${chatGroupEntity.approval}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{group_pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${result}    Set Base Request Attribute    ${contentType}    ${token}     ${requestHeader}
    &{requestHeader1}    copy dictionary    ${result.requestHeader}
    ${resp}=    /{orgName}/{appName}/chatgroups    POST    ${RestRes.alias}    ${requestHeader1}    pathParamter=${group_pathParamter}    data=${group_data}
    ${r}    loads    ${resp.text}    
    ${data1}    Get From Dictionary    ${r}    data    
    ${groupId}    Get From Dictionary    ${data1}    groupid  
    
    #申请加入该群
    ${data}    set variable    {"message":"join group123"}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${usertoken}    ${statusCode}    ${keywordDescribtion}    Apply to join in group    @{arguments}
    
    #审批入群申请
    ${data2}    set variable    {"applicant":"${userName}","verifyResult":true}
    @{arguments2}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data2}
    &{apiResponse2}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Apply Verify    @{arguments2}
    Log    ${apiResponse2}   
    #断言
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    'true'    'applyVerify'    '${userName}'    '${groupId}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse2}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}



Accept Invitation From Group 
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data2}   
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/invite_verify    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data2}         
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse} 
 
 
 
Accept Invitation From Group Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    ${orgName}    ${appName}    ${groupId}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    ${baseRes.validChatgroup.groupId}
    #创建用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    #取用户token
    ${gettokendata}    set variable    {"grant_type":"password","username":"${userName}","password":"${userName}"}
    &{pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${resp}=    /{orgName}/{appName}/token    POST    ${RestRes.alias}    ${requestHeader}    pathParamter=${pathParamter1}    data=${gettokendata}
    ${r}    loads    ${resp.text}   
    ${usertoken}    Get From Dictionary    ${r}    access_token
    #邀请user加入群组
    ${data}    set variable    {"usernames":["${userName}"],"welcome":"hello"}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    &{pathParamter2}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter2}    ${data}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Invite to group    @{arguments}
    #user审批邀请
    ${data2}    Set Variable    {"invitee":"${userName}","verifyResult":true,"reason":"123"}
    @{arguments2}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter2}    ${data2}
    &{apiResponse2}    Set Request Attribute And Run Keyword    ${contentType}    ${usertoken}    ${statusCode}    ${keywordDescribtion}    Accept Invitation From Group    @{arguments2}
    
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${baseRes.validAppUUID}'    'true'    'inviteVerify'    '${userName}'    '${groupId}'
    ...    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse2}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

