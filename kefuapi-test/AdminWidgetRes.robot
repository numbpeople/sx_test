*** Keywords ***
/v1/webimplugin/theme/options
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/theme/options?tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/notice/options
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/notice/options?tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
