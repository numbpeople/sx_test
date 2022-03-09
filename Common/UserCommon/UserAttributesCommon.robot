*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/User/UserApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../AppCommon/AppCommon.robot
Resource          UserCommon.robot

*** Keywords ***
Add User Attribute
    [Arguments]     ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    添加应用app下的用户属性
    Log    ${header}    
    ${resp}=    /{org_name}/{app_name}/metadata/user/{username}    PUT    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Get User Attribute
    [Documentation]    获取用户属性
    [Arguments]     ${session}    ${header}    ${pathParamter}
    Log    ${header}    
    ${resp}=    /{org_name}/{app_name}/metadata/user/{username}   GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
  
Get More User Attribute
    [Documentation]    批量获取用户属性
    [Arguments]     ${session}    ${header}    ${pathParamter}    ${data}
    ${resp}=    /{org_name}/{app_name}/metadata/user/get    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Delete User Attribute
    [Arguments]     ${session}    ${header}    ${pathParamter}
    [Documentation]    删除用户属性（通过Delete）
    ${resp}=    /{org_name}/{app_name}/metadata/user/{username}    DELETE    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Add Temple User Attribute
    [Documentation]    设置用户属性
    [Arguments]    ${username}    ${RandomString}=
    log    ${username}
    Log    ${preRandomString}    
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    log    ${newRequestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    # 修改请求header中Content-Type值为application/x-www-form-urlencoded
    ${newRequestHeader2}    copy dictionary    ${newRequestHeader}
    Set To Dictionary    ${newRequestHeader2}   Content-Type=${contentType.urlencoded}    
    Log    ${newRequestHeader2}  
    ${expectedStatusCode}    set variable    200
    #创建请求体
    ${data}    set variable    ${RandomString}=${RandomString}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${username}
    #创建用户
    &{apiResponse}    Add User Attribute   ${RestRes.alias}    ${newRequestHeader2}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
Delete Temple User Attribute
    [Documentation]    设置用户属性
    [Arguments]    ${userName}
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    log    ${newRequestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    Log    ${newRequestHeader}  
    ${expectedStatusCode}    set variable    200
    #创建请求体
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${username}
    #删除用户属性
    &{apiResponse}    Delete User Attribute   ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}

Delete Temple User and UserAttribute
    [Documentation]    设置用户属性
   #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    log    ${newRequestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    Log    ${newRequestHeader}  
    ${expectedStatusCode}    set variable    200
    #查看测试用例中创建的用户
    ${variableExsitStatus}    Run Keyword And Return Status    Variable Should Exist    ${testTempUserList}
    return from keyword if    not ${variableExsitStatus}
    #循环删除指定用户
    log list    ${testTempUserList}
    FOR    ${i}    IN    @{testTempUserList}
    #获取用户username
    ${userName}    set variable    ${i}
    #创建请求体
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${username}
    #删除用户属性
    &{apiResponse}    Delete User Attribute   ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建用户失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    #删除指定用户
    Delete Temp Specific User    ${userName}
    END
Get Attribute Capacity
    [Arguments]     ${session}    ${header}    ${pathParamter}
    [Documentation]    创建应用app下的用户
    # 创建应用app
    ${resp}=    /{org_name}/{app_name}/metadata/user/capacity    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}
    
Get Attribute Capacity Template
    [Documentation]    用户属性容量(已设置用户属性)
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建用户
    ${userres}    Create Temp User
    ${username}    Set Variable    ${userres["entities"][0]["username"]}
    #设置用户属性
    ${RandomString}    Generate Random String    
    Add Temple User Attribute    ${username}    ${RandomString}
    ${len}    Get Length    ${RandomString}
    ${length}    Set Variable    ${len}*2+7
    Log    ${length}    
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName} 
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Attribute Capacity
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    ${length}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    #目前没有api清除用户属性容量，需要手动用户创建的属性
    Delete Temple User Attribute    ${username}
    
 Get Attribute CapacityZero Template
    [Documentation]    用户属性容量（未设置用户属性）
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${length}    Set Variable    0
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Attribute Capacity
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    ${length}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Add User Attribute Template
    [Documentation]    设置用户属性
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建设置用户属性的用户
    ${userres}    Create Temp User    
    ${username}    Set Variable    ${userres["entities"][0]["username"]}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${username}
    #构建属性key和value
    ${randomstring}    Generate Random Specified String    
    ${data}    Set Variable    ${randomstring}=${randomstring}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data} 
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}   Add User Attribute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${randomstring}'    '${randomstring}'
    @{argumentValue}    create list    '${randomstring}'    '${randomstring}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
