*** keyword ***
/v1/monitor/alarms
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/monitor/alarms
    ${params}=    set variable    page=0&size=15&_=1512729907512
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
