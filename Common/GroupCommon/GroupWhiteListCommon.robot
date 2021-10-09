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
Resource          ../GroupCommon/GroupMemberCommon.robot

*** Keywords ***
Get White List
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/white/users    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
      

Get White List Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #获取初始化的有效群组
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}
     #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get White List    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'get'    '${baseRes.validAppUUID}'    '${baseRes.validIMUser}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


Add to White List Single
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/white/users/{username}    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


Add to White List Single Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    #获取群初始信息
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #将用户添加到群
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatgroup Member    @{arguments}
    #将用户添加至白名单
    &{apiResponse2}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add to White List Single    @{arguments}
    Log Dictionary    ${apiResponse2}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    'true'    'add_user_whitelist'    '${userName}'    ${baseRes.validChatgroup.groupId}    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse2}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


Add to White List
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${data}    Set Variable    {"usernames":["${pathParamter.userName}"]}
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/white/users    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


Add to White List Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    #获取群初始信息
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #将用户添加到群
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Single Chatgroup Member    @{arguments}
    #将用户添加至白名单
    &{apiResponse2}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add to White List    @{arguments}
    Log Dictionary    ${apiResponse2}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    'true'    'add_user_whitelist'    '${userName}'    ${baseRes.validChatgroup.groupId}    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse2}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

