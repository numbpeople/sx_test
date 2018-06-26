*** Settings ***
Suite Setup       Create Customer Setup
Resource          ../../../../commons/admin common/Customers/Customers_common.robot
Resource          ../../../../commons/admin common/Setting/CustomerTags_Common.robot

*** Test Cases ***
更新访客资料(/v1/crm/tenants/{tenantId}/customers/{customerId})
    [Documentation]    更新访客名字
    ${customerId}    set variable    ${customerDetail["customer_id"]}
    ${visitorId}    set variable    ${customerDetail["bind_visitors"][0]}
    ${truename}    set variable    ${customerDetail["nickname"]}
    #创建请求体
    ${data}    set variable    {"visitorId":"${visitorId}","properties":{"truename":["${truename}"]}}
    #更新访客名字
    ${j}    Update Customer Detail    ${AdminUser}    ${customerId}    ${data}
    should be true    ${j['entity']} == True    接口返回值entity不正确:${j}
    #验证访客基本资料与期望值是否一致
    ${j}    Get Customer DetailInfo    ${AdminUser}    ${visitorId}
    ${length}    get length    ${j['entity']['columnValues']}
    : FOR    ${n}    IN RANGE    ${length}
    \    ${value}    run keyword if    '${j['entity']['columnValues'][${n}]['columnName']}' == 'truename'    set variable    ${j['entity']['columnValues'][${n}]['values'][0]}
    \    run keyword if    '${j['entity']['columnValues'][${n}]['columnName']}' == 'truename'    exit for loop
    should be equal    ${j['entity']['customerId']}    ${customerId}    接口返回customerId不正确:${j}
    should be equal    ${value}    ${truename}    接口返回truename不正确:${value}

更新客户标签(/v1/Tenant/VisitorUsers/{visitorId}/VisitorUserTags/{userTagId})
    [Documentation]    更新某个访客的客户标签
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    per_page=100
    ${visitorId}    set variable    ${customerDetail["bind_visitors"][0]}
    #获取改租户下的所有访客标签
    ${j}    Set UserTags    get    ${AdminUser}    ${filter}
    Should Be True    ${j['total_entries']}>=0    获取的访客标签数不正确：${j}
    ${tagName}    set variable    ${j['items'][0]['tagName']}
    ${userTagId}    set variable    ${j['items'][0]['userTagId']}
    #为访客打一个标签
    ${data}    set variable    {"userTagId":${userTagId},"tagName":"${tagName}","visitorUserId":"${visitorId}","checked":true}
    Update CustomerTag    ${AdminUser}    ${visitorId}    ${userTagId}    ${data}
    #验证访客基本资料的标签值与期望值是否一致
    sleep    1000ms
    ${j}    Get Customer DetailInfo    ${AdminUser}    ${visitorId}
    should be true    '${j['entity']['customerTags']}' == '[${userTagId}]'    接口返回customerTags不正确:${j['entity']}

加入黑名单(/v1/tenants/{tenantId}/blacklists)
    [Documentation]    将访客加入黑名单
    #创建局部变量
    ${visitorId}    set variable    ${customerDetail["bind_visitors"][0]}
    #获取nickname
    ${j}    Get Customer DetailInfo    ${AdminUser}    ${visitorId}
    ${length}    get length    ${j['entity']['columnValues']}
    : FOR    ${n}    IN RANGE    ${length}
    \    ${nickname}    run keyword if    '${j['entity']['columnValues'][${n}]['columnName']}' == 'nickname'    set variable    ${j['entity']['columnValues'][${n}]['values'][0]}
    \    run keyword if    '${j['entity']['columnValues'][${n}]['columnName']}' == 'nickname'    exit for loop
    #创建请求体
    ${data}    set variable    {"tenantId":${AdminUser.tenantId},"visitorUserId":"${visitorId}","visitorUserNickname":"${nickname}","actor":"${AdminUser.userId}","actorNickname":"${AdminUser.nicename}","reason":"blacklist reason","status":"Created"}
    #加入黑名单
    Add Blacklist    ${AdminUser}    ${data}
    #按访客昵称筛选黑名单列表,验证返回结果与期望值是否一致
    ${params}    set variable    visitorName=${nickname}
    ${j}    Get blacklists    ${AdminUser}    ${params}
    should be true    ${j['totalElements']} == 1    接口返回totalElements不正确:${j}
    should be equal    ${j['entities'][0]['visitorUserId']}     ${visitorId}    接口返回visitorUserId不正确:${j['entities'][0]['visitorUserId']}
    should be equal    ${j['entities'][0]['actorNickname']}     ${AdminUser.nicename}    接口返回actorNickname不正确:${j['entities'][0]['actorNickname']}
    should be equal    ${j['entities'][0]['visitorUserNickname']}     ${nickname}    接口返回visitorUserNickname不正确:${j['entities'][0]['visitorUserNickname']}
    should be true    '${j['entities'][0]['reason']}' == 'blacklist reason'    接口返回reason不正确:${j['entities'][0]['reason']}