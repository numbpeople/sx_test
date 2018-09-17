*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Library           DateTime
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/Customers/Customers_Common.robot

*** Test Cases ***
获取访客的客户标签(/v1/crm/tenants/{tenantId}/visitors/{visitorId}/tags)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、获取访客标签数据，调用接口：/v1/crm/tenants/{tenantId}/visitors/{visitorId}/tags，接口请求状态码为200。
    ...    - Step3、获取接口返回值。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK。
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    log    ${sessionInfo.userId}
    #获取客户标签
    ${apiResponse}    Get Visitor Tags    ${AdminUser}    ${sessionInfo.userId}
    Should Be Equal     ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
    ${j}    set variable    ${apiResponse.text}
    should be equal    ${j['status']}    OK    访客中心人数不正确：${j}

获取租户客户中心的筛选filters(/v1/crm/tenants/{tenantId}/filters)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户客户中心的筛选数据，调用接口：/v1/crm/tenants/{tenantId}/filters，接口请求状态码为200。
    ...    - Step2、获取接口返回值。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK。
    #获取租户客户中心的筛选filters
    ${apiResponse}=    Set Filters    get    ${AdminUser}
    Should Be Equal     ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
    ${j}    set variable    ${apiResponse.text}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Pass Execution    租户的filters为空， ${j}

创建客户中心的筛选filters(/v1/crm/tenants/{tenantId}/filters)
    [Documentation]    【操作步骤】：
    ...    - Step1、调用关键字Create Time Value来获取接口时间参数：今天、昨天、本周、本月、上月，返回值如：1512921600000,1513007940000。
    ...    - Step2、创建客户中心的筛选filters，调用接口：/v1/crm/tenants/{tenantId}/filters，接口返回状态码为200。
    ...    - Step3、获取接口返回值，status等于OK，各字段值应等于预期值。
    ...    - Step4、获取客户中心的筛选filters，调用接口：/v1/crm/tenants/{tenantId}/filters，接口返回状态码为200。
    ...    - Step5、判断接口返回情况。
    ...
    ...    【预期结果】：
    ...    获取接口返回值，status等于OK，数据总数大于0。
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${value}    Create Time Value    ${param}
    #创建租户客户中心的筛选filters
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${displayName}    set variable    ${AdminUser.tenantId}-${randoNumber}
    ${crmFilter}    create dictionary    displayName=${displayName}    status=ENABLE    type=normal    visible=true
    ${conditionList}    create dictionary    fieldName=createDateTime    operation=RANGE    param=${param}    value=${value}
    ${data}    set variable    {"displayName":"${crmFilter.displayName}","visible":${crmFilter.visible},"type":"${crmFilter.type}","status":"${crmFilter.status}","conditionList":[{"fieldName":"${conditionList.fieldName}","operation":"${conditionList.operation}","value":"${conditionList.value}","param":"${conditionList.param}"}]}
    ${apiResponse}=    Set Filters    post    ${AdminUser}    ${data}
    Should Be Equal     ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
    ${j}    set variable    ${apiResponse.text}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}
    should be equal    ${j['entity']['displayName']}    ${crmFilter.displayName}    返回值中displayName值不正确: ${j}
    Comment    should be equal    ${j['entity']['visible']}    ${crmFilter.visible}    返回值中visible值不正确: ${j}
    should be equal    ${j['entity']['type']}    ${crmFilter.type}    返回值中type字段值不正确: ${j}
    should be equal    ${j['entity']['status']}    ${crmFilter.status}    返回值中status字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['fieldName']}    ${conditionList.fieldName}    返回值中fieldName字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['operation']}    ${conditionList.operation}    返回值中operation字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['value']}    ${conditionList.value}    返回值中value字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['param']}    ${conditionList.param}    返回值中param字段值不正确: ${j}
    #获取租户客户中心的筛选filters
    ${apiResponse1}=    Set Filters    get    ${AdminUser}
    Should Be Equal     ${apiResponse1.status}    ${ResponseStatus.OK}    ${apiResponse1.errorDescribetion}
    ${j}    set variable    ${apiResponse1.text}
    ${length} =    get length    ${j['entities']}
    should be true    ${length} > 0    因为刚刚创建了新的客户中心筛选数据，获取到的数据总数应大于0。
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}

