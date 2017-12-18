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
    #获取告警记录列表
    ${j}    Get Monitor Alarms    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${j}
