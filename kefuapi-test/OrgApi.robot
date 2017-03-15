*** Variables ***
&{OrgRegInfo}     phone=    codeValue=    name=    desc=    username=leoli-org081701@easemob.com    password=111111    orgName=leoli081701

*** Keywords ***
/v1/organs
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/${AgentEntity.userId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/organs/{org_name}/token
    [Arguments]    ${session}    ${timeout}    ${OrgRegInfo}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${OrgRegInfo.orgName}/token
    ${data}=    Create Dictionary    username=${OrgRegInfo.username}    password=${OrgRegInfo.password}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/organs todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/token todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/users/me todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/users/{userId}/attributes/nicename todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId} todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/enable todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/disable todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/attributes/agentNumQuota todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/easemobchannels/ todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/servicesessions todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/servicesessions/{sessionServiceId} todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/servicesessions/{sessionServiceId}/messages todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/messages/{msgId} todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/quality/mark todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/trend todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/visitor/total todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/count/type todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/message/today/total todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/trend todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/total todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/processing todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/today/agent todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workload todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/session/workquality todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/external/agent/online/count todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}
