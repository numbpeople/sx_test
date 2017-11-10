*** Keywords ***
/v1/tenants/{tenantId}/searchrecords
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/searchrecords
    ${params}    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
