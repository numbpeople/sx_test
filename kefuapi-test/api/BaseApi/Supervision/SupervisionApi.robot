*** keyword ***
/v1/monitor/agentqueues
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/monitor/agentqueues
    ${params}=    set variable    _=1512722524588
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/monitor/agentusers
    [Arguments]    ${agent}    ${queueId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/monitor/agentusers
    ${params}=    set variable    queueId=${queueId}&_=1512722524589
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
