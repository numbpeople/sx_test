*** Keywords ***
/v1/Admin/TechChannel/WeiboTechChannel
    [Arguments]    ${agent}    ${type}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel
    ${params}=    set variable    type=${type}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/weixin/admin/preauthcode
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/weixin/admin/preauthcode
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
