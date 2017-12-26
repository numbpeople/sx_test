*** Keywords ***
/v1/Agents/{AdminUserId}/Agents
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/${agent.userId}/Agents
    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
    ...    timeout=${timeout}
