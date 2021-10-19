*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Library           pabot.PabotLib
Resource          ../../RestApi/App/AppApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../../RestApi/Token/TokenApi.robot

*** Keywords ***
Create App
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    创建应用app
    # 创建应用app
    ${resp}=    /management/organizations/{orgName}/applications    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Create Temp App
    [Arguments]    ${openRegistration}=true
    [Documentation]    创建一个新的应用APP
    #创建获取token的请求体
    ${randoNumber}    Generate Random Specified String
    ${data}    set variable    {"name":"${randoNumber}","productName":"${randoNumber}","appDesc":"${randoNumber}","app_status":"online","allow_open_registration":${openRegistration}}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}
    ${expectedStatusCode}    set variable    200
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${newRequestHeader}    Set Request Header And Return    ${newRequestHeader}
    #创建应用app
    &{apiResponse}    Create App    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    创建应用失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    Return From Keyword    ${text}

Create Exist Application Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    ${appRunStatus}    Should No Run App Testcase
    Return From Keyword If    ${appRunStatus}
    #设置请求数据
    ${data}    set variable    {"name":"${baseRes.validAppName}","productName":"${baseRes.validAppName}","appDesc":"${baseRes.validAppName}","app_status":"online","allow_open_registration":true}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create App
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${baseRes.validAppName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Create New Application Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    ${appRunStatus}    Should No Run App Testcase
    Return From Keyword If    ${appRunStatus}
    #设置请求数据
    ${randoNumber}    Generate Random Specified String
    ${appStatus}    set variable    online
    ${data}    set variable    {"name":"${randoNumber}","productName":"${randoNumber}","appDesc":"${randoNumber}","app_status":"${appStatus}","allow_open_registration":true}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${data}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Create App
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list    '${baseRes.validOrgName}'    '${randoNumber}'
    @{argumentValue}    create list    '${baseRes.validOrgName}'    '${randoNumber}'    '${baseRes.validOrgName}'    '${randoNumber}'    '${randoNumber}'
    ...    '${randoNumber}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Applications List Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    ${appRunStatus}    Should No Run App Testcase
    Return From Keyword If    ${appRunStatus}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}
    ${filter}    Copy Dictionary    ${FilterEntity}
    ${params}    set variable    page_num=${filter.page_num}&page_size=${filter.page_size}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${params}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Console Applications
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Applications List With Inexistent Org Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    ${appRunStatus}    Should No Run App Testcase
    Return From Keyword If    ${appRunStatus}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${baseRes.invalidOrgName}
    ${filter}    Copy Dictionary    ${FilterEntity}
    ${params}    set variable    page_num=${filter.page_num}&page_size=${filter.page_size}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}    ${params}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Console Applications
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Specific Application Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    ${appRunStatus}    Should No Run App Testcase
    Return From Keyword If    ${appRunStatus}
    #创建一个新的应用app
    &{newAppApiResponse}    Create Temp App
    ${uuid}    set variable    ${newAppApiResponse['entities'][0]['uuid']}
    ${name}    set variable    ${newAppApiResponse['entities'][0]['name']}
    ${organizationName}    set variable    ${baseRes.validOrgName}
    ${productName}    set variable    ${newAppApiResponse['entities'][0]['productName']}
    #设置请求数据
    &{pathParamter}    Create Dictionary    orgName=${organizationName}    appName=${productName}
    ${filter}    Copy Dictionary    ${FilterEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Console Specific Application
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${uuid}'    '${uuid}'    '${name}'    '${organizationName}'    '${productName}'
    ...    '${productName}'    '${productName}'    '${organizationName}'    '${productName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get Specific Application Template With Inexistent Application Template
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${diffStructTemplate}    ${diffStructResult}    ${specificModelCaseRunStatus}
    [Documentation]    创建已存在应用
    ...    - 传入header中content-type值
    ...    - 传入header中token值
    ...    - 应用APP是否是开放注册
    ...    - 测试用例的预期状态码
    ...    - 针对返回值对比的结构
    ...    - 针对返回值需要对比的字段和返回值
    ...    - 该条模板用例，是否执行
    #判断是否继续执行该条测试用例
    ${runStatus}    Should Run Model Case    ${specificModelCaseRunStatus}
    Return From Keyword If    not ${runStatus}
    #判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    ${appRunStatus}    Should No Run App Testcase
    Return From Keyword If    ${appRunStatus}
    #设置请求数据
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.invalidAppName}
    ${filter}    Copy Dictionary    ${FilterEntity}
    #设置请求集和
    ${keywordDescribtion}    set variable    ${TEST NAME}
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    #设置请求头，并运行关键字
    &{apiResponse}    Set Request Attribute And Run Keyword    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    Get Console Specific Application
    ...    @{arguments}
    Log Dictionary    ${apiResponse}
    @{argumentField}    create list
    @{argumentValue}    create list    '${pathParamter.orgName}'    '${pathParamter.appName}'    '${pathParamter.orgName}'    '${pathParamter.appName}'
    #断言请求结果中的字段和返回值
    Assert Request Result    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}

