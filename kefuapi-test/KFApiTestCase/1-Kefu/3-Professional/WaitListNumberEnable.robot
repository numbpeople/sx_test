*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | waitListNumberEnable | 显示排队人数 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Default Tags      waitListNumberEnable
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Channels/Webim_Common.robot
Resource          ../../../commons/agent common/Queue/Queue_Common.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取显示排队人数(/v1/visitors/waitings/data)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【获取显示排队人数】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step3、获取显示排队人数，调用接口：/v1/visitors/waitings/data，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建待接入会话
    ${sessionInfo}    Create Wait Conversation    webim
    ${serviceSessionId}    set variable    ${sessionInfo.serviceSessionId}
    ${queueId}    set variable    ${sessionInfo.queueId}
    #获取会话的排队人数
    &{apiResponse}    Set WaitListNumber    ${AdminUser}    ${serviceSessionId}    ${queueId}
    Should Be Equal     ${apiResponse.status}    ${ResponseStatus.OK}    步骤3时，发生异常：${apiResponse.errorDescribetion}
    ${text}    set variable    ${apiResponse.text}
    Should Be Equal     ${text['status']}    OK    步骤3时，status字段值不等于OK：${apiResponse.errorDescribetion}
