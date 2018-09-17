*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | questionnaireEnable | 第三方问卷调查 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Default Tags      questionnaireEnable
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Setting/Questionnaire_Common.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取问卷账号列表(/v1/tenants/{tenantId}/questionnaires/accounts)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【问卷调查】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取调查问卷账号列表，调用接口：/v1/tenants/{tenantId}/questionnaires/accounts，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #获取问卷账号列表
    ${j}    Set Questionnaire    ${AdminUser}    get    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

创建问卷账号数据(/v1/tenants/{tenantId}/questionnaires/accounts)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【问卷调查】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、创建问卷账号数据，调用接口：/v1/tenants/{tenantId}/questionnaires/accounts，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行    
    #创建问卷账号列表
    ${data}    set variable    {"type":"WJW" }
    ${j}    Set Questionnaire    ${AdminUser}    post    ${data}
    ${tenantid}    convert to string    ${AdminUser.tenantId}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['tenant_id']}    ${AdminUser.tenantId}    返回值中租户id不正确: ${j}
    should be equal    ${j['entity']['type']}    WJW    返回值中的类型不正确: ${j}
    should be equal    ${j['entity']['status']}    Enable    返回值中的状态不正确: ${j}
    Should Contain    ${j['entity']['username']}    ${tenantid}    返回值中的账号名称不正确: ${j}

获取问卷问题列表(/v1/tenants/{tenantId}/questionnaires/list)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【问卷调查】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取问卷问题列表，调用接口：/v1/tenants/{tenantId}/questionnaires/list，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行 
    #获取问卷账号列表
    ${j}    Get Questionnaires List    WJW
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

删除问卷账号(/v1/tenants/{tenantId}/questionnaires/accounts)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【问卷调查】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、删除问卷账号，调用接口：/v1/tenants/{tenantId}/questionnaires/accounts，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行 
    #创建问卷账号列表
    ${data}    set variable    {"type":"WJW" }
    ${j}    Set Questionnaire    ${AdminUser}    delete    ${data}
    ${tenantid}    convert to string    ${AdminUser.tenantId}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['tenant_id']}    ${AdminUser.tenantId}    返回值中租户id不正确: ${j}
    should be equal    ${j['entity']['type']}    WJW    返回值中的类型不正确: ${j}
    should be equal    ${j['entity']['status']}    Deleted    返回值中的状态不正确: ${j}
    Should Contain    ${j['entity']['username']}    ${tenantid}    返回值中的账号名称不正确: ${j}
