*** Keywords ***
/v1/Agents/me
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/home/initdata
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /home/initdata
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/options
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Agents/{agentId}
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/${agent.userId}
    ${data}=    set variable    {"maxServiceUserNumber":"${agent.maxServiceSessionCount}","status":"${agent.status}","userId":"${agent.userId}"}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Agents/me/Visitors
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/visitors/{visitorUserId}
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/visitors/${visitorUserId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/VisitorUsers/{visitorUserId}
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ChatGroup/{ChatGroupId}/Messages
    [Arguments]    ${agent}    ${ChatGroupId}    ${MsgFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ChatGroup/${ChatGroupId}/Messages
    ${params}    set variable    fromSeqId=${MsgFilter.fromSeqId}&size=${MsgFilter.size}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/SessionServices/{sessionId}/Messages
    [Arguments]    ${agent}    ${guest}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/SessionServices/${guest.sessionServiceId}/Messages
    ${params}    set variable    lastSeqId=${guest.sessionServiceSeqId}&startSessionTimestamp=${guest.startSessionTimestamp}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/visitorusers
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/visitorusers
    ${params}    set variable    page=${FilterEntity.page}&size=${FilterEntity.per_page}&userTagIds=${FilterEntity.userTagIds}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&enquirySummary=${FilterEntity.enquirySummary}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/Tenants/{tenantId}/Agents/{agentId}/PreSchedule/Ack?answer=true
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /Tenants/${agent.tenantId}/Agents/${agent.userId}/PreSchedule/Ack?answer=true
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
