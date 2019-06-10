*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/FileUploadDownload/FileUploadDownloadApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot

*** Keywords ***
Upload Media File
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${files}
    [Documentation]    上传语音/图片文件
    #上传语音/图片文件
    ${resp}=    /{orgName}/{appName}/chatfiles    POST    ${session}    ${header}    pathParamter=${pathParamter}    files=${files}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Download Media File
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    下载语音/图片文件
    #上传语音/图片文件
    ${resp}=    /{orgName}/{appName}/chatfiles/{fileStream}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Upload Picture
    [Documentation]    上传图片
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #获取图片文件
    ${picpath}    Find Media Path
    &{filesEntity}    create dictionary    filename=image.gif    filepath=${picpath}    contentType=image/gif
    ${fileData}    evaluate    ('${filesEntity.filename}', open('${filesEntity.filepath}','rb'),'${filesEntity.contentType}',{'Expires': '0'})
    &{files}    Create Dictionary    file=${fileData}
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    restrict-access=true
    remove from dictionary    ${newRequestHeader}    Content-Type
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #上传图片
    &{apiResponse}    Upload Media File    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${files}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    上传图片文件失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    set to dictionary    ${filesEntity}    uuid=${text['entities'][0]['uuid']}    shareSecret=${text['entities'][0]['share-secret']}    url=${text['uri']}/${text['entities'][0]['uuid']}
    return from keyword    ${filesEntity}

Upload Audio
    [Documentation]    上传语音文件
    #创建请求体
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #获取语音文件
    ${picpath}    Find Media Path    audio
    &{filesEntity}    create dictionary    filename=blob.amr    filepath=${picpath}    contentType=audio/amr
    ${fileData}    evaluate    ('${filesEntity.filename}', open('${filesEntity.filepath}','rb'),'${filesEntity.contentType}',{'Expires': '0'})
    &{files}    Create Dictionary    file=${fileData}
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    restrict-access=true
    remove from dictionary    ${newRequestHeader}    Content-Type
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #上传语音
    &{apiResponse}    Upload Media File    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${files}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    上传语音文件失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    set to dictionary    ${filesEntity}    uuid=${text['entities'][0]['uuid']}    shareSecret=${text['entities'][0]['share-secret']}    url=${text['uri']}/${text['entities'][0]['uuid']}
    return from keyword    ${filesEntity}

Upload Picture Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    上传图片
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
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #获取图片文件
    ${picpath}    Find Media Path
    &{filesEntity}    create dictionary    filename=image.gif    filepath=${picpath}    contentType=image/gif
    ${fileData}    evaluate    ('${filesEntity.filename}', open('${filesEntity.filepath}','rb'),'${filesEntity.contentType}',{'Expires': '0'})
    &{files}    Create Dictionary    file=${fileData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${files}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Upload Media File
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Upload Audio Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    上传语音
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
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #获取语音文件
    ${picpath}    Find Media Path    audio
    &{filesEntity}    create dictionary    filename=blob.amr    filepath=${picpath}    contentType=audio/amr
    ${fileData}    evaluate    ('${filesEntity.filename}', open('${filesEntity.filepath}','rb'),'${filesEntity.contentType}',{'Expires': '0'})
    &{files}    Create Dictionary    file=${fileData}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${files}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Upload Media File
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${applicationUUID}'    '${orgName}'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Download Picture Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    下载图片
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #上传图片文件
    ${pictureResponse}    Upload Picture
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    fileStream=${uuid}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    &{newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Accept=application/octet-stream    share-secret=${shareSecret}
    @{arguments}    Create List    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Download Media File
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Download Audio Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    下载语音
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #上传语音文件
    ${audioResponse}    Upload Audio
    ${uuid}    set variable    ${audioResponse.uuid}
    ${shareSecret}    set variable    ${audioResponse.shareSecret}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    fileStream=${uuid}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    &{newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Accept=application/octet-stream    share-secret=${shareSecret}
    @{arguments}    Create List    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Download Media File
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Download Thumbnail Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    下载缩略图
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #上传图片文件
    ${pictureResponse}    Upload Picture
    ${uuid}    set variable    ${pictureResponse.uuid}
    ${shareSecret}    set variable    ${pictureResponse.shareSecret}
    #设置请求数据
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    fileStream=${uuid}
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    &{newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Accept=application/octet-stream    thumbnail=true
    @{arguments}    Create List    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Download Media File
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
