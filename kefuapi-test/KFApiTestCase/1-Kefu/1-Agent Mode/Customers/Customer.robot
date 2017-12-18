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
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    log    ${sessionInfo.userId}
    #获取客户标签
    ${j}=    Get Visitor Tags    ${AdminUser}    ${sessionInfo.userId}
    should be equal    ${j['status']}    OK    访客中心人数不正确：${j}

获取租户客户中心的筛选filters(/v1/crm/tenants/{tenantId}/filters)
    #获取租户客户中心的筛选filters
    ${j}=    Set Filters    get    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Pass Execution    租户的filters为空， ${j}

创建客户中心的筛选filters(/v1/crm/tenants/{tenantId}/filters)
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${value}    Create Time Value    ${param}
    #创建租户客户中心的筛选filters
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${displayName}    set variable    ${AdminUser.tenantId}-${randoNumber}
    ${crmFilter}    create dictionary    displayName=${displayName}    status=ENABLE    type=normal    visible=true
    ${conditionList}    create dictionary    fieldName=createDateTime    operation=RANGE    param=${param}    value=${value}
    ${data}    set variable    {"displayName":"${crmFilter.displayName}","visible":${crmFilter.visible},"type":"${crmFilter.type}","status":"${crmFilter.status}","conditionList":[{"fieldName":"${conditionList.fieldName}","operation":"${conditionList.operation}","value":"${conditionList.value}","param":"${conditionList.param}"}]}
    ${j}=    Set Filters    post    ${AdminUser}    ${data}
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
    ${j}=    Set Filters    get    ${AdminUser}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Pass Execution    租户的filters为空， ${j}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}

删除客户中心的filters(/v1/crm/tenants/{tenantId}/filters)
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${value}    Create Time Value    ${param}
    #创建租户客户中心的筛选filters
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${displayName}    set variable    ${AdminUser.tenantId}-${randoNumber}
    ${crmFilter}    create dictionary    displayName=${displayName}    status=ENABLE    type=normal    visible=true
    ${conditionList}    create dictionary    fieldName=createDateTime    operation=RANGE    param=${param}    value=${value}
    ${data}    set variable    {"displayName":"${crmFilter.displayName}","visible":${crmFilter.visible},"type":"${crmFilter.type}","status":"${crmFilter.status}","conditionList":[{"fieldName":"${conditionList.fieldName}","operation":"${conditionList.operation}","value":"${conditionList.value}","param":"${conditionList.param}"}]}
    ${j}=    Set Filters    post    ${AdminUser}    ${data}
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
    ${j}=    Set Filters    delete    ${AdminUser}    ${EMPTY}    ${filterId}
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
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客的筛选filters
    ${j}=    Get Visitor Filters    ${AdminUser}    ${sessionInfo.userId}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}

获取访客的黑名单列表(/v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客黑名单列表
    ${j}    Get Visitor Blacklists    ${AdminUser}    ${sessionInfo.userId}
    Should Be Equal    ${j['status']}    OK    获取接口返回status不是OK: ${j}
