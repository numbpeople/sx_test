*** Keywords ***
/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${timeout}
    [Documentation]    结束进行中会话API
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${visitorId} | 必填 | 访客id |
    ...    | ${serviceSessionId} | 必填 | 会话id |
    ...    | ${timeout} | 必填 | 接口最大调用超时时间，例如：${timeout} |
    ...
    ...    【返回值】
    ...    | 调用接口/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop后，返回true 或 false |
    ...
    ...    【调用方式】
    ...    | 获取进行中会话 | ${resp} | /v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop | ${agent} | ${visitoruserid} | ${servicesessionid} | ${timeout} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 构造请求header |
    ...    | Step 2 | 构造请求uri，例如：/v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Stop |
    ...    | Step 2 | 调用get请求 Post Request，返回请求结果 |
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Stop
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${Msg}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Messages
    ${postdata}    set variable    {"type":"${Msg.type}","msg":"${Msg.msg}"}
    run keyword if    "${Msg.type}" == "img"    set suite variable    ${postdata}    {"type":"${Msg.type}","msg":"${Msg.msg}","filename":"${Msg.filename}","imageHeight":${Msg.imageHeight},"imageWidth":${Msg.imageWidth},"mediaId":"${Msg.mediaId}","thumb":"${Msg.thumb}","url":"${Msg.url}"}
    run keyword if    "${Msg.type}" == "file"    set suite variable    ${postdata}    {"type":"${Msg.type}","msg":"${Msg.msg}","fileLength":"${Msg.fileLength}","filename":"${Msg.filename}","imageHeight":${Msg.imageHeight},"imageWidth":${Msg.imageWidth},"mediaId":"${Msg.mediaId}","thumb":"${Msg.thumb}","url":"${Msg.url}"}
    run keyword if    "${Msg.type}" == "audio"    set suite variable    ${postdata}    {"type":"${Msg.type}","fileLength":"${Msg.fileLength}","audioLength":${Msg.audioLength},"filename":"${Msg.filename}","mediaId":"${Msg.mediaId}","thumb":"${Msg.thumb}","url":"${Msg.url}"}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${postdata}    timeout=${timeout}

/v1/Tenants/me/Agents/me/UnReadTags/Count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me/customInfoParam
    [Arguments]    ${agent}    ${visitorId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/customInfoParam
    ${params}=    set variable    visitorId=${visitorId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/official-accounts
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/official-accounts
    ${params}=    set variable    _=1510727292733
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/ServiceSession/{serviceSessionId}/AgentQueue/{queueId}
    [Arguments]    ${agent}    ${serviceSessionId}    ${queueId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/ServiceSession/${serviceSessionId}/AgentQueue/${queueId}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v6/tenants/{tenantId}/servicesessions/{serviceSessionId}/transfer
    [Arguments]    ${agent}    ${serviceSessionId}    ${queueId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v6/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/transfer
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/agents/{agentUserId}/transfer
    [Arguments]    ${agent}    ${serviceSessionId}    ${agentUserId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/agents/${agentUserId}/transfer
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Tenant/me/MediaFiles
    [Arguments]    ${agent}    ${files}    ${timeout}
    ${header}=    Create Dictionary    #Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/MediaFiles
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    files=${files}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/mediafiles/amr
    [Arguments]    ${agent}    ${files}    ${timeout}
    ${header}=    Create Dictionary    #Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/mediafiles/amr
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    files=${files}
    ...    timeout=${timeout}