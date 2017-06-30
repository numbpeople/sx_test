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

/v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags
    [Arguments]    ${agent}    ${evaluationdegreeId}    ${timeout}
    [Documentation]    分页获取租户满意度评价标签
    ...
    ...    GET
    ...
    ...    /v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags
    ${header}=    Create Dictionary    Content-Type=application/json;
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/evaluationdegrees/${evaluationdegreeId}/appraisetags
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
    set global variable    ${evaluationdegreeId}    ${r1}

/v1/tenants/{tenantId}/sms/create-remind
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/sms/create-remind
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
