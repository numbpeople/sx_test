*** Variables ***
${url}            https://a1-vip5.easemob.com
${appkey}         easemob-demo#jianguo9
${client_id}      YXA6GS5loMNxEeWyjKe374xQVA
${client_secret}    YXA6iYLgfPv-wEGCsFHIbvgciRZRh4M
${from}           imguest1
${target}         Zktest5478
${txttype}        txt
${ext}            ${empty}
${token}          YWMtA1glxky2EeanC0vMidZkbQAAAVcx0ICcr1hhxJORlxtsjUGkfWg11_tEfeI
${username}       99baoyou3@qq.com
${tenantId}       8455
${password}       123456
${kefuurl}        https://chuchujie.kefu.easemob.com
${status}         online
${cookies}        ${EMPTY}
${session}        ${EMPTY}
${userId}         ${EMPTY}
@{kefustatus}     Busy    Leave    Hidden    Online
${maxServiceUserNumber}    10    # 坐席最大接待人数
${timeout}        30
${page}           1
${per_page}       15
${originType}     ${EMPTY}
${shortcutMessageGroupId}    ${EMPTY}
${shortcutMessageGroupName}    ${EMPTY}
${groupType}      System
@{shortcutMessages}
@{userTagIds}
${size}           10
${beginDate}      ${EMPTY}
${endDate}        ${EMPTY}
@{visitorUserId}    6c701921-59b5-4776-b6e1-749ec8703307
@{appkeys}
&{visitorUser}    userId=29a68433-f95e-48bd-97e4-1ae53f68a462    nicename=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    username=webim-visitor-2CRVGCTG6HWGEJ7E9PGF
@{WeiboTechChannelType}    weibo    wechat

*** Keywords ***
get token by credentials
    [Arguments]    ${session}    ${appkey}    ${client_id}    ${client_secret}
    ${header}=    Create Dictionary    Content-Type=application/json
    #${postdata}=    Create Dictionary    grant_type=client_credentials    client_id=${client_id}    client_secret=${client_secret}
    ${postdata}=    set variable    {"grant_type": "client_credentials","client_id": "${client_id}","client_secret": "${client_secret}"}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/token
    ${data}    Post Request    ${session}    ${uri}    data=${postdata}    headers=${header}
    Return From Keyword    ${data}

get token by password
    [Arguments]    ${session}    ${appkey}    ${username}    ${password}
    ${header}=    Create Dictionary    Content-Type=application/json
    #${postdata}=    Create Dictionary    grant_type=password    username=${username}    password=${password}
    ${postdata}=    set variable    {"grant_type": "password","username": "${username}","password": "${password}"}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/token
    ${data}    Post Request    ${session}    ${uri}    data=${postdata}    headers=${header}
    Return From Keyword    ${data}

send msg
    [Arguments]    ${session}    ${appkey}    ${token}    ${target}    ${from}    ${type}
    ...    ${msg}    ${ext}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    #${lengext}=    Get Length    ${ext}
    #${strext}=    set variable if    ${lengext}==0    ${ext}    ${lengext}>0    "${ext}"
    ${postdata}    set variable    {"target_type":"users","target":["${target}"],"msg":{"type":"${type}","msg":"${msg}"},"from":"${from}","ext":{${ext}}}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/messages
    ${data}    Post Request    ${session}    ${uri}    data=${postdata}    headers=${header}
    Return From Keyword    ${data}

GetChannel
    [Arguments]    ${session}    ${appkey}    ${token}    ${target}    ${users}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/users/${users}/tenantApi/imchanel?imNumber=${target}
    ${data}    Get request    ${session}    ${uri}    headers=${header}
    Return From Keyword    ${data}

Create Kefu Session
    [Arguments]    ${url}
    ${rand}=    Generate Random String
    create session    ${rand}    ${url}
    Return From Keyword    ${rand}

Create Kefu Requests
    [Arguments]    ${session}    ${uri}    ${method}='get'    ${data}=${none}    ${params}=${none}    ${headers}=${none}
    ...    ${files}=${none}    ${allow_redirects}=${none}    ${timeout}=${none}
    ${resp}=    Run Keyword If    ${method}=='get'    Get Request    ${session}    ${uri}    ${headers}
    ...    ${params}    ${allow_redirects}    ${timeout}
    ...    ELSE IF    ${method}=='post'    Post Request    ${session}    ${uri}    ${data}
    ...    ${params}    ${headers}    ${files}    ${allow_redirects}    ${timeout}
    ...    ELSE IF    ${method}=='put'    Put Request    ${session}    ${uri}    ${data}
    ...    ${params}    ${files}    ${headers}    ${allow_redirects}    ${timeout}
    ...    ELSE IF    ${method}=='delete'    Delete \ Request    ${session}    ${uri}    ${data}
    ...    ${params}    ${headers}    ${allow_redirects}    ${timeout}
    Return From Keyword    ${resp}

/login
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Admin/UserTags todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/UserTags
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    headers=${header}    timeout=${timeout}

