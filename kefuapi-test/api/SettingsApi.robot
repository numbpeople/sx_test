*** Keywords ***
/v1/access/config
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/access/config
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/webhook
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/webhook
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/commonphrases/exportFile
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    [Documentation]    导出公共常用语
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/commonphrases/exportFile
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&agentUserId=${agent.userId}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/evaluationdegrees
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    /v1/tenants/{tenantId}/evaluationdegrees
    ...
    ...    GET
    ...
    ...    分页获取租户满意度评价级别
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/evaluationdegrees
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

Get evaluationdegreeId
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #获取评价级别id
    log    ${j['entities'][0]['id']}
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    Append To List    ${r1}    ${r2}
    set global variable    ${degreeId}    ${r1}
    set global variable    ${evaluationdegreeId}    ${degreeId[0]}

/v1/tenants/{tenantId}/sms/create-remind
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/create-remind
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/tenants/{tenantId}/sms/reminds
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/reminds
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/sms/reminds/{id}
    [Arguments]    ${method}    ${agent}    ${remindId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/reminds/${remindId}
    ${rs}=    Run Keyword If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    ...    ELSE IF    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/v1/tenants/{tenantId}/sms/reminds/{id}/status
    [Arguments]    ${agent}    ${remindentity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/reminds/${remindentity.id}/status
    ${params}=    set variable    status=${remindentity.status}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags
    [Arguments]    ${agent}    ${timeout}    ${evaluationdegreeId}
    ${header}=    Create Dictionary    Content-Type=application/json;
    set global variable    ${evaluationdegreeId}    ${degreeId[0]}
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/evaluationdegrees/${evaluationdegreeId}/appraisetags
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/timeplans/schedules
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/weekdays
    [Arguments]    ${agent}    ${timeout}    ${scheduleId}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules/${scheduleId}/weekdays
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes
    [Arguments]    ${agent}    ${timeout}    ${scheduleId}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules/${scheduleId}/worktimes
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays
    [Arguments]    ${agent}    ${timeout}    ${scheduleId}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/timeplans/schedules/${scheduleId}/holidays
    ${params}=    set variable    _=1504607966982
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/questionnaires/accounts
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/questionnaires/accounts
    ${params}=    set variable    _=1509438791265
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/questionnaires/list
    [Arguments]    ${agent}    ${timeout}    ${type}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/questionnaires/list
    ${params}=    set variable    type=${type}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/permission/tenants/{tenantId}/roles
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/roles
    ${params}=    set variable    _=1509526060679
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/permission/tenants/{tenantId}/roles/{roleId}
    [Arguments]    ${agent}    ${timeout}    ${roleId}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/roles/${roleId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/users/${agent.userId}/resource_categories
    ${params}=    set variable    _=1509526060679
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories
    [Arguments]    ${agent}    ${timeout}    ${method}    ${roleId}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/permission/tenants/${agent.tenantId}/roles/${roleId}/resource_categories
    ${params}=    set variable    _=1509526060679
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
