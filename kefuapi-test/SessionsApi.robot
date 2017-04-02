*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib

*** Keywords ***
/sessions
    [Arguments]    ${agent}    ${params}    ${timeout}
    [Documentation]    api定义参考：http://wiki.easemob.com/api_doc/api.raml.html#sessions_get
    ${tenantId}    convert to string    ${agent.tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /sessions
    ${tparams}=    set variable    agent_id=${params.agent_id}&visitor_id=${params.visitor_id}&state=${params.state}&page=${params.page}&size=${params.size}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${tparams}    timeout=${timeout}

/sessions/{sessionId}
    [Arguments]    ${agent}    ${sessionId}    ${timeout}
    [Documentation]    api定义参考：http://wiki.easemob.com/api_doc/api.raml.html#sessions__sessionid__get
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
