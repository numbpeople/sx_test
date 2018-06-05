*** Keywords ***
/v1/access/config
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/access/config
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/access
    [Arguments]    ${agent}    ${path}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/access
    ${params}=    set variable    returnTo=${path}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
