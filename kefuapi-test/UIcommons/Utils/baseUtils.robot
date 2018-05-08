*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../api/MicroService/Webapp/InitApi.robot
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
Resource          ../../commons/admin common/Members/Agents_Common.robot

*** Variables ***
@{elementstatelist}    ''    ' noAnswer'    ' selected'    ' activated'    ' hide'

*** Keywords ***
smoketest case 
    [Arguments]    ${agent}    ${json}    ${mode}=Agent
    switch browser    ${agent.session}    
    Check Base Module    ${kefuurl}    ${agent}    ${json}    ${mode} 

UI Agent Init
    [Arguments]    ${agent}
    [Documentation]    1.接口登录
    ...    2.设置浏览器cookie和localStorage
    ...    3.获取账号语言信息
    ...    4.获取灰度列表
    ${session}    Create Random Session    ${kefuurl}
    ${uiagent}    Login And Set Cookies    ${agent}    ${session}    ${kefuurl}
    #设置浏览器语言
    Execute Javascript    localStorage.setItem('lang','${uiagent.language}')
    #设置tenantId
    Execute Javascript    localStorage.setItem('tenantId','${uiagent.tenantId}')
    #获取权限list
    ${resourcelist}=    Get ResourceList  ${uiagent}
    #添加所有权限name到resourcelist
    ${uiagent.resourcelist}    copy list    ${resourcelist}
    [Return]    ${uiagent}

Get ResourceList
    [Arguments]    ${agent}
    [Documentation]    获取权限列表
    ${resp}=    /v1/permission/tenants/{tenantId}/users/{userId}/resource_categories    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    #base加入灰度默认值中
    @{resourcelist}    Create List    base
    #添加所有权限name到resourcelist
    Append to List    ${resourcelist}    @{j['entity']['resource_categories']}
    [Return]    ${resourcelist}

Get GrayList
    [Arguments]    ${agent}
    [Documentation]    获取灰度列表
    #获取灰度列表信息并保存
    ${resp}=    /v1/grayscale/tenants/{tenantId}    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    #base加入灰度默认值中
    @{graylist}    Create List    base
    #添加所有灰度name到graylist
    : FOR    ${i}    IN    @{j['entities']}
    \    Append to List    ${graylist}    ${i['grayName']}
    #添加所有控制页面显示option项为true的optionNaem到graylist
    @{optionlist}    create list    agentVisitorCenterVisible    robotOptimizationStatus    growingioEnable
    : FOR    ${i}    IN    @{optionlist}
    \    ${t}    Get Option Value    ${agent}    ${i}
    \    Run Keyword If    '${t}'=='true'    Append to List    ${graylist}    ${i}
    #获取callback
    ${resp}=    /home/initdata    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j['showCallback']}    Append to List    ${graylist}    showCallback
    log    ${graylist}
    [Return]    ${graylist}

Check Element Contains Text
    [Arguments]    ${locator}    ${text}
    log    ${text}
    Wait Until Page Contains Element    xpath=${locator}
    Wait Until Element Contains    xpath=${locator}    ${text}

Check Base Elements
    [Arguments]    ${lang}    ${elements}    ${parentxpath}=${empty}    ${hide}=${false}
    Return From Keyword If    ${hide}    log    隐藏元素
    log    ${hide}
    log    ${elements}
    : FOR    ${i}    IN    @{elements}
    \    ${locator}    set variable    ${parentxpath}${i['xPath']}
    \    ${lt}    Get Length    ${i['text']}
    \    Run Key word if    ${lt}>0    Check Element Contains Text    ${locator}    ${i['text']['${lang}']}
    \    ${la}    Get Length    ${i['attributes']}
    \    ${hide}    Run Key word if    ${la}>0    Check Attributes    ${locator}    ${lang}
    \    ...    ${i['attributes']}
    \    ${le}    Get Length    ${i['elements']}
    \    Run Key word if    ${le}>0    Check Base Elements    ${lang}    ${i['elements']}    ${locator}
    \    ...    ${hide}

Check Attributes
    [Arguments]    ${locator}    ${lang}    ${attributes}
    [Documentation]    1.检查各属性与json中是否匹配
    ...    2.如发现hide属性，返回true，无则返回false
    set test variable    ${hide}    ${false}
    log    ${attributes}
    : FOR    ${i}    IN    @{attributes}
    \    log    ${locator}@${i['name']}
    \    ${a}    Get Element Attribute    xpath=${locator}@${i['name']}
    \    log    ${a}
    \    Should be True    '${a}'=='${i['value']['${lang}']}'
    \    #查询属性中是否有隐藏属性
    \    ${t}    Get Regexp Matches    ${a}    hide
    \    ${l}    get length    ${t}
    \    Run Keyword If    ${l}>0    set test variable    ${hide}    ${true}
    [Return]    ${hide}

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
    [Arguments]    ${agent}    ${session}    ${url}
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
    ...    session=${session}    nicename=${j['agentUser']['nicename']}
    #打开浏览器并写入cookie
    open browser    ${url}    ${agent.browser}    ${agent.session}
    Maximize Browser Window
    Set Browser Cookies    ${tagent}    ${kefuurl}
    Return From Keyword    ${tagent}

