*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/Customers/Customers_Common.robot

*** Test Cases ***
获取访客的客户标签(/v1/crm/tenants/{tenantId}/visitors/{visitorId}/tags)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    log    ${sessionInfo.userId}
    #获取时间计划
    ${j}=    Get Visitor Tags    ${AdminUser}    ${sessionInfo.userId}
    should be equal    ${j['status']}    OK    访客中心人数不正确：${j}

获取租户客户中心的筛选filters(/v1/crm/tenants/{tenantId}/filters)
    #获取租户客户中心的筛选filters
    ${j}=    Get Filters    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Pass Execution    租户的filters为空， ${j}
    Comment    Run Keyword if    ${length} > 0    should be equal    ${j['entities']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Comment    Run Keyword if    ${length} > 0    should be equal    ${j['entities']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Comment    Run Keyword if    ${length} > 0    should be equal    ${j['entities']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

获取访客的筛选filters(/v1/crm/tenants/{tenantId}/visitor/{visitorId}/filters)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取访客的筛选filters
    ${j}=    Get Visitor Filters    ${AdminUser}    ${sessionInfo.userId}
    should be equal    ${j['status']}    OK    接口返回值中status不正确：${j}
