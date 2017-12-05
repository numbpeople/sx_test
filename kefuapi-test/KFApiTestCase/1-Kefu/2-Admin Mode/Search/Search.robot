*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Search/Search_Common.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot

*** Test Cases ***
获取搜索记录(/v1/tenants/{tenantId}/searchrecords)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    #获取搜索记录
    set to dictionary    ${filter}    page=0    per_page=20
    ${j}    Set Searchrecords    get    ${AdminUser}    ${filter}    ${EMPTY}
    ${length}    get length    ${j['entities']}
    run keyword if    ${length} == 0    Pass Execution    该坐席没有搜索记录
    Should Be Equal    ${j['status']}    OK    接口返回结果中status值不正确：${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentUserId']}    ${AdminUser.userId}    返回值中agentUserId不正确：${j}

新增并获取搜索记录(/v1/tenants/{tenantId}/searchrecords)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    #请求上报搜索记录
    ${uuid}    Uuid 4
    ${keyword}    set variable    ${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"keyword":"${keyword}"}
    ${j}    Set Searchrecords    post    ${AdminUser}    ${filter}    ${data}
    Should Be Equal    ${j['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId不正确：${j}
    Should Be Equal    ${j['agentUserId']}    ${AdminUser.userId}    返回值中agentUserId不正确：${j}
    Should Be Equal    ${j['keyword']}    ${keyword}    返回值中keyword不正确：${j}
    ${searchId}    set variable    ${j['searchId']}
    #获取搜索记录
    set to dictionary    ${filter}    page=0    per_page=50
    ${j}    Search Searchrecords    get    ${AdminUser}    ${filter}    ${searchId}
    Should Be True    '${j['searchId']}' == '${searchId}'    搜索记录返回的searchId不正确：${j}
    Should Be Equal    ${j['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId不正确：${j}
    Should Be Equal    ${j['agentUserId']}    ${AdminUser.userId}    返回值中agentUserId不正确：${j}
    Should Be Equal    ${j['keyword']}    ${keyword}    返回值中keyword不正确：${j}

获取管理员模式下会话记录(/v1/Tenant/me/ServiceSessionHistorys)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建结束的会话
    ${session}    Create Terminal Conversation
    ${msg}    set variable    ${session.msg.msg}
    #获取会话搜索记录
    set to dictionary    ${filter}    isAgent=false    message=${msg}    #isAgent为false，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['total_entries']} ==1    坐席模式搜索历史会话记录查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    坐席模式搜索历史会话记录的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    坐席模式搜索历史会话记录的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    坐席模式搜索历史会话记录的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['messageDetail']}    ${msg}    坐席模式搜索历史会话记录的messageDetail不正确：${j}

获取管理员模式下消息记录(/v1/tenants/{tenantId}/chatmessagehistorys)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    page=0
    #创建结束的会话
    ${session}    Create Terminal Conversation
    ${msg}    set variable    ${session.msg.msg}
    #获取会话搜索记录
    set to dictionary    ${filter}    isAgent=false    message=${msg}    #isAgent为false，表示管理员模式查询
    ${j}    Get Chatmessage History    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['totalElements']} ==1    坐席模式搜索历史消息记录查询到该会话不是唯一：${j}
    Should Be Equal    ${j['entities'][0]['message']}    ${msg}    坐席模式搜索历史消息记录的msg不正确：${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    坐席模式搜索历史消息记录的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['serviceSessionId']}    ${session.sessionServiceId}    坐席模式搜索历史消息记录的会话id不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    坐席模式搜索历史消息记录的originType不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    坐席模式历史会话的访客chatGroupId不正确：${j}
