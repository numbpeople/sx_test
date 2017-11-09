*** Keywords ***
/v1/tenants/{tenantId}/evaluationdegrees
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    /v1/tenants/{tenantId}/evaluationdegrees
    ...
    ...    GET
    ...
    ...    分页获取租户满意度评价级别
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/evaluationdegrees
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags
    [Arguments]    ${agent}    ${timeout}    ${evaluationdegreeId}
    ${header}=    Create Dictionary    Content-Type=application/json;
    set global variable    ${evaluationdegreeId}    ${degreeId[0]}
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/evaluationdegrees/${evaluationdegreeId}/appraisetags
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
