*** Keywords ***
Login And Set Browser Cookies
    [Arguments]    ${agent}
    set suite variable    ${uiagent}    ${agent}
    Create Session    uiagentsession    ${kefuurl}
    ${resp}=    /login    uiagentsession    ${uiagent}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${uiagent}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=uiagentsession
    @{t}=    Get Dictionary Keys    ${resp.cookies}
    open browser    ${kefuurl}    ${uiagent.browser}    browser1
    :FOR    ${key}    IN    @{t}
    \    log    ${key}
    \    ${value}=    Get From Dictionary    ${resp.cookies}    ${key}
    \    Add Cookie    ${key}    ${value}
