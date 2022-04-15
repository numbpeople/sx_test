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
Resource          ../SendMessageCommon/SendMessageCommon.robot

*** Keywords ***
Create Chatgroup
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    创建一个群组
    #创建一个群组
    ${resp}=    /{orgName}/{appName}/chatgroups    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Create Temp Chatgroup
    [Arguments]    ${owner}=${validIMUserInfo.username}    ${maxusers}=200    ${public}=true    ${members_only}=false
    [Documentation]    创建一个群组
    #创建请求体
    ${randomNumber}    Generate Random Specified String
    ${groupName}    Catenate    群组昵称${randomNumber}
    ${desc}    Catenate    群组描述    ${randomNumber}
    &{chatGroupEntity}    Create Dictionary    groupName=${groupName}    desc=${desc}    owner=${owner}    maxusers=${maxusers}    public=${public}
    ...    members_only=${members_only}
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupName}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"public":${chatGroupEntity.public},"members_only":${chatGroupEntity.members_only}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建群组
    &{apiResponse}    Create Chatgroup    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建群组失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    set to dictionary    ${chatGroupEntity}    groupId=${text['data']['groupid']}
    Return From Keyword    ${chatGroupEntity}

Get Chatgroup Init
    [Arguments]    ${owner}=${validIMUserInfo.username}    ${maxusers}=200    ${public}=true    ${members_only}=false
    [Documentation]    创建一个群组，初始化群组信息
    #创建一个群组
    ${chatGroup}    Create Temp Chatgroup
    ${validChatgroup}    create dictionary    groupId=${chatGroup.groupId}
    #设置全局的有效、无效基本数据
    set to dictionary    ${baseRes}    validChatgroup=${validChatgroup}
    set global variable    ${baseRes}    ${baseRes}
    Set Parallel Value For Key    ParallelbaseRes    ${baseRes}

Edit Chatgroup
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    修改群组信息
    #修改群组信息
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}    PUT    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Delete Chatgroup
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    删除群组
    #删除群组
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Chatgroup
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取App中所有的群组
    #获取App中所有的群组
    ${resp}=    /{orgName}/{appName}/chatgroups    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Get Public Chatgroup
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取App中所有的公开的群组
    #获取App中所有的群组
    ${resp}=    /{orgName}/{appName}/publicchatgroups    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Get Chatgroup By Page
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${params}    
    [Documentation]    分页获取App中所有的群组
    ...    create by wudi 
    #获取App中所有的群组
    ${resp}=    /{orgName}/{appName}/chatgroups    GET    ${session}    ${header}    pathParamter=${pathParamter}    params=${params}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


Get IM User Joined Chatgroups
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取一个用户参与的所有群组
    #获取一个用户参与的所有群组
    ${resp}=    /{orgName}/{appName}/users/{userName}/joined_chatgroups    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Chatgroup Details
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取群组详情
    #获取群组详情
    ${resp}=    /{orgName}/{appName}/chatgroups/{groupId}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Chatgroup Count
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    群组统计    created by wudi
    #获取群组详情
    ${resp}=    /{orgname}/{appname}/chatgroups/count    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
Chatgroup Member Count
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    群组统计    created by wudi
    #获取群组详情
    ${resp}=    /{orgname}/{appname}/chatgroups/{groupid}/count    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Chatgroup Count Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    群组统计    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Chatgroup Count
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Chatgroup Member Count Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    群组成员数量统计    created by shuangxi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建一个用户
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
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Chatgroup Member Count
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '1'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Create New Chatgroup Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个新的群组（群组名称、描述为英文）
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    log    ${token}
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${username}    set variable    ${validIMUserInfo.username}
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    desc=${randomNumber}    owner=${username}    maxusers=200    public=true
    ...    members_only=false
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"public":${chatGroupEntity.public},"members_only":${chatGroupEntity.members_only}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create Include Chinese groups Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个新的群组（群组名称、描述为中文）
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    log    ${token}
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${desc}    Catenate    描述    ${randomNumber}
    Log    ${desc}    
    ${username}    set variable    ${validIMUserInfo.username}
    &{chatGroupEntity}    Create Dictionary    groupname=群组    desc=${desc}    owner=${username}    maxusers=200    public=true
    ...    members_only=false
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"public":${chatGroupEntity.public},"members_only":${chatGroupEntity.members_only}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create Private Chatgroup Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}    ${allow}
    [Documentation]    
    ...    created by wudi 
    #判断是否继续执行该条测试用例
    log    ${token}
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${username}    set variable    ${validIMUserInfo.username}
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    desc=${randomNumber}    public=false    maxusers=800    approval=true    owner=${username}    
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"public":${chatGroupEntity.public},"allowinvites":${allow},"approval":${chatGroupEntity.approval}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}   
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'   
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    


