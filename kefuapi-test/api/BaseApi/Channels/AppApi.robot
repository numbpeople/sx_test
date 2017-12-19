*** Keywords ***
/channels
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /channels
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/EaseMobTechChannel
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/autoCreateImAssosciation
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/autoCreateImAssosciation
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Admin/TechChannel/EaseMobTechChannel/{channelId}
    [Arguments]    ${agent}    ${channelId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel/${channelId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
