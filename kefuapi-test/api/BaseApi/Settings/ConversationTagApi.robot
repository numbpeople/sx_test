*** Keywords ***
/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree
    [Arguments]    ${agent}    ${summaryId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/ServiceSessionSummaries/${summaryId}/tree
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
