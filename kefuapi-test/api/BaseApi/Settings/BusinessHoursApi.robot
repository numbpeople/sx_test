*** Keywords ***
/v1/tenants/{tenantId}/timeplans/schedules
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/weekdays
    [Arguments]    ${agent}    ${timeout}    ${scheduleId}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules/${scheduleId}/weekdays
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes
    [Arguments]    ${agent}    ${timeout}    ${scheduleId}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules/${scheduleId}/worktimes
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays
    [Arguments]    ${agent}    ${timeout}    ${scheduleId}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules/${scheduleId}/holidays
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
