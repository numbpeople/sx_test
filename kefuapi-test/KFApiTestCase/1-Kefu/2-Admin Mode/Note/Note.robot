*** Settings ***
Force Tags        note    adminNote
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户的project数据，调用接口：/tenants/{tenantId}/projects，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、tenant_id字段值等于租户id。
    ${j}    Get Project    ${AdminUser}
    Should Be Equal    ${j['entities'][0]['tenant_id']}    ${AdminUser['tenantId']}    获取租户ID不正确：${j}

获取status数据(/tenants/{tenantId}/projects/{projectId}/status)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户留言的状态数据，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、tenant_id字段值等于租户id、project_id字段值等于留言项目id。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户留言的状态数据，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、获取未处理留言count数，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets/count，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Open}
    ${j}    Get Tickets Counts    ${AdminUser}    ${projectId}    ${statusId}
    # Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取处理中留言count数(/tenants/{tenantId}/projects/{projectId}/tickets/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户留言的状态数据，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、获取处理中留言count数，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets/count，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Pending}
    ${j}    Get Tickets Counts    ${AdminUser}    ${projectId}    ${statusId}
    # Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取已解决留言count数(/tenants/{tenantId}/projects/{projectId}/tickets/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户留言的状态数据，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、获取已解决留言count数，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets/count，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    &{statusDic}    Get StatusIds    ${AdminUser}
    ${statusId}    set variable    ${statusDic.Solved}
    ${j}    Get Tickets Counts    ${AdminUser}    ${projectId}    ${statusId}
    # Should Be True    ${j} >= 0    返回值中不是数字:${j}

获取全部留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step2、获取全部留言，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，最多循环10次查询留言数据，所有数据包含该新留言数据。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step2、获取全部留言，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，最多循环10次查询留言数据，所有数据包含该新留言数据。
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

获取comments数据(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step2、获取未处理状态id，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step3、添加留言的评论，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments，接口请求状态码为200。
    ...    - Step4、获取留言的评论，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，评论的内容和id等于预期值。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取留言分类数据，调用接口：/tenants/{tenantId}/projects/{projectId}/categories，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #获取分类数据
    ${j}    Get Categories    ${AdminUser}

分配留言给其他坐席(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/{assigneeId})
    [Documentation]    【操作步骤】：
    ...    - Step1、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step2、分配留言给其他坐席，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/{assigneeId}，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，分配的id等于坐席的Id值。
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #分配留言给其他坐席
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    ticketId=${ticketId}
    ${j}    Assign Ticket    ${AdminUser}    ${filter}    ${AdminUser.userId}
    Should Be equal    ${j['assignee']['id']}    ${AdminUser.userId}    分配的坐席Id值不正确:${j}

分配留言给自己(/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/take)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step2、分配留言给自己，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/take，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，分配的id等于坐席的Id值。
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${AdminUser}
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #分配留言给自己
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    ticketId=${ticketId}
    ${j}    Take Ticket    ${AdminUser}    ${filter}
    Should Be equal    ${j['assignee']['id']}    ${AdminUser.userId}    分配的坐席Id值不正确:${j}

获取未分配留言(/tenants/{tenantId}/projects/{projectId}/tickets)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step2、获取全部留言中刚创建的留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，留言数据在未分配留言中。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取未分配状态id，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、获取未处理留言中刚创建的留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，留言数据在未处理留言中。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取已解决状态id，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、获取已解决留言中刚创建的留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，留言数据在已解决留言中。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取处理中状态id，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、获取处理中留言中刚创建的留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，留言数据在处理中留言中。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取处理中状态id，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、以访客身份创建留言（创建新的访客->获取im号的token操作），调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、获取处理中留言中刚创建的留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，留言数据在处理中留言中。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、下载留言文件，调用接口：/v1/tenants/{tenantId}/projects/{projectId}/tickets/file，接口请求状态码为204。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为204。
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}
    #导出留言
    ${resp}=    Export Tickets File    ${AdminUser}    ${filter}

下载指定留言id文件(/v1/tenants/{tenantId}/projects/{projectId}/tickets/file)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取处理中状态id，调用接口：/tenants/{tenantId}/projects/{projectId}/status，接口请求状态码为200。
    ...    - Step2、创建一条留言数据，调用接口：/tenants/{tenantId}/projects/{projectId}/tickets，接口请求状态码为200。
    ...    - Step3、下载并导出指定留言文件，调用接口：/v1/tenants/{tenantId}/projects/{projectId}/tickets/file，接口请求状态码为204。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为204。
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
