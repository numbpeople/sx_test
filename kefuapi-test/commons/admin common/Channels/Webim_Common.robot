*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Channels/WebimApi.robot
Resource          ../../Base Common/Base_Common.robot

*** Keywords ***
Get Template
    [Arguments]    ${agent}
    [Documentation]    获取网页插件模板
    #获取网页插件模板
    ${resp}=    /v1/webimplugin/settings/template    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    set variable    ${resp.text}
    Return From Keyword    ${j}

Configs
    [Arguments]    ${agent}    ${method}=get    ${data}=    ${configId}=
    [Documentation]    获取/新增/删除/修改 网页插件配置信息
    #操作网页插件配置
    ${resp}=    /v1/webimplugin/settings/tenants/{tenantId}/configs    ${agent}    ${method}    ${timeout}    ${data}    ${configId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Configs、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Update Config
    [Arguments]    ${agent}    ${configId}    ${data}
    [Documentation]    修改 网页插件配置信息
    #更新配置
    ${resp}=    /v1/webimplugin/settings/tenants/{tenantId}/configs/{configId}/global    ${agent}    ${timeout}    ${configId}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Configinfo Via ConfigId
    [Arguments]    ${agent}    ${configId}
    [Documentation]    根据configId获取配置信息
    #根据configId获取配置信息
    ${resp}=    /v1/webimplugin/settings/visitors/configs/{configId}    ${agent}    ${timeout}    ${configId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Configs
    [Arguments]    ${agent}
    #查询configs信息，设置configName和configId到字典中
    &{configList}    create dictionary
    ${j}    Configs    ${agent}    get
    ${listlength}=    Get Length    ${j['entities']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${configname}=    convert to string    ${j['entities'][${i}]['configName']}
    \    ${configId}=    convert to string    ${j['entities'][${i}]['configId']}
    \    set to dictionary    ${configList}    ${configname}=${configId}
    Return From Keyword    ${configList}

Create Template
    #创建新的网页插件配置
    ${curTime}    get time    epoch
    ${data}    set variable    {"configName":"${AdminUser.tenantId}_${curTime}","isDefault":false}
    ${j}    Configs    ${AdminUser}    post    ${data}
    should be equal    ${j['status']}    OK
    #获取configId
    ${configId}    set variable    ${j['entity']['configId']}
    #设置configId为全局变量
    set global variable    ${templateConfigId}    ${configId}

Delete Template
    [Documentation]    批量删除config
    #设置客服账号名称模板
    ${preConfigName}=    convert to string    ${AdminUser.tenantId}
    #获取网页插件配置返回值
    ${configlist}=    Get Configs    ${AdminUser}    #返回字典
    ${configNameList}=    Get Dictionary Keys    ${configlist}
    ${listlength}=    Get Length    ${configNameList}
    log    ${configlist}
    #循环判断技能组名称是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${configName}=    convert to string    ${configNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${configName}    ${preConfigName}
    \    ${configIdValue}=    Get From Dictionary    ${configlist}    ${configNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Config    ${AdminUser}    ${configIdValue}

Delete Config
    [Arguments]    ${agent}    ${configId}
    #删除网页插件配置
    ${j}    Configs    ${agent}    delete    ${EMPTY}    ${configId}
    should be equal    ${j['status']}    OK    结果中不包含"OK", ${j}
    should be true    ${j['entity']} == 1    结果中获取entity不为1, ${j}

Get Webimplugin Channels
    [Arguments]    ${agent}
    [Documentation]    获取租户下所有的关联信息（网页访客端使用的接口）
    #获取网页插件的所有关联
    ${resp}=    WebimApi./v1/webimplugin/targetChannels    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Show Message
    [Arguments]    ${agent}    ${paramData}
    [Documentation]    获取网页渠道是否上下班
    #获取网页渠道是否上下班
    ${resp}=    /v1/webimplugin/tenants/show-message    ${agent}    ${timeout}    ${paramData}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}, 返回结果：${resp.text}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Show Company Greeting
    [Arguments]    ${agent}
    [Documentation]    网页渠道获取系统欢迎语
    #获取系统欢迎语
    ${resp}=    /v1/webimplugin/welcome    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} , 返回结果：${resp.text}
    Return From Keyword    ${resp.text}

Decode Bytes To String In
    [Arguments]    ${msg}    ${code}
    ${data}    Decode Bytes To String    ${msg}    ${code}
    Return From Keyword    ${data}

Show Robot Greeting
    [Arguments]    ${agent}    ${paramData}
    [Documentation]    网页渠道获取系统欢迎语
    #获取系统欢迎语
    ${resp}=    WebimApi./v1/webimplugin/tenants/robots/welcome    ${agent}    ${timeout}    ${paramData}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} , 返回结果：${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Skillgroup-menu
    [Arguments]    ${agent}
    [Documentation]    获取网页插件技能组绑定欢迎语
    #获取网页插件技能组绑定欢迎语
    ${resp}=    WebimApi./v1/webimplugin/tenants/{tenantId}/skillgroup-menu    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} , 返回结果：${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Webim Stickers
    [Arguments]    ${agent}
    [Documentation]    获取访客端自定义表情
    #获取访客端自定义表情
    ${resp}=    /v1/webimplugin/emoj/tenants/{tenantId}/packages    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} , 返回结果：${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Webim Stickers Files
    [Arguments]    ${agent}
    [Documentation]    获取访客端自定义表情
    #获取访客端自定义表情
    ${resp}=    /v1/webimplugin/emoj/tenants/{tenantId}/files    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} , 返回结果：${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Create Visitor
    [Arguments]    ${agent}    ${data}
    [Documentation]    创建访客
    #创建访客
    ${resp}=    /v1/webimplugin/visitors    ${agent}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Create New Visitor
    [Arguments]    ${agent}
    [Documentation]    创建新访客
    ...    返回值: username、password、orgName、appName、imServiceNumber
    #获取所用的关联信息
    ${orgName}    set variable    ${restentity.orgName}
    ${appName}    set variable    ${restentity.appName}
    ${imServiceNumber}    set variable    ${restentity.serviceEaseMobIMNumber}
    ${tenantId}    set variable    ${agent.tenantId}
    &{visitorDic}    create dictionary    orgName=${orgName}    appName=${appName}    imServiceNumber=${imServiceNumber}    tenantId=${tenantId}
    #创建请求体数据
    ${data}    set variable    {"orgName":"${orgName}","appName":"${appName}","imServiceNumber":"${imServiceNumber}","tenantId":"${tenantId}"}
    #创建在该关联下的访客数据
    ${j}    Create Visitor    ${agent}    ${data}
    set to dictionary    ${visitorDic}    username=${j['userId']}    password=${j['userPassword']}    appkey=${orgName}%23${appName}
    Return From Keyword    ${visitorDic}

Set MessagePredict
    [Arguments]    ${method}    ${agent}    ${serviceSessionId}    ${data}=    ${rest}=
    [Documentation]    获取/添加消息预知
    #获取/添加消息预知
    ${resp}=    /v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict    ${method}    ${agent}    ${serviceSessionId}    ${data}    ${rest}
    ...    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取/添加消息预知，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Create MessagePredict Data
    [Arguments]    ${agent}
    [Documentation]    创建消息预知数据
    #访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    ${serviceSessionId}    set variable    ${sessionInfo.sessionServiceId}
    ${visitorUserId}    set variable    ${sessionInfo.userId}
    ${userName}    set variable    ${sessionInfo.userName}
    #创建请求参数
    ${rest}    copy dictionary    ${restentity}
    log    ${rest}
    set to dictionary    ${rest}    userName=${userName}    techChannelInfo=${rest.orgName}#${rest.appName}#${rest.serviceEaseMobIMNumber}
    #创建请求体
    ${curTime}    get time    epoch
    ${data}    set variable    {"visitor_user_id":"${visitorUserId}","content":"${curTime}","timestamp":${curTime}000}
    #发送创建消息预知数据请求
    ${apiResponse}    Set MessagePredict    post    ${agent}    ${serviceSessionId}    ${data}    ${rest}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    '${j['status']}'    'OK'    消息预知接口返回status数据不是OK：${apiResponse.describetion}
    Should Be True    ${j['entity']}    消息预知接口返回entity字段数据不是True：${apiResponse.describetion}
    set to dictionary    ${rest}    visitorUserId=${visitorUserId}    serviceSessionId=${serviceSessionId}    content=${curTime}
    Return From Keyword    ${rest}

Set AgentInputState
    [Arguments]    ${method}    ${agent}    ${serviceSessionId}    ${data}=    ${rest}=
    [Documentation]    获取/添加客服输入状态
    #获取/添加客服输入状态
    ${resp}=    /v1/webimplugin/sessions/{serviceSessionId}/agent-input-state    ${method}    ${agent}    ${serviceSessionId}    ${data}    ${rest}
    ...    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取/添加客服输入状态，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Set WaitListNumber
    [Arguments]    ${agent}    ${serviceSessionId}    ${queueId}
    [Documentation]    获取显示排队人数
    #获取显示排队人数
    ${resp}    /v1/visitors/waitings/data    ${agent}    ${serviceSessionId}    ${queueId}    ${timeout}
    ${apiStatus}    Run Keyword And Return Status    Should Be Equal As Integers    ${resp.status_code}    200
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    errorDescribetion=【实际结果】：获取显示排队人数接口，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    run keyword if    not ${apiStatus}    set to dictionary    ${apiResponse}    status=${ResponseStatus.FAIL}
    Return From Keyword    ${apiResponse}

Create AgentInputState Data
    [Arguments]    ${agent}
    [Documentation]    创建消息预知数据
    #访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    ${serviceSessionId}    set variable    ${sessionInfo.sessionServiceId}
    ${visitorUserId}    set variable    ${sessionInfo.userId}
    ${userName}    set variable    ${sessionInfo.userName}
    #创建请求参数
    ${rest}    copy dictionary    ${restentity}
    log    ${rest}
    set to dictionary    ${rest}    userName=${userName}
    #创建请求体
    ${curTime}    get time    epoch
    ${data}    set variable    {"service_session_id":"${serviceSessionId}","input_state_tips":"${curTime}","timestamp":${curTime}}
    ${apiResponse}    Set AgentInputState    post    ${AdminUser}    ${serviceSessionId}    ${data}    ${rest}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    '${j['status']}'    'OK'    客服输入状态接口返回status数据不是OK：${apiResponse.describetion}
    Should Be True    ${j['entity']}    客服输入状态接口返回entity字段数据不是True：${apiResponse.describetion}
    set to dictionary    ${rest}    visitorUserId=${visitorUserId}    serviceSessionId=${serviceSessionId}    content=${curTime}
    Return From Keyword    ${rest}

Get Welcome
    [Arguments]    ${agent}
    [Documentation]    获取企业欢迎语
    ${resp}=    /v1/webimplugin/welcome    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    Return From Keyword    ${resp.text}

Get Theme Option
    [Arguments]    ${agent}
    [Documentation]    获取主题信息
    ${resp}=    /v1/webimplugin/theme/options    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Notice Option
    [Arguments]    ${agent}
    [Documentation]    获取信息栏信息
    ${resp}=    /v1/webimplugin/notice/options    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

WebimTemplate Result Should Be Equal
    [Arguments]    ${actualResult}    ${expectWebimTemplateChannelJson}
    [Documentation]    对传入的实际结果和预期结果，进行递归式比较
    log    ${actualResult}
    log    ${expectWebimTemplateChannelJson}
    #获取返回结果中所有的key
    @{webimKeys}    Get Dictionary Keys    ${expectWebimTemplateChannelJson}
    #递归所有的key，取出每个字典和属性的值，进行比较。
    :FOR    ${i}    IN    @{webimKeys}
    \    log    ${i}
    \    #判断实际结果中，应该包含预期的所有的key
    \    Dictionary Should Contain Key    ${actualResult}    ${i}    调用接口：/v1/webimplugin/settings/template，返回结果中，没有包含字段：${i}，实际值：${actualResult}，预期值：${expectWebimTemplateChannelJson}
    \    #取出对应字典key的value值
    \    ${subkey}    set variable    ${expectWebimTemplateChannelJson['${i}']}
    \    #判断如果值等于空&不包括json格式，则直接判断结果；如果是字典，则递归继续比较字典结构
    \    run keyword if    "${subkey}" == ""     Should Be Equal    "${actualResult['${i}']}"    "${expectWebimTemplateChannelJson['${i}']}"    调用接口：/v1/webimplugin/settings/template，返回结果中，${i}对应的值不相等，实际值：${actualResult['${i}']}，预期值：${expectWebimTemplateChannelJson['${i}']}
    \    run keyword if    ("${subkey}" != "") and ("{" not in "${subkey}") and ("}" not in "${subkey}")     Should Be Equal    "${actualResult['${i}']}"    "${expectWebimTemplateChannelJson['${i}']}"    调用接口：/v1/webimplugin/settings/template，返回结果中，${i}对应的值不相等，实际值：${actualResult['${i}']}，预期值：${expectWebimTemplateChannelJson['${i}']}
    \    run keyword if    "{" in "${subkey}" and "}" in "${subkey}"     WebimTemplate Result Should Be Equal    ${actualResult['${i}']}    ${expectWebimTemplateChannelJson['${i}']}
