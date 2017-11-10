*** Keywords ***
/v1/tenants/{tenantId}/servicesessions/qualityreviews
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/qualityreviews
    ${params}=    set variable    page=${FilterEntity.page}&pagesize=${FilterEntity.per_page}&beginDateTime=${DateRange.beginDate}&endDateTime=${DateRange.endDate}&firstResponseTime=${FilterEntity.firstResponseTime}&sessionTime=${FilterEntity.sessionTime}&avgResponseTime=${FilterEntity.avgResponseTime}&visitorMark=${FilterEntity.visitorMark}&originType=${FilterEntity.originType}&sessionTag=${FilterEntity.sessionTag}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
