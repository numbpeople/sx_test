*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../api/MicroService/WebGray/WebGrayApi.robot
Resource          ../../api/MicroService/Permission/PermissionApi.robot
Resource          ../../UIcommons/Utils/baseUtils.robot
Library           uuid
Library           urllib
Library           Selenium2Library
Resource          ../../api/HomePage/Login/Login_Api.robot
Resource          ../../commons/admin common/BaseKeyword.robot
Resource          ../../commons/Base Common/Base_Common.robot
Library           uuid

*** Keywords ***
Kefu UI Init
    [Arguments]    ${agent}    ${user}=0
    [Documentation]    1.接口登录
    ...    2.设置浏览器cookie和localStorage
    ...    3.获取账号语言信息
    ...    4.获取灰度列表
    open browser    ${kefuurl}    ${agent.browser}
    ${session}    Create Random Session    ${kefuurl}
    ${uiagent}    Login And Set Cookies    ${agent}    ${session}
    #设置浏览器语言
    Execute Javascript    localStorage.setItem('language','${uiagent.language}')
    #设置tenantId
    Execute Javascript    localStorage.setItem('tenantId','${uiagent.tenantId}')
    #设置selenium超时时间
    Set Selenium Timeout    ${SeleniumTimeout}
    #获取账号语言信息
    ${resp}=    /tenants/{tenantId}/options/agentUserLanguage_{userId}    ${uiagent}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${uiagent}    language=${j['data'][0]['optionValue']}
    #获取灰度列表信息并保存
    ${resp}=    /v1/grayscale/tenants/{tenantId}    ${uiagent}    ${timeout}
    ${j}    to json    ${resp.content}
    #base加入灰度默认值中
    @{graylist}    Create List    base
    #添加所有灰度name到graylist
    : FOR    ${i}    IN    @{j['entities']}
    \    Append to List    ${graylist}    ${i['grayName']}
    #添加所有控制页面显示option项为true的optionNaem到graylist
    @{optionlist}    create list    agentVisitorCenterVisible    robotOptimizationStatus    growingioEnable
    : FOR    ${i}    IN    @{optionlist}
    \    ${t}    Get Option Value    ${uiagent}    ${i}
    \    Run Keyword If    '${t}'=='true'    Append to List    ${graylist}    ${i}
    log    ${graylist}
    ${uiagent.graylist}    copy list    ${graylist}
    #获取权限list
    ${resp}=    /v1/permission/tenants/{tenantId}/users/{userId}/resource_categories    ${uiagent}    ${timeout}
    ${j}    to json    ${resp.content}
    #base加入灰度默认值中
    @{resourcelist}    Create List    base
    #添加所有权限name到resourcelist
    Append to List    ${resourcelist}    @{j['entity']['resource_categories']}
    ${uiagent.resourcelist}    copy list    ${resourcelist}
    Run Keyword if    ${user}==0    set global variable    ${uiadmin}    ${uiagent}
    ...    ELSE IF    ${user}==1    set global variable    ${uiagent1}    ${uiagent}
    ...    ELSE IF    ${user}==2    set global variable    ${uiagent2}    ${uiagent}

Check Element Contains Text
    [Arguments]    ${locator}    ${text}
    log    ${text}
    Wait Until Page Contains Element    ${locator}
    Wait Until Element Contains    ${locator}    ${text}

Check Base Elements
    [Arguments]    ${lang}    ${elements}    ${parentxpath}=${empty}
    log    ${elements}
    : FOR    ${i}    IN    @{elements}
    \    ${locator}    set variable    xpath=${parentxpath}${i['xPath']}
    \    ${lt}    Get Length    ${i['text']}
    \    Run Key word if    ${lt}>0    Check Element Contains Text    ${locator}    ${i['text']['${lang}']}
    \    ${la}    Get Length    ${i['attributes']}
    \    Run Key word if    ${la}>0    Check Attributes    ${locator}    ${lang}    ${i['attributes']}
    \    ${le}    Get Length    ${i['elements']}
    \    Run Key word if    ${le}>0    Check Base Elements    ${lang}    ${i['elements']}    ${i['xPath']}

Check Attributes
    [Arguments]    ${locator}    ${lang}    ${attributes}
    log    ${attributes}
    : FOR    ${i}    IN    @{attributes}
    \    log    ${locator}@${i['name']}
    \    ${a}    Get Element Attribute    ${locator}@${i['name']}
    \    log    ${a}
    \    Should be True    '${a}'=='${i['value']['${lang}']}'

Check Base Module
    [Arguments]    ${url}    ${agent}    ${checkstr}    ${mode}=Agent
    [Documentation]    判断整个模块是否灰度，若灰度，跳转到url，检查基础元素
    ${json}    to json    ${checkstr}
    set test variable    ${nav}    ${json['navigator']['${mode}']}
    ${ig}    Get Index From List    ${agent.graylist}    ${nav['GrayKey']}
    ${ir}    Get Index From List    ${agent.resourcelist}    ${nav['ResourceKey']}
    #如果灰度列表没有该key或者option未打开，输出log，否则检查元素
    Return From Keyword If    ${ig}==-1    log    未灰度此功能：${ig}
    Return From Keyword If    ${ir}==-1    log    未配置此功能：${ir}
    go to    ${url}${nav['uri']}
    Check Base Elements    ${agent.language}    ${json['elements']}

Update Tab Selector
    [Arguments]    ${key}    &{tab}
    : FOR    ${i}    IN    ${tab}
    \    ${value}    Get Dictionary Values    ${i}
    \    \    Run Keyword If
    \    log    ${value}

Login And Set Cookies
    [Arguments]    ${agent}    ${session}
    [Documentation]    1.接口登录
    ...    2.设置浏览器cookie
    ...    3.返回坐席信息
    #接口登录并打开浏览器
    ${tagent}    set variable    ${agent}
    #登录
    ${resp}=    /login    ${session}    ${tagent}    ${timeout}
    : FOR    ${i}    IN    @{resp}
    \    log    ${i}
    ${j}    to json    ${resp.content}
    set to dictionary    ${tagent}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=${session}
    #打开浏览器并写入cookie
    @{t}=    Get Dictionary Keys    ${tagent.cookies}
    ${protocol}    ${domain}    Split String    ${kefuurl}    ://
    : FOR    ${key}    IN    @{t}
    \    log    ${key}
    \    ${value}=    Get From Dictionary    ${tagent.cookies}    ${key}
    \    Add Cookie    ${key}    ${value}    /    .${domain}
    Return From Keyword    ${tagent}

Create Random Session
    [Arguments]    ${url}
    ${session}    Generate Random String
    Create Session    ${session}    ${url}
    return from keyword    ${session}

Disable All Waiting Rules
    [Arguments]    ${agent}
    [Documentation]    1.接口登录
    ...    2.设置浏览器cookie和localStorage
    ...    3.获取账号语言信息
    ...    4.获取灰度列表
    ${ig}    Get Index From List    ${agent.graylist}    teamOverflow
    #如果灰度列表没有该key或者option未打开，输出log，否则检查元素
    Return From Keyword If    ${ig}==-1    log    未灰度此功能：${ig}
    #否则，关闭所有Waiting Rules
    Reverse All Rules Status    ${agent}
