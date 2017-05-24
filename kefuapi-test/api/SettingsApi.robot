*** Keywords ***
/v1/access/config
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/access/config
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/webhook
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/webhook
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/commonphrases/exportFile
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    [Documentation]    导出公共常用语
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/commonphrases/exportFile
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&agentUserId=${agent.userId}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
