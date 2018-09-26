*** Settings ***
Suite Setup       Create Customer Setup
Resource          ../../../../commons/admin common/Customers/Customers_common.robot
Resource          ../../../../commons/admin common/Setting/CustomerTags_Common.robot

*** Test Cases ***
更新访客资料(/v1/crm/tenants/{tenantId}/customers/{customerId})
    [Documentation]    【操作步骤】：
    ...    - Step1、创建新访客和新会话，获取该访客的客户中心数据存在。
    ...    - Step2、更新访客名称信息，调用接口：/v1/crm/tenants/{tenantId}/customers/{customerId}，接口请求状态码为200。
    ...    - Step3、获取访客更新后的数据一致，调用接口：/v1/crm/tenants/{tenantId}/customers/{customerId}，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    获取访客数据接口返回值中，columnName字段值等于truename、customerId等于访客的顾客id。
    #获取setup时创建的访客信息
    ${customerId}    set variable    ${customerDetail["customer_id"]}
    ${visitorId}    set variable    ${customerDetail["bind_visitors"][0]}
    ${nickName}    set variable    ${customerDetail["nickname"]}
    set suite variable    ${customer_Id}    ${customerId}
    set suite variable    ${visitor_Id}    ${visitorId}
    set suite variable    ${nick_Name}    ${nickName}
    #创建请求体,将访客的truename设置为${nickName}
    ${truename}    set variable    ${nickName}
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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户下所有的客户标签数据，调用接口：/v1/Admin/UserTags，接口请求状态码为200。
    ...    - Step2、为访客打上客户标签，调用接口：/v1/Tenant/VisitorUsers/{visitorId}/VisitorUserTags/{userTagId}，接口请求状态码为200。
    ...    - Step3、获取访客资料信息，调用接口：/v1/crm/tenants/{tenantId}/visitors/{visitorId}/customer_detailinfo，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    获取访客资料信息接口返回值中，customerTags字段值等于刚标记的客户标签id值。
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    per_page=100
    #获取改租户下的所有访客标签
    ${j}    Set UserTags    get    ${AdminUser}    ${filter}
    Should Be True    ${j['total_entries']}>=0    获取的访客标签数不正确：${j}
    ${tagName}    set variable    ${j['items'][0]['tagName']}
    ${userTagId}    set variable    ${j['items'][0]['userTagId']}
    #为访客打一个标签
    ${data}    set variable    {"userTagId":${userTagId},"tagName":"${tagName}","visitorUserId":"${visitor_Id}","checked":true}
    Update CustomerTag    ${AdminUser}    ${visitor_Id}    ${userTagId}    ${data}
    #验证访客基本资料的标签值与期望值是否一致
    sleep    1000ms
    ${j}    Get Customer DetailInfo    ${AdminUser}    ${visitor_Id}
    should be true    '${j['entity']['customerTags']}' == '[${userTagId}]'    接口返回customerTags不正确:${j['entity']}

加入黑名单(/v1/tenants/{tenantId}/blacklists)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客资料信息，调用接口：/v1/crm/tenants/{tenantId}/visitors/{visitorId}/customer_detailinfo，接口请求状态码为200。
    ...    - Step2、将访客加入黑名单中，调用接口：/v1/tenants/{tenantId}/blacklists，接口请求状态码为200。
    ...    - Step3、获取黑名单中的数据，包含刚加入的访客黑名单数据，调用接口：/v1/tenants/{tenantId}/blacklists，接口请求状态码为200。
    ...    - Step4、获取客户中心操作日志列表，调用接口：/v1/tenants/{tenantId}/operationLog，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    获取客户中心操作日志列表接口返回值中，包含加入黑名单的客户id：customerId、操作类型operationType：blacklist、客户昵称等等。
    #获取nickname
    ${j}    Get Customer DetailInfo    ${AdminUser}    ${visitor_Id}
    ${length}    get length    ${j['entity']['columnValues']}
    : FOR    ${n}    IN RANGE    ${length}
    \    ${nickname}    run keyword if    '${j['entity']['columnValues'][${n}]['columnName']}' == 'nickname'    set variable    ${j['entity']['columnValues'][${n}]['values'][0]}
    \    run keyword if    '${j['entity']['columnValues'][${n}]['columnName']}' == 'nickname'    exit for loop
    #创建请求体
    ${data}    set variable    {"tenantId":${AdminUser.tenantId},"visitorUserId":"${visitor_Id}","visitorUserNickname":"${nickname}","actor":"${AdminUser.userId}","actorNickname":"${AdminUser.nicename}","reason":"blacklist reason","status":"Created"}
    #加入黑名单
    Add Blacklist    ${AdminUser}    ${data}
    #按访客昵称筛选黑名单列表,验证返回结果与期望值是否一致
    ${params}    set variable    visitorName=${nickname}
    ${j}    Get blacklists    ${AdminUser}    ${params}
    should be true    ${j['totalElements']} == 1    接口返回totalElements不正确:${j}
    should be equal    ${j['entities'][0]['visitorUserId']}     ${visitor_Id}    接口返回visitorUserId不正确:${j['entities'][0]['visitorUserId']}
    should be equal    ${j['entities'][0]['actorNickname']}     ${AdminUser.nicename}    接口返回actorNickname不正确:${j['entities'][0]['actorNickname']}
    should be equal    ${j['entities'][0]['visitorUserNickname']}     ${nickname}    接口返回visitorUserNickname不正确:${j['entities'][0]['visitorUserNickname']}
    should be true    '${j['entities'][0]['reason']}' == 'blacklist reason'    接口返回reason不正确:${j['entities'][0]['reason']}
    #获取客户中心操作日志列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    page=0
    ${apiResponse}    Get Customer OperationLog    ${AdminUser}    ${filter}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤4时，发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    #验证接口返回的第一条数据是加入黑名单的操作
    should be equal    ${j['status']}    OK    接口返回值status不正确:${apiResponse.describetion}
    should be equal    ${j['entities'][0]['customerId']}    ${customer_Id}    接口返回的第一条数据customerId不正确:${apiResponse.describetion}
    should be equal    ${j['entities'][0]['operationType']}    blacklist    接口返回的第一条数据operationType不正确:${j['entities'][0]}，${apiResponse.describetion}
    should be equal    ${j['entities'][0]['operatorId']}    ${AdminUser.userId}    接口返回的第一条数据operatorId不正确:${j['entities'][0]}，${apiResponse.describetion}
    should be equal    ${j['entities'][0]['operatorNickname']}    ${AdminUser.nicename}    接口返回的第一条数据operatorNickname不正确:${j['entities'][0]}，${apiResponse.describetion}
    should be equal    ${j['entities'][0]['status']}    add    接口返回的第一条数据status不正确:${j['entities'][0]}，${apiResponse.describetion}
    should be equal    ${j['entities'][0]['visitorUserId']}    ${visitor_Id}    接口返回的第一条数据visitorUserId不正确，${apiResponse.describetion}
    should be equal    ${j['entities'][0]['visitorUserNickname']}    ${nick_Name}    接口返回的第一条数据visitorUserNickname不正确，${apiResponse.describetion}