*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        note
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/AdminMode/Note/NoteApi.robot
Resource          JsonDiff/KefuJsonDiff.robot

*** Test Cases ***
获取project数据(/tenants/{tenantId}/projects)
    [Documentation]    获取租户的project数据
    [Tags]
    ${resp}=    /tenants/{tenantId}/projects    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    set global variable    ${projectId}    ${j['entities'][0]['id']}
    log    ${j['entities'][0]['tenant_id']}
    Should Be Equal    ${j['entities'][0]['tenant_id']}    ${AdminUser['tenantId']}    获取租户ID不正确：${resp.content}

获取status数据(/tenants/{tenantId}/projects/{projectId}/status)
    [Documentation]    获取租户的status的数据
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/status    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j['entities'][0]['tenant_id']}
    Should Be Equal    ${j['entities'][0]['tenant_id']}    ${AdminUser['tenantId']}    获取租户ID不正确：${resp.content}
    Should Be Equal    ${j['entities'][0]['project_id']}    ${projectId}    获取ProjectID不正确：${resp.content}
    #取出除了已解决的其他状态id列表
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    Run Keyword If    '${j['entities'][${i}]['name']}' !='已解决'    Append To List    ${r1}    ${r2}
    log    ${r1}
    set global variable    ${statusIds}    ${r1}

获取未读count数据(/tenants/{tenantId}/projects/{projectId}/tickets/count)
    [Documentation]    获取租户坐席的未读留言数据
    Log List    ${statusIds}
    ${str}=    evaluate    ','.join(${statusIds})    string
    log    ${str}
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/count    ${AdminUser}    ${timeout}    ${str}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取ticket数据(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId})
    [Documentation]    获取租户的留言的具体信息
    #发送一条留言
    ${secs} =    Get Time    epoch
    ${ticketEntity}=    create dictionary    subject=my-subject-${secs}    email=leoli@easemob.com    phone=18612390240    url=https://www.baidu.com/img/bd_logo1.png    name=my-name-${secs}
    log    ${ticketEntity}
    ${data}=    set variable    {"subject":"${ticketEntity.subject}","content":"${ticketEntity.subject}","creator":{"name":"${ticketEntity.name}","avatar":"${ticketEntity.name}","email":"${ticketEntity.email}","phone":"${ticketEntity.phone}","qq":"${ticketEntity.phone}","company":"${ticketEntity.name}","description":"${ticketEntity.name}"},"attachments":[{"name":"${ticketEntity.name}","url":"${ticketEntity.url}","type":"img"}]}
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    log    ${j['id']}
    set to dictionary    ${ticketEntity}    ticketId=${j['id']}
    set global variable    ${ticketEntity}    ${ticketEntity}
    #从客服获取ticket数据
    ${resp1}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp1.status_code}    200    不正确的状态码:${resp1.status_code}
    ${j1}    to json    ${resp1.content}
    log    ${j1}
    Should Be equal    ${j1['content']}    ${ticketEntity.subject}    内容content值不正确:${j1}
    Should Be equal    ${j1['subject']}    ${ticketEntity.subject}    主题subject值不正确:${j1}
    Should Be equal    ${j1['attachments'][0]['name']}    ${ticketEntity.name}    附件名称不正确:${j1}
    Should Be equal    ${j1['attachments'][0]['url']}    ${ticketEntity.url}    附件url不正确:${j1}

获取comments数据(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId})
    [Documentation]    获取租户的留言的comments信息
    #发送一条comments评论
    ${secs} =    Get Time    epoch
    &{CommentsEntity}=    create dictionary    username=${TenantsMeAgentsMeJson['username']}    nicename=${TenantsMeAgentsMeJson['nicename']}    phone=15077778888    content=my_content_${secs}
    log    ${CommentsEntity}
    ${data}=    set variable    {"content":"${CommentsEntity.content}","creator":{"username":"${CommentsEntity.username}","name":"${CommentsEntity.nicename}","avatar":"","type":"AGENT","phone":"${CommentsEntity.phone}","email":"","qq":"","company":"","description":""},"attachments":[],"status_id":${statusIds[0]}}
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments    post    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    log    ${j['id']}
    set to dictionary    ${CommentsEntity}    commentsId=${j['id']}
    set global variable    ${CommentsEntity}    ${CommentsEntity}
    #从客服获取ticket数据
    ${resp1}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp1.status_code}    200    不正确的状态码:${resp1.status_code}
    ${j1}    to json    ${resp1.content}
    log    ${j1}
    Should Be equal    ${j1['entities'][0]['content']}    ${CommentsEntity.content}    内容content值不正确:${j1}
    Should Be equal    ${j1['entities'][0]['id']}    ${CommentsEntity.commentsId}    评论的id值不正确:${j1}

获取分类数据(/tenants/{tenantId}/projects/{projectId}/categories)
    [Documentation]    获取租户的categories分类数据
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/categories    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

分配留言给其他坐席(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/${assigneeId})
    [Documentation]    获取租户的留言的具体信息
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/{assigneeId}    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be equal    ${j['assignee']['id']}    ${AdminUser.userId}    分配的坐席Id值不正确:${j}

下载留言文件(/v1/tenants/{tenantId}/projects/{projectId}/tickets/file)
    [Documentation]    下载留言文件
    ${resp}=    /v1/tenants/{tenantId}/projects/{projectId}/tickets/file    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

获取全部留言(/tenants/{tenantId}/projects/{projectId}/tickets/count）
    [Documentation]    获取全部留言
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/status    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j['entities'][0]['tenant_id']}
    Should Be Equal    ${j['entities'][0]['tenant_id']}    ${AdminUser['tenantId']}    获取租户ID不正确：${resp.content}
    Should Be Equal    ${j['entities'][0]['project_id']}    ${projectId}    获取ProjectID不正确：${resp.content}
    #获取全部留言状态id列表
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    Append To List    ${r1}    ${r2}
    log    ${r1}
    set global variable    ${statusIds}    ${r1}
    log    ${statusIds[0]}
    #获取全部留言
    Log List    ${statusIds}
    ${str}=    evaluate    ','.join(${statusIds})    string
    log    ${str}
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/countall    ${AdminUser}    ${timeout}    ${str}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取未分配留言(v1/tickets/tenants/{tenantId}/projects/{projectId}/tickets/unassignee/count)
    ${resp}=    v1/tickets/tenants/{tenantId}/projects/{projectId}/tickets/unassignee/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取未处理留言(/tenants/{tenantId}/projects/{projectId}/tickets/countUnfix)
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/countUnfix    ${AdminUser}    ${timeout}    ${statusIds}    ${Empty}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取已解决留言(/tenants/{tenantId}/projects/{projectId}/tickets/countFixed)
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/countFixed    ${AdminUser}    ${timeout}    ${statusIds}    ${Empty}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取处理中留言(/tenants/{tenantId}/projects/{projectId}/tickets/countFixing)
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/countFixing    ${AdminUser}    ${timeout}    ${statusIds}    ${Empty}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be True    ${j} >= 0    返回值中不是数字:${j}
