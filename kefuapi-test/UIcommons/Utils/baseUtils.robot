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
    [Arguments]    ${xpath}    ${text}
    Wait Until Page Contains Element    xpath=${xpath}
    Wait Until Element Contains    xpath=${xpath}    ${text}

test
