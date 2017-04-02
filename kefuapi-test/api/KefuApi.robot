*** Settings ***
Library           uuid

*** Keywords ***
get token by credentials
    [Arguments]    ${session}    ${channel}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    #${postdata}=    Create Dictionary    grant_type=client_credentials    client_id=${client_id}    client_secret=${client_secret}
    ${postdata}=    set variable    {"grant_type": "client_credentials","client_id": "${channel['clientId']}","client_secret": "${channel['clientSecret']}"}
    ${str}=    Replace String    ${channel['appKey']}    \#    \/
    ${uri}=    set variable    /${str}/token
    ${data}    Post Request    ${session}    ${uri}    data=${postdata}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

get token by password
    [Arguments]    ${session}    ${appkey}    ${username}    ${password}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    #${postdata}=    Create Dictionary    grant_type=password    username=${username}    password=${password}
    ${postdata}=    set variable    {"grant_type": "password","username": "${username}","password": "${password}"}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/token
    ${data}    Post Request    ${session}    ${uri}    data=${postdata}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

send msg
    [Arguments]    ${rest}    ${guest}    ${msg}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${rest.token}
    #${lengext}=    Get Length    ${ext}
    #${strext}=    set variable if    ${lengext}==0    ${ext}    ${lengext}>0    "${ext}"
    ${postdata}    set variable    {"target_type":"users","target":["${rest.serviceEaseMobIMNumber}"],"msg":{"type":"${msg.type}","msg":"${msg.msg}"},"from":"${guest.userName}","ext":${msg.ext}}
    #${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${rest.orgName}/${rest.appName}/messages
    ${data}    Post Request    ${rest.session}    ${uri}    data=${postdata}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

GetChannel
    [Arguments]    ${session}    ${appkey}    ${token}    ${target}    ${users}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/users/${users}/tenantApi/imchanel?imNumber=${target}
    ${data}    Get request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

