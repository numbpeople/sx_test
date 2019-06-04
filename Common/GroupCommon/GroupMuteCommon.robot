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
Resource          GroupMemberCommon.robot

*** Keywords ***
Add Chatgroup User Mute
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    添加禁言
    #添加禁言
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/mute    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Remove Chatgroup User Mute
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    移除禁言
    #移除禁言
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/mute/{userName}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Temp Chatgroup User Mute
    [Arguments]    ${groupId}    ${userName}
    [Documentation]    添加禁言
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    ${data}    set variable    {"usernames":["${userName}"],"mute_duration":86400000}
    #添加禁言
    &{apiResponse}    Add Chatgroup User Mute    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    群组添加用户禁言，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Get Chatgroup User Mute List
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取禁言列表
    #获取禁言列表
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}/mute    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Add Chatgroup User Mute Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加禁言
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
    #添加单个群组成员
    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"usernames":["${userName}"],"mute_duration":86400000}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatgroup User Mute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${baseRes.validAppUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatgroup User Mute With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加禁言-群组ID不存在
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
    ${userName}    set variable    ${baseRes.validIMUserInfo.username}
    ${groupId}    set variable    ${randomNumber}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"usernames":["${userName}"],"mute_duration":86400000}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatgroup User Mute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${groupId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add Chatgroup User Mute With Inexistent IMUser Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    添加禁言-IM用户不存在
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
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${data}    set variable    {"usernames":["${userName}"],"mute_duration":86400000}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Chatgroup User Mute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${userName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatgroup User Mute Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除禁言
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
    #添加单个群组成员
    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #群组添加用户禁言
    Add Temp Chatgroup User Mute    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup User Mute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'delete'    '${baseRes.validAppUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatgroup User Mute With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除禁言-群组ID不存在
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
    ${userName}    set variable    ${baseRes.validIMUserInfo.username}
    ${groupId}    set variable    ${randomNumber}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup User Mute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${groupId}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Remove Chatgroup User Mute With Inexistent IMUser Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    移除禁言-IM用户不存在
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
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Remove Chatgroup User Mute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'delete'    '${baseRes.validAppUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatgroup User Mute List Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取禁言列表
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
    #创建新的群组
    ${chatGroup}    Create Temp Chatgroup
    ${groupId}    set variable    ${chatGroup.groupId}
    #添加单个群组成员
    Add Temp Single Chatgroup Member    ${groupId}    ${userName}
    #群组添加用户禁言
    Add Temp Chatgroup User Mute    ${groupId}    ${userName}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup User Mute List
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${baseRes.validAppUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
