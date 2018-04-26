*** Keywords ***
/v1/webimplugin/tenants/{tenantId}/sessions/{serviceSessionId}/continue-wait
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/tenants/${agent.tenantId}/sessions/${serviceSessionId}/continue-wait
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/waitings
    [Arguments]    ${agent}    ${filter}    ${range}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /waitings
    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&originType=${filter.originType}&beginDate=${range.beginDate}&endDate=${range.endDate}&techChannelId=${filter.techChannelId}&techChannelType=${filter.techChannelType}&visitorName=${filter.visitorName}&queueId=${filter.queueId}&vip=${filter.vip}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues
    ${params}=    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&originType=${FilterEntity.originType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/search
    [Arguments]    ${agent}    ${filter}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues/search
    ${params}=    set variable    page=${filter.page}&per_page=${filter.per_page}&originType=${filter.originType}&beginDate=${data.beginDate}&endDate=${data.endDate}&techChannelId=${filter.techChannelId}&techChannelType=${filter.techChannelType}&visitorName=${filter.visitorName}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/agents/{agentId}/queues
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/agents/${agent.userId}/queues
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/queues/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/queues?page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&originType=${FilterEntity.originType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort
    [Arguments]    ${agent}    ${waitingId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/queues/waitqueue/waitings/${waitingId}/abort
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/{waitingId}
    [Arguments]    ${agent}    ${waitingId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues/${waitingId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues/waitings/abort forbidden
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${tenantId}/queues/waitings/abort
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    headers=${header}    timeout=${timeout}

/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSessionId}/abort
    [Arguments]    ${agent}    ${serviceSesssionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/tenants/${agent.tenantId}/queues/unused/waitings/${serviceSesssionId}/abort
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSessionId}/assign/queues/{queueId}
    [Arguments]    ${agent}    ${serviceSesssionId}    ${queueId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/tenants/${agent.tenantId}/queues/unused/waitings/${serviceSesssionId}/assign/queues/${queueId}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSessionId}/assign/agents/{agentUserId}
    [Arguments]    ${agent}    ${serviceSesssionId}    ${agentUserId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/tenants/${agent.tenantId}/queues/unused/waitings/${serviceSesssionId}/assign/agents/${agentUserId}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v6/Tenant/me/Agents/me/UserWaitQueues/{serviceSessionId}
    [Arguments]    ${agent}    ${serviceSesssionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/Tenant/me/Agents/me/UserWaitQueues/${serviceSesssionId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
