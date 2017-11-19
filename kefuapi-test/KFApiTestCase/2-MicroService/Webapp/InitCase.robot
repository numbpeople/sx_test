*** Settings ***
Force Tags
Resource          ../../../AgentRes.robot
Resource          ../../../commons/MicroService/Webapp/Init_Common.robot

*** Test Cases ***
查看租户过期时间(/v1/tenants/{tenantId}/expire_info)
    ${j}    Get ExpireInfo    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    获取过期时间接口status不为OK: ${j}
    ${status}    Run Keyword And Return Status    Should Contain    ${j['entity']}    tenantId
    run keyword if    ${status}    Should Be Equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    获取过期时间接口tenantId不正确: ${j}
