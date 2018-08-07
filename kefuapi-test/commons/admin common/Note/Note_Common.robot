*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Note/NoteApi.robot
Resource          ../Channels/Webim_Common.robot
Resource          ../../IM_Common/IM Common.robot

*** Keywords ***
Get Project
    [Arguments]    ${agent}
    [Documentation]    获取留言Project数据
    ${resp}=    /tenants/{tenantId}/projects    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Get Project、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get ProjectId
    [Arguments]    ${agent}
    [Documentation]    获取留言ProjectId
    ${j}    Get Project    ${agent}
    Should Be Equal    ${j['entities'][0]['tenant_id']}    ${agent['tenantId']}    获取租户ID不正确：${j}
    set global variable    ${projectId}    ${j['entities'][0]['id']}

Get Project Status
    [Arguments]    ${agent}
    [Documentation]    获取租户的status的数据
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/status    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get StatusIds
    [Arguments]    ${agent}
    [Documentation]    获取租户的status中所有的code和状态id的字典
    ...    返回值为code和statusId的字典
    ...    code的key值: Open、Pending、Solved
    #获取留言的状态id
    ${j}    Get Project Status    ${agent}
    #取出code状态id字典集
    ${statusDic}    create dictionary
    : FOR    ${i}    IN    @{j['entities']}
    \    set to dictionary    ${statusDic}    ${i['code']}=${i['id']}
    return from keyword    ${statusDic}

Get Tickets Counts
    [Arguments]    ${agent}    ${projectId}    ${statusId}    ${userId}=
    [Documentation]    获取留言数
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/count    ${agent}    ${projectId}    ${statusId}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword    ${resp.text}

Set Tickets
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}=    ${visiorDic}=
    [Documentation]    获取/创建留言数据
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets    ${method}    ${agent}    ${filter}    ${data}    ${visiorDic}
    ...    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get TicketId Data
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取某个留言数据
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Create Ticket
    [Arguments]    ${agent}    ${statusId}=    ${ticketType}=agent
    [Documentation]    创建一条留言数据
    ...    参数: ${ticketType}值可为: agent、visitor
    #判断发起留言是以访客身份或者坐席身份创建
    Run Keyword And Return If    '${ticketType}'=='visitor'    Create Visitor Ticket    ${agent}    ${statusId}
    #发送一条留言
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}
    ${secs} =    Get Time    epoch
    &{ticketEntity}=    create dictionary    subject=my-subject-${secs}    email=leoli@easemob.com    phone=18612390240    url=https://www.baidu.com/img/bd_logo1.png    name=my-name-${secs}
    ${data}=    set variable    {"subject":"${ticketEntity.subject}","status_id": "${statusId}","content":"${ticketEntity.subject}","creator":{"name":"${ticketEntity.name}","avatar":"${ticketEntity.name}","email":"${ticketEntity.email}","phone":"${ticketEntity.phone}","qq":"${ticketEntity.phone}","company":"${ticketEntity.name}","description":"${ticketEntity.name}"},"attachments":[{"name":"${ticketEntity.name}","url":"${ticketEntity.url}","type":"img"}]}
    ${j}    Set Tickets    post    ${AdminUser}    ${filter}    ${data}
    set to dictionary    ${ticketEntity}    ticketId=${j['id']}
    return from keyword    ${ticketEntity}

Create Visitor Ticket
    [Arguments]    ${agent}    ${statusId}=
    [Documentation]    创建访客端的留言数据
    #创建新的访客
    ${visiorDic}    Create New Visitor    ${agent}
    #获取im号的token
    ${tokenResult}    Get IM Login Token    ${restentity}    ${visiorDic}
    ${IMToken}    set variable    ${tokenResult['access_token']}
    #发送一条留言
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    Authorization=Easemob IM ${IMToken}
    ${secs} =    Get Time    epoch
    &{ticketEntity}=    create dictionary    subject=my-subject-${secs}    email=leoli@easemob.com    phone=18612390240    url=http://oev49clxj.bkt.clouddn.com/test1.amr    name=my-name-${secs}
    ...    type=audio
    ${data}=    set variable    {"subject":"${ticketEntity.subject}","status_id": "${statusId}","content":"${ticketEntity.subject}","creator":{"name":"${ticketEntity.name}","avatar":"${ticketEntity.name}","email":"${ticketEntity.email}","phone":"${ticketEntity.phone}","qq":"${ticketEntity.phone}","company":"${ticketEntity.name}","description":"${ticketEntity.name}"},"attachments":[{"name":"${ticketEntity.name}","url":"${ticketEntity.url}","type":"${ticketEntity.type}"}]}
    ${j}    Set Tickets    post    ${AdminUser}    ${filter}    ${data}    ${visiorDic}
    set to dictionary    ${ticketEntity}    ticketId=${j['id']}
    return from keyword    ${ticketEntity}

