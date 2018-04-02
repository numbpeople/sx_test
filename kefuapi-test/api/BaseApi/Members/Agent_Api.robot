*** Keywords ***
/v1/Admin/Agents
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents
    ${params}    set variable if    '${method}'=='get'    page=${filter.page}&size=${filter.size}&keyValue=${filter.keyValue}&orderBy=${filter.orderBy}&orderMethod=${filter.orderMethod}    ${empty}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/Admin/Agents/{userId}
    [Arguments]    ${agent}    ${userId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents/${userId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v6/Admin/Agents/{userId}
    [Arguments]    ${agent}    ${userId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/Admin/Agents/${userId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