/login
    [Arguments]    ${session}    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${agent.username}&password=${agent.password}&status=${agent.status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Post Request    ${session}    ${uri}    params=${params}    headers=${header}    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Stop
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages
    [Arguments]    ${agent}    ${visitorId}    ${serviceSessionId}    ${Msg}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors/${visitorId}/ServiceSessions/${serviceSessionId}/Messages
    ${postdata}    set variable    {"type":"${Msg.type}","msg":"${Msg.msg}","ext":${Msg.ext}}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${postdata}    timeout=${timeout}

/v1/tenantapp/imUser
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenantapp/imUser
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me/UnReadTags/Count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/agents/${agent.userId}/checkisnewuser
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/webimplugin/targetChannels
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/targetChannels
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/showMessage
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/showMessage
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/visitors/password
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/password
    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel
    [Arguments]    ${agent}    ${type}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel
    ${params}=    set variable    type=${type}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/me/Agents/me/customInfoParam
    [Arguments]    ${agent}    ${visitorId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/customInfoParam
    ${params}=    set variable    visitorId=${visitorId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/welcome
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/welcome
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Agents/{AdminUserId}/Agents
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/${agent.userId}/Agents
    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
    ...    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/channels
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /channels
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/logout
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /logout
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/webimplugin/agentnicename/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/agentnicename/options
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Admin/Agents
    [Arguments]    ${method}    ${agent}    ${AgentFilterEntity}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents
    ${params}    set variable    page=${AgentFilterEntity.page}&size=${AgentFilterEntity.size}&keyValue=${AgentFilterEntity.keyValue}&orderBy=${AgentFilterEntity.orderBy}&orderMethod=${AgentFilterEntity.orderMethod}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/Admin/Agents/{userId}
    [Arguments]    ${agent}    ${userId}    ${timeout}
    log    ${AgentUser1.userId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents/${userId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/AgentQueue
    [Arguments]    ${method}    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/AgentQueue
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/AgentQueue/{queueId}
    [Arguments]    ${agent}    ${queueId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/AgentQueue/${queueId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/AgentQueue/{queueId}/AgentUser
    [Arguments]    ${agent}    ${queueId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/AgentQueue/${queueId}/AgentUser
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Admin/TechChannel/EaseMobTechChannel
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/phone-tech-channel
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/phone-tech-channel
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/CurrentServiceSessionCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/today/processing
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/today/processing
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/Statistics/CurrentOnlineAgentCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/agent/online
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/agent/online
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/statistics/tenant/{tenantId}/message/today/total
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/statistics/tenant/${agent.tenantId}/message/today/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/EveryDayNewServiceSessionCountCurrentMonthList
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/EveryDayNewServiceSessionCountCurrentMonthList
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/{tenantId}/ChatMessage/Statistics/CurrentMonthMessageCountByDayList
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/${agent.tenantId}/ChatMessage/Statistics/CurrentMonthMessageCountByDayList
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/session/today
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/agent/session/today
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}&tenantId=${agent.tenantId}
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/statistics/tenant/{tenantId}/message/trend
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&dateInterval=${FilterEntity.dateInterval}&tenantId=${agent.tenantId}
    ${uri}=    set variable    /v1/statistics/tenant/${agent.tenantId}/message/trend
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/me/robot/rule/group/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rule/group/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/robot/menu/items
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/menu/items
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}&q=${RobotFilter.q}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/menu/items
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/menu/items
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}&q=${RobotFilter.q}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/intent/list
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/intent/list
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/robot/rules
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rules
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}&q=${RobotFilter.q}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/rules
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/rules
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}&q=${RobotFilter.q}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/rule/group/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/rule/group/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/robot/rule/items/template
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rule/items/template
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/rule/items/template
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/rule/items/template
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/media/items
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/media/items
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/status/dist
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/agent/status/dist
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/agent/status/dist
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/agent/status/dist
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/agent/load
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/agent/load
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/wait/count
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/wait/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/wait/count
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/wait/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/session/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/session/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/session/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/visitor/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/visitor/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/visitor/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/quality/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/quality/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/quality/total
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/quality/total
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/session/start/top
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/session/start/top?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/session/start
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/top/session/start?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/first/response/top
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/first/response/top?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/first/response
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/top/first/response?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/monitor/visitor/mark/top
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/monitor/visitor/mark/top?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/top/visitor/mark
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/top/visitor/mark?top=${top}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/session/start
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/session/start?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/first/response
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/first/response?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/visitor/mark
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/visitor/mark?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/monitor/list/response/time
    [Arguments]    ${agent}    ${orgEntity}    ${top}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/monitor/list/response/time?top=${top}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/Configuration
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Configuration
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/qualityreviews
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/qualityreviews
    ${params}=    set variable    page=${FilterEntity.page}&pagesize=${FilterEntity.per_page}&beginDateTime=${DateRange.beginDate}&endDateTime=${DateRange.endDate}&firstResponseTime=${FilterEntity.firstResponseTime}&sessionTime=${FilterEntity.sessionTime}&avgResponseTime=${FilterEntity.avgResponseTime}&visitorMark=${FilterEntity.visitorMark}&originType=${FilterEntity.originType}&sessionTag=${FilterEntity.sessionTag}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/detail/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/agent/detail/trend
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/total
    ${params}=    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/file
    ${params}=    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/hour
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/hour
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/hour
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/hour
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/wait/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/wait/trend
    ${params}    set variable    originType=${FilterEntity.originType}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&waitTime=${FilterEntity.waitTime}&visitorTag=${FilterEntity.visitorTag}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/me/robot/profile/setting
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/profile/setting
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/setting
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/setting
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/settings
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/settings
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/predefinedReplys
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/predefinedReplys
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}&type=${RobotFilter.type}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/greetings
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/greetings
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/robotUserTransferKf
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/robotUserTransferKf
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/robot/profile/personalInfo
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/profile/personalInfo
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/personalInfo
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/personalInfo?_=111
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/personalInfos
    [Arguments]    ${agent}    ${RobotFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/personalInfos
    ${params}    set variable    page=${RobotFilter.page}&per_page=${RobotFilter.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/userChannelSwitches
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/userChannelSwitches
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/userChannelSwitches/{channel}
    [Arguments]    ${agent}    ${channel}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/userChannelSwitches/${channel}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/freechat
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/freechat
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/searchrecords
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/searchrecords
    ${params}    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessioncurrents
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessioncurrents
    ${params}    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&state=${FilterEntity.state}&isAgent=${FilterEntity.isAgent}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&sortOrder=${FilterEntity.sortOrder}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}&visitorName=${FilterEntity.visitorName}&agentName=${AgentEntity.username}&userTagIds=${FilterEntity.userTagIds}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Admin/UserTags
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/UserTags
    ${params}    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/total
    [Arguments]    ${agent}    ${orgEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/total
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/count
    ${params}    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&total_entries=${FilterEntity.total_entries}&order=${FilterEntity.sortOrder}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/count/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/count/file
    ${params}    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&queryType=${FilterEntity.queryType}&order=${FilterEntity.sortOrder}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/visitor/trend
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/visitor/trend
    ${params}    set variable    queryType=${FilterEntity.queryType}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/integration/tenants/{tenantId}/userinfo
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/integration/tenants/${agent.tenantId}/userinfo
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/integration/tenants/{tenantId}/dashboard
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/integration/tenants/${agent.tenantId}/dashboard
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/weixin/admin/preauthcode
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/weixin/admin/preauthcode
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/webimplugin/theme/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/theme/options
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/notice/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/notice/options
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workLoad/agent
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&total_entries=${FilterEntity.total_entries}&order=${FilterEntity.sortOrder}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wl
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/agent/wl
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&total_entries=${FilterEntity.total_entries}&order=${FilterEntity.sortOrder}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/agent/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workLoad/agent/file
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&order=${FilterEntity.sortOrder}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/file/orgs/{organId}/tenants/{tenantId}/wl
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/file/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/wl
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&agentUserId=${agent.userId}&objectType=${FilterEntity.objectType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workLoad/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workLoad/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wl/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/wl/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/trend/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/trend/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/trend/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/trend/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTag
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/sessionTag
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/tag
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/session/tag
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/messageCount
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/messageCount
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/message/count
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/message/count
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/session/time
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/session/time
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}


/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/sessionTime
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/sessionTime
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/kpi/agent/wq
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/kpi/agent/wq
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.sortOrder}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/serve/agent
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/serve/agent
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&total_pages=${FilterEntity.total_pages}&totalElements=${FilterEntity.total_entries}&order=${FilterEntity.sortOrder}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&agentId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workQuality/agent
    ${params}=    set variable    page=${FilterEntity.page}&pageSize=${FilterEntity.per_page}&order=${FilterEntity.sortOrder}&beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/agent/file
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workQuality/agent/file
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&AdminUserId=${agent.userId}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}&order=${FilterEntity.sortOrder}&asc=${FilterEntity.asc}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/workQuality/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/workQuality/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/wq/total
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/wq/total
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/visitorMark
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/visitorMark
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/vm
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/vm
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/qualityMark
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/qualityMark
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/qm
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/qm
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/effective
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/effective
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/effective
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/effective
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/firstResTime
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/firstResTime
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/first
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/response/first
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/statistics/internal/session/dist/avgResTime
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/statistics/internal/session/dist/avgResTime
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&AdminUserId=${agent.userId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/statistics/internal/orgs/{organId}/tenants/{tenantId}/session/dist/response/avg
    [Arguments]    ${agent}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /statistics/internal/orgs/${orgEntity.organId}/tenants/${agent.tenantId}/session/dist/response/avg
    ${params}=    set variable    beginDateTime=${DateRange.beginDateTime}&endDateTime=${DateRange.endDateTime}&channelId=${FilterEntity.channelId}&sessionTag=${FilterEntity.sessionTag}&sessionType=${FilterEntity.sessionType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/agents/${agent.userId}/callcenter-attrs
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v2/infos
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v2/infos
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/recommendationSwitch
    [Arguments]    ${agent}    ${switchType}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/recommendationSwitch
    ${params}=    set variable    switchType=${switchType}&switchId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/recommendation/status
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/recommendation/status
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/organs/{organName}/tenants/{tenantId}/commonphrases
    [Arguments]    ${agent}    ${orgEntity}    ${timeout}    ${systemOnly}=${False}    ${buildChildren}=${True}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/organs/${orgEntity.organName}/tenants/${agent.tenantId}/commonphrases
    ${params}=    set variable    systemOnly=${systemOnly}&buildChildren=${buildChildren}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessions}/attributes
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/servicesessions/${serviceSessionId}/attributes?names=ip%2Cregion%2CuserAgent%2Creferer
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/integration/tenants/{tenantId}/servicesessions/{serviceSessions}/tracks
    [Arguments]    ${agent}    ${serviceSessionId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/integration/tenants/${agent.tenantId}/servicesessions/${serviceSessionId} /tracks
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Agents/me
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/home/initdata
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /home/initdata
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/options
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Agents/{agentId}
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/${agent.userId}
    ${data}=    set variable    {"maxServiceUserNumber":"${agent.maxServiceSessionCount}","status":"${agent.status}","userId":"${agent.userId}"}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Agents/me/Visitors
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/me/Visitors
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/visitors/{visitorUserId}
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/visitors/${visitorUserId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/visitorusers
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/visitorusers
    ${params}    set variable    page=${FilterEntity.page}&size=${FilterEntity.per_page}&userTagIds=${FilterEntity.userTagIds}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&enquirySummary=${FilterEntity.enquirySummary}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/VisitorUsers/{visitorUserId}
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenant/me/ChatGroup/{ChatGroupId}/Messages
    [Arguments]    ${agent}    ${ChatGroupId}    ${MsgFilter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ChatGroup/${ChatGroupId}/Messages
    ${params}    set variable    fromSeqId=${MsgFilter.fromSeqId}&size=${MsgFilter.size}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/SessionServices/{sessionId}/Messages
    [Arguments]    ${agent}    ${guest}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/SessionServices/${guest.sessionServiceId}/Messages
    ${params}    set variable    lastSeqId=${guest.sessionServiceSeqId}&startSessionTimestamp=${guest.startSessionTimestamp}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/
    [Arguments]    ${agent}    ${visitorUserId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree
    [Arguments]    ${agent}    ${summaryId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/ServiceSessionSummaries/${summaryId}/tree
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/crm/tenants/{tenantId}/agents/{agentId}/visitors
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/agents/${agent.userId}/visitors
    ${params}=    set variable    page=${FilterEntity.page}&size=${FilterEntity.per_page}&userTagIds=${FilterEntity.userTagIds}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&enquirySummary=${FilterEntity.enquirySummary}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/crm/tenants/{tenantId}/customers
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/crm/tenants/${agent.tenantId}/customers
    ${params}=    set variable    page=${FilterEntity.page}&size=${FilterEntity.per_page}&userTagIds=${FilterEntity.userTagIds}&categoryId=${FilterEntity.categoryId}&subCategoryId=${FilterEntity.subCategoryId}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&enquirySummary=${FilterEntity.enquirySummary}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/tenants/{tenantId}/projects
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/projects
    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}&userRoles=${agent.roles}&page=${FilterEntity.page}&per_page=${FilterEntity.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues
    ${params}=    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&originType=${FilterEntity.originType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/search
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues/search
    ${params}=    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&originType=${FilterEntity.originType}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}&techChannelId=${FilterEntity.techChannelId}&techChannelType=${FilterEntity.techChannelType}&visitorName=${FilterEntity.visitorName}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/agents/{agentId}/queues
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/agents/${agent.userId}/queues
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/queues/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/queues?page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&originType=${FilterEntity.originType}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort
    [Arguments]    ${agent}    ${waitingId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/queues/waitqueue/waitings/${waitingId}/abort
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/autoCreateImAssosciation
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/autoCreateImAssosciation
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/{waitingId}
    [Arguments]    ${agent}    ${waitingId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Agents/me/UserWaitQueues/${waitingId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/EaseMobTechChannel/{channelId}
    [Arguments]    ${agent}    ${channelId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel/${channelId}
    Run Keyword And Return    Delete Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/queues/waitings/abort forbidden
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${tenantId}/queues/waitings/abort
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/serviceSessionHistoryFiles
    [Arguments]    ${agent}    ${FilterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/serviceSessionHistoryFiles
    ${params}=    set variable    AdminUserId=${agent.userId}&page=${FilterEntity.page}&size=${FilterEntity.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenant/me/ServiceSessionHistorys
    [Arguments]    ${agent}    ${FilterEntity}    ${DateRange}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSessionHistorys
    ${params}=    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&state=${FilterEntity.state}&isAgent=${FilterEntity.isAgent}&originType=${FilterEntity.originType}&techChannelId=${FilterEntity.techChannelId}&techChannelType=${FilterEntity.techChannelType}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&sortOrder=${FilterEntity.sortOrder}&beginDate=${DateRange.beginDate}&endDate=${DateRange.endDate}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/users/{agentId}/activities
    [Arguments]    ${agent}    ${FilterEntity}    ${MsgCenterEntity}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSessionHistorys
    ${params}=    set variable    page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&total_pages=${MsgCenterEntity.total_pages}&total_entries=${MsgCenterEntity.total_entries}&status=${MsgCenterEntity.status}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/users/{agentId}/feed/info
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /users/${agent.userId}/feed/info
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/agents/{agentId}/news/latest
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/agents/${agent.userId}/news/latest
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/options/userSpecifiedQueueId
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /tenants/${agent.tenantId}/options/userSpecifiedQueueId
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/Tenants/{tenantId}/Agents/{agentId}/PreSchedule/Ack?answer=true
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /Tenants/${agent.tenantId}/Agents/${agent.userId}/PreSchedule/Ack?answer=true
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

Should Be Not Contain In JsonList
    [Arguments]    ${keyname}    ${diffvalue}    @{list}
    ${l}    Get Length    ${list}
    Return From Keyword If    ${l}==0    ${true}
    : FOR    ${a}    IN    @{list}
    \    Exit For Loop If    '${a${keyname}}'=='${diffvalue}'
    Return From Keyword If    '${a${keyname}}'=='${diffvalue}'    ${false}
    Return From Keyword If    '${a${keyname}}'!='${diffvalue}'    ${true}

Return QueueName From QueueList By QueueId
    [Arguments]    ${queueId}    @{list}
    log    ${queueId}__${list}
    : FOR    ${a}    IN    @{list}
    \    log    ${a}—@{list}
    \    Exit For Loop If    '${a['agentQueue']['queueId']}'=='${queueId}'
    Return From Keyword    ${a['agentQueue']['queueName']}

Return QueueId From QueueList By QueueName
    [Arguments]    ${queueName}    @{list}
    log    ${queueName}__${list}
    : FOR    ${a}    IN    @{list}
    \    log    ${a}—@{list}
    \    Exit For Loop If    '${a['agentQueue']['queueName']}'=='${queueName}'
    Return From Keyword    ${a['agentQueue']['queueId']}

Create Agent TxtMsg
    [Arguments]    ${msg}
    ${uuid}=    Uuid1
    Return From Keyword    {"msg":"${msg}","type":"txt","ext":{"weichat":{"msgId":"${uuid}","originType":null,"visitor":null,"agent":null,"queueId":null,"queueName":null,"agentUsername":null,"ctrlType":null,"ctrlArgs":null,"event":null,"metadata":null,"callcenter":null,"language":null,"service_session":null,"html_safe_body":{"type":"txt","msg":""},"msg_id_for_ack":null,"ack_for_msg_id":null}}}

/v1/infos
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/infos
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}
