*** Variables ***
${codeId}         ${EMPTY}
${registersession}    ${EMPTY}

*** Keywords ***
/imgVerifyCode
    [Arguments]    ${agent}    ${method}    ${timeout}    ${codeId}=${empty}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /imgVerifyCode
    ${params}=    set variable if    '${method}'=='post'    ${empty}    '${method}'=='get'    codeId=${codeId}
    Run Keyword And Return    ${method} request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
