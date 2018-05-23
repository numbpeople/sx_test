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
    ${resp}=    /tenants/{tenantId}/projects/{projectId}/tickets    ${method}    ${agent}    ${filter}    ${data}    ${visiorDic}    ${timeout}
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
    &{ticketEntity}=    create dictionary    subject=my-subject-${secs}    email=leoli@easemob.com    phone=18612390240    url=http://oev49clxj.bkt.clouddn.com/test1.amr    name=my-name-${secs}    type=audio
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
    [Documentation]    1、创建留言    2、导出留言
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
    