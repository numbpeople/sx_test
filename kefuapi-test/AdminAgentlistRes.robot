*** Variables ***
&{AgentFilterEntity}    page=1    size=8    keyValue=    orderBy=    orderMethod=

*** Keywords ***
/v1/Admin/Agents
    [Arguments]    ${session}    ${timeout}    ${AgentFilterEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents?page=${AgentFilterEntity.page}&size=${AgentFilterEntity.size}&keyValue=${AgentFilterEntity.keyValue}&orderBy=${AgentFilterEntity.orderBy}&orderMethod=${AgentFilterEntity.orderMethod}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