Set Browser Cookies
    [Arguments]    ${agent}    ${url}
    [Documentation]    设置浏览器cookie
    #写入cookie
    @{t}=    Get Dictionary Keys    ${agent.cookies}
    ${protocol}    ${domain}    Split String    ${url}    ://
    : FOR    ${key}    IN    @{t}
    \    log    ${key}
    \    ${value}=    Get From Dictionary    ${agent.cookies}    ${key}
    \    Comment    Add Cookie    ${key}    ${value}    /    60.205.245.1
    \    Add Cookie    ${key}    ${value}    /    .${domain}

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

Iinit Queue In Setup
    [Arguments]    ${admin}    ${agent}    ${type}='suite'
    [Documentation]    1.在setup中添加坐席到新技能组
    ...    2.
    ${q}    Init Agent In New Queue    ${admin}    ${agent}
    Run Keyword If    ${type}=='suite'    set suite variable    ${suitequeue}    ${q}
    ...    ELSE    set test variable    ${testqueue}    ${q}

Del Queue In Teardown
    [Arguments]    ${admin}    ${type}='suite'
    [Documentation]    1.在setup中添加坐席到新技能组
    ...    2.
    ${q}    Set Variable If    ${type}=='suite'    ${suitequeue}    ${testqueue}
    Delete Agentqueue    ${q.queueId}    ${admin}

Set Agent StatusAndMaxServiceUserNumber
    [Arguments]    ${agent}    ${status}    ${maxServiceSessionCount}
    [Documentation]    1.设置坐席状态
    ...    2.设置最大接待数
    Set Agent Status    ${agent}    ${status}
    Set Agent MaxServiceUserNumber    ${agent}    ${maxServiceSessionCount}

Kefu Chat Suite Setup
    [Arguments]    ${admin}    ${agent}
    [Documentation]    1.创建关联
    ...    2.关闭所有溢出规则
    ...    3.获取账号语言信息
    ...    4.获取灰度列表
    Create Channel    ${admin}
    Disable All Waiting Rules    ${admin}
    Iinit Queue In Setup    ${admin}    ${agent}
    Set RoutingPriorityList    入口    渠道    关联    ${admin}

Kefu Chat Suite Teardown
    [Arguments]    ${admin}
    [Documentation]    1.创建关联
    ...    2.关闭所有溢出规则
    ...    3.获取账号语言信息
    ...    4.获取灰度列表
    Delete Channels    ${admin}
    Del Queue In Teardown    ${admin}

Format String And Check Elements
    [Arguments]    ${agent}    ${keyword}    @{params}
    ${jbase}    Format String To Json    ${keyword}    @{params}
    Check Base Elements    ${agent.language}    ${jbase['elements']}

Format String To Json
    [Arguments]    ${keyword}    @{params}
    ${j}    Run Keyword    ${keyword}    @{params}
    ${jbase}    to json    ${j}
    [Return]    ${jbase}

Generate Uuidguest
    [Arguments]    ${originType}=app
    ${u}    uuid 4
    ${guest}=    create dictionary    userName=${u}    originType=${originType}
    [Return]    ${guest}

Send Uuidmsg By Specified Queue
    [Arguments]    ${restentity}    ${guest}    ${queueName}
    ${u}    uuid 4
    ${msg}    create dictionary    msg=${u}:test msg!    type=txt    ext={"weichat":{"originType":"${guest.originType}","queueName":"${queueName}"}}
    Send Message    ${restentity}    ${guest}    ${msg}

Send Uuidmsg By Specified Agent
    [Arguments]    ${restentity}    ${guest}    ${agentname}
    ${u}    uuid 4
    ${msg}    create dictionary    msg=${u}:test msg!    type=txt    ext={"weichat":{"originType":"${guest.originType}","agentUsername":"${agentname}"}}
    Send Message    ${restentity}    ${guest}    ${msg}

KefuUI Setup
    [Arguments]    ${admin}
    #登录管理员
    ${agent}    UI Agent Init    ${admin}
    #灰度对所有坐席生效，仅需获取一次
    ${graylist}=    Get GrayList  ${agent}
    #添加灰度list
    ${agent.graylist}    copy list    ${graylist}
    set global variable    ${uiadmin}    ${agent}
    #创建普通坐席1
    ${agent1}    copy dictionary    ${admin}
    ${a}    Create Temp Agent    ${uiadmin}    2
    set to dictionary    ${agent1}    username=${a.username}    password=${a.password}
    #登录普通坐席1
    ${agent}    UI Agent Init    ${agent1}
    #添加灰度list
    ${agent.graylist}    copy list    ${graylist}
    set global variable    ${uiagent1}    ${agent}
    #设置selenium超时
    Set Selenium Timeout    ${SeleniumTimeout}
    #获取时间计划scheduleId
    Get ScheduleId    ${uiadmin}
    #允许坐席设置接待人数
    Set Option    ${Admin}    allowAgentChangeMaxSessions    true


KefuUI Teardown
    Close All Browsers
    Delete AgentUser    ${uiagent1.userId}    ${uiadmin}
