*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Channels/App_Common.robot

*** Test Cases ***
获取所有app关联(/channels)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户下全渠道的关联数据，调用接口：/channels，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，如果接口不为空，tenantId字段等于租户id。
    ${j}    Get All OriginType Channels    ${AdminUser}
    Run Keyword If    "${j}"!="[]"    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    获取app关联失败
