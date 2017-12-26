*** Keywords ***
/v1/tenants/{tenantId}/timeplans
    [Arguments]    ${method}    ${agent}    ${timeout}    ${data}
    [Documentation]    Description:
    ...
    ...    获取/修改租户的上下班时间
    ...
    ...    Request URL: /v1/tenants/{tenantId}/timeplans
    ...
    ...    Request Method: GET / PUT
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
