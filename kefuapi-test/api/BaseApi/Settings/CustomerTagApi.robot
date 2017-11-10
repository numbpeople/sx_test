*** Keywords ***
/v1/Admin/UserTags
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/UserTags
    ${params}    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
