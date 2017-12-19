*** Variables ***

*** Keywords ***
/login
    [Arguments]    ${session}    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${agent.username}&password=${agent.password}&status=${agent.status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Post Request    ${session}    ${uri}    params=${params}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/integration/tickets
    [Arguments]    ${method}    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/integration/tickets
    ${rs}=    Run Keyword If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

Agent Login
    #接口登录并打开浏览器
    Create Session    cisession    ${kefuurl}
    #登录
    ${resp}=    /login    cisession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=cisession

Check Results And Send Reports
    [Arguments]    ${results}
    ${l}    get length    ${results.reportmsg}
    Run Keyword If    ${l}>1    SendMail    ${results.api},${results.reportmsg}

SendMail
    [Arguments]    ${msg}
    ${to_list}    create list    jiaqin@easemob.com
    ${s}    Encode String To Bytes    ${msg}    UTF-8
    Comment    Send Sms    101    test    test    102
    Send Report Mail    ${s}    ${s}    ${to_list}

/v1/tenants/{tenantId}/integration/tickets/{ticketId}
    [Arguments]    ${agent}    ${data}    ${timeout}    ${method}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/integration/tickets/8
    ${rs}=    Run Keyword If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/v1/tenants/{tenantId}/integration/tickets/{ticketId}/reply
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/integration/tickets/6f5ff50c-2153-4704-b4e4-0df6a204bba6/reply
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}    data=${data}

/v1/tenants/{tenantId}/integration/tickets/{ticketId}/threads
    [Arguments]    ${agent}    ${timeout}    ${method}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/integration/tickets/6f5ff50c-2153-4704-b4e4-0df6a204bba6
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/integration/filters/submissions
    [Arguments]    ${agent}    ${timeout}    ${method}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/integration/filters/submissions
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v2/tenants/{tenantId}/integration/tickets
    [Arguments]    ${agent}    ${timeout}    ${method}    ${data}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/tenants/${agent.tenantId}/integration/tickets
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}    data=${data}
