*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Robot/Robot_Api.robot

*** Test Cases ***
获取机器人菜单素材库new(/v1/Tenants/{tenantId}/robot/media/items)
    ${resp}=    /v1/Tenants/{tenantId}/robot/media/items    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${resp.content}
    #Should Be Equal    '${j['first']}'    'True'    返回的机器人菜单素材库不正确：${resp.content}
    #Should Be Equal    '${j['last']}'    'True'    返回的机器人菜单素材库不正确：${resp.content}
