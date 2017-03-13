*** Keywords ***
/v1/tenants/{tenantId}/current/agentstate todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/5884/current/agentstate?orgName=easemob-demo&appName=testxtmvip&userName=webim-visitor-YTPF96TGQH36P39EEGM6&token=YWMtyrB0VHiXEeamsMkU1ymL9wAAAVhRZjHFsrHsYRba4sqswm7fKyfaOshXWbY&imServiceNumber=0427&?=112
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
