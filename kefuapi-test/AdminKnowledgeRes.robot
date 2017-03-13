*** Keywords ***
/v1/Tenants/me/robot/rule/group/count
    [Arguments]    ${session}    ${timeout}    ${RobotRulesEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rule/group/count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
