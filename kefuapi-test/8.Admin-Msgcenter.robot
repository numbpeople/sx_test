*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        msgcenter
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/BaseApi/Notification/MsgCenterApi.robot
Resource          JsonDiff/KefuJsonDiff.robot
Library           uuid

*** Test Cases ***
获取消息中心未读消息数据(/users/{agentUserId}/activities)
    [Documentation]    获取消息中心未读消息数据
    [Tags]
    #获取未读消息，并标记
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    unread
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j['count_total']}
    log    ${j['count_unread']}
    Should Be True    ${j['count_total']} >= 1    count_total返回值不正确:${j}
    Should Be True    ${j['count_unread']} >= 1    count_unread返回值不正确:${j}
    #发送未读消息
    ${secs} =    Get Time    epoch
    ${uuid} =    Uuid 4
    ${uuid1} =    Uuid 4
    ${msgCenterEntity}=    create dictionary    actorId=${uuid}    actorName=leoli_01_${secs}    objectId=${uuid1}
    log    ${msgCenterEntity}=
    ${data}=    set variable    {"receiverIds":["${AdminUser.userId}"],"activity":{"actor":{"id":"${msgCenterEntity.actorId}","objectType":"visitor","name":"${msgCenterEntity.actorName}","avatar":"/avatars/223.jpg"},"verb":"POST","object":{"id":"${msgCenterEntity.objectId}","uri":"http://www.baidu.com","content":{"summary":"status has changed.","detail":"status has changed：customer has sent."}}}}
    ${resp}=    /v1/tenants/{tenantId}/activities    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取未读消息
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    unread
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j1}    to json    ${resp.content}
    log    ${j1['count_total']}
    log    ${j1['count_unread']}
    Should Be True    ${j['count_total']}+1 == ${j1['count_total']}    count_total返回值不正确 ,比较前后值分别为:${j['count_total']} ,${j1['count_total']}
    Should Be True    ${j['count_unread']}+1 == ${j1['count_unread']}    count_total返回值不正确 , 比较前后值分别为:${j['count_unread']} ,${j1['count_unread']}

获取消息中心未读消息数(/users/{agentUserId}/feed/info)
    [Documentation]    获取消息中心未读消息数
    [Tags]
    #获取未读消息，并标记
    ${resp}=    /users/{agentUserId}/feed/info    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j['count_total']}
    log    ${j['count_unread']}
    Should Be True    ${j['count_total']} >= 1    count_total返回值不正确:${j}
    Should Be True    ${j['count_unread']} >= 1    count_unread返回值不正确:${j}
    #发送未读消息
    ${secs} =    Get Time    epoch
    ${uuid} =    Uuid 4
    ${uuid1} =    Uuid 4
    ${msgCenterEntity}=    create dictionary    actorId=${uuid}    actorName=leoli_01_${secs}    objectId=${uuid1}
    log    ${msgCenterEntity}=
    ${data}=    set variable    {"receiverIds":["${AdminUser.userId}"],"activity":{"actor":{"id":"${msgCenterEntity.actorId}","objectType":"visitor","name":"${msgCenterEntity.actorName}","avatar":"/avatars/223.jpg"},"verb":"POST","object":{"id":"${msgCenterEntity.objectId}","uri":"http://www.baidu.com","content":{"summary":"status has changed.","detail":"status has changed：customer has sent."}}}}
    ${resp}=    /v1/tenants/{tenantId}/activities    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取未读消息
    ${resp}=    /users/{agentUserId}/feed/info    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j1}    to json    ${resp.content}
    log    ${j1['count_total']}
    log    ${j1['count_unread']}
    Should Be True    ${j['count_total']}+1 == ${j1['count_total']}    count_total返回值不正确 ,比较前后值分别为:${j['count_total']} ,${j1['count_total']}
    Should Be True    ${j['count_unread']}+1 == ${j1['count_unread']}    count_total返回值不正确 , 比较前后值分别为:${j['count_unread']} ,${j1['count_unread']}

获取消息中心已读消息数据(/users/{agentUserId}/activities)
    [Documentation]    获取消息中心已读消息数据
    [Tags]
    #获取未读消息，为了下面的遍历取activiesId
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    unread
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j['count_unread']}
    #获取已读消息，为了与最后结果作比较
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    read
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j2}    to json    ${resp.content}
    log    ${j2['count_unread']}
    Should Be True    ${j2['count_unread']} >= 0    count_unread返回值不正确:${j2}
    #取出所有的activity_id值
    ${r1}=    create list
    : FOR    ${i}    IN RANGE    ${j['count_unread']}
    \    log    ${j['entities'][${i}]['activity_id']}
    \    Append To List    ${r1}    ${j['entities'][${i}]['activity_id']}
    log    ${r1}
    #标记消息从未读到已读
    ${resp}=    /v2/users/{agentUserId}/activities/{activitiesId}    ${AdminUser}    ${timeout}    ${r1[0]}
    Should Be Equal As Integers    ${resp.status_code}    202    不正确的状态码:${resp.status_code}
    #获取已读消息
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    read
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j1}    to json    ${resp.content}
    log    ${j1['count_unread']}
    Should Be True    ${j2['count_unread']}== ${j1['count_unread']}+1    count_unread返回值不正确 , 比较前后值分别为:${j2['count_unread']} ,${j1['count_unread']}

获取已发消息列表数据(/v1/tenants/{tenantId}/agents/{userId}/activities)
    [Documentation]    获取消息中心已发消息列表数据
    [Tags]
    #获取已发消息列表
    ${secs} =    Get Time    epoch
    ${notificationEntity}=    create dictionary    agentUserId=${AdminUser.userId}    content=my-content-${secs}    detail=my-detail-${secs}
    log    ${notificationEntity}
    ${data}=    set variable    {"receviceAgentIds":["${notificationEntity.agentUserId}"],"content":{"summary":"${notificationEntity.content}","detail":"${notificationEntity.detail}"}}
    ${resp}=    /v1/tenants/{tenantId}/agents/{userId}/activities    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j} >= 0    返回值中不是数字:${j}
    log    ${j['count_total']}
    #发送消息通知给其他坐席
    ${resp}=    /v1/tenants/{tenantId}/agents/{userId}/activities    post    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #获取已发消息列表，并和第一次做对比
    ${data}=    set variable    {"receviceAgentIds":["${notificationEntity.agentUserId}"],"content":{"summary":"${notificationEntity.content}","detail":"${notificationEntity.detail}"}}
    ${resp}=    /v1/tenants/{tenantId}/agents/{userId}/activities    get    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j1}    to json    ${resp.content}
    log    ${j1['count_total']}
    Should Be True    ${j['count_total']} + 1 == ${j1['count_total']}    count_total返回值不正确 , 比较前后值分别为:${j['count_total']} ,${j1['count_total']}
