*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Robot/Robot_Api.robot
Resource          ../../../../commons/admin common/Robot/RobotSettings_Common.robot

*** Test Cases ***
获取智能场景应答(/v1/Tenants/{tenantId}/robots/intent/list)
    [Documentation]    获取机器人智能场景应答
    #获取机器人智能场景应答
    ${j}    Get Robot Scenarios    ${AdminUser}
    Should Be Equal    '${j['logistics']['name']}'    '物流'    返回的机器人只能场景应答信息不正确：${j}
 