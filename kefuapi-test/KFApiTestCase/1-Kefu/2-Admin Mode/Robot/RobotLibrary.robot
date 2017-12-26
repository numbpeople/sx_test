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

获取知识库模板(/v1/Tenants/me/robot/rule/items/template)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/rule/items/template    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #log    ${resp.headers.Content-Length}
    log    ${resp.headers}
    log    ${resp.headers['Content-Type']}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败
