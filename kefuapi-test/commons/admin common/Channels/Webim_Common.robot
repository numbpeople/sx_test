*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Channels/WebimApi.robot

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
