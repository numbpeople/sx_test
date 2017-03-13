*** Variables ***
${switchType}     0
&{commonphrasesVariables}    systemOnly=false    buildChildren=true
&{visitorUser}    userId=29a68433-f95e-48bd-97e4-1ae53f68a462    nicename=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    username=webim-visitor-2CRVGCTG6HWGEJ7E9PGF

*** Keywords ***
/v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${agentId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${tenantId}/agents/${agentId}/callcenter-attrs
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/infos
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/infos
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/recommendationSwitch
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${switchType}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${tenantId}/robots/recommendationSwitch?switchType=${switchType}&switchId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/recommendation/status
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${tenantId}/robots/recommendation/status
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/commonphrases
    [Arguments]    ${session}    ${timeout}    ${organName}    ${tenantId}    ${systemOnly}=${False}    ${buildChildren}=${True}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${organName}/tenants/${tenantId}/commonphrases?systemOnly=${systemOnly}&buildChildren=${buildChildren}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/serviceSessions/{serviceSessions}/enquiryStatus todo
    [Arguments]    ${session}    ${timeout}    ${organName}    ${tenantId}    ${systemOnly}=${False}    ${buildChildren}=${True}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${organName}/tenants/${tenantId}/commonphrases?systemOnly=${systemOnly}&buildChildren=${buildChildren}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessions}/attributes todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/13250/servicesessions/2a1f35a7-1f77-4eb7-9178-626bc059eebb/attributes?names=ip%2Cregion%2CuserAgent%2Creferer
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Agents/me
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/home/initdata
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /home/initdata
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/options
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${tenantId}/options
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Agents/{agentId}
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${userId}    ${maxServiceUserNumber}    ${status}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/${userId}
    ${data}=    Create Dictionary    maxServiceUserNumber=${maxServiceUserNumber}    status=${status}    userId=${userId}    timeout=${timeout}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'put'    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/Agents/me/Visitors
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

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

/v1/tenants/{tenantId}/visitors/{visitorUserId}
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    v1/tenants/${tenantId}/visitors/${visitorUserId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/visitorusers
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${page}    ${size}    ${beginDate}
    ...    ${endDate}    @{userTagIds}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${tenantId}/visitorusers?page=${page}&size=${size}&beginDate=${beginDate}&endDate=${endDate}&userTagIds=@{userTagIds}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenant/VisitorUsers/{visitorUserId} todo
    [Arguments]    ${method}    ${session}    ${timeout}    ${visitorUserId}    ${data}=${none}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    ${method}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSessionHistorys todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSessionHistorys
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessions}/ServiceSessionSummaryResults todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/13250/servicesessions/2a1f35a7-1f77-4eb7-9178-626bc059eebb/attributes?names=ip%2Cregion%2CuserAgent%2Creferer
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ChatGroup/{ChatGroupId}/Messages todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/13250/servicesessions/2a1f35a7-1f77-4eb7-9178-626bc059eebb/attributes?names=ip%2Cregion%2CuserAgent%2Creferer
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/sessions/{sessionid}/messages/read todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/13250/servicesessions/2a1f35a7-1f77-4eb7-9178-626bc059eebb/attributes?names=ip%2Cregion%2CuserAgent%2Creferer
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${summaryId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${tenantId}/ServiceSessionSummaries/${summaryId}/tree
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/recommendation/sessions/{sessionid}/questions todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${summaryId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${tenantId}/ServiceSessionSummaries/${summaryId}/tree
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenant/me/SessionServices/${sessionId}/Messages todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${summaryId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/SessionServices/2a1f35a7-1f77-4eb7-9178-626bc059eebb/Messages?lastSeqId=1&startSessionTimestamp=1470733325215&_=1470733321958
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
