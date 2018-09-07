*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Supervision/AlarmRecords_Common.robot

*** Test Cases ***
获取告警记录列表(/v1/monitor/alarms)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取告警记录列表，调用接口：/v1/monitor/alarms，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #获取告警记录列表
    ${j}    Get Monitor Alarms    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${j}
