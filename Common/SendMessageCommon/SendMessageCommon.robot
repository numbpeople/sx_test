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
# Resource          ../SendMessageCommom/SendMessageCommom.robot
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=text    msg=${userName}
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
Send Open Debug Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送透传消息-开启debug模式
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=cmd    action=em_start_debug
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
Send Close Debug Message Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送透传消息-开启debug模式
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=cmd    action=em_stop_debug
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #上传图片文件
    ${pictureResponse}    Upload Picture
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #上传语音文件
    ${pictureResponse}    Upload Audio
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
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
    ${userName}    set variable    ${validIMUserInfo.username}
    #上传语音文件
    ${pictureResponse}    Upload Audio
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
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
    return from keyword    true
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建新的用户
    ${userName}    set variable    ${validIMUserInfo.username}
    #上传语音文件
    ${pictureResponse}    Upload Audio
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    # &{msgBody}    Create Dictionary    {"appkey":"${orgName}#${appName}","host":"localhost","from":"hx#hxdemo_wzy@easemob.com","to":"hx#hxdemo_wzy_huawei@easemob.com","msg_id":"626473521765161476","timestamp":1585011534369,"direction":"offline","chat_type":"chat","payload":{"ext":{"em_push_ext":{"type":"call","sound":"/raw/ring","channel_id":"testChannel","custom":{"test":1}},"em_ignore_notification":false,"em_force_notification":true,"em_apns_ext":{"em_alert_title":"","em_alert_subTitle":"","em_alert_body":"","em_push_title":"您有一条新消息","em_push_name":"您有一条新消息","em_push_content":"您有一条新消息","em_push_category":"","em_push_mutable_content":true,"em_push_body_loc_key":"","em_push_title_loc_key":"","em_push_title_loc_args":"","em_push_body_loc_args":"","em_push_sound":"appsound.mp3","em_push_badge":1,"em_push_ignore_sound":true,"extern":{"test":"123"},"em_push_collapse_key":"collapseKey","em_huawei_push_badge_class":"com.hyphenate.chatuidemo.ui.SplashActivity","em_push_channel_id":"testSound"},"em_android_push_ext":{"em_push_channel_id":"testChannel","em_push_sound":"/raw/appsound","em_push_callback_url":"http://www.easemob.com","em_push_callback_param":"easemobtest","em_push_callback_type_meizu":"3","em_push_xiaomi_notify_id":1,"em_push_callback_type_xiaomi":"3","em_push_xiaomi_channel_id":"","em_push_xiaomi_sound_uri":""}},"bodies":[{"msg":"你好啊，吃饭了没？","type":"txt"}],"from":"wzy","to":"wzy_huawei"}}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${userName}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=audio    filename=${filename}    secret=${shareSecret}    url=${url}    length=3494
    #定义扩展消息
    
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

Send Group Message
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    发送文本、图片、语音、视频、扩展等消息
    #发送文本、图片、语音、视频、扩展等消息
    ${resp}=    /{orgName}/{appName}/messages?useMsgId=true    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Send Group Message Template 
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    发送群文本消息
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${orgName}    ${appName}    ${groupId}    ${userName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    ${baseRes.validChatgroup.groupId}    ${validIMUserInfo.username}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    groupId=${groupId}    userName=${userName}
    #定义消息接收人列表
    @{targetList}    create list    ${groupId}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=txt    msg=${groupId}
    #定义请求体
    &{msgBody}    create dictionary    target_type=chatgroups    target=${targetList}    msg=${msgInfo}    from=${userName}
    #转换json的请求体
    ${msgData}    dumps    ${msgBody}
    log dictionary    ${msgBody}
    log    ${msgData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${msgData}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Send Group Message
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${groupId}'
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


Send Group Audio Message Template
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
    ${userName}    set variable    ${validIMUserInfo.username}
    ${groupId}    Set Variable    ${baseRes.validChatgroup.groupId}        
    #上传语音文件
    ${pictureResponse}    Upload Audio
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${groupId}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=audio    filename=${filename}    secret=${shareSecret}    url=${url}    length=3494
    #定义请求体
    &{msgBody}    create dictionary    target_type=chatgroups    target=${targetList}    msg=${msgInfo}    from=${userName}
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
    @{argumentField}    create list    '${groupId}'
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Send Group Picture Message Template
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
    ${userName}    set variable    ${validIMUserInfo.username}
    ${groupId}    Set Variable    ${baseRes.validChatgroup.groupId}  
    #上传图片文件
    ${pictureResponse}    Upload Picture
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    ${url}    set variable    ${pictureResponse.url}
    ${filename}    set variable    ${pictureResponse.filename}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${validUserUUID}    set variable    ${validIMUserInfo.uuid}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #定义消息接收人列表
    @{targetList}    create list    ${groupId}
    #定义消息类型和内容
    &{msgInfo}    create dictionary    type=img    filename=${filename}    secret=${shareSecret}    url=${url}
    #定义图片尺寸
    &{size}    create dictionary    width=480    height=720
    #定义请求体
    &{msgBody}    create dictionary    target_type=chatgroups    target=${targetList}    msg=${msgInfo}    from=${userName}    size=${size}
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
    @{argumentField}    create list    '${groupId}'
    @{argumentValue}    create list    '${baseRes.validAppUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


