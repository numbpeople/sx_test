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

/v1/tenants/{tenantId}/commonphrases/exportFile
    [Arguments]    ${agent}    ${timeout}    ${language}
    [Documentation]    导出公共常用语
    ${header}=    Create Dictionary    Accept-Language=${language}
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/commonphrases/exportFile
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx
    [Arguments]    ${agent}    ${timeout}    ${language}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
