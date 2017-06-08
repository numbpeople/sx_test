*** Keywords ***
/v1/tenants/{tenantId}/channels
    [Arguments]    ${method}    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/channels
    ${rs}=    Run Keyword If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/v1/tenants/{tenantId}/channels/{channelId}
    [Arguments]    ${method}    ${agent}    ${channelId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/channels/${channelId}
    ${rs}=    Run Keyword If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}
