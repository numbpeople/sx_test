*** Keywords ***
/v1/imgateway/messages
    [Arguments]    ${agent}    ${data}    ${timeout}
    [Documentation]    IM上传文件到服务器
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/imgateway/messages
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    data=${data}
    ...    timeout=${timeout}

/v1/Tenant/{tenantId}/{orgName}/{appName}/{username}MediaFiles
    [Arguments]    ${agent}    ${rest}    ${files}    ${boundary}    ${timeout}
    [Documentation]    IM上传文件到服务器
    ${header}=    Create Dictionary    Content-Type=multipart/form-data;boundary=${boundary}    Authorization=Bearer ${rest.token}
    ${uri}=    set variable    /v1/Tenant/{tenantId}/{orgName}/{appName}/{username}MediaFiles
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    files=${files}    headers=${header}    timeout=${timeout}
