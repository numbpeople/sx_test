*** Keywords ***
Browser Init
    [Arguments]    ${agent}
    [Documentation]    1.接口登录
    ...    2.设置浏览器cookie和localStorage
    ...    3.获取账号语言信息
    ...    4.获取灰度列表
    #接口登录并打开浏览器
    set global variable    ${uiagent}    ${agent}
    Create Session    uisession    ${kefuurl}
    #登录
    ${resp}=    /login    uisession    ${uiagent}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${uiagent}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=uisession
    #打开浏览器并写入cookie
    @{t}=    Get Dictionary Keys    ${uiagent.cookies}
    open browser    ${kefuurl}    ${uiagent.browser}
    : FOR    ${key}    IN    @{t}
    \    log    ${key}
    \    ${value}=    Get From Dictionary    ${uiagent.cookies}    ${key}
    \    Add Cookie    ${key}    ${value}
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
    ${uiagent.graylist}    copy list    ${graylist}
    set global variable    ${uiagent}    ${uiagent}

Check Element Contains Text
    [Arguments]    ${locator}    ${text}
    log    ${text}
    Wait Until Page Contains Element    ${locator}
    Wait Until Element Contains    ${locator}    ${text}

Check Base Elements
    [Arguments]    ${lang}    ${elements}
    log    ${elements}
    : FOR    ${i}    IN    @{elements}
    \    ${locator}    set variable    xpath=${i['xPath']}
    \    ${lt}    Get Length    ${i['text']}
    \    Run Key word if    ${lt}>0    Check Element Contains Text    ${locator}    ${i['text']['${lang}']}
    \    ${la}    Get Length    ${i['attributes']}
    \    Run Key word if    ${la}>0    Check Attributes    ${locator}    ${lang}    ${i['attributes']}
    \    ${le}    Get Length    ${i['elements']}
    \    Run Key word if    ${le}>0    Check Base Elements    ${lang}    ${i['elements']}

Check Attributes
    [Arguments]    ${locator}    ${lang}    ${attributes}
    log    ${attributes}
    : FOR    ${i}    IN    @{attributes}
    \    log    ${locator}@${i['name']}
    \    ${a}    Get Element Attribute    ${locator}@${i['name']}
    \    log    ${a}
    \    Should be True    '${a}'=='${i['value']['${lang}']}'

Check Base Module
    [Arguments]    ${url}    ${showkey}    ${agent}    ${json}
    [Documentation]    判断整个模块是否灰度，若灰度，跳转到url，检查基础元素
    ${ig}    Get Index From List    ${agent.graylist}    ${showkey}
    #如果灰度列表没有该key或者option未打开，输出log，否则检查元素
    Run Keyword If    ${ig}==-1    Pass Execution    未灰度此功能：${showkey}
    log    ${url}
    go to    ${url}
    Check Base Elements    ${agent.language}    ${json['elements']}
