*** Keywords ***
/v1/Tenant/me/Agents/me/UserWaitQueues
    [Arguments]    ${session}    ${timeout}    ${page}    ${per_page}    ${originType}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues?page=${page}&per_page=${per_page}&originType=${originType}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/count
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues/count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
