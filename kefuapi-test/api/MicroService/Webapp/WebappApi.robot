*** Keywords ***
/v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/visitors/${visitorUserId}/blacklists
    ${params}    set variable    _=1510727292732
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults
    [Arguments]    ${method}    ${agent}    ${serviceSessionId}    ${timeout}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/ServiceSessions/${serviceSessionId}/ServiceSessionSummaryResults
    ${params}    set variable    _=1510727292732
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/tenants/{tenantId}/serviceSessions/{serviceSessionId}/comment
    [Arguments]    ${method}    ${agent}    ${serviceSessionId}    ${timeout}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessions/${serviceSessionId}/comment
    ${params}    set variable    _=1511161448093
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/sessions/{serviceSessionId}/messages/read
    [Arguments]    ${agent}    ${serviceSessionId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sessions/${serviceSessionId}/messages/read
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/tenants/{tenantId}/whisper-messages
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/whisper-messages
    ${params}    set variable    serviceSessionId=${filter.serviceSessionId}&chatGroupId=${filter.chatGroupId}&officialAccountId=${filter.officialAccountId}&beginTimestamp=${filter.beginTimestamp}&endTimestamp=${filter.endTimestamp}&asc=${filter.asc}&_=1537165262797
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/sessions/{serviceSessionId}/whisper-messages
    [Arguments]    ${agent}    ${serviceSessionId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sessions/${serviceSessionId}/whisper-messages
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
    
/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/messages/{msgId}/recall
    [Arguments]    ${agent}    ${serviceSessionId}    ${msgId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/messages/${msgId}/recall
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    