*** Settings ***
Default Tags      phone
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Channels/Phone_Common.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取callcenter属性(/v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs)
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status    ${AdminUser}
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #获取坐席绑定呼叫中心的数据
    ${j}    Get Agent Phone Data    ${AdminUser}
    Should Be Equal    '${j['status']}'    'OK'    callcenter属性数据不正确：${j}

获取呼叫中心信息(/v1/tenants/{tenantId}/phone-tech-channel)
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status    ${AdminUser}
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    ${j}    Get PhoneTechChannel    ${AdminUser}
    Run Keyword If    ${j}==[]    log    无呼叫中心信息
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    呼叫中心信息不正确：${j}