Get App
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取应用app
    #获取应用app
    ${resp}=    /management/organizations/{orgName}/applications    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get App And Return Application
    [Documentation]    创建应用app
    #创建获取token的请求体
    &{pathParamter}    Create Dictionary    orgName=${RestRes.orgName}
    #给相应变量赋值
    ${newToken}    set variable    ${Token.orgToken}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set suite variable    ${newToken}    ${RunModelCaseConditionDic.specificBestToken}
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${newRequestHeader}    Authorization=Bearer ${newToken}
    ${expectedStatusCode}    set variable    200
    #获取应用app
    &{apiResponse}    Get App    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取应用列表失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${application}    set variable    ${text['data']}
    return from keyword    ${application}

Get Applications And Set AppName Init
    [Documentation]    初始化组织下的应用信息
    #设置有效appName和无效appName
    ${bestTokenAndAppNameStatus}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}") and ("${RunModelCaseConditionDic.appName}" == "${EMPTY}")    #配置了超管token，并且appName未配置
    Comment    ${bestTokenAndAppNameNotEmpty}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}") and ("${RunModelCaseConditionDic.appName}" != "${EMPTY}")    #配置了超管token和appName
    ${orgNameAndAppNameNotEmpty}    evaluate    ("${RunModelCaseConditionDic.orgName}" != "${EMPTY}") and ("${RunModelCaseConditionDic.appName}" != "${EMPTY}")    #配置了orgName和appName
    Run Keyword If    ${bestTokenAndAppNameStatus}    FAIL    配置了指定超管token，需要配置orgName、appName，请检查变量：RunModelCaseConditionDic 配置
    ${randomNumber}    Generate Random String    10    [NUMBERS]
    Run Keyword If    ${orgNameAndAppNameNotEmpty}    Get Application And Set Global Variable    ${RunModelCaseConditionDic.orgName}    ${RunModelCaseConditionDic.appName}    ${randomNumber}
    Return From Keyword If    ${orgNameAndAppNameNotEmpty}
    #创建新的应用
    &{newAppApiResponse}    Create Temp App
    ${applicationName}    set variable    ${newAppApiResponse['entities'][0]['applicationName']}
    ${applicationUUID}    set variable    ${newAppApiResponse['entities'][0]['uuid']}
    #设置全局的有效、无效基本数据
    Comment    ${randoNumber}    Generate Random String    5    [NUMBERS]
    set to dictionary    ${baseRes}    validAppName=${applicationName}    invalidAppName=invalidApp${randomNumber}    validAppUUID=${applicationUUID}
    set global variable    ${baseRes}    ${baseRes}
    Set Parallel Value For Key    ParallelbaseRes    ${baseRes}
    Set Parallel Value For Key    ParallelRunModelCaseConditionDic    ${RunModelCaseConditionDic}

