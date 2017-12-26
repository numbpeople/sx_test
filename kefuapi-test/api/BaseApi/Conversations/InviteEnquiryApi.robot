*** Keywords ***
/v6/tenants/{tenantId}/serviceSessions/{serviceSessionId}/inviteEnquiry
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    [Documentation]    Description:
    ...
    ...    发送满意度评价邀请消息
    ...
    ...    Request URL: /v6/tenants/{tenantId}/serviceSessions/{serviceSessionId}/inviteEnquiry
    ...
    ...    Request Method: POST
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/tenants/${agent.tenantId}/serviceSessions/${serviceSessionId}/inviteEnquiry
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
