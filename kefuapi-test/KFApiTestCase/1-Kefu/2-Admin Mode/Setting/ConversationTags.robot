*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/ConversationTagApi.robot
Resource          ../../../../commons/admin common/Setting/ConversationTags_Common.robot

*** Test Cases ***
获取所有会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree)
    #创建参数字典
    &{conversationTagEntity}    create dictionary    systemOnly=false    buildCount=true
    #获取会话标签数据
    ${j}    Get Conversation Tags    get    ${AdminUser}    0    ${conversationTagEntity}
    Should Not Be Empty    ${j[0]['children']}    会话标签为空
