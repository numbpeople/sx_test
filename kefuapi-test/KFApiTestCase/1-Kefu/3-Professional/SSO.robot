*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/HomePage_Common/SSO_Common.robot

*** Test Cases ***
获取单点登录配置(/v1/access/config)
    ${j}    Get Access Config    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${j}

获取单点登录跳转的地址信息(/v1/access)
    ${j}    Get Access    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${j}
