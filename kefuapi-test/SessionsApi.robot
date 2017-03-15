*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib

*** Keywords ***
/sessions
    [Arguments]    ${agent}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /sessions
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/sessions/{sessionId}
    [Arguments]    ${agent}    ${sessionId}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /sessions/${sessionId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/sessions/{sessionId}/messages
    [Arguments]    ${method}    ${agent}    ${sessionId}    ${messageData}    ${timeout}
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json    tenantId=${tenantId}
    ${uri}=    set variable    /sessions/${sessionId}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
