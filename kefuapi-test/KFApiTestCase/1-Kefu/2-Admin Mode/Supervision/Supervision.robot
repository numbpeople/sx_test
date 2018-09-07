*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Supervision/Supervision_Common.robot
Resource          ../../../../commons/admin common/Members/AgentQueue_Common.robot

*** Test Cases ***
获取现场管理的技能组列表(/v1/monitor/agentqueues)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取现场管理的技能组列表，调用接口：/v1/monitor/agentqueues，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、返回值数据总数大于0。
    #获取现场管理的技能组列表
    ${j}    Get Monitor Agentqueues    ${AdminUser}
    ${length}    get length    ${j['entities']}
    should be true    ${length} > 0    现场管理中没有技能组数据，${j}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${j}

获取现场管理的技能组中坐席列表(/v1/monitor/agentusers)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建新的技能组，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取现场管理的技能组中坐席列表，调用接口：/v1/monitor/agentqueues，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值等于{}。
    #创建技能组
    ${curTime}    Uuid 4
    ${queueName}    set variable    ${AdminUser.tenantId}${curTime}
    ${queue}    Create Agentqueue    ${queueName}
    #获取现场管理的技能组中坐席列表
    ${j}    Get Monitor Agentusers    ${AdminUser}    ${queue.queueId}
    should be true    "${j}" == "{}"    现场管理中技能组坐席应该为空, 但实际不为空, ${j}

创建坐席并添加技能组，现场管理的技能组中坐席列表(/v1/tenants/{tenantId}/timeplans/schedules)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组和坐席，并将坐席设置到技能组里，调用接口：/v1/AgentQueue、/v1/Admin/Agents、/v1/AgentQueue/{queueId}/AgentUser，接口请求状态码为200。
    ...    - Step2、获取现场管理的技能组中坐席列表，调用接口：/v1/monitor/agentqueues，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、返回值总长度等于1。
    #创建技能组和坐席，并将坐席设置到技能组里
    ${queue}    Set Agents To Queue
    #获取现场管理的技能组中坐席列表
    ${j}    Get Monitor Agentusers    ${AdminUser}    ${queue.queueId}
    run keyword if    "${j}" == "{}"    Fail    现场管理中技能组不包含坐席, ${j}
    ${length}    get length    ${j['entities']}
    should be true    ${length} == 1    现场管理中技能组坐席数不是唯一，${j}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${j}
    should be equal    ${j['entities'][0]['user_id']}    ${queue.agent.agentId}    接口返回值中user_id值不正确, ${j}
    should be equal    ${j['entities'][0]['username']}    ${queue.agent.username}    接口返回值中username值不正确, ${j}
    should be equal    ${j['entities'][0]['nickname']}    ${queue.agent.nicename}    接口返回值中nickname值不正确, ${j}
    should be equal    ${j['entities'][0]['max_session_count']}    ${${queue.agent.maxServiceSessionCount}}    接口返回值中max_session_count值不正确, ${j}
    should be equal    ${j['entities'][0]['current_session_count']}    ${0}    接口返回值中current_session_count值不正确, ${j}
    should be equal    ${j['entities'][0]['avg_session_time']}    ${0}    接口返回值中avg_session_time值不正确, ${j}
    should be equal    ${j['entities'][0]['session_terminal_count']}    ${0}    接口返回值中session_terminal_count值不正确, ${j}
    should be true    ${j['entities'][0]['first_login_time_of_today']} is None    接口返回值中first_login_time_of_today值不正确, ${j}
    should be equal    ${j['entities'][0]['state']}    Offline    接口返回值中state值不正确, ${j}
