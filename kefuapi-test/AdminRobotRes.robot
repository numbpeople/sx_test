*** Variables ***
&{RobotRulesEntity}    page=1    per_page=5    q=

*** Keywords ***
/v1/Tenants/me/robot/rules
    [Arguments]    ${session}    ${timeout}    ${RobotRulesEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rules?page=${RobotRulesEntity.page}&per_page=${RobotRulesEntity.per_page}&q=${RobotRulesEntity.q}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
