*** Variables ***
&{MsgCenterEntity}    total_pages=1    total_entries=9    status=unread

*** Keywords ***
/users/{agentId}/activities
    [Arguments]    ${session}    ${timeout}    ${AgentEntity}    ${FilterEntity}    ${MsgCenterEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /users/{agentId}/activities?page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&total_pages=${MsgCenterEntity.total_pages}&total_entries=${MsgCenterEntity.total_entries}&status=${MsgCenterEntity.status}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
