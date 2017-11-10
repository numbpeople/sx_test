*** Keywords ***
/v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
