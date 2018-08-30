*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        msgcenter
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Notification/MsgCenterApi.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../../commons/admin common/Notification/Notification_Common.robot

*** Test Cases ***
获取消息中心未读消息数据(/users/{agentUserId}/activities)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取消息中心未读消息总数，调用接口：/users/{agentUserId}/activities，接口请求状态码为200。
    ...    - Step2、发送并创建一个未读消息，调用接口：/v1/tenants/{tenantId}/activities，接口请求状态码为200。
    ...    - Step3、再次获取消息中心未读消息总数，调用接口：/users/{agentUserId}/activities，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、第二个获取的未读消息总数比第一次大1、即：字段count_total、count_unread值要比第一次增加1。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取消息中心未读消息总数，调用接口：/users/{agentUserId}/feed/info，接口请求状态码为200。
    ...    - Step2、发送并创建一个未读消息，调用接口：/v1/tenants/{tenantId}/activities，接口请求状态码为200。
    ...    - Step3、再次获取消息中心未读消息总数，调用接口：/users/{agentUserId}/activities，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、第二个获取的未读消息总数比第一次大1、即：字段count_total、count_unread值要比第一次增加1。
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取消息中心未读消息总数，调用接口：/users/{agentUserId}/activities，接口请求状态码为200。
    ...    - Step2、获取消息中心已读消息总数，调用接口：/users/{agentUserId}/activities，接口请求状态码为200。
    ...    - Step3、如果未读总数据大于0，则标记第一条数据为已读，调用接口：/v2/users/{agentUserId}/activities/{activitiesId}，接口请求状态码为202。
    ...    - Step4、获取消息中心已读消息总数，调用接口：/users/{agentUserId}/activities，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、第二个获取的已读消息总数会增加1。
    #获取未读消息，为了下面的遍历取activiesId
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    unread
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j['count_unread']}
    #获取已读消息，为了与最后结果作比较
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    read
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j2}    to json    ${resp.content}
    #已读消息对比前总数
    ${preReadCounts}    evaluate    ${j2['count_total']} - ${j2['count_unread']}
    #标记未读消息
    ${activityId}    set variable    ${EMPTY}
    run keyword if    ${j['count_unread']} > 0    set test variable    ${activityId}    ${j['entities'][0]['activity_id']}    #如果未读消息数据大于0，则取第一结果作为标记已读的数据
    run keyword if    ${j['count_unread']} > 0    Mark Read Activity    ${AdminUser}    ${activityId}    ${timeout}
    #获取已读消息
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    read
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j1}    to json    ${resp.content}
    #已读消息对比前总数
    ${currReadCounts}    evaluate    ${j1['count_total']} - ${j1['count_unread']}
    ${afterReadCounts}    evaluate    ${currReadCounts}-1    #标记已读后，已读总数会增加
    Should Be True    ${preReadCounts} == ${afterReadCounts}    count_unread返回值不正确 , 比较前后值分别为:${preReadCounts} ,${currReadCounts}

获取已发消息列表数据(/v1/tenants/{tenantId}/agents/{userId}/activities)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取已发消息列表，获取总数，调用接口：/v1/tenants/{tenantId}/agents/{userId}/activities，接口请求状态码为200。
    ...    - Step2、发送新消息通知给其他坐席，调用接口：/v1/tenants/{tenantId}/agents/{userId}/activities，接口请求状态码为200。
    ...    - Step3、再次获取已发消息列表，获取总数，调用接口：/v1/tenants/{tenantId}/agents/{userId}/activities，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、第二个获取的已发消息列表总数会增加1。
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

获取默认消息中心数据(/users/{agentId}/activities)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取默认消息中心数据，调用接口：/users/{agentId}/activities，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，total_entries字段值大于等于0。
    ${resp}=    /users/{agentId}/activities    ${AdminUser}    ${FilterEntity}    ${MsgCenterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} >= 0    消息中心数据不正确

获取默认消息中心数量(/users/{agentId}/feed/info)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取默认消息中心数量总数，调用接口：/users/{agentId}/feed/info，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200，count_total、count_unread字段值大于等于0。
    ${resp}=    /users/{agentId}/feed/info    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['count_total']} >= 0    消息中心总数不正确：${resp.content}
    Should Be True    ${j['count_unread']} >= 0    消息中心未读数不正确：${resp.content}
