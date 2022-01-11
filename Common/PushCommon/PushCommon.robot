*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/Push/PushApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../AppCommon/AppCommon.robot
Resource          ../UserCommon/UserCommon.robot
Resource          ../SendMessageCommon/SendMessageCommon.robot

*** Keywords ***
Get Push certificate
    [Arguments]    ${session}    ${header}    ${pathParamter}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{org_name}/{app_name}/notifiers    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}   


Get Push certificate Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}    
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}      
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Push certificate    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '/notifiers'    '0'    'get'    
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
 
Upload
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{org_name}/{app_name}/notifiers    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}  

Upload huawei Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi    
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${data}    Set Variable    {"name":"10492024","provider":"HUAWEIPUSH","environment":"PRODUCTION","certificate":"8o42az0cej2i2wgefk2y46yyed44sq4n","packageName":"com.hyphenate.chatuidemo","huaweiPushSettings":{"apiVersion":4,"activityClass":"com.hyphenate.chatuidemo.ui.SplashActivity"}}  
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}      
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Upload    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '/notifiers'    '${orgName}'    '${baseRes.validAppUUID}'    'post'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

Upload xiaomi Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi    
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${data}    Set Variable    {"name":"2882303761517426801","provider":"XIAOMIPUSH","environment":"PRODUCTION","certificate":"XZpWGpMfeEizuWn1Auh2Dg==","packageName":"com.hyphenate.chatuidemo"}  
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}      
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Upload    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '/notifiers'    '${orgName}'    '${baseRes.validAppUUID}'    'XIAOMIPUSH'    'post'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

 Delete
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${params}    
    [Documentation]    
    ...    created by wudi
    ${resp}=    /{org_name}/{app_name}/notifiers    DELETE    ${session}    ${header}    pathParamter=${pathParamter}    params=${params}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}  
    Return From Keyword    ${resp}   


 Delete huawei Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi    
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${data}    Set Variable    {"name":"10492024","provider":"HUAWEIPUSH","environment":"PRODUCTION","certificate":"8o42az0cej2i2wgefk2y46yyed44sq4n","packageName":"com.hyphenate.chatuidemo","huaweiPushSettings":{"apiVersion":4,"activityClass":"com.hyphenate.chatuidemo.ui.SplashActivity"}}  
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}      
    ${keywordDescribtion}    set variable    ${TEST NAME}
    #上传一个证书
    ${headers}    Create Dictionary    Authorization=Bearer ${token}
    ${resp}    Upload    ${RestRes.alias}    ${headers}    ${pathParamter}    ${data}
    #取证书ID
    ${r}    json.dumps    ${resp.text}
    ${entities}    Get From Dictionary    ${resp.text}    entities
    ${uuid}    Get From Dictionary    ${entities[0]}    uuid
    #删除证书
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${uuid}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '/notifiers'    '${orgName}'    '${baseRes.validAppUUID}'    '${uuid}'    'delete'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    

Delete xiaomi Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    
    ...    created by wudi    
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    ${data}    Set Variable    {"name":"2882303761517426801","provider":"XIAOMIPUSH","environment":"PRODUCTION","certificate":"XZpWGpMfeEizuWn1Auh2Dg==","packageName":"com.hyphenate.chatuidemo"}  
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}      
    ${keywordDescribtion}    set variable    ${TEST NAME}
    #上传一个证书
    ${headers}    Create Dictionary    Authorization=Bearer ${token}
    ${resp}    Upload    ${RestRes.alias}    ${headers}    ${pathParamter}    ${data}
    #取证书ID
    ${r}    json.dumps    ${resp.text}
    ${entities}    Get From Dictionary    ${resp.text}    entities
    ${uuid}    Get From Dictionary    ${entities[0]}    uuid
    #删除证书
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${uuid}
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Delete    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '/notifiers'    '${orgName}'    '${baseRes.validAppUUID}'    '${uuid}'    'delete'    '${appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