Get Console Applications
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${params}
    [Documentation]    获取应用app
    #获取应用app
    ${resp}=    /management/organizations/{orgName}/applications/list/console    GET    ${session}    ${header}    pathParamter=${pathParamter}    params=${params}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Console Applications List
    [Arguments]    ${session}    ${requestHeader}    ${pathParamter}    ${params}
    [Documentation]    获取应用app
    #获取应用app
    &{apiResponse}    Get Console Applications    ${session}    ${requestHeader}    ${pathParamter}    ${params}
    return from keyword    ${apiResponse.data}

Get Console Specific Application
    [Arguments]    ${session}    ${requestHeader}    ${pathParamter}
    [Documentation]    获取应用app
    #获取应用app
    ${resp}=    /management/organizations/{orgName}/applications/{appName}    GET    ${session}    ${requestHeader}    ${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Console Specific Application And Return Application
    [Arguments]    ${orgName}    ${appName}
    [Documentation]    获取指定应用app信息
    #创建获取token的请求体
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #给相应变量赋值
    ${newToken}    set variable    ${Token.orgToken}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set suite variable    ${newToken}    ${RunModelCaseConditionDic.specificBestToken}
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${newRequestHeader}    Authorization=Bearer ${newToken}
    ${expectedStatusCode}    set variable    200
    #获取应用app
    &{apiResponse}    Get Console Specific Application    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取应用列表失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${application}    set variable    ${text['entities'][0]}
    return from keyword    ${application}

Get Application And Set Global Variable
    [Arguments]    ${orgName}    ${appName}    ${randomNumber}=
    #获取指定应用信息
    &{applicationInfo}    Get Console Specific Application And Return Application    ${orgName}    ${appName}
    ${applicationUUID}    set variable    ${applicationInfo.uuid}
    #设置变量并更新为全局
    set to dictionary    ${baseRes}    validAppName=${RunModelCaseConditionDic.appName}    invalidAppName=invalidApp${randomNumber}    validAppUUID=${applicationUUID}
    set global variable    ${baseRes}    ${baseRes}
    set to dictionary    ${RunModelCaseConditionDic}    specificAppkey=${RunModelCaseConditionDic.orgName}#${RunModelCaseConditionDic.appName}
    set global variable    ${RunModelCaseConditionDic}    ${RunModelCaseConditionDic}
    Set Parallel Value For Key    ParallelbaseRes    ${baseRes}
    Set Parallel Value For Key    ParallelRunModelCaseConditionDic    ${RunModelCaseConditionDic}

Update App
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    [Documentation]    更新应用app
    #修改应用app
    ${resp}=    /{orgName}/{appName}    PUT    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Update App AllowOpenRegistration
    [Arguments]    ${openRegistration}
    [Documentation]    更新应用app
    #判断当前的开放注册的值，是否需要修改
    ${status}    Run Keyword And Return Status    should be equal    ${openRegistration}    ${allowOpenRegistration}
    return from keyword if    ${status}
    #创建获取token的请求体
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${data}    set variable    {"allow_open_registration":${openRegistration}}
    #给相应变量赋值
    ${newToken}    set variable    ${Token.orgToken}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set suite variable    ${newToken}    ${RunModelCaseConditionDic.specificBestToken}
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${newRequestHeader}    Authorization=Bearer ${newToken}
    ${expectedStatusCode}    set variable    200
    #修改应用app
    &{apiResponse}    Update App    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    修改应用的开放注册&授权注册接口失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    #重置更新后的状态值
    ${allowOpenRegistration}    set variable    ${openRegistration}
    set global variable    ${allowOpenRegistration}    ${allowOpenRegistration}
    return from keyword    ${text}

Should Run TestCase
    [Arguments]    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}
    [Documentation]    是否需要执行该条测试用例
    ...    - 1、如果发现没有指定appkey，则证明需要跑测试用例
    ...    - 2、如果发现指定了appkey，并且运行的状态是True，则证明需要跑测试用例
    #判断如果指定超管token用例为执行情况，则判断用例的执行状态
    ${logstatus}    evaluate    (("${RunModelCaseConditionDic.specificBestToken}"=="${EMPTY}") and ${specificBestTokenRunStatus}) or (("${RunModelCaseConditionDic.specificBestToken}"!="${EMPTY}") and (not ${specificBestTokenRunStatus}))
    ${emptyAndRun}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}"=="${EMPTY}") and ${specificBestTokenRunStatus}
    ${notEmptyAndNoRun}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}"!="${EMPTY}") and (not ${specificBestTokenRunStatus})
    log    ${emptyAndRun}
    log    ${notEmptyAndNoRun}
    log    ${logstatus}
    #运行指定超管token的判断
    ${bestTokenAndAppkeyRunStatus}    Run Keyword    Should Run SpecificBestToken And SpecificAppkey TestCase    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}    ${RunModelCaseConditionDic.specificBestToken}
    #判断如果指定超管token为空
    Return From Keyword If    ${logstatus}    ${bestTokenAndAppkeyRunStatus}
    #没有指定bestToken，则仅判断指定appkey的执行状态
    ${appkeyRunStatus}    Should Run SpecificAppkey TestCase    ${RunModelCaseConditionDic.specificAppkey}    ${specificAppkeyRunStatus}
    Return From Keyword    ${appkeyRunStatus}

