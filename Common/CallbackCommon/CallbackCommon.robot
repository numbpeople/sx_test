*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource    ../../RestApi/CallBack/CallBackApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot


*** Keywords ***
AddCallBackAPI
    [Documentation]    创建一个回调
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    ${resp}=    /{orgName}/{appName}/callbacks    POST    ${session}    ${header}    pathParamter=${pathParamter}
    ...    data=${data}    
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}


GetAllCallBackAPI
    [Documentation]    查看所有回调
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/callbacks    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

DeleteCallBackAPI
    [Documentation]    删除一个回调
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/callbacks/{callbackname}    DELETE    ${session}    ${header}    ${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

EditCallbackAPI
    [Documentation]    修改一个回调
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    ${resp}=    /{orgName}/{appName}/callbacks/{callbackname}    PUT    ${session}    ${header}    ${pathParamter}
    ...    data=${data}  
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

GetSingleCallBackAPI
    [Documentation]    查看单个回调详情
    [Arguments]    ${session}    ${header}    ${pathParamter}
    ${resp}=    /{orgName}/{appName}/callbacks/{callbackname}    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

AddCallBackTemp
    [Documentation]    添加发送前回调
    [Arguments]    ${specificPreString}=
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #设置请求参数
    ${specificPreString}    Run Keyword If    '${specificPreString}'=='${EMPTY}'    Generate Random String    8    [LOWER]
    ${callbackname}    Set Variable    ${specificPreString}
    Log    ${callbackname}    
    Log    ${callbackvariable.telenumber}    
    Log    ${callbackvariable.callbackuri}    
    ${data}    set variable    {"name":"${callbackname}","msgTypes":["chat","chat_offline"],"interested":["chat","chatroom","recall","sensitiveWords","muc","userStatus","groupchat","read_ack","roster"],"hxSecret":"40088182666","secret":"9582402158","targetUrl":"${callbackvariable.callbackuri}","status":1,"appkeyBanExpire":300,"userPhone":"${callbackvariable.telenumber}","acceptRestMessage":false}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    AddCallBackAPI    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}


DelteCallBackTemp
    [Documentation]    删除发送后回调
    [Arguments]    ${specificPreString}=
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #设置请求参数
    ${callbackname}    Set Variable    ${specificPreString}
    Log    ${callbackname}    
    Log    ${callbackvariable.telenumber}    
    Log    ${callbackvariable.callbackuri}    
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    callbackname=${callbackname}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    DeleteCallBackAPI    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}


GetAllCallBackTemp
    [Documentation]    查询已有发送后回调
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    GetAllCallBackAPI    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}


AddCallBackTemplate
    [Documentation]    添加一个发送前回调
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求参数
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${callbackname}    Generate Random String    8    qwertyuiopasdfghjklzxcvbnm
    Log    ${callbackvariable.telenumber}    
    Log    ${callbackvariable.callbackuri}    
    ${data}    set variable    {"name":"${callbackname}","msgTypes":["chat","chat_offline"],"interested":["chat","chatroom","recall","sensitiveWords","muc","userStatus","groupchat","read_ack","roster"],"hxSecret":"40088182666","secret":"9582402158","targetUrl":"${callbackvariable.callbackuri}","status":1,"appkeyBanExpire":300,"userPhone":"${callbackvariable.telenumber}","acceptRestMessage":false}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    AddCallBackAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    #设置结果替换参数
    ${forAppkey}    Set Variable    ${baseRes.validOrgName}#${baseRes.validAppName}
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/callbacks
    @{argumentField}    create list
    @{argumentValue}    create list    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    '${callbackname}'    '${forAppkey}'    '${forAppkey}'    '${callbackvariable.callbackuri}'    "${callbackvariable.telenumber}"    300    "post"    "${baseRes.validAppName}"

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


EditCallbackTemplate
    [Documentation]    修改一个发送后回调（create by shuang）
    ...    步骤1.先创建一个发送后回到
    ...    步骤2.修改步骤一中创建的发送后回调
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #构建修改body参数
    ${keywordDescribtion}    set variable    ${TEST NAME}
    ${callback}    AddCallBackTemp
    ${callbackname}    Set Variable    ${callback["entities"][0]["name"]}
    Log    ${callbackname}    
    ${telenumber1}    Generate Random String    11    [NUMBERS]
    Log    ${telenumber1}    
    ${targeturl}    Set Variable    http://www.baidu111.com
    Log    ${targeturl}    
    #设置请求参数
    ${data}    set variable    {"targetUrl": "${targeturl}","appkeyBanExpire": 200,"userPhone": "${telenumber1}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    callbackname=${callbackname}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    EditCallbackAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    #设置结果替换参数
    ${forAppkey}    Set Variable    ${baseRes.validOrgName}#${baseRes.validAppName}
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/callbacks
    @{argumentField}    create list
    @{argumentValue}    create list    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    '${callbackname}'    '${forAppkey}'    '${forAppkey}'    '${targeturl}'    "${telenumber1}"    200    "put"    "${baseRes.validAppName}"

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}


