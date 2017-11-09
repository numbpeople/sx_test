*** Keywords ***
/v1/Tenant/me/ServiceSession/Statistics/MessageCountByTechChannelList
    [Arguments]    ${agent}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/MessageCountByTechChannelList
    ${params}    set variable    beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/EveryTechChannelNewServiceSessionCount
    [Arguments]    ${agent}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/EveryTechChannelNewServiceSessionCount
    ${params}    set variable    beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
