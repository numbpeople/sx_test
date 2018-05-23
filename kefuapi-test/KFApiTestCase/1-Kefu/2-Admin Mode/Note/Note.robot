*** Settings ***
Force Tags        note
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Note/NoteApi.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../../commons/admin common/Note/Note_Common.robot
Resource          ../../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取project数据(/tenants/{tenantId}/projects)
    [Documentation]    获取租户的project数据
    ${j}    Get Project    ${AdminUser}
    Should Be Equal    ${j['entities'][0]['tenant_id']}    ${AdminUser['tenantId']}    获取租户ID不正确：${j}

获取status数据(/tenants/{tenantId}/projects/{projectId}/status)
    [Documentation]    获取租户的status的数据
    ${j}    Get Project Status    ${AdminUser}
    Should Be Equal    ${j['entities'][0]['tenant_id']}    ${AdminUser['tenantId']}    获取租户ID不正确：${j}
    Should Be Equal    ${j['entities'][0]['project_id']}    ${projectId}    获取ProjectID不正确：${j}
    #取出除了已解决的其他状态id列表
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    Run Keyword If    '${j['entities'][${i}]['name']}' !='已解决'    Append To List    ${r1}    ${r2}
    log    ${r1}
    set global variable    ${statusIds}    ${r1}

获取未处理留言count数(/tenants/{tenantId}/projects/{projectId}/tickets/count)
    [Documentation]    获取未处理留言count数
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Open}
    ${j}    Get Tickets Counts    ${AdminUser}    ${projectId}    ${statusId}
    # Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取处理中留言count数(/tenants/{tenantId}/projects/{projectId}/tickets/count)
    [Documentation]    获取处理中留言count数
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Pending}
    ${j}    Get Tickets Counts    ${AdminUser}    ${projectId}    ${statusId}
    # Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取已解决留言count数(/tenants/{tenantId}/projects/{projectId}/tickets/count)
    [Documentation]    获取已解决留言count数
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Solved}
    ${j}    Get Tickets Counts    ${AdminUser}    ${projectId}    ${statusId}
    # Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取全部留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    获取全部留言
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${filter}
    ${expectConstruction}    set variable    ['entities'][0]['id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${ticketId}    #该参数为获取接口某字段的预期值
    #获取全部留言中刚创建的留言数据
    ${j}    Repeat Keyword Times    Set Tickets    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中没有查到新创建的留言数据

获取留言数据(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId})
    [Documentation]    获取租户的留言的具体信息
    #发送一条留言
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}
    ${secs} =    Get Time    epoch
    &{ticketEntity}=    create dictionary    subject=my-subject-${secs}    email=leoli@easemob.com    phone=18612390240    url=https://www.baidu.com/img/bd_logo1.png    name=my-name-${secs}
    log    ${ticketEntity}
    ${data}=    set variable    {"subject":"${ticketEntity.subject}","content":"${ticketEntity.subject}","creator":{"name":"${ticketEntity.name}","avatar":"${ticketEntity.name}","email":"${ticketEntity.email}","phone":"${ticketEntity.phone}","qq":"${ticketEntity.phone}","company":"${ticketEntity.name}","description":"${ticketEntity.name}"},"attachments":[{"name":"${ticketEntity.name}","url":"${ticketEntity.url}","type":"img"}]}
    ${j}    Set Tickets    post    ${AdminUser}    ${filter}    ${data}
    #从客服获取ticket数据
    set to dictionary    ${filter}    ticketId=${j['id']}
    ${j1}    Get TicketId Data    ${AdminUser}    ${filter}
    log    ${j1}
    Should Be equal    ${j1['content']}    ${ticketEntity.subject}    内容content值不正确:${j1}
    Should Be equal    ${j1['subject']}    ${ticketEntity.subject}    主题subject值不正确:${j1}
    Should Be equal    ${j1['attachments'][0]['name']}    ${ticketEntity.name}    附件名称不正确:${j1}
    Should Be equal    ${j1['attachments'][0]['url']}    ${ticketEntity.url}    附件url不正确:${j1}