DeleteCallBackTemplate
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
    ${callback}    AddCallBackTemp
    #设置校验结果参数
    ${forAppkey}    Set Variable    ${baseRes.validOrgName}#${baseRes.validAppName}
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/callbacks
    ${callbackname}    Set Variable    ${callback["entities"][0]["name"]}
    ${targeturl}    Set Variable    ${callback["entities"][0]["actionParams"]["uri"]}
    ${telenumber1}    Set Variable    ${callback["entities"][0]["userPhone"]}
    ${appkeyBanExpire}    Set Variable    ${callback["entities"][0]["appkeyBanExpire"]}
    Log    ${callbackname}    
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    callbackname=${callbackname}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    DeleteCallBackAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    '${callbackname}'    '${forAppkey}'    '${forAppkey}'    '${targeturl}'    "${telenumber1}"    ${appkeyBanExpire}    "delete"    "${baseRes.validAppName}"

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

GetSingCallBackTemplate
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
    ${callback}    AddCallBackTemp
    #设置校验结果参数
    ${forAppkey}    Set Variable    ${baseRes.validOrgName}#${baseRes.validAppName}
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/callbacks
    ${callbackname}    Set Variable    ${callback["entities"][0]["name"]}
    ${targeturl}    Set Variable    ${callback["entities"][0]["actionParams"]["uri"]}
    ${telenumber1}    Set Variable    ${callback["entities"][0]["userPhone"]}
    ${appkeyBanExpire}    Set Variable    ${callback["entities"][0]["appkeyBanExpire"]}
    Log    ${callbackname}    
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    callbackname=${callbackname}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    GetSingleCallBackAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${uri}'    '${baseRes.validOrgName}'    '${baseRes.validAppUUID}'    '${callbackname}'    '${forAppkey}'    '${forAppkey}'    '${targeturl}'    "${telenumber1}"    ${appkeyBanExpire}    "get"    "${baseRes.validAppName}"

    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

GetAllCallBackTemplate
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}
    ...    ${specificModelCaseRunStatus}
    #判断是否执行此case
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    ${keywordDescribtion}    set variable    ${TEST NAME}
    #添加两个个发送后回调
    ${callback}    AddCallBackTemp
    ${callback1}    AddCallBackTemp
    #设置校验结果参数
    ${forAppkey}    Set Variable    ${baseRes.validOrgName}#${baseRes.validAppName}
    ${uri}    Set Variable    ${RestRes.RestUrl}/${baseRes.validOrgName}/${baseRes.validAppName}/callbacks
    ${callbackname}    Set Variable    ${callback["entities"][0]["name"]}
    ${callbackname1}    Set Variable    ${callback1["entities"][0]["name"]}
    # ${targeturl}    Set Variable    ${callback["entities"][0]["actionParams"]["uri"]}
    # ${telenumber1}    Set Variable    ${callback["entities"][0]["userPhone"]}
    # ${appkeyBanExpire}    Set Variable    ${callback["entities"][0]["appkeyBanExpire"]}
    Log Many    ${callbackname}    ${callbackname1}
    #设置请求参数
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    GetAllCallBackAPI
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

    #清理创建的所有发送回调
    ${resu}    DelteCallBackTemp    ${callbackname}
    ${resukey}    Set Variable    ${resu.path}
    Should Be Equal As Strings    ${resukey}    /callbacks    
    ${resu1}    DelteCallBackTemp    ${callbackname1}
    ${resukey1}    Set Variable    ${resu1.path}
    Should Be Equal As Strings    ${resukey1}    /callbacks 
    

DeleteAppKeyAllCallBack
    [Documentation]    回调清理工作（删除所有创建的回调）
    ...    
    #获取appkey下所有回调
    ${callcallback}    GetAllCallBackTemp
    log    ${callcallback}
    ${length}    Get Length    ${callcallback.entities}
    Log    ${length}    
    #遍历所有回调name
    FOR    ${index}    IN RANGE    ${length}
            ${resu}    DelteCallBackTemp    ${callcallback}[entities][${index}][name]
            ${resukey}    Set Variable    ${resu.path}
    END