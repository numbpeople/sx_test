*** Keywords ***
/login
    [Arguments]    ${session}    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${agent.username}&password=${agent.password}&status=${agent.status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Post Request    ${session}    ${uri}    params=${params}    headers=${header}    timeout=${timeout}
