*** Keywords ***
/v1/event_collector/events
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/event_collector/events
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/event_collector/event/{eventId}
    [Arguments]    ${agent}    ${eventId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/event_collector/event/${eventId}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/event_collector/{tenantId}/events
    [Arguments]    ${agent}    ${agentAccountName}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/event_collector/${agent.tenantId}/events
    ${params}    set variable    agentUserName=${agentAccountName}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}    params=${params}