Should Run SpecificAppkey TestCase
    [Arguments]    ${specificAppkey}    ${specificAppkeyRunStatus}
    [Documentation]    是否需要执行该条测试用例
    ...    - 1、如果发现没有指定appkey，则证明需要跑测试用例
    ...    - 2、如果发现指定了appkey，并且运行的状态是True，则证明需要跑测试用例
    ...
    ...    返回值：
    ...    - True：执行用例
    ...    - False：不执行用例
    #如果发现没有指定appkey，则证明需要跑测试用例
    ${specificAppkeyStatus}    Run Keyword And Return Status    should be equal    "${specificAppkey}"    "${EMPTY}"
    Return From Keyword If    ${specificAppkeyStatus}    True
    #如果发现指定了appkey，并且运行的状态是True，则证明需要跑测试用例
    Return From Keyword If    (not ${specificAppkeyStatus}) and ${specificAppkeyRunStatus}    True
    Return From Keyword    False

Should Run SpecificBestToken And SpecificAppkey TestCase
    [Arguments]    ${specificAppkeyRunStatus}    ${specificBestTokenRunStatus}    ${specificBestToken}
    [Documentation]    指定超管token场景下，是否需要执行该条测试用例
    ...    - 1、如果发现超管token未设置，并且标志为运行用例，则证明该条case不需要执行
    ...    - 2、其他情况均返回指定token的运行用例标志状态
    #如果发现超管token未设置，并且标志为运行用例，则证明该条case不需要执行
    Return From Keyword If    ("${specificBestToken}" == "${EMPTY}") and ${specificBestTokenRunStatus}    not ${specificBestTokenRunStatus}
    Return From Keyword If    ("${specificBestToken}"!="${EMPTY}") and (not ${specificBestTokenRunStatus})    ${specificBestTokenRunStatus}
    Comment    Return From Keyword    ${specificBestTokenRunStatus}

Get Appkey Or User Token
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${data}
    # 创建应用app
    ${resp}=    /{orgName}/{appName}/token    POST    ${session}    ${header}    pathParamter=${pathParamter}    data=${data}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Appkey Token
    [Arguments]    ${orgName}    ${appName}
    [Documentation]    获取应用appkey的token
    #获取应用的Client ID和Client Secret信息
    &{credentials}    Get Specific App Credentials    ${orgName}    ${appName}
    ${clientId}    ${clientSecret}    set variable    ${credentials.clientId}    ${credentials.clientSecret}
    #创建获取token的请求体
    ${data}    set variable    {"grant_type":"client_credentials","client_id":"${clientId}","client_secret":"${clientSecret}"}
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    ${expectedStatusCode}    set variable    200
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    #获取应用appkey的token
    &{apiResponse}    Get Appkey Or User Token    POST    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取应用appkey的token失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${access_token}    set variable    ${text.access_token}
    Return From Keyword    ${access_token}
    
