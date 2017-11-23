*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../commons/admin common/Members/AgentQueue_Common.robot

*** Test Cases ***
获取技能组时间计划和问候语开关设置(/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/weekdays)
    #使用第一个时间计划数据
    ${curTime}    get time    epoch
    ${queueName}    set variable    ${AdminUser.tenantId}${curTime}
    ${queue}    Create Agentqueue    ${queueName}
    #根据时间计划获取工作日设置
    ${j}=    Get Time-Options    ${AdminUser}    ${queue.queueId}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    接口返回值中tenantId值不是${AdminUser.tenantId}, ${j}
    should be equal    '${j['entity']['timeScheduleId']}'    '0'    接口返回值中timeScheduleId值不是0 , ${j}
