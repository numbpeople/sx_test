*** Keywords ***
/v1/permission/tenants/{tenantId}/roles
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/roles
    ${params}=    set variable    _=1509526060679
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/permission/tenants/{tenantId}/roles/{roleId}
    [Arguments]    ${agent}    ${timeout}    ${roleId}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/roles/${roleId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/users/${agent.userId}/resource_categories
    ${params}=    set variable    _=1509526060679
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories
    [Arguments]    ${agent}    ${timeout}    ${method}    ${roleId}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/roles/${roleId}/resource_categories
    ${params}=    set variable    _=1509526060679
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/permission/tenants/{tenantId}/users/{userId}/roles
    [Arguments]    ${agent}    ${data}    ${userId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/users/${userId}/roles
    ${params}=    set variable    _=1509526060679
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    data=${data}
    ...    timeout=${timeout}
