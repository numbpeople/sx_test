*** Keywords ***
/v1/Admin/Agents
    [Arguments]    ${method}    ${agent}    ${AgentFilterEntity}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents
    ${params}    set variable    page=${AgentFilterEntity.page}&size=${AgentFilterEntity.size}&keyValue=${AgentFilterEntity.keyValue}&orderBy=${AgentFilterEntity.orderBy}&orderMethod=${AgentFilterEntity.orderMethod}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/Admin/Agents/{userId}
    [Arguments]    ${agent}    ${userId}    ${timeout}
    log    ${AgentUser1.userId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents/${userId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
