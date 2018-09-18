*** keyword ***
/v1/monitor/alarms
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/monitor/alarms
    ${params}=    set variable    page=0&size=15&_=1512729907512
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/monitor/unreadalarmcount
    [Arguments]    ${agent}    ${method}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/monitor/unreadalarmcount
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
