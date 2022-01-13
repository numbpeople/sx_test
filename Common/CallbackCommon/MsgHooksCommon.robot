*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource    ../../RestApi/CallBack/MsgHooksApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot


*** Keywords ***
AddMsghooksAPI
    [Documentation]    创建一个发送前回调
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    ${resp}=    /{orgName}/{appName}/msghooks    POST    ${session}    ${header}    pathParamter=${pathParamter}
    ...    data=${data}    
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


GetAllMsghooksAPI
    [Documentation]    查看所有发送前回调
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/msghooks    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

DeleteMsghooksAPI
    [Documentation]    删除一个发送前回调
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/msghooks/{msghooksname}    DELETE    ${session}    ${header}    ${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

EditMsghooksAPI
    [Documentation]    修改一个发送前回调
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    ${resp}=    /{orgName}/{appName}/msghooks/{msghooksname}    PUT    ${session}    ${header}    ${pathParamter}
    ...    data=${data}  
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

GetSingleMsgHooksAPI
    [Documentation]    查看单个发送前回调详情
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/msghooks/{msghooksname}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

AddMsgHooksTemp
    [Documentation]    添加发送前回调
    [Arguments]    ${specificPreString}=
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #设置请求参数
    ${specificPreString}    Run Keyword If    '${specificPreString}'=='${EMPTY}'    Generate Random String    8    [LOWER]
    ${msghooksname}    Set Variable    ${specificPreString} 
    Log    ${msghooksvariable.msghooksuri}
    ${data}    set variable     {"name":"${msghooksname}","msgTypes":["VIDEO","FILE","IMAGE","LOCATION","TEXT","VOICE","CUSTOM"],"interested":["chat","groupchat","chatroom"],"targetUrl":"${msghooksvariable.msghooksuri}","defaultAction":0,"error_code":1,"status":1,"callType":"before"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    AddMsgHooksAPI    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}


DelteMsgHooksTemp
    [Documentation]    删除发送后回调
    [Arguments]    ${specificPreString}=
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #设置请求参数
    ${msghooksid}    Set Variable    ${specificPreString} 
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    msgHooksName=${msghooksid}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    DeleteMsgHooksAPI    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}


GetAllMsgHooksTemp
    [Documentation]    查询已有发送后回调
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    GetAllMsgHooksAPI    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}