Set Comments
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}=
    [Documentation]    获取/添加留言评论
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/comments    ${method}    ${agent}    ${filter}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get Categories
    [Arguments]    ${method}
    [Documentation]    获取分类数据
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/categories    ${method}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Assign Ticket
    [Arguments]    ${agent}    ${filter}    ${assigneeId}
    [Documentation]    将留言分配给坐席
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/assign/{assigneeId}    ${agent}    ${filter}    ${assigneeId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Take Ticket
    [Arguments]    ${agent}    ${filter}
    [Documentation]    将留言分配给自己
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets/{ticketId}/take    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Export Tickets File
    [Arguments]    ${agent}    ${filter}    ${language}=zh-CN
    [Documentation]    导出留言
    ${resp}=    /v1/tenants/{tenantId}/projects/{projectId}/tickets/file    ${agent}    ${filter}    ${language}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword    ${resp}

Create Ticket And Export Data
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    1、创建留言 2、导出留言
    #获取已解决状态id
    &{statusDic}    Get StatusIds    ${agent}
    ${statusId}    set variable    ${statusDic.Pending}
    #创建一条留言数据
    &{ticketResult}    Create Ticket    ${agent}    ${statusId}    visitor
    ${ticketId}    set variable    ${ticketResult.ticketId}
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${agent.tenantId}    userId=${agent.userId}    ticketId=${ticketId}
    #导出留言
    Export Tickets File    ${agent}    ${filter}    ${language}
    return from keyword    ${ticketResult}

Get Ticket With Custom Filter
    [Arguments]    ${agent}    ${visitorName}=    ${ticketId}=    ${isAll}=
    [Documentation]    根据筛选条件查询留言信息
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${visitorName} | 选填 | 发起人的昵称，例如：my-name-1532930622 |
    ...    | ${ticketId} | 选填 | 留言ID，例如：577002 |
    ...    | ${isAll} | 选填 | 返回筛选留言结果中第一条数据。默认为空，如果true，则返回全部数据 |
    ...
    ...    【返回值】
    ...    | 根据筛选条件查询后的留言数据结果，如果${isAll}为空，则返回数据中第一个元素数据，如果${isAll}不为空，则返回整个列表 |
    ...
    ...    【调用方式】
    ...    | 根据昵称获取留言信息，返回匹配的第一条数据 | ${j} | Get Ticket With VisitorName | ${AdminUser} | my-name-1532930622 |
    ...    | 根据留言ID获取留言信息，返回匹配的第一条数据 | ${j} | Get Ticket With VisitorName | ${AdminUser} | \ | 577072 |
    ...    | 根据筛选条件获取留言信息，返回匹配的所有数据 | ${j} | Get Ticket With VisitorName | ${AdminUser} | my-name-1532930622 | \ | true |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据传入参数来调用查询留言接口的函数=> Set Tickets |
    ...    | Step 2 | 针对接口返回值，判断数据总数totalElements是否为0，为0则返回[] |
    ...    | Step 3 | 如果${isAll}为空，则返回数据中第一个元素数据，如果${isAll}不为空，则返回整个列表 |
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    tenantId=${AdminUser.tenantId}    userId=${AdminUser.userId}    visitorName=${visitorName}    ticketId=${ticketId}
    #获取全部留言中刚创建的留言数据
    ${j}    Set Tickets    get    ${agent}    ${filter}
    log    ${j}
    #判断如果数据总数为0，则返回空列表
    return from keyword if    ${j['totalElements']} == 0    []
    #判断返回全部数据或第一条数据
    return from keyword if    '${isAll}' != ''    ${j['entities']}
    return from keyword    ${j['entities'][0]}

Add Comment For Ticket
    [Arguments]    ${agent}    ${ticketId}    ${content}
    [Documentation]    添加留言评论
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${ticketId} | 必填 | 留言ID，例如：2820041 |
    ...    | ${content} | 必填 | 留言评论的内容，例如：客服添加评论 |
    ...
    ...    【返回值】
    ...    | 添加留言评论请求返回结果，包括评论id |
    ...
    ...    【调用方式】
    ...    | 添加留言评论 | ${j} | Add Comment For Ticket | ${AdminUser} | 2820041 | 客服添加评论 |
    ...    | 获取评论id | ${commentId} | Set Variable | ${j['id']} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据传入参数来调用添加评论接口的函数=> Set Comments |
    ...    | Step 2 | 接口请求后，将返回值进行返回 |
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    size=1000    ticketId=${ticketId}
    &{CommentsEntity}=    create dictionary    username=${TenantsMeAgentsMeJson['username']}    nicename=${TenantsMeAgentsMeJson['nicename']}    phone=    content=${content}
    ${data}=    set variable    {"content":"${CommentsEntity.content}","creator":{"username":"${CommentsEntity.username}","name":"${CommentsEntity.nicename}","avatar":"","type":"AGENT","phone":"${CommentsEntity.phone}","email":"","qq":"","company":"","description":""},"attachments":[]}
    #添加留言的评论
    ${j}    Set Comments    post    ${AdminUser}    ${filter}    ${data}
    return from keyword    ${j}

Get Ticket Comment
    [Arguments]    ${agent}    ${ticketId}
    [Documentation]    获取留言评论
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${agent} | 必填 | 包含连接别名、tenantId、userid、roles等坐席信息，例如：${AdminUser} |
    ...    | ${ticketId} | 必填 | 留言ID，例如：2820041 |
    ...
    ...    【返回值】
    ...    | 获取留言评论内容 |
    ...
    ...    【调用方式】
    ...    | 添加留言评论 | ${j} | Get Ticket Comment | ${AdminUser} | 2820041 |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 根据传入参数来调用获取评论接口的函数=> Set Comments |
    ...    | Step 2 | 接口请求后，将返回值进行返回 |
    #创造接口请求数据
    ${filter}    copy dictionary    ${NotesEntity}
    set to dictionary    ${filter}    projectId=${projectId}    size=1000    ticketId=${ticketId}
    ${j}    Set Comments    get    ${AdminUser}    ${filter}
    return from keyword    ${j['entities']}
