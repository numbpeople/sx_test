*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib

*** Keywords ***
/agents/{agentId}
    [Arguments]    ${method}    ${agent}    ${data}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /agents/${agent.userId}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/agents/{agentId}/sessions
    [Arguments]    ${agent}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /agents/${agent.userId}/sessions
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/agents/{agentId}/visitors
    [Arguments]    ${agent}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /agents/${agent.userId}/visitors
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/agents/{agentId}/skillgroups
    [Arguments]    ${agent}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /agents/${agent.userId}/skillgroups
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/agents/{sessionId}
    [Arguments]    ${agent}    ${sessionId}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /agents/${sessionId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/agents/{sessionId}/messages
    [Arguments]    ${agent}    ${sessionId}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /agents/${sessionId}/messages
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