/v1/Admin/Agents todo
    [Arguments]    ${session}    ${timeout}    ${page}    ${size}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/Agents?page=${page}&size=${size}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Admin/{agentUserId} todo
    [Arguments]    ${session}    ${timeout}    ${agentUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/${agentUserId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/attributes todo
    [Arguments]    ${session}    ${timeout}    ${agentUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/attributes
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/tenants/{tenantId}/agents/{agentUserId}/checklogin unused?
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${agentUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${tenantId}/agents/${agentUserId}/checklogin/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/tenants/{tenantId}/visitors/{visitorId}/attributes todo
    [Arguments]    ${session}    ${timeout}    ${agentUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/attributes
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/logout todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/GetChannel todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /home/initdata
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Agents/me/ServiceSessions/Stop todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /home/initdata
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/Scheduler/Transfer todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId} todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Message todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Tenant/me/SessionServices/{sessionServiceId}/Messages todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Agents/me/Visitors/{visitorId}/MarkReadTag todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/{userWaitQueueId} todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Tenant/me/Agents/me/UserWaitQueues/search todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/Tenants/me/Agents/me/ShortcutMessageGroups unused
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/visitors todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/tenants/{tenantId}/visitors/{visitorUserId}/messages unused？
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/tenants/{tenantId}/servicesessions/{sessionServiceId}/messages todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/verifycodes todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/verifycodes/{codeId}/image todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/sms-verifycodes todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/tenants/{tenantId}/projects todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId} todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/take todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/file todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}

/v1/tenantapp/imUser
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenantapp/imUser
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Agents/{agentUserId}/RemoteAgentUsers/{remoteAgentUserId}/Messages todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Agents/{agentUserId}/RemoteAgentUsers/{remoteAgentUserId}//MarkReadTag todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/tenant/iframe/options todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/tenant/iframe/options/{optionId} todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/VisitorUsers/${visitorUserId}/VisitorUserTags/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/EaseMobTechChannel/{id} todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/AgentQueue/AgentUser todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/AgentQueue/AgentUser/{id} todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/AgentQueue/AgentUser/channels todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId} todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/EaseMobTechChannel
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/children todo
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${summaryId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${tenantId}/ServiceSessionSummaries/${summaryId}/tree
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me/UnReadTags/Count
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/forgotPassword todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/register todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/registerApi todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenantApi/Register todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/replaceAccount todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/resetPassword todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/UnReadTags/Count
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/targetChannels
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/targetChannels?tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/showMessage
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/showMessage?tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/visitors/password
    [Arguments]    ${session}    ${timeout}    ${tenantId}    ${userId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/password?tenantId=${tenantId}&userId=${userId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenantApi/imchannel todo
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenantapp/imUser
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel
    [Arguments]    ${session}    ${timeout}    ${type}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel?type=${type}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel/{id} todo
    [Arguments]    ${session}    ${timeout}    ${type}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel?type=${type}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me/customInfoParam
    [Arguments]    ${session}    ${timeout}    ${visitorId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/customInfoParam?visitorId=${visitorId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Visitors/
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Visitors/
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/welcome
    [Arguments]    ${session}    ${timeout}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/welcome?tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/visitors/{visitorUserId}/CurrentServiceSession todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/CurrentServiceSession?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/visitors/{visitorUserId}/ChatGroupId todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/ChatGroupId?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/visitors/msgHistory todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/ChatGroupId?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/webimplugin/visitors todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/ChatGroupId?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenatApi/update todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/ChatGroupId?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/TechChannel/PhoneTechChannel todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/ChatGroupId?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/Agents/{agentUserId}/RemoteAgentUsers/{remoteAgentUserId}/Messages/New todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/ChatGroupId?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Agents/{agentUserId}/Agents
    [Arguments]    ${session}    ${timeout}    ${agentUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Agents/${agentUserId}/Agents
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/Agents/{agentUserId}/Visitors/{visitorId}/MarkReadTag todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}    ${techChannelInfo}    ${tenantId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/${visitorUserId}/ChatGroupId?techChannelInfo=${techChannelInfo}&tenantId=${tenantId}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/{visitorUserId}/CreateServiceSession todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/helpDeskService todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/serviceSessionHistoryFiles todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/serviceSessionHistoryFiles/{id}/file todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenantApi/clear todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiries todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/me/Agents/me/ShortcutMessageGroups/{shortcutMessageGroupId} todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/tenants/{tenantId}/serviceSessions/{serviceSessionId}/comment todo
    [Arguments]    ${session}    ${timeout}    ${visitorUserId}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/${visitorUserId}/CreateServiceSession
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/channels
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /channels
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenant/me/Configuration
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/Configuration
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/v1/Tenants/me
    [Arguments]    ${session}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}

/bigdata/v1/tenants/{tenantId}/messages/ssds?msgIds={msgIds} todo
    [Arguments]    ${session}    ${username}    ${password}    ${status}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${params}    set variable    username=${username}&password=${password}&status=${status}
    ${uri}=    set variable    /login
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'post'    params=${params}    headers=${header}
    ...    timeout=${timeout}
