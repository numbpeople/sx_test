*** Keywords ***
/v1/Admin/UserTags
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}    ${userTagId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/UserTags
    run keyword if    '${method}'=='put' or '${method}'=='delete'    set suite variable    ${uri}    /v1/Admin/UserTags/${userTagId}
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Admin/UserTags/exportfile
    [Arguments]    ${agent}    ${timeout}    ${language}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /v1/Admin/UserTags/exportfile
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx
    [Arguments]    ${agent}    ${timeout}    ${language}
    ${header}=    Create Dictionary    Content-Type=application/json    Accept-Language=${language}
    ${uri}=    set variable    /download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
