*** Settings ***
Suite Setup       Agent Login
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          AgentRes.robot
Resource          api/TicketsApi.robot
Library           uuid
Library           jsonschema
Library           SendReport

*** Test Cases ***
>坐席获取工单(/v1/tenants/{tenantId}/integration/tickets)
    &{r}    create dictionary    api=/v1/tenants/{tenantId}/integration/tickets    reportmsg=request timeout
    ${resp}=    /v1/tenants/{tenantId}/integration/tickets    get    ${AdminUser}    ${empty}    ${timeout}
    Run Keyword IF    ${resp.status_code}==200    set to dictionary    ${r}    reportmsg=${empty}
    ...    ELSE    set to dictionary    ${r}    reportmsg=不正确的状态码:${resp.status_code};
    ${j}    to json    ${resp.content}
    Run Keyword Unless    '${j["status"]}'=='OK'    set to dictionary    ${r}    reportmsg=${r.reportmsg}返回值不正确=${j};
    ${l}    get length    ${r.reportmsg}
    Should be true    ${l}==0    ${r.reportmsg}
    [Teardown]    Check Results And Send Reports    ${r}

>更新工单(/v1/tenants/{tenantId}/integration/tickets/{ticketId})
    &{r}    create dictionary    api=/v1/tenants/{tenantId}/integration/tickets/{ticketId}    reportmsg=request timeout
    ${resp}=    /v1/tenants/{tenantId}/integration/tickets/{ticketId}    ${AdminUser}    {"message":"note"}    ${timeout}    put
    Run Keyword IF    ${resp.status_code}==200    set to dictionary    ${r}    reportmsg=${empty}
    ...    ELSE    set to dictionary    ${r}    reportmsg=不正确的状态码:${resp.status_code};
    ${j}    to json    ${resp.content}
    Run Keyword Unless    '${j["status"]}'=='OK'    set to dictionary    ${r}    reportmsg=${r.reportmsg}返回值不正确=${j};
    ${l}    get length    ${r.reportmsg}
    Should be true    ${l}==0    ${r.reportmsg}
    [Teardown]    Check Results And Send Reports    ${r}

>工单回复(/v1/tenants/{tenantId}/integration/tickets/{ticketId}/reply)
    &{r}    create dictionary    api=/v1/tenants/{tenantId}/integration/tickets/{ticketId}    reportmsg=request timeout
    ${resp}=    /v1/tenants/{tenantId}/integration/tickets/{ticketId}/reply    ${AdminUser}    ${timeout}    post    {"type":"note"}
    Run Keyword IF    ${resp.status_code}==200    set to dictionary    ${r}    reportmsg=${empty}
    ...    ELSE    set to dictionary    ${r}    reportmsg=不正确的状态码:${resp.status_code};
    ${j}    to json    ${resp.content}
    Run Keyword Unless    '${j["status"]}'=='OK'    set to dictionary    ${r}    reportmsg=${r.reportmsg}返回值不正确=${j};
    ${l}    get length    ${r.reportmsg}
    Should be true    ${l}==0    ${r.reportmsg}
    [Teardown]    Check Results And Send Reports    ${r}

>获取工单处理详情列表(/v1/tenants/{tenantId}/integration/tickets/{ticketId}/threads)
    &{r}    create dictionary    api=/v1/tenants/{tenantId}/integration/tickets/{ticketId}/threads    reportmsg=request timeout
    ${resp}=    /v1/tenants/{tenantId}/integration/tickets/{ticketId}/threads    ${AdminUser}    ${timeout}    get
    Run Keyword IF    ${resp.status_code}==200    set to dictionary    ${r}    reportmsg=${empty}
    ...    ELSE    set to dictionary    ${r}    reportmsg=不正确的状态码:${resp.status_code};
    ${j}    to json    ${resp.content}
    Run Keyword Unless    '${j["status"]}'=='OK'    set to dictionary    ${r}    reportmsg=${r.reportmsg}返回值不正确=${j};
    ${l}    get length    ${r.reportmsg}
    Should be true    ${l}==0    ${r.reportmsg}
    [Teardown]    Check Results And Send Reports    ${r}

>获取提交工单默认筛选器(/v1/tenants/{tenantId}/integration/filters/submissions)
    &{r}    create dictionary    api=/v1/tenants/{tenantId}/integration/filters/submissions    reportmsg=request timeout
    ${resp}=    /v1/tenants/{tenantId}/integration/filters/submissions    ${AdminUser}    ${timeout}    get
    Run Keyword IF    ${resp.status_code}==200    set to dictionary    ${r}    reportmsg=${empty}
    ...    ELSE    set to dictionary    ${r}    reportmsg=不正确的状态码:${resp.status_code};
    ${j}    to json    ${resp.content}
    Run Keyword Unless    '${j["status"]}'=='OK'    set to dictionary    ${r}    reportmsg=${r.reportmsg}返回值不正确=${j};
    ${l}    get length    ${r.reportmsg}
    Should be true    ${l}==0    ${r.reportmsg}
    [Teardown]    Check Results And Send Reports    ${r}

>创建工单(/v2/tenants/{tenantId}/integration/tickets)
    &{r}    create dictionary    api=/v2/tenants/{tenantId}/integration/tickets    reportmsg=request timeout
    ${resp}=    /v2/tenants/{tenantId}/integration/tickets    ${AdminUser}    ${timeout}    post    {"team_id":0,"content":"3333","priority_id":"222199b6-b89d-4b39-b65a-8946740a52d6","staff_id":"","title":"3333","attachments":[],"help_topic_id":""}
    Run Keyword IF    ${resp.status_code}==200    set to dictionary    ${r}    reportmsg=${empty}
    ...    ELSE    set to dictionary    ${r}    reportmsg=不正确的状态码:${resp.status_code};
    ${j}    to json    ${resp.content}
    Run Keyword Unless    '${j["status"]}'=='OK'    set to dictionary    ${r}    reportmsg=${r.reportmsg}返回值不正确=${j};
    ${l}    get length    ${r.reportmsg}
    Should be true    ${l}==0    ${r.reportmsg}
    [Teardown]    Check Results And Send Reports    ${r}
