*** Variables ***
&{OrgRegInfo}     phone=    codeValue=    name=    desc=    username=leoli-org081701@easemob.com    password=111111    orgName=leoli081701
&{OrgFilterEntity}    page=0    size=20    originType=${EMPTY}    state=Terminal,Abort    isAgent=${True}    techChannelId=    visitorName=
...               summaryIds=    sortOrder=desc    techChannelType=    categoryId=-1    subCategoryId=-1    userTagIds=    enquirySummary=
...               total_pages=1    total_entries=1    firstResponseTime=0    sessionTime=0    avgResponseTime=0    visitorMark=    sessionTag=all
...               asc=false    channelId=    dateInterval=1d    sessionType=S_ALL    queryType=ORIGIN    visitorTag=    waitTime=60000
...               objectType=O_AGENT    pagesize=20
&{OrgDateRange}    beginDate=    endDate=    beginDateTime=    endDateTime=    beginWeekDate=    endWeekDate=    beginWeekDateTime=
...               endWeekDateTime=    beginMonthDate=    endMonthDate=    beginMonthDateTime=    endMonthDateTime=

*** Keywords ***
/v2/orgs/{orgId}/token
    [Arguments]    ${method}    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/token
    ${data}=    Create Dictionary    username=${agent.username}    password=${agent.password}
    ${rs}=    Run Keyword If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/v2/orgs/initdata
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/initdata
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v2/orgs/{orgId}/count/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/count/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v2/orgs/{orgId}/users
    [Arguments]    ${agent}    ${OrgFilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/users
    ${params}=    set variable    page=${OrgFilterEntity.page}&size=${OrgFilterEntity.size}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v2/orgs/{orgId}/metrics
    [Arguments]    ${agent}    ${OrgFilterEntity}    ${OrgDateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/metrics
    ${params}=    set variable    sessionTag=${OrgFilterEntity.sessionTag}&sessionType=${OrgFilterEntity.sessionType}&beginDateTime=${OrgDateRange.beginDateTime}&endDateTime=${OrgDateRange.endDateTime}&page=${OrgFilterEntity.page}&size=${OrgFilterEntity.size}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v2/orgs/{orgId}/downloadmetrics
    [Arguments]    ${agent}    ${OrgFilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/downloadmetrics
    ${params}=    set variable    page=${OrgFilterEntity.page}&size=${OrgFilterEntity.size}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v2/orgs/{orgId}/tenants
    #    [Arguments]    ${agent}    ${OrgFilterEntity}    ${timeout}
    #    ${header}=    Create Dictionary    Content-Type=application/json
    #    ${uri}=    set variable    /v2/orgs/${agent.orgId}/tenants
    #    ${params}=    set variable    page=${OrgFilterEntity.page}&size=${OrgFilterEntity.size}
    #    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
    [Arguments]    ${method}    ${agent}    ${OrgFilterEntity}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/tenants
    ${params}    set variable    page=${OrgFilterEntity.page}&pagesize=${OrgFilterEntity.pagesize}&size=${OrgFilterEntity.size}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v2/orgs/{orgId}
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v2/orgs/{orgId}/template
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${agent.orgId}/template
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v2/orgs/{orgId}/tenants/{tenantId}
    [Arguments]        ${OrgAdminUser}    ${OrgUser1}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/orgs/${OrgAdminUser.orgId}/tenants/${OrgUser1.tenantId}
    Run Keyword And Return    Delete Request    ${OrgAdminUser.session}    ${uri}    headers=${header}    timeout=${timeout}
