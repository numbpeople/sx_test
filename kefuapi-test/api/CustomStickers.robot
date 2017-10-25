*** Keywords ***
/v1/emoj/tenants/{tenantId}/packages
    [Arguments]    ${agent}    ${timeout}    ${method}    ${file}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/emoj/tenants/${agent.tenantId}/packages
    ${params}=    set variable    _=1508830444702
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    files=${file}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/emoj/tenants/{tenantId}/packages/{packageId}
    [Arguments]    ${agent}    ${timeout}    ${packageId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/emoj/tenants/${agent.tenantId}/packages/${packageId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/emoj/tenants/{tenantId}/packages/sort
    [Arguments]    ${agent}    ${timeout}    ${orderList}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/emoj/tenants/${agent.tenantId}/packages/sort
    ${data}    set variable    {"ordered_ids":${orderList}}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