AddMsgHooksTemplate
    [Documentation]    添加一个发送前回调
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求参数
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${msghooksname}    Generate Random String    8    qwertyuiopasdfghjklzxcvbnm
    Log    ${msghooksvariable.msghooksuri}    
    ${data}    set variable    {"name":"${msghooksname}","msgTypes":["VIDEO","FILE","IMAGE","LOCATION","TEXT","VOICE","CUSTOM"],"interested":["chat","groupchat","chatroom"],"targetUrl":"${msghooksvariable.msghooksuri}","defaultAction":0,"error_code":1,"status":1,"callType":"before"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    AddMsgHooksAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    #设置结果替换参数
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/msghooks
    @{argumentField}    create list
    @{argumentValue}    create list    '/msghooks'    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    '${msghooksvariable.msghooksuri}'    '${msghooksname}'    'post'    '${baseRes.validAppName}'

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


EditMsgHooksTemplate
    [Documentation]    修改一个发送后回调（create by shuang）
    ...    步骤1.先创建一个发送后回到
    ...    步骤2.修改步骤一中创建的发送后回调
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #添加一个发送前回调
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${MsgHooks}    AddMsgHooksTemp 
    ${msghooksname}    Set Variable    ${MsgHooks["entities"][0]["name"]}
    Log    ${msghooksname}     
    #构建修改body参数 
    ${newurl}    Set Variable    http://www.baidu111.com
    ${newname}    Generate Random String    8    [LOWER]      
    #设置请求参数
    ${data}    set variable    {"name":"${newname}","msgTypes":["VIDEO","FILE","IMAGE","LOCATION","TEXT","VOICE","CUSTOM"],"interested":["chat","groupchat","chatroom"],"targetUrl":"${newurl}","defaultAction":0,"error_code":1,"status":1,"callType":"before"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    msgHooksName=${msghooksname}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    EditMsgHooksAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    #设置结果替换参数
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/msghooks/${msghooksname}
    @{argumentField}    create list
    @{argumentValue}    create list    '/msghooks/${msghooksname}'    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    '${newurl}'    '${newname}'    'put'    '${baseRes.validAppName}'

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


DeleteMsgHooksTemplate
    [Documentation]    删除一个发送后回调（create by shuang）
    ...    步骤1.先创建一个发送后回到
    ...    步骤2.删除步骤一中创建的发送后回调
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    #添加一个发送后回调
    ${MsgHooks}    AddMsgHooksTemp
    #设置校验结果参数
    ${msghooksname}    Set Variable    ${MsgHooks["entities"][0]["name"]}
    ${msghooksid}    Set Variable    ${MsgHooks["entities"][0]["id"]}
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/msghooks/${msghooksname}
    Log    ${msghooksname}    
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    msgHooksName=${msghooksid}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    DeleteMsgHooksAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '/msghooks/${msghooksname}'    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    'delete'    '${baseRes.validAppName}'

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

GetSingMsgHooksTemplate
   [Documentation]    查询一个发送后回调详情（create by shuang）
    ...    步骤1.先创建一个发送后回到
    ...    步骤2.查询步骤一中创建的发送后回调详情
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    #添加一个发送后回调
    ${MsgHooks}    AddMsgHooksTemp
    #设置校验结果参数
    ${msghooksname}    Set Variable    ${MsgHooks["entities"][0]["name"]}
    ${msghooksid}    Set Variable    ${MsgHooks["entities"][0]["id"]}
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/msghooks/${msghooksid}
    Log    ${msghooksname}    
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    msgHooksName=${msghooksid}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    GetSingleMsgHooksAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '/msghooks/${msghooksname}'    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    '${msghooksvariable.msghooksuri}'    '${msghooksname}'    'get'    '${baseRes.validAppName}'

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

GetAllMsgHooksTemplate
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    #添加两个个发送后回调
    ${MsgHooks}    AddMsgHooksTemp
    ${MsgHooks1}    AddMsgHooksTemp
    #设置校验结果参数
    # ${forAppkey}    Set Variable    ${baseRes.validOrgName}#${baseRes.validAppName}
    # ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/msghooks
    ${msghooksname}    Set Variable    ${MsgHooks["entities"][0]["name"]}
    ${msghooksname1}    Set Variable    ${MsgHooks1["entities"][0]["name"]}
    ${msghooksid}    Set Variable    ${MsgHooks["entities"][0]["id"]}
    ${msghooksid1}    Set Variable    ${MsgHooks1["entities"][0]["id"]}
    # ${targeturl}    Set Variable    ${MsgHooks["entities"][0]["actionParams"]["uri"]}
    # ${telenumber1}    Set Variable    ${MsgHooks["entities"][0]["userPhone"]}
    # ${appkeyBanExpire}    Set Variable    ${MsgHooks["entities"][0]["appkeyBanExpire"]}
    Log Many    ${msghooksname}    ${msghooksname1}
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    GetAllMsgHooksAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

    #清理创建的所有发送回调
    ${resu}    DelteMsgHooksTemp    ${msghooksid}
    ${resukey}    Set Variable    ${resu.path}
    Should Be Equal As Strings    ${resukey}    /msghooks/${msghooksid}    
    ${resu1}    DelteMsgHooksTemp    ${msghooksid1}
    ${resukey1}    Set Variable    ${resu1.path}
    Should Be Equal As Strings    ${resukey1}    /msghooks/${msghooksid1} 
    

DeleteAppKeyAllMsgHooks
    [Documentation]    回调清理工作（删除所有创建的回调）
    ...    查询/删除发送前回调使用id，并非name
    #获取appkey下所有发送前回调
    ${MsgHooks}    GetAllMsgHooksTemp
    log    ${MsgHooks}
    ${length}    Get Length    ${MsgHooks.entities}
    Log    ${length}    
    #遍历所有发送前回调name
    FOR    ${index}    IN RANGE    ${length}
        Log    ${MsgHooks}[entities][${index}][id]    
        #删除所有发送前回调
        ${resu}    DelteMsgHooksTemp    ${MsgHooks}[entities][${index}][id]
        ${resukey}    Set Variable    ${resu.path}
    END
    #再次判断是否所有发送前回调都已经删除
    ${MsgHooks}    GetAllMsgHooksTemp
    ${length}    Get Length    ${MsgHooks.entities}
    Should Be Equal    "0"    "${length}"    未删除所有回调