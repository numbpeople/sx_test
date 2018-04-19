*** Keywords ***
/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Stop
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${Msg}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Messages
    ${postdata}    set variable    {"type":"${Msg.type}","msg":"${Msg.msg}"}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${postdata}    timeout=${timeout}

/v1/Tenants/me/Agents/me/UnReadTags/Count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me/customInfoParam
    [Arguments]    ${agent}    ${visitorId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/customInfoParam
    ${params}=    set variable    visitorId=${visitorId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/official-accounts
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/official-accounts
    ${params}=    set variable    _=1510727292733
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/ServiceSession/{serviceSessionId}/AgentQueue/{queueId}
    [Arguments]    ${agent}    ${serviceSessionId}    ${queueId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/ServiceSession/${serviceSessionId}/AgentQueue/${queueId}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    
/v6/tenants/{tenantId}/servicesessions/{serviceSessionId}/transfer
    [Arguments]    ${agent}    ${serviceSessionId}    ${queueId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/transfer
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