删除客户中心的filters(/v1/crm/tenants/{tenantId}/filters)
    [Documentation]    【操作步骤】：
    ...    - Step1、调用关键字Create Time Value来获取接口时间参数：今天、昨天、本周、本月、上月，返回值如：1512921600000,1513007940000。
    ...    - Step2、创建客户中心的筛选filters，调用接口：/v1/crm/tenants/{tenantId}/filters，接口返回状态码为200。
    ...    - Step3、获取接口返回值，status等于OK，各字段值应等于预期值。
    ...    - Step4、删除客户中心的筛选filters，调用接口：/v1/crm/tenants/{tenantId}/filters，接口返回状态码为200。
    ...    - Step5、判断接口返回情况。
    ...
    ...    【预期结果】：
    ...    获取接口返回值，status等于OK，各字段值应等于预期值。
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${value}    Create Time Value    ${param}
    #创建租户客户中心的筛选filters
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${displayName}    set variable    ${AdminUser.tenantId}-${randoNumber}
    ${crmFilter}    create dictionary    displayName=${displayName}    status=ENABLE    type=normal    visible=true
    ${conditionList}    create dictionary    fieldName=createDateTime    operation=RANGE    param=${param}    value=${value}
    ${data}    set variable    {"displayName":"${crmFilter.displayName}","visible":${crmFilter.visible},"type":"${crmFilter.type}","status":"${crmFilter.status}","conditionList":[{"fieldName":"${conditionList.fieldName}","operation":"${conditionList.operation}","value":"${conditionList.value}","param":"${conditionList.param}"}]}
    ${apiResponse}=    Set Filters    post    ${AdminUser}    ${data}
    Should Be Equal     ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
    ${j}    set variable    ${apiResponse.text}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}
    should be equal    ${j['entity']['displayName']}    ${crmFilter.displayName}    返回值中displayName值不正确: ${j}
    Comment    should be equal    ${j['entity']['visible']}    ${crmFilter.visible}    返回值中visible值不正确: ${j}
    should be equal    ${j['entity']['type']}    ${crmFilter.type}    返回值中type字段值不正确: ${j}
    should be equal    ${j['entity']['status']}    ${crmFilter.status}    返回值中status字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['fieldName']}    ${conditionList.fieldName}    返回值中fieldName字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['operation']}    ${conditionList.operation}    返回值中operation字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['value']}    ${conditionList.value}    返回值中value字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['param']}    ${conditionList.param}    返回值中param字段值不正确: ${j}
    #获取filterId
    ${filterId}    set variable    ${j['entity']['filterId']}
    #创建租户客户中心的筛选filters
    ${apiResponse1}=    Set Filters    delete    ${AdminUser}    ${EMPTY}    ${filterId}
    Should Be Equal     ${apiResponse1.status}    ${ResponseStatus.OK}    ${apiResponse1.errorDescribetion}
    ${j}    set variable    ${apiResponse1.text}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}
    should be equal    ${j['entity']['displayName']}    ${crmFilter.displayName}    返回值中displayName值不正确: ${j}
    Comment    should be equal    ${j['entity']['visible']}    ${crmFilter.visible}    返回值中visible值不正确: ${j}
    should be equal    ${j['entity']['type']}    ${crmFilter.type}    返回值中type字段值不正确: ${j}
    should be equal    ${j['entity']['status']}    ${crmFilter.status}    返回值中status字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['fieldName']}    ${conditionList.fieldName}    返回值中fieldName字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['operation']}    ${conditionList.operation}    返回值中operation字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['value']}    ${conditionList.value}    返回值中value字段值不正确: ${j}
    should be equal    ${j['entity']['conditionList'][0]['param']}    ${conditionList.param}    返回值中param字段值不正确: ${j}

获取访客的筛选filters(/v1/crm/tenants/{tenantId}/visitor/{visitorId}/filters)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、获取访客筛选filters数据，调用接口：/v1/crm/tenants/{tenantId}/visitor/{visitorId}/filters，接口请求状态码为200。
    ...    - Step3、获取接口返回值。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK。
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客的筛选filters
    ${apiResponse}=    Get Visitor Filters    ${AdminUser}    ${sessionInfo.userId}
    Should Be Equal     ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
    ${j}    set variable    ${apiResponse.text}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}

获取访客的黑名单列表(/v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、获取访客黑名单列表数据，调用接口：/v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists，接口请求状态码为200。
    ...    - Step3、获取接口返回值。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK。
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客黑名单列表
    ${apiResponse}    Get Visitor Blacklists    ${AdminUser}    ${sessionInfo.userId}
    Should Be Equal     ${apiResponse.status}    ${ResponseStatus.OK}    ${apiResponse.errorDescribetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    ${j['status']}    OK    获取接口返回status不是OK: ${j}