Get User Token
    [Documentation]    获取user的token
    #创建获取user token的请求体
    [Arguments]    ${token1}
    ${data}    set variable    {"grant_type":"password","username":"${baseRes.validIMUser}","password":"${baseRes.validIMUser}"}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}
    ${expectedStatusCode}    set variable    200
    #给相应变量赋值
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    #获取user token
    &{apiResponse}    Get Appkey Or User Token    POST    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取应用user token失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    ${text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    ${access_token}    set variable    ${text.access_token}
    #设置全局变量
    set to dictionary    ${Token}    userToken=${accessToken} 
    # Return From Keyword    ${Token.userToken}
    Log    ${Token}    
    Log    ${token1}
    Log    ${Token.userToken} 
    # ${token}=    Set Variable If    "${token1}" == "a"    ${token1}    ${Token.userToken}    
    Return From Keyword    ${Token.userToken}

    
Get App Credentials
    [Arguments]    ${session}    ${header}    ${pathParamter}
    [Documentation]    获取应用的Client ID和Client Secret信息
    #获取应用的Client ID和Client Secret信息
    ${resp}=    /{orgName}/{appName}/credentials    GET    ${session}    ${header}    pathParamter=${pathParamter}
    &{apiResponse}    Return Result    ${resp}
    Return From Keyword    ${apiResponse}

Get Specific App Credentials
    [Arguments]    ${orgName}    ${appName}
    [Documentation]    获取应用的Client ID和Client Secret信息
    #创建获取token的请求体
    &{pathParamter}    Create Dictionary    orgName=${orgName}    appName=${appName}
    #给相应变量赋值
    ${newToken}    set variable    ${Token.orgToken}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set suite variable    ${newToken}    ${RunModelCaseConditionDic.specificBestToken}
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${newRequestHeader}    Authorization=Bearer ${newToken}
    log    ${newRequestHeader}
    ${expectedStatusCode}    set variable    200
    #获取应用的Client ID和Client Secret信息
    &{apiResponse}    Get App Credentials    ${RestRes.alias}    ${newRequestHeader}    ${pathParamter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    ${expectedStatusCode}    获取应用的Client ID和Client Secret信息失败，预期返回状态码等于${expectedStatusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}
    &{text}    set variable    ${apiResponse.text}
    ${url}    set variable    ${apiResponse.url}
    log    ${text}
    log    ${url}
    #创建返回结构
    &{result}    create dictionary    clientId=${text.credentials["client_id"]}    clientSecret=${text.credentials["client_secret"]}
    return from keyword    ${result}

Get AppToken Init
    [Documentation]    初始化Appkey的token
    #获取应用的token
    ${accessToken}    Get Appkey Token    ${baseRes.validOrgName}    ${baseRes.validAppName}
    #设置全局变量
    set to dictionary    ${Token}    appToken=${accessToken}
    set global variable    ${Token}    ${Token}
    Log   ${Token}     
    Set Parallel Value For Key    ParallelToken    ${Token}
    log    ${Token.appToken}

Judge the use of Token
    [Documentation]    判断是否使用usertoken
    ...    由于usertoken需要先注册用户，才可以获取。所以部分测试case使用usertoken时需判断是否使用usertoken
    ...    判断：
    [Arguments]    ${username}    ${token}
    ${baseRes.validIMUser}    set variable    ${username}
    ${token}=    Run Keyword If    "${token}"=="a"    Get User Token    ${token}
    ...    ELSE    Set Variable    ${token}
    log    ${token}
    [Return]    ${token}
    