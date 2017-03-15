*** Variables ***
${codeId}         ${EMPTY}
${registersession}    ${EMPTY}

*** Keywords ***
/imgVerifyCode
    [Arguments]    ${session}    ${method}    ${timeout}    ${codeId}=${empty}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable if    ${method}=='post'    /imgVerifyCode    ${method}=='get'    /imgVerifyCode?codeId=${codeId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    ${method}    headers=${header}    timeout=${timeout}