Create Public Chatgroup Without Invite Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}    ${allow}
    [Documentation]    
    ...    created by wudi 
    log    ${token}
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${randomNumber}    Generate Random Specified String
    ${username}    set variable    ${validIMUserInfo.username}
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    desc=${randomNumber}    public=true    maxusers=800    approval=true    owner=${username}    
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"public":${chatGroupEntity.public},"allowinvites":${allow},"approval":${chatGroupEntity.approval}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}   
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


Create New Chatgroup With Inexistent Owner Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个新的群组-群主用户ID不存在
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
    ${username}    set variable    ${validIMUserInfo.username}
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    desc=${randomNumber}    owner=${randomNumber}    maxusers=200    public=true
    ...    members_only=false
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"public":${chatGroupEntity.public},"members_only":${chatGroupEntity.members_only}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New Chatgroup With Inexistent PublicTemplate
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建一个新的群组-是否公开群组字段不存在
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
    ${username}    set variable    ${validIMUserInfo.username}
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    desc=${randomNumber}    owner=${randomNumber}    maxusers=200    public=true
    ...    members_only=false
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","desc":"${chatGroupEntity.desc}","owner":"${chatGroupEntity.owner}","maxusers":${chatGroupEntity.maxusers},"members_only":${chatGroupEntity.members_only}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Edit Chatgroup Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改群组信息
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
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    description=${randomNumber}    maxusers=200
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","description":"${chatGroupEntity.description}","maxusers":${chatGroupEntity.maxusers}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Edit Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
Edit Chatgroup Maxuser Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改群组信息
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
    &{chatGroupEntity}    Create Dictionary    maxusers=100
    ${data}    set variable    {"maxusers":${chatGroupEntity.maxusers}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Edit Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Edit Chatgroup With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    修改群组信息-群组ID不存在
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
    # Comment    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}    #获取初始化的有效群组
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    description=${randomNumber}    maxusers=200
    ${data}    set variable    {"groupname":"${chatGroupEntity.groupname}","description":"${chatGroupEntity.description}","maxusers":${chatGroupEntity.maxusers}}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Edit Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Chatgroup Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    删除群组信息
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
    ${chatGroup}    Create Temp Chatgroup
    ${groupId}    set variable    ${chatGroup.groupId}
    ${randomNumber}    Generate Random Specified String
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    description=${randomNumber}    maxusers=200
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${groupId}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Delete Chatgroup With Inexistent GroupId Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    删除群组信息-群组ID不存在
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
    &{chatGroupEntity}    Create Dictionary    groupname=${randomNumber}    description=${randomNumber}    maxusers=200
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatgroup Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取App中所有的群组
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
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get IM User Joined Chatgroups Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取一个用户参与的所有群组
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
    ${chatGroup}    Create Temp Chatgroup    owner=${userName}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    #设置变量
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${userName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get IM User Joined Chatgroups
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${groupId}'    '${groupName}'
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${groupId}'    '${groupName}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get IM User Joined Chatgroups With Inexistent IM User Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取一个用户参与的所有群组
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
    #设置变量
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get IM User Joined Chatgroups
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatgroup Detail Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取群组详情
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
    ${owner}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${public}    set variable    true
    ${members_only}    set variable    false
    #创建新的群组
    ${chatGroup}    Create Temp Chatgroup    ${owner}    ${maxusers}    ${public}    ${members_only}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    ${desc}    set variable    ${chatGroup.desc}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup Details
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${groupId}'    '${groupName}'    '${desc}'    'false'
    ...    '${members_only}'    '${maxusers}'    '${owner}'    '${owner}'    '${public}'    '${orgName}'
    ...    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatgroup Detail With Inexistent GroupIdTemplate
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    获取群组详情-群组ID不存在
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
    ${owner}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${public}    set variable    true
    ${members_only}    set variable    false
    #创建新的群组
    ${randomNumber}    Generate Random Specified String
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${randomNumber}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup Details
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${randomNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get All Groups Of App by page Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    created by wudi 分页获取全部群组
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${params}    Create Dictionary    limit=8    version=v3
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${params}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup By Page
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Public Group Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    created by wudi 
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Public Chatgroup
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Get ChatgroupS Detail Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${owner}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${public}    set variable    true
    ${members_only}    set variable    false
    #创建新的群组
    ${chatGroup}    Create Temp Chatgroup    ${owner}    ${maxusers}    ${public}    ${members_only}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    ${desc}    set variable    ${chatGroup.desc}
    #创建第二个群组
    ${chatGroup2}    Create Temp Chatgroup    ${owner}    ${maxusers}    ${public}    ${members_only}
    ${groupId2}    set variable    ${chatGroup2.groupId}
    ${groupName2}    set variable    ${chatGroup2.groupName}
    ${desc2}    set variable    ${chatGroup2.desc}

    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId},${groupId2}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup Details
    ...    @{arguments}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${groupId}'    '${groupName}'    '${desc}'    'false'
    ...    '${members_only}'    '${maxusers}'    '${owner}'    '${public}'    '${groupId2}'    '${groupName2}'    '${desc2}'    'false'
    ...    '${members_only}'    '${maxusers}'    '${owner}'    '${public}'    '${orgName}'
    ...    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Chatgroup roles
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    #创建一个群组
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/roles    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Get Chatgroup roles Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${owner}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${public}    set variable    true
    ${members_only}    set variable    false
    #创建新的群组
    ${chatGroup}    Create Temp Chatgroup    ${owner}    ${maxusers}    ${public}    ${members_only}
    ${groupId}    set variable    ${chatGroup.groupId}
    ${groupName}    set variable    ${chatGroup.groupName}
    ${desc}    set variable    ${chatGroup.desc}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Chatgroup roles
    ...    @{arguments}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${validIMUserInfo.username}'    'owner'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


Add Group Announcement
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${data}    set variable    {"announcement": "test"}
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/announcement    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


Add Group Announcement Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #获取初始化的有效群组
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Add Group Announcement    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${groupId}'    'true'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
    
        
Get Group Announcement
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/announcement    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


Get Group Announcement Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #获取初始化的有效群组
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Group Announcement    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Shield Group Message
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/shield    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


Shield Group Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #获取初始化的有效群组
    ${groupId}    set variable    ${baseRes.validChatgroup.groupId}
     #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #获取该用户user token
    ${gettokendata}    set variable    {"grant_type":"password","username":"${baseRes.validIMUser}","password":"${baseRes.validIMUser}"}
    &{pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${resp}=    /{orgName}/{appName}/token    POST    ${RestRes.alias}    ${requestHeader}    pathParamter=${pathParamter1}    data=${gettokendata}
    ${r}    loads    ${resp.text}   
    ${usertoken}    Get From Dictionary    ${r}    access_token
    log    ${usertoken}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${usertoken}    ${statusCode}    ${keywordDescribtion}    Shield Group Message    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'post'    '${baseRes.validAppUUID}'    'true'    'add_shield'    '${baseRes.validIMUser}'    '${groupId}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


UnShield Group Message
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/shield    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   

UnShield Group Message Template
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
    #获取该用户user token
    ${gettokendata}    set variable    {"grant_type":"password","username":"${baseRes.validIMUser}","password":"${baseRes.validIMUser}"}
    &{pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${resp}=    /{orgName}/{appName}/token    POST    ${RestRes.alias}    ${requestHeader}    pathParamter=${pathParamter1}    data=${gettokendata}
    ${r}    loads    ${resp.text}   
    ${usertoken}    Get From Dictionary    ${r}    access_token
    log    ${usertoken}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${usertoken}    ${statusCode}    ${keywordDescribtion}    UnShield Group Message    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'delete'    '${baseRes.validAppUUID}'    'true'    'remove_shield'    '${baseRes.validIMUser}'    '${groupId}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Member Who Open Shield
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/shield    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   


Get Member Who Open Shield Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${orgName}    ${appName}    ${groupId}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    ${baseRes.validChatgroup.groupId}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Member Who Open Shield    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'get'    '${baseRes.validAppUUID}'    '${orgName}'    '0'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

   

 Users join groups in batches
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${data}    Set Variable    {"id_list":["${pathParamter.groupId1}","${pathParamter.groupId2}"]}
    ${resp}=    /{orgName}/{appName}/users/{username}/joined_chatgroups    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   


 Users join groups in batches Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    #创建群所需参数
    ${owner}    set variable    ${validIMUserInfo.username}
    ${maxusers}    set variable    200
    ${public}    set variable    true
    ${members_only}    set variable    false
    #创建新的群组1
    ${chatGroup1}    Create Temp Chatgroup    ${owner}    ${maxusers}    ${public}    ${members_only}
    ${groupId1}    set variable    ${chatGroup1.groupId}
    #创建新的群组2
    ${chatGroup2}    Create Temp Chatgroup    ${owner}    ${maxusers}    ${public}    ${members_only}
    ${groupId2}    set variable    ${chatGroup2.groupId}
    #创建新的用户
    ${user}    Create Temp User
    ${userName}    set variable    ${user['entities'][0]['username']}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId1=${groupId1}    groupId2=${groupId2}    userName=${userName}
    #该用户批量加入群1群2
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Users join groups in batches    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${groupId1}'    '${groupId2}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
 
   
Ban Group Message   
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/ban    POST    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   


Ban Group Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${orgName}    ${appName}    ${groupId}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    ${baseRes.validChatgroup.groupId}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Ban Group Message    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    'true'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
 
    

Allow Group Message   
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi    
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/ban    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   

Allow Group Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${orgName}    ${appName}    ${groupId}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    ${baseRes.validChatgroup.groupId}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Allow Group Message    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    'false'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
     


Get Received Members
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/acks/{msgID}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   
    
Get Received Members Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${orgName}    ${appName}    ${groupId}    ${userName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    ${baseRes.validChatgroup.groupId}    ${validIMUserInfo.username}
    #定义消息接收人列表
    @{targetList}    create list    ${groupId}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=txt    msg=${groupId}
    #定义请求体
    &{msgBody}    create dictionary    target_type=chatgroups    target=${targetList}    msg=${msgInfo}    from=${userName}
    ${msgData}    dumps    ${msgBody}
    
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}  
    #设置发送消息的请求头
    ${result}    Set Base Request Attribute    ${contentType}    ${token}     ${requestHeader}
    &{requestHeader1}    copy dictionary    ${result.requestHeader}
    #发送消息
    ${resp}=    /{orgName}/{appName}/messages?useMsgId=true    POST    ${RestRes.alias}    ${requestHeader1}    pathParamter=${pathParamter}    data=${msgData}
    ${r}    loads    ${resp.text}    
    #获取消息ID
    ${data1}    Get From Dictionary    ${r}    data    
    ${MsgId}    Get From Dictionary    ${data1}    ${groupId}    
    #获取群消息已读成员列表
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${pathParamter1}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    msgId=${MsgId}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter1}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Received Members    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'group_read_ack'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
 
 


Get File List
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{orgName}/{appName}/chatgroups/{grpID}/share_files    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   


Get File List Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${orgName}    ${appName}    ${groupId}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    ${baseRes.validChatgroup.groupId}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}  
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get File List    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    'get'    '${baseRes.validAppUUID}'    '${orgName}'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
