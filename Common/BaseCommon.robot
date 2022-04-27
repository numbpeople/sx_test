*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           ../Lib/KefuUtils.py
Library           pabot.PabotLib
Resource          ../Variable_Env.robot

*** Keywords ***
request method
    [Arguments]    ${method}    ${session}    ${uri}    ${header}    ${params}=    ${data}=
    ...    ${files}=
    [Documentation]    封装的请求信息，返回相应结果
    #封装各个请求方法与参数值
    Log Many    ${uri}    ${header}    ${params}    ${data}    ${files}    ${session}
    Run Keyword And Return If    '${method}'=='GET'    GET Request    ${session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='POST'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    params=${params}    timeout=${timeout}    files=${files}
    Run Keyword And Return If    '${method}'=='PUT'    PUT Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    params=${params}    timeout=${timeout}    files=${files}
    Run Keyword And Return If    '${method}'=='DELETE'    DELETE Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    params=${params}    timeout=${timeout}

Set Base Request Attribute
    [Arguments]    ${contentType}    ${token}    ${requestHeader}
    [Documentation]    设置请求header基本属性
    Log    ${contentType}
    Log    ${token}
    Log    ${requestHeader}
    #定义测试用例的操作描述
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    ${contentTypeDesc}    set variable    Content-Type值为：${contentType}
    ${tokenDesc}    set variable    Authorization值为：Bearer ${token}
    #给相应变量赋值
    set to dictionary    ${newRequestHeader}    Content-Type=${contentType}
    set to dictionary    ${newRequestHeader}    Authorization=Bearer ${token}
    Log Dictionary    ${newRequestHeader}
    #考虑如果传入header中值为空情况，去掉请求key
    ${newRequestHeader}    Reset Request Header For Not Empty    ${newRequestHeader}
    #定义返回结构
    &{result}    create dictionary
    set to dictionary    ${result}    requestHeader=${newRequestHeader}    contentTypeDesc=${contentTypeDesc}    tokenDesc=${tokenDesc}
    return from keyword    ${result}

Return Result
    [Arguments]    ${resp}
    [Documentation]    封装返回值结果
    ...
    ...    【参数值】：
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${resp} | 必填 | 接口返回的对象，其中包含请求地址、状态码、返回值 |
    ...
    ...    【返回值】
    ...    | 进行二次封装，将请求状态、请求地址、状态码、返回值进行返回：status、url、statusCode、text |
    ...
    ...    【调用方式】
    ...    | 获取进行中会话 | ${j} | Return Result | ${resp} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 构造返回字典，返回请求状态、请求地址、状态码、返回值：status、url、statusCode、text |
    ...    | Step 2 | 如果请求返回值为空，则返回值为空字符串 |
    #构造返回字典
    &{apiResponse}    Copy Dictionary    ${ApiResponse}
    ${text}    set variable    ${EMPTY}
    #判断返回值场景：返回是string、json、空、无返回值等
    #如果返回值resp.text是否包含502 Bad Gateway
    log    ${resp.text}
    ${badGatewaystatus}    Run Keyword And Return Status    should contain    ${resp.text}    502 Bad Gateway
    set to dictionary    ${apiResponse}    status=${ResponseStatus.OK}    url=${resp.url}    statusCode=${resp.status_code}    text=${resp.text}    resp=${resp}
    Return From Keyword If    ${badGatewaystatus}    ${apiResponse}
    #如果返回值resp.text不为空，则设置返回值，否则text设置为空值
    ${emptyStatus}    Run Keyword And Return Status    Should Not Be Equal    "${resp.text}"    "${EMPTY}"
    set to dictionary    ${apiResponse}    status=${ResponseStatus.OK}    url=${resp.url}    statusCode=${resp.status_code}    text=${text}    resp=${resp}
    Return From Keyword If    not ${emptyStatus}    ${apiResponse}
    #设置请求返回值
    ${jsonStatus}    Run Keyword And Return Status    to json    ${resp.text}
    Return From Keyword If    not ${jsonStatus}    ${apiResponse}
    #设置请求返回值
    &{textJson}    to json    ${resp.text}
    set to dictionary    ${apiResponse}    status=${ResponseStatus.OK}    url=${resp.url}    statusCode=${resp.status_code}    text=${textJson}    resp=${resp}
    Return From Keyword    ${apiResponse}

Format Jsonstr
    [Arguments]    ${jsonstr}    ${argument}
    Log    ${jsonstr}
    Log    ${argument}    
    ${t}    evaluate    ','.join(list(map(str,@{argument})))
    log    ${t}
    # ${formatstr}    decode bytes to string    ${t}    utf-8
    ${s}    evaluate    '${jsonstr}' % (${t})
    Log    ${s}    
    return from keyword    ${s}

# Repeat Keyword Times
#     [Arguments]    ${functionName}    ${expectConstruction}    ${expectValue}    @{paramList}
#     [Documentation]    重试调用接口多次，判断结果是否包含预期的值，包含则返回结果，否则返回{}
#     ...
#     ...    【参数值】：
#     ...    - ${functionName} ，代表接口封装后的关键字
#     ...    - ${expectConstruction} ，接口返回值中应取的字段结构
#     ...    - ${expectValue} ，获取接口某字段的预期值
#     ...    - @{paramList}，接口封装后所需要传入的参数值
#     ...
#     ...    【返回值】：
#     ...    - 调用${functionName}接口，返回结果中，匹配${expectConstruction}字段结构，值等于${expectValue}的数据结构
#     : FOR    ${i}    IN RANGE    ${retryTimes}
#     \    ${j}    run keyword    ${functionName}    @{paramList}
#     \    #适配最新的返回结构，获取返回值
#     \    ${status}    Run Keyword And Return Status    Dictionary Should Contain Key    ${j}    statusCode
#     \    run keyword if    ${status}    Set Suite Variable    ${j}    ${j.text}
#     \    #返回结果为空，则进入下次循环
#     \    Continue For Loop If    "${j}" == "[]"
#     \    #想要获取返回值中应取的字段结构，即${j}返回值中，获取${expectConstruction}结构的值 ，例如：${j['data'][0]}
#     \    ${dataRes}    set variable    ${j${expectConstruction}}
#     \    return from keyword if    "${dataRes}" == "${expectValue}"    ${j}
#     \    sleep    ${delay}
#     return from keyword    {}

Structure Field Should Be Equal
    [Arguments]    ${requestResult}    ${diffStructTemplate}
    #定义返回结构
    &{diffResult}    create dictionary    status=True    errorDescribtion=
    log    ${diffStructTemplate}
    ${diffStructTemplateLength}    get length    ${diffStructTemplate}
    return from keyword if    ${diffStructTemplateLength} == 0    ${diffResult}
    #将模板转换成字典
    &{diffStructTemplateJson}    to json    ${diffStructTemplate}
    #获取模板结果中所有的字段
    @{diffStructTemplateList}    Get Dictionary Keys    ${diffStructTemplateJson}
    #分别校验字段的匹配性，不匹配或不包含，则将错误置如返回错误结果中
    ${diffResult}    Check Field Format    ${requestResult}    ${diffStructTemplateJson}    ${diffStructTemplateList}    ${diffResult}
    return from keyword    ${diffResult}

Structure Value Should Be Equal
    [Arguments]    ${requestResult}    ${diffStructResult}
    #定义返回结构
    Log    ${requestResult}    
    &{diffResult}    create dictionary    status=True    errorDescribtion=
    log    ${diffStructResult}
    ${diffStructResult}    convert to string    ${diffStructResult}
    ${diffStructResultLength}    get length    ${diffStructResult}
    return from keyword if    ${diffStructResultLength} == 0    ${diffResult}
    #将模板转换成字典
    &{diffStructResultJson}    to json    ${diffStructResult}
    #获取模板结果中所有的字段
    @{diffStructResultList}    Get Dictionary Keys    ${diffStructResultJson}
    #分别校验字段值的正确性，如不正确，则将错误置如返回错误结果中
    ${diffResult}    Check Value Format    ${requestResult}    ${diffStructResultJson}    ${diffStructResultList}    ${diffResult}
    return from keyword    ${diffResult}

Check Field Format
    [Arguments]    ${requestResult}    ${diffStructTemplateJson}    ${diffStructTemplateList}    ${diffResult}
    #分别校验字段的匹配性，不匹配或不包含，则将错误置如返回错误结果中
    FOR    ${index}    ${diffKey}    IN ENUMERATE    @{diffStructTemplateList}
        #递归校验结构的正确性（适配robotframework==5.0，使用line：161-185并修改了参数,替换了159行，）
        # Check Type Format    ${requestResult}    ${diffStructTemplateJson}    ${diffStructTemplateList}    ${diffResult}    ${index}    ${diffKey}    Check Field Format
        
        log    ${diffStructTemplateJson}
        log    ${requestResult}
        log list    ${diffStructTemplateList}
        #判断key的类型，如果key是json，则递归循环获取
        ${keyJsonType}    Check Json Type    ${diffKey}
        @{keyJsondiffStructList}    run keyword if    ${keyJsonType}    Get Dictionary Keys    ${diffKey}
        run keyword if    ${keyJsonType}    Check Field Format    ${requestResult[${index}]}    ${diffStructTemplateJson[${index}]}    ${keyJsondiffStructList}    ${diffResult}
        Continue For Loop If    ${keyJsonType}
        #判断结果中key和value均不属于json
        ${keyStatus}    Run Keyword And Return Status    should contain    "${diffKey}"    :
        ${valueStatus}    Run Keyword And Return Status    log    ${diffStructTemplateJson['${diffKey}']}
        Continue For Loop If    (not ${keyStatus}) and (not ${valueStatus})
        Comment    log    ${diffStructTemplateJson['${diffKey}']}
        Comment    log    ${requestResult['${diffKey}']}
        #判断是否是json
        ${valueJsonType}    Check Json Type    ${diffStructTemplateJson['${diffKey}']}
        @{jsondiffStructList}    run keyword if    ${valueJsonType}    Get Dictionary Keys    ${diffStructTemplateJson['${diffKey}']}
        #判断是否是list
        ${valueListType}    Check List Type    ${diffStructTemplateJson['${diffKey}']}
        @{listdiffStructList}    run keyword if    ${valueListType}    set variable    ${diffStructTemplateJson['${diffKey}']}
        #判断是否是json
        run keyword if    ${valueJsonType}    Check Field Format    ${requestResult['${diffKey}']}    ${diffStructTemplateJson['${diffKey}']}    ${jsondiffStructList}    ${diffResult}
        #判断是否是list
        run keyword if    ${valueListType}    Check Field Format    ${requestResult['${diffKey}']}    ${diffStructTemplateJson['${diffKey}']}    ${listdiffStructList}    ${diffResult}
        Continue For Loop If    ${valueListType} or ${valueJsonType}

        #根据json结构断言字段正确性
        ${keyStatus}    Run Keyword And Return Status    Dictionary Should Contain Key    ${requestResult}    ${diffKey}
        ${errorDescribtion}    set variable    ${diffResult.errorDescribtion}
        run keyword if    not ${keyStatus}    set to dictionary    ${diffResult}    status=False    errorDescribtion=${errorDescribtion} \n返回结果中未包含字段：${diffKey}\n
    END    
    return from keyword    ${diffResult}

Check Value Format
    [Arguments]    ${requestResult}    ${diffStructResultJson}    ${diffStructList}    ${diffResult}
    Log    ${requestResult}    
    Log    ${diffStructList}
    Log    ${diffStructResultJson}
    Log    ${diffResult}    
    #分别校验字段的匹配性，不匹配或不包含，则将错误置如返回错误结果中
    FOR    ${index}    ${diffKey}    IN ENUMERATE    @{diffStructList}
        #递归校验结构的正确性（适配robotframework==5.0，使用line：207-231并修改了参数,替换了159行，）
        # Check Type Format    ${requestResult}    ${diffStructResultJson}    ${diffStructList}    ${diffResult}    ${index}    ${diffKey}    Check Value Format

        # [Arguments]    ${requestResult}    ${diffStructResultJson}    ${diffStructList}    ${diffResult}    ${index}    ${diffKey}    ${keyword}
        # [Documentation]    递归校验结构的正确性
        log    ${diffStructResultJson}
        log    ${requestResult}
        log list    ${diffStructList}
        #判断key的类型，如果key是json，则递归循环获取
        ${keyJsonType}    Check Json Type    ${diffKey}
        @{keyJsondiffStructList}    run keyword if    ${keyJsonType}    Get Dictionary Keys    ${diffKey}
        run keyword if    ${keyJsonType}    Check Value Format    ${requestResult[${index}]}    ${diffStructResultJson[${index}]}    ${keyJsondiffStructList}    ${diffResult}
        Continue For Loop If    ${keyJsonType}
        #判断结果中key和value均不属于json
        ${keyStatus}    Run Keyword And Return Status    should contain    "${diffKey}"    :
        ${valueStatus}    Run Keyword And Return Status    log    ${diffStructResultJson['${diffKey}']}
        Continue For Loop If    (not ${keyStatus}) and (not ${valueStatus})
        Comment    log    ${diffStructResultJson['${diffKey}']}
        Comment    log    ${requestResult['${diffKey}']}
        #判断是否是json
        ${valueJsonType}    Check Json Type    ${diffStructResultJson['${diffKey}']}
        @{jsondiffStructList}    run keyword if    ${valueJsonType}    Get Dictionary Keys    ${diffStructResultJson['${diffKey}']}
        #判断是否是list
        ${valueListType}    Check List Type    ${diffStructResultJson['${diffKey}']}
        @{listdiffStructList}    run keyword if    ${valueListType}    set variable    ${diffStructResultJson['${diffKey}']}
        #判断是否是json
        run keyword if    ${valueJsonType}    Check Value Format    ${requestResult['${diffKey}']}    ${diffStructResultJson['${diffKey}']}    ${jsondiffStructList}    ${diffResult}
        #判断是否是list
        run keyword if    ${valueListType}    Check Value Format    ${requestResult['${diffKey}']}    ${diffStructResultJson['${diffKey}']}    ${listdiffStructList}    ${diffResult}
        Continue For Loop If    ${valueListType} or ${valueJsonType}

        Log    ${requestResult}
        #检查字段值是否相等
        log many    ${requestResult['${diffKey}']}
        ${valueStatus}    Run Keyword And Return Status    Should Contain    "${diffStructResultJson['${diffKey}']}"    "${requestResult['${diffKey}']}"
        ${errorDescribtion}    set variable    ${diffResult.errorDescribtion}
        run keyword if    not ${valueStatus}    set to dictionary    ${diffResult}    status=False    errorDescribtion=${errorDescribtion} \n返回结果中字段：${diffKey}，不等于${diffStructResultJson['${diffKey}']}，实际值为：${requestResult['${diffKey}']}。\n
    END
    return from keyword    ${diffResult}

Check Type Format
    [Arguments]    ${requestResult}    ${diffStructResultJson}    ${diffStructList}    ${diffResult}    ${index}    ${diffKey}    ${keyword}
    [Documentation]    递归校验结构的正确性
    log    ${diffStructResultJson}
    log    ${requestResult}
    log list    ${diffStructList}
    #判断key的类型，如果key是json，则递归循环获取
    ${keyJsonType}    Check Json Type    ${diffKey}
    @{keyJsondiffStructList}    run keyword if    ${keyJsonType}    Get Dictionary Keys    ${diffKey}
    run keyword if    ${keyJsonType}    ${keyword}    ${requestResult[${index}]}    ${diffStructResultJson[${index}]}    ${keyJsondiffStructList}    ${diffResult}
    Continue For Loop If    ${keyJsonType}
    #判断结果中key和value均不属于json
    ${keyStatus}    Run Keyword And Return Status    should contain    "${diffKey}"    :
    ${valueStatus}    Run Keyword And Return Status    log    ${diffStructResultJson['${diffKey}']}
    Continue For Loop If    (not ${keyStatus}) and (not ${valueStatus})
    Comment    log    ${diffStructResultJson['${diffKey}']}
    Comment    log    ${requestResult['${diffKey}']}
    #判断是否是json
    ${valueJsonType}    Check Json Type    ${diffStructResultJson['${diffKey}']}
    @{jsondiffStructList}    run keyword if    ${valueJsonType}    Get Dictionary Keys    ${diffStructResultJson['${diffKey}']}
    #判断是否是list
    ${valueListType}    Check List Type    ${diffStructResultJson['${diffKey}']}
    @{listdiffStructList}    run keyword if    ${valueListType}    set variable    ${diffStructResultJson['${diffKey}']}
    #判断是否是json
    run keyword if    ${valueJsonType}    ${keyword}    ${requestResult['${diffKey}']}    ${diffStructResultJson['${diffKey}']}    ${jsondiffStructList}    ${diffResult}
    #判断是否是list
    run keyword if    ${valueListType}    ${keyword}    ${requestResult['${diffKey}']}    ${diffStructResultJson['${diffKey}']}    ${listdiffStructList}    ${diffResult}
    Continue For Loop If    ${valueListType} or ${valueJsonType}

Check Json Type
    [Arguments]    ${key}
    #检查是否是json结构
    ${jsonValue}    Get Substring    "${key}"    1    2
    log    ${jsonValue}
    ${status}    Run Keyword And Return Status    Should Be Equal    ${jsonValue}    {
    return from keyword    ${status}

Check List Type
    [Arguments]    ${key}
    #检查是否是json结构
    ${jsonValue}    Get Substring    "${key}"    1    2
    log    ${jsonValue}
    ${status}    Run Keyword And Return Status    Should Be Equal    ${jsonValue}    [
    return from keyword    ${status}

Set Request Attribute And Run Keyword
    [Arguments]    ${contentType}    ${token}    ${statusCode}    ${keywordDescribtion}    ${keyword}    @{arguments}
    [Documentation]    设置请求头，并运行关键字，并返回接口结果
    Log    ${contentType}
    Log    ${token}
    Log    ${statusCode}
    Log    ${keywordDescribtion}
    Log    ${keyword}
    Log    ${arguments}
   
    #设置请求header基本属性
    &{newRequestHeader}    set variable    ${arguments[1]}
    ${result}    Set Base Request Attribute    ${contentType}    ${token}    ${newRequestHeader}
    #获取测试用例的操作描述和header信息
    ${contentTypeDesc}    set variable    ${result.contentTypeDesc}
    ${tokenDesc}    set variable    ${result.tokenDesc}
    &{requestHeader1}    copy dictionary    ${result.requestHeader}
    #替换列表参数中header值
    ${index}    Get Index From List    ${arguments}    ${newRequestHeader}
    Set List Value    ${arguments}    ${index}    ${requestHeader1}
    
    #运行关键字
    &{apiResponse}    Run keyword    ${keyword}    @{arguments}
    log dictionary    ${apiResponse}
    set to dictionary    ${apiResponse}    errorDescribetion=${keywordDescribtion}，${contentTypeDesc}，${tokenDesc}，\n预期返回状态码等于${statusCode}，\n实际返回状态码等于${apiResponse.statusCode}，\n调用接口：${apiResponse.url}，\n接口返回值：${apiResponse.text}\n================================================================华丽的分割线================================================================
    Return From Keyword    ${apiResponse}

Assert Request Result
    [Arguments]    ${apiResponse}    ${diffStructTemplate}    ${diffStructResult}    ${statusCode}    ${argumentField}    ${argumentValue}
    Log    ${apiResponse}
    Log    ${diffStructTemplate}
    Log    ${diffStructResult}
    Log    ${statusCode}
    Log List    ${argumentField}
    Log List    ${argumentValue}
    #验证状态码等于预期值
    ${codeStatus}    Run Keyword And Return Status    Should Be Equal As Integers    ${apiResponse.statusCode}    ${statusCode}
    ${errorDescribetion}    set variable    ${apiResponse.errorDescribetion}
    run keyword if    not ${codeStatus}    set to dictionary    ${apiResponse}    status=${ResponseStatus.FAIL}    errorDescribetion=${errorDescribetion}，实际返回状态码：${apiResponse.statusCode}
    #验证接口返回值的字段是否完整
    ${errorDescribetion}    set variable    ${apiResponse.errorDescribetion}
    Log    ${errorDescribetion}    
    #判断对比的结构中是否有包含替换的值的场景
    ${diffStructTemplateResultStatus}    Run Keyword And Return Status    Should Contain    ${diffStructTemplate}    %
    #替换格式化str
    ${diffStructTemplateResultTemp}    Run Keyword If    ${diffStructTemplateResultStatus}    Format Jsonstr    ${diffStructTemplate}    ${argumentField}
    run keyword if    ${diffStructTemplateResultStatus}    set suite variable    ${diffStructTemplate}    ${diffStructTemplateResultTemp}
    #验证接口返回值的字段是否完整
    ${errorDescribetion}    set variable    ${apiResponse.errorDescribetion}
    log    ${apiResponse.text}
    Log    ${diffStructTemplate}    
    ${fieldDiffResult}    Structure Field Should Be Equal    ${apiResponse.text}    ${diffStructTemplate}
    run keyword if    not ${fieldDiffResult.status}    set to dictionary    ${apiResponse}    status=${ResponseStatus.FAIL}    errorDescribetion=${errorDescribetion}，${fieldDiffResult.errorDescribtion}
    #验证接口返回值的字段值是否正确
    ${errorDescribetion}    set variable    ${apiResponse.errorDescribetion}
    #判断对比的结构中是否有包含替换的值的场景
    ${diffStructResultStatus}    Run Keyword And Return Status    Should Contain    ${diffStructResult}    %
    #替换格式化str
    ${diffStructResultTemp}    Run Keyword If    ${diffStructResultStatus}    Format Jsonstr    ${diffStructResult}    ${argumentValue}
    run keyword if    ${diffStructResultStatus}    set suite variable    ${diffStructResult}    ${diffStructResultTemp}
    #验证接口返回值的字段值是否正确
    ${valueDiffResult}    Structure Value Should Be Equal    ${apiResponse.text}    ${diffStructResult}
    run keyword if    not ${valueDiffResult.status}    set to dictionary    ${apiResponse}    status=${ResponseStatus.FAIL}    errorDescribetion=${errorDescribetion}，${valueDiffResult.errorDescribtion}
    #验证最终的校验结果
    Should Be Equal    ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}

Set Model Case Run Status Init
    [Documentation]    初始化模板case中，各条用例的执行状态
    #判断若指定了超管token，则设置其他模板case为不执行
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set to dictionary    ${ModelCaseRunStatus}    OrgToken_ContentType=${RunStatus.NORUN}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set to dictionary    ${ModelCaseRunStatus}    OrgToken_EmptyContentType=${RunStatus.NORUN}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set to dictionary    ${ModelCaseRunStatus}    EmptyOrgToken_ContentType=${RunStatus.NORUN}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set to dictionary    ${ModelCaseRunStatus}    EmptyOrgToken_EmptyContentType=${RunStatus.NORUN}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set to dictionary    ${ModelCaseRunStatus}    AppToken_ContentType=${RunStatus.NORUN}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set to dictionary    ${ModelCaseRunStatus}    BestToken_ContentType=${RunStatus.RUN}
    set global variable    ${ModelCaseRunStatus}    ${ModelCaseRunStatus}
    Set Parallel Value For Key    ParallelModelCaseRunStatus    ${ModelCaseRunStatus}

Generate Random Specified String
    [Arguments]    ${specificPreString}=
    [Documentation]    随机生成字符串
    ${randomNumber}    Generate Random String    10    [NUMBERS]
    ${preString}    set variable    ${preRandomString}
    ${newNumber}    set variable    ${preString}-${randomNumber}
    return from keyword if    '${specificPreString}' != '${EMPTY}'    ${specificPreString}-${randomNumber}
    Return From Keyword    ${newNumber}

Find Media Path
    [Arguments]    ${mediaType}=
    [Documentation]    找到Resource文件夹下的富媒体文件
    ...
    ...    参数：${mediaType}为富媒体的类型
    ...
    ...    - 1、image：图片文件
    ...    - 2、audio：语音文件
    #找到Resource文件夹下的富媒体文件
    ${folderName}    set variable    Resource
    ${fileTempName}    set variable    image.gif
    run keyword if    "${mediaType}" == "audio"    set suite variable    ${fileTempName}    blob.amr
    ${folderPath}    set variable    ${CURDIR}
    ${folderPath}    evaluate    os.path.abspath(os.path.dirname("${folderPath}"))    os
    ${picpath}    set variable    ${folderPath}${/}${folderName}${/}${fileTempName}
    ${picpath}    Replace String    ${picpath}    \\    /
    return from keyword    ${picpath}

Should Run Model Case
    [Arguments]    ${specificModelCaseRunStatus}
    [Documentation]    是否需要执行该条测试用例
    ...    - 参数 ${specificModelCaseRunStatus}：传入的模板Case执行状态
    ...
    ...    返回值
    ...    - 传入True则执行该条模板用例，传入False则不执行
    Return From Keyword    ${specificModelCaseRunStatus}

Set Request Header And Return
    [Arguments]    ${requestHeader}=${requestHeader}
    [Documentation]    设置请求header中的contentType和token
    #设置请求header中的contentType和token
    ${newToken}    set variable    ${Token.orgToken}
    Run Keyword If    "${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}"    set suite variable    ${newToken}    ${RunModelCaseConditionDic.specificBestToken}
    ${newRequestHeader}    copy dictionary    ${requestHeader}
    #判断是否包含指定key
    ${contentTypeStatus}    Run Keyword And Return Status    Dictionary Should Contain Key    ${newRequestHeader}    Content-Type
    run keyword if    ${contentTypeStatus}    set to dictionary    ${newRequestHeader}    Content-Type=${contentType.JSON}
    set to dictionary    ${newRequestHeader}    Authorization=Bearer ${newToken}
    #考虑如果传入header中值为空情况，去掉请求key
    ${newRequestHeader1}    Reset Request Header For Not Empty    ${newRequestHeader}
    return from keyword    ${newRequestHeader1}

Reset Request Header For Not Empty
    [Arguments]    ${newRequestHeader}
    [Documentation]    将请求header中值为空的key去掉
    #考虑如果传入header中值为空情况，去掉请求key
    @{keys}    Get Dictionary Keys    ${newRequestHeader}
    FOR    ${i}    IN    @{keys}
    ${keyValue}    set variable    ${newRequestHeader['${i}']}
    run keyword if    "${keyValue}" == "${EMPTY}"    Remove From Dictionary    ${newRequestHeader}    ${i}
    END    
    return from keyword    ${newRequestHeader}

Should No Run App Testcase
    [Documentation]    判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    #判断如果存在指定appkey和bestToken，则不执行app应用相关的测试用例
    ${status}    evaluate    ("${RunModelCaseConditionDic.specificBestToken}" != "${EMPTY}") and ("${RunModelCaseConditionDic.orgName}" != "${EMPTY}") and ("${RunModelCaseConditionDic.appName}" != "${EMPTY}")
    Return From Keyword    ${status}
