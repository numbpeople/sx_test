*** Keywords ***
Login And Set Browser Cookies&localStorage
    [Arguments]    ${agent}
    #接口登录并打开浏览器
    set global variable    ${uiagent}    ${agent}
    Create Session    uisession    ${kefuurl}
    #登录
    ${resp}=    /login    uisession    ${uiagent}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${uiagent}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=uisession
    #获取账号语言信息
    ${resp}=    /tenants/{tenantId}/options/agentUserLanguage_{userId}    ${uiagent}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${uiagent}    language=${j['data'][0]['optionValue']}
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
