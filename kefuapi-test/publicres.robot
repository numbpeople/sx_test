*** Variables ***
${kefusession}    ${EMPTY}
${restsession}    ${EMPTY}
&{AgentEntity}    userId=29a68433-f95e-48bd-97e4-1ae53f68a462    nicename=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    username=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    roles=admin,agent    onLineState=Online    maxServiceSessionCount=10
&{FilterEntity}    page=1    per_page=15    originType=${EMPTY}    beginDate=    endDate=    state=Terminal,Abort    isAgent=${True}
...               techChannelId=    visitorName=    summaryIds=    sortOrder=desc    techChannelType=
&{StatisticFilterEntity}    page=1    per_page=15    originType=${EMPTY}    beginDateTime=    endDateTime=    dateInterval=1d
&{orgEntity}      organName=${empty}    organId=${empty}

*** Keywords ***
/users/{agentId}/feed/info
    [Arguments]    ${session}    ${timeout}    ${AgentEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /users/${AgentEntity.userId}/feed/info
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
