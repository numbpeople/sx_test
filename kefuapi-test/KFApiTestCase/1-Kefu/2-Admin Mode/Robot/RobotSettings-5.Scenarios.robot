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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取智能场景应答，调用接口：/v1/Tenants/{tenantId}/robots/intent/list，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、接口字段值name等于“物流”。
    #获取机器人智能场景应答
    ${j}    Get Robot Scenarios    ${AdminUser}
    Should Be Equal    '${j['logistics']['name']}'    '物流'    返回的机器人智能场景应答信息不正确：${j}
 