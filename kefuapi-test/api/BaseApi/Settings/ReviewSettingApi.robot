*** Keywords ***
/v1/tenants/{tenantId}/qualityreviews/qualityitems
    [Arguments]    ${method}    ${agent}    ${timeout}    ${data}=    ${id}=
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/qualityreviews/qualityitems
    run keyword if    '${method}'=='delete'    set suite variable    ${uri}    /v1/tenants/${agent.tenantId}/qualityreviews/qualityitems/${id}
    ${params}    set variable    _=1512560343767
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    data=${data}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/qualityreviews/scoremapping
    [Arguments]    ${method}    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/qualityreviews/scoremapping
    ${params}    set variable    mode=Auto&_=1512615873279
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
