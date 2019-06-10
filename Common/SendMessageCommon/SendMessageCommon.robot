*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/SendMessage/SendMessageApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../UserCommon/UserCommon.robot
Resource          ../FileUploadDownloadCommon/FileUploadDownloadCommon.robot

*** Keywords ***
Send Message
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    发送文本、图片、语音、视频、扩展等消息
    #发送文本、图片、语音、视频、扩展等消息
    ${resp}=    /{orgName}/{appName}/messages    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Send Text Message
    [Arguments]    ${msgEntity}
    [Documentation]    发送文本消息
    ...
    ...    ${msgEntity}：发消息定义的字典结构
    ...
    ...    - from：消息的发起者
    ...    - target：消息的送达者
    ...    - msg：消息内容
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #获取传入参数的各个值
    log dictionary    ${msgEntity}
    ${from}    ${target}    ${msg}    set variable    ${msgEntity.fromUser}    ${msgEntity.targetUser}    ${msgEntity.msg}
    #定义消息接收人列表
    @{targetList}    create list    ${target}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=txt    msg=${msg}
    #定义请求体
    &{msgBody}    create dictionary    target_type=users    target=${targetList}    msg=${msgInfo}    from=${from}
    #转换json的请求体
    ${msgData}    dumps    ${msgBody}
    log dictionary    ${msgBody}
    log    ${msgData}
    #发送文本消息
    &{apiResponse}    Send Message    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${msgData}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    发送文本消息失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Send Text Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送文本消息
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
    ${userName}    set variable    ${baseRes.validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${baseRes.validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=txt    msg=${userName}
    #定义请求体
    &{msgBody}    create dictionary    target_type=users    target=${targetList}    msg=${msgInfo}    from=${userName}
    #转换json的请求体
    ${msgData}    dumps    ${msgBody}
    log dictionary    ${msgBody}
    log    ${msgData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${msgData}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Send Message
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'
    @{argumentValue}    create list    '${applicationUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Send Picture Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送图片消息
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
    ${userName}    set variable    ${baseRes.validIMUserInfo.username}
    #上传图片文件
    ${pictureResponse}    Upload Picture
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${baseRes.validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=img    filename=${filename}    secret=${shareSecret}    url=${url}
    #定义图片尺寸
    &{size}    create dictionary    width=480    height=720
    #定义请求体
    &{msgBody}    create dictionary    target_type=users    target=${targetList}    msg=${msgInfo}    from=${userName}    size=${size}
    #转换json的请求体
    ${msgData}    dumps    ${msgBody}
    log dictionary    ${msgBody}
    log    ${msgData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${msgData}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Send Message
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'
    @{argumentValue}    create list    '${applicationUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Send Audio Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送语音消息
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
    ${userName}    set variable    ${baseRes.validIMUserInfo.username}
    #上传语音文件
    ${pictureResponse}    Upload Audio
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${baseRes.validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=audio    filename=${filename}    secret=${shareSecret}    url=${url}    length=3494
    #定义请求体
    &{msgBody}    create dictionary    target_type=users    target=${targetList}    msg=${msgInfo}    from=${userName}
    #转换json的请求体
    ${msgData}    dumps    ${msgBody}
    log dictionary    ${msgBody}
    log    ${msgData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${msgData}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Send Message
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'
    @{argumentValue}    create list    '${applicationUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Send Video Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送视频消息
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    return from keyword    true
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${userName}    set variable    ${baseRes.validIMUserInfo.username}
    #上传语音文件
    ${pictureResponse}    Upload Audio
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${baseRes.validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=audio    filename=${filename}    secret=${shareSecret}    url=${url}    length=3494
    #定义请求体
    &{msgBody}    create dictionary    target_type=users    target=${targetList}    msg=${msgInfo}    from=${userName}
    #转换json的请求体
    ${msgData}    dumps    ${msgBody}
    log dictionary    ${msgBody}
    log    ${msgData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${msgData}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Send Message
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'
    @{argumentValue}    create list    '${applicationUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Send Ext Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送扩展消息
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    return from keyword    true
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${userName}    set variable    ${baseRes.validIMUserInfo.username}
    #上传语音文件
    ${pictureResponse}    Upload Audio
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${baseRes.validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=audio    filename=${filename}    secret=${shareSecret}    url=${url}    length=3494
    #定义请求体
    &{msgBody}    create dictionary    target_type=users    target=${targetList}    msg=${msgInfo}    from=${userName}
    #转换json的请求体
    ${msgData}    dumps    ${msgBody}
    log dictionary    ${msgBody}
    log    ${msgData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${msgData}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Send Message
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${userName}'
    @{argumentValue}    create list    '${applicationUUID}'    '${userName}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
