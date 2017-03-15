*** Keywords ***
/v1/Admin/TechChannel/EaseMobTechChannel
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
