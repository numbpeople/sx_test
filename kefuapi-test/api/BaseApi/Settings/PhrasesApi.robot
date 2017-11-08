*** Keywords ***
/v1/organs/{organName}/tenants/{tenantId}/commonphrases
    [Arguments]    ${agent}    ${method}    ${orgEntity}    ${phrasesEntity}    ${timeout}    ${data}
    ...    ${id}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/commonphrases
    Run Keyword If    '${method}'=='put'    set suite variable    ${uri}    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/commonphrases/${id}
    Run Keyword If    '${method}'=='delete'    set suite variable    ${uri}    /v6/organs/${orgEntity.organName}/tenants/${agent.tenantId}/commonphrases/${id}
    ${params}=    set variable    systemOnly=${phrasesEntity.systemOnly}&buildChildren=${phrasesEntity.buildChildren}&buildCount=${phrasesEntity.buildCount}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
