*** Settings ***
Force Tags
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Setting/Company_Common.robot

*** Test Cases ***
查看租户过期时间(/v1/tenants/{tenantId}/expire_info)
    [Documentation]    【操作步骤】：
    ...    - Step1、查看租户过期时间，调用接口：/v1/tenants/{tenantId}/expire_info，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    ${j}    Get ExpireInfo    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    获取过期时间接口status不为OK: ${j}
    ${status}    Run Keyword And Return Status    Should Contain    ${j['entity']}    tenantId
    run keyword if    ${status}    Should Be Equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    获取过期时间接口tenantId不正确: ${j}