获取comments数据(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId})
    [Documentation]    获取租户的留言的comments信息
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #获取未处理状态id
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Open}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    size=1000    ticketId=${ticketId}
    ${secs} =    Get Time    epoch
    &{CommentsEntity}=    create dictionary    username=${TenantsMeAgentsMeJson['username']}    nicename=${TenantsMeAgentsMeJson['nicename']}    phone=15077778888    content=my_content_${secs}
    ${data}=    set variable    {"content":"${CommentsEntity.content}","creator":{"username":"${CommentsEntity.username}","name":"${CommentsEntity.nicename}","avatar":"","type":"AGENT","phone":"${CommentsEntity.phone}","email":"","qq":"","company":"","description":""},"attachments":[],"status_id":${statusId}}
    #添加留言的评论
    ${j}    Set Comments    post    ${AdminUser}    ${filter}    ${data}
    set to dictionary    ${CommentsEntity}    commentsId=${j['id']}
    set global variable    ${CommentsEntity}    ${CommentsEntity}
    #获取留言的评论数据
    ${j1}    Set Comments    get    ${AdminUser}    ${filter}
    Should Be equal    ${j1['entities'][0]['content']}    ${CommentsEntity.content}    内容content值不正确:${j1}
    Should Be equal    ${j1['entities'][0]['id']}    ${CommentsEntity.commentsId}    评论的id值不正确:${j1}

获取分类数据(/tenants/{tenantId}/projects/{projectId}/categories)
    [Documentation]    获取租户的categories分类数据
    ${j}    Get Categories    ${AdminUser}

分配留言给其他坐席(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/${assigneeId})
    [Documentation]    分配留言给其他坐席
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #分配留言给其他坐席
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    ticketId=${ticketId}
    ${j}    Assign Ticket    ${AdminUser}    ${filter}    ${AdminUser.userId}
    Should Be equal    ${j['assignee']['id']}    ${AdminUser.userId}    分配的坐席Id值不正确:${j}

分配留言给自己(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/${assigneeId})
    [Documentation]    分配留言给自己
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #分配留言给自己
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    ticketId=${ticketId}
    ${j}    Take Ticket    ${AdminUser}    ${filter}
    Should Be equal    ${j['assignee']['id']}    ${AdminUser.userId}    分配的坐席Id值不正确:${j}

获取未分配留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    获取未分配留言
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    assigned=0
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${filter}
    ${expectConstruction}    set variable    ['entities'][0]['id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${ticketId}    #该参数为获取接口某字段的预期值
    #获取全部留言中刚创建的留言数据
    ${j}    Repeat Keyword Times    Set Tickets    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中没有查到新创建的留言数据

获取未处理留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    获取未分配留言
    #获取未分配状态id
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Open}
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}    ${statusId}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    statusId=${statusId}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${filter}
    ${expectConstruction}    set variable    ['entities'][0]['id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${ticketId}    #该参数为获取接口某字段的预期值
    #获取全部留言中刚创建的留言数据
    ${j}    Repeat Keyword Times    Set Tickets    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中没有查到新创建的留言数据

获取已解决留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    获取已解决留言
    #获取已解决状态id
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Solved}
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}    ${statusId}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    statusId=${statusId}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${filter}
    ${expectConstruction}    set variable    ['entities'][0]['id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${ticketId}    #该参数为获取接口某字段的预期值
    #获取全部留言中刚创建的留言数据
    ${j}    Repeat Keyword Times    Set Tickets    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中没有查到新创建的留言数据

获取处理中留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    获取处理中留言
    #获取处理中状态id
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Pending}
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}    ${statusId}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    statusId=${statusId}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${filter}
    ${expectConstruction}    set variable    ['entities'][0]['id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${ticketId}    #该参数为获取接口某字段的预期值
    #获取全部留言中刚创建的留言数据
    ${j}    Repeat Keyword Times    Set Tickets    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中没有查到新创建的留言数据

以访客身份发起留言后获取处理中留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    以访客身份发起留言后获取处理中留言
    #获取处理中状态id
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Pending}
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}    ${statusId}    visitor    #和网页端页面操作一致，以访客身份提交留言
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    statusId=${statusId}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${filter}
    ${expectConstruction}    set variable    ['entities'][0]['id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${ticketId}    #该参数为获取接口某字段的预期值
    #获取全部留言中刚创建的留言数据
    ${j}    Repeat Keyword Times    Set Tickets    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中没有查到新创建的留言数据

下载留言文件(/v1/tenants/{tenantId}/projects/{projectId}/tickets/file)
    [Documentation]    下载留言文件
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}
    #导出留言
    ${resp}=    Export Tickets File    ${AdminUser}    ${filter}

下载指定留言id文件(/v1/tenants/{tenantId}/projects/{projectId}/tickets/file)
    [Documentation]    下载指定留言id文件
    #获取已解决状态id
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Pending}
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}    ${statusId}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    ticketId=${ticketId}
    #导出留言
    ${resp}=    Export Tickets File    ${AdminUser}    ${filter}