Delete User Attribute Template
    [Documentation]    通过Delete删除用户属性模版
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建设置用户属性的用户
    ${userres}    Create Temp User    
    ${username}    Set Variable    ${userres["entities"][0]["username"]}
    #添加用户属性
    ${RandomString}    Generate Random String   
    Add Temple User Attribute    ${username}    ${RandomString}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}   Delete User Attribute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    
    @{argumentValue}    create list    {}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Rmove User Attribute Template
    [Documentation]    删除用户属性（将用户属性的value设置为null）模版
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建设置用户属性的用户
    ${userres}    Create Temp User    
    ${username}    Set Variable    ${userres["entities"][0]["username"]}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${username}    ${token}
    #添加用户属性
    ${RandomString}    Generate Random String   
    Add Temple User Attribute    ${username}    ${RandomString} 
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${username}
    ${data}    Set Variable    ${RandomString}=
    Log    ${requestHeader}    
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}  
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}   Add User Attribute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    
    @{argumentValue}    create list    {}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Get User Attribute Template
    [Documentation]    获取用户属性
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建设置用户属性的用户
    ${userres}    Create Temp User    
    ${username}    Set Variable    ${userres["entities"][0]["username"]}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${username}    ${token}
    #添加用户属性
    ${RandomString}    Generate Random String   
    Add Temple User Attribute    ${username}    ${RandomString}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}   Get User Attribute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${randomstring}'    '${randomstring}'
    @{argumentValue}    create list    '${randomstring}'    '${randomstring}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Get User Attribute Empty Template
    [Documentation]    获取用户属性
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建设置用户属性的用户
    ${userres}    Create Temp User    
    ${username}    Set Variable    ${userres["entities"][0]["username"]}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${username}    ${token} 
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}    userName=${username}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}   Get User Attribute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    
    @{argumentValue}    create list    {}
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
Get More Attribute Template
    [Documentation]    批量获取用户属性
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建设置用户属性的用户
    ${userres1}    Create Temp User    
    ${username1}    Set Variable    ${userres1["entities"][0]["username"]}
    ${userres2}    Create Temp User    
    ${username2}    Set Variable    ${userres2["entities"][0]["username"]}
    ${userres2}    Create Temp User    
    ${username3}    Set Variable    ${userres2["entities"][0]["username"]}
    #添加用户属性
    ${properties1}    Generate Random String
    ${properties2}    Generate Random String
    Add Temple User Attribute    ${username1}    ${properties1}
    # Add Temple User Attribute    ${username2}    ${properties2}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${username1}    ${token}
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #构建属性key和value
    ${data}    Set Variable     {"properties":["${properties1}","${properties2}"],"targets":["${username1}","${username2}","${username3}"]}   
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data} 
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}   Get More User Attribute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${username1}'    '${properties1}'    '${properties1}'    '${username2}'    '${username3}'
    @{argumentValue}    create list    '${username1}'    '${properties1}'    '${properties1}'    '${username2}'    '${username3}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    
Get More Attribute Empty Template
    [Documentation]    批量获取用户属性(未设置用户属性)
    ...    - 传入header中content-type值    
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #创建设置用户属性的用户
    ${userres1}    Create Temp User    
    ${name1}    Set Variable    ${userres1["entities"][0]["username"]}
    ${userres2}    Create Temp User    
    ${name2}    Set Variable    ${userres2["entities"][0]["username"]}
    ${userres2}    Create Temp User    
    ${name3}    Set Variable    ${userres2["entities"][0]["username"]}
    #根据token判断是否获取usertoken
    ${token}    Judge the use of Token    ${name1}    ${token} 
    
    #设置请求数据
    ${applicationUUID}    set variable    ${baseRes.validAppUUID}
    ${orgName}    ${appName}    set variable    ${baseRes.validOrgName}    ${baseRes.validAppName}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${properties1}    Generate Random String    
    ${properties2}    Generate Random String    
    #构建属性key和value
    ${data}    Set Variable     {"properties":["${properties1}","${properties2}"],"targets":["${name1}","${name2}","${name3}"]}   
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data} 
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}   Get More User Attribute
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${name1}'    '${name2}'    '${name3}'
    @{argumentValue}    create list    '${name1}'    '${name2}'    '${name3}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}