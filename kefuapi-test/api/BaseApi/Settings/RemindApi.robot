*** Keywords ***
/v1/tenants/{tenantId}/sms/create-remind
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/create-remind
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/tenants/{tenantId}/sms/reminds
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/reminds
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/sms/reminds/{id}
    [Arguments]    ${method}    ${agent}    ${remindId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/reminds/${remindId}
    ${rs}=    Run Keyword If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    ...    ELSE IF    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/v1/tenants/{tenantId}/sms/reminds/{id}/status
    [Arguments]    ${agent}    ${remindentity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/reminds/${remindentity.id}/status
    ${params}=    set variable    status=${remindentity.status}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
