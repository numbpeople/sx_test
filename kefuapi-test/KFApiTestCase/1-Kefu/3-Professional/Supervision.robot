*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | supervise | 现场监控/现场管理 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Force Tags        supervise
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Supervision/Supervision_Common.robot
Resource          ../../../commons/admin common/Members/AgentQueue_Common.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取现场管理的技能组列表(/v1/monitor/agentqueues)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【现场监控/现场管理】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取现场管理的技能组列表，调用接口：/v1/monitor/agentqueues，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、返回值数据总数大于0。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #获取现场管理的技能组列表
    ${apiResponse}    Get Monitor Agentqueues    ${AdminUser}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤2时，发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    ${length}    get length    ${j['entities']}
    should be true    ${length} > 0    现场管理中没有技能组数据，${apiResponse.describetion}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${apiResponse.describetion}

获取现场管理的技能组中坐席列表(/v1/monitor/agentusers)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【现场监控/现场管理】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、创建新的技能组，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step3、获取现场管理的技能组中坐席列表，调用接口：/v1/monitor/agentqueues，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值等于{}。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建技能组
    ${curTime}    Uuid 4
    ${queueName}    set variable    ${AdminUser.tenantId}${curTime}
    ${queue}    Create Agentqueue    ${queueName}
    #获取现场管理的技能组中坐席列表
    ${apiResponse}    Get Monitor Agentusers    ${AdminUser}    ${queue.queueId}
    # Should Be Equal    ${apiResponse.status}    ${ResponseStatus.OK}    发生异常：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    ${length}    get length    ${j['entities']}
    should be true    ${length}==0    现场管理中技能组坐席应该为空, 但实际不为空, ${apiResponse.describetion}

创建坐席并添加技能组，现场管理的技能组中坐席列表(/v1/tenants/{tenantId}/timeplans/schedules)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【现场监控/现场管理】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、创建技能组和坐席，并将坐席设置到技能组里，调用接口：/v1/AgentQueue、/v1/Admin/Agents、/v1/AgentQueue/{queueId}/AgentUser，接口请求状态码为200。
    ...    - Step3、获取现场管理的技能组中坐席列表，调用接口：/v1/monitor/agentqueues，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、返回值总长度等于1。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建技能组和坐席，并将坐席设置到技能组里
    ${queue}    Set Agents To Queue
    #获取现场管理的技能组中坐席列表
    ${apiResponse}    Get Monitor Agentusers    ${AdminUser}    ${queue.queueId}
    Should Be Equal    ${apiResponse.status}    ${ResponseStatus.OK}    发生异常：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    ${length}    get length    ${j['entities']}
    should be true    ${length} == 1    现场管理中技能组坐席数不是1，${apiResponse.describetion}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${apiResponse.describetion}
    should be equal    ${j['entities'][0]['user_id']}    ${queue.agent.agentId}    接口返回值中user_id值不正确, $${apiResponse.describetion}
    should be equal    ${j['entities'][0]['username']}    ${queue.agent.username}    接口返回值中username值不正确, $${apiResponse.describetion}
    should be equal    ${j['entities'][0]['nickname']}    ${queue.agent.nicename}    接口返回值中nickname值不正确, $${apiResponse.describetion}
    should be equal    ${j['entities'][0]['max_session_count']}    ${${queue.agent.maxServiceSessionCount}}    接口返回值中max_session_count值不正确, $${apiResponse.describetion}
    should be equal    ${j['entities'][0]['current_session_count']}    ${0}    接口返回值中current_session_count值不正确, $${apiResponse.describetion}
    should be equal    ${j['entities'][0]['avg_session_time']}    ${0}    接口返回值中avg_session_time值不正确, $${apiResponse.describetion}
    should be equal    ${j['entities'][0]['session_terminal_count']}    ${0}    接口返回值中session_terminal_count值不正确, $${apiResponse.describetion}
    should be true    ${j['entities'][0]['first_login_time_of_today']} is None    接口返回值中first_login_time_of_today值不正确, $${apiResponse.describetion}
    should be equal    ${j['entities'][0]['state']}    Offline    接口返回值中state值不正确, $${apiResponse.describetion}
