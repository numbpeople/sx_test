*** Keywords ***
/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Stop
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${Msg}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Messages
    ${postdata}    set variable    {"type":"${Msg.type}","msg":"${Msg.msg}"}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${postdata}    timeout=${timeout}

/v1/Tenants/me/Agents/me/UnReadTags/Count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me/customInfoParam
    [Arguments]    ${agent}    ${visitorId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/customInfoParam
    ${params}=    set variable    visitorId=${visitorId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
