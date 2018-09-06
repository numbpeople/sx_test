*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Colleague_Common.robot

*** Test Cases ***
获取当前客服列表(/v1/Agents/{AdminUserId}/Agents)
    [Documentation]    【操作步骤】：
    ...    - Step1、坐席模式-坐席列表，获取坐席列表接口：/v1/Agents/{AdminUserId}/Agents，接口请求状态码为200。
    ...    - Step2、判断接口返回值字段：tenantId
    ...
    ...    【预期结果】：
    ...    判断接口第一条数据的tenantId值，等于${AdminUser.tenantId}。
    #获取同事列表
    ${j}    Get Colleagues    ${AdminUser}
    Run Keyword If    ${j}==[]    Fail    租户下仅有一个Admin坐席来测试？需要确认，如有只有一个，忽略case：${j}
    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取同事列表失败，返回值中tenantId不正确:${j}

# 客服设置状态--暂先不执行该用例，47.32上增加了限制，会导致执行失败(/v1/tenants/{tenantId}/agents/{agentId}/status)
    # [Documentation]    【操作步骤】：
    # ...    - Step1、坐席模式下，调用设置坐席状态接口：/v1/tenants/{tenantId}/agents/{agentId}/status，接口请求状态码为200。
    # ...    - Step2、查询坐席接待人数和状态信息，调用接口：/v1/Agents/me，接口请求状态码为200。
    # ...
    # ...    【预期结果】：
    # ...    判断更新状态后的接口返回值字段status相等。
    # : FOR    ${s}    IN    @{kefustatus}
    # \    ${j}    Set Agent Status    ${AdminUser}    ${s}
    # \    Should Be Equal    ${j['status']}    OK    设置状态失败：${j}
    # \    ${j}    Get Agent Status&MaxServiceUserNumber    ${AdminUser}
    # \    Should Be Equal    ${j['status']}    ${s}    设置状态不正确：${j}
    # \    sleep    100ms

客服设置最大接待数(/v1/tenants/{tenantId}/agents/{agentId}/max-service-number)
    [Documentation]    【操作步骤】：
    ...    - Step1、坐席模式下，调用设置坐席最大接待人数接口：/v1/tenants/{tenantId}/agents/{agentId}/max-service-number，接口请求状态码为200。
    ...    - Step2、查询坐席接待人数和状态信息，调用接口：/v1/Agents/me，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    判断更新状态后的接口返回值字段maxServiceUserNumber相等。
    @{numlist}    create list    ${1}    ${2}
    : FOR    ${i}    IN    @{numlist}
    \    ${j}    Set Agent MaxServiceUserNumber    ${AdminUser}    ${i}
    \    Should Be Equal    ${j['status']}    OK    设置最大接待数失败：${j}
    \    ${j}    Get Agent Status&MaxServiceUserNumber    ${AdminUser}
    \    Should Be Equal    ${j['maxServiceUserNumber']}    ${i}    设置最大接待数不正确：${j}
