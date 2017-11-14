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
获取机器人推荐状态(/v1/Tenants/{tenantId}/robots/recommendation/status)
    ${resp}=    /v1/Tenants/{tenantId}/robots/recommendation/status    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    log    ${j}

获取机器人推荐开关信息？(/v1/Tenants/{tenantId}/robots/recommendationSwitch)
    ${resp}=    /v1/Tenants/{tenantId}/robots/recommendationSwitch    ${AdminUser}    ${switchType}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

获取机器人知识规则(/v1/Tenants/me/robot/rules)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/rules    ${AdminUser}    ${RobotRulesEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的机器人知识规则不正确：${resp.content}

获取机器人知识规则条数(/v1/Tenants/me/robot/rule/group/count)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/rule/group/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j} >= 0    机器人知识规则条数：${resp.content}

获取机器人自定义菜单(/v1/Tenants/me/robot/menu/items)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/menu/items    ${AdminUser}    ${RobotRulesEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${resp.content}

获取机器人设置(/v1/Tenants/me/robot/profile/setting)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/profile/setting    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人设置信息不正确：${resp.content}

获取机器人信息(/v1/Tenants/me/robot/profile/personalInfo)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/profile/personalInfo    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取机器人闲聊开关信息(/v1/Tenants/{tenantId}/robots/freechat)
    ${resp}=    /v1/Tenants/{tenantId}/robots/freechat    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    #Should Be Equal As Integers    ${j['tenantId']}    ${tenantId}    返回的机器人信息不正确：${resp.content}
    Run Keyword If    ${j}==${True}    log    闲聊功能开启
    ...    ELSE IF    ${j}==${False}    log    闲聊功能关闭
    ...    ELSE    Should Be True    ${j}    闲聊开关信息不正确：${resp.content}

获取机器人信息new(/v1/Tenants/{tenantId}/robot/profile/personalInfo)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfo    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取多机器人信息(/v1/Tenants/{tenantId}/robot/profile/personalInfos)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfos    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['content'][0]['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取机器人设置new(/v1/Tenants/{tenantId}/robot/profile/setting)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/setting    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取多机器人设置(/v1/Tenants/{tenantId}/robot/profile/settings)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/settings    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['content'][0]['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取机器人欢迎语(/v1/Tenants/{tenantId}/robots/greetings)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robots/greetings    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    #${j}    to json    ${resp.content}
    #Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人欢迎语不正确：${resp.content}
    #log    ${resp.content}

获取机器人默认回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Tags]
    set test variable    ${tf}    ${RobotFilter}
    set to dictionary    ${tf}    type=0
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${AdminUser}    ${tf}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人默认回复不正确：${resp.content}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人默认回复不正确：${resp.content}

获取机器人重复回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Tags]
    set test variable    ${tf}    ${RobotFilter}
    set to dictionary    ${tf}    type=1
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人重复回复不正确：${resp.content}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人重复回复不正确：${resp.content}

获取机器人超时回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Tags]
    set test variable    ${tf}    ${RobotFilter}
    set to dictionary    ${tf}    type=2
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人重复回复不正确：${resp.content}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人重复回复不正确：${resp.content}

获取机器人转人工设置(/v1/Tenants/{tenantId}/robots/robotUserTransferKf)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robots/robotUserTransferKf    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人欢迎语不正确：${resp.content}
    log    ${resp.content}

获取机器人知识规则new(/v1/Tenants/{tenantId}/robot/rules)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/rules    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的机器人知识规则不正确：${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人知识规则不正确：${resp.content}

获取机器人知识规则数量new(/v1/Tenants/{tenantId}/robot/rule/group/count)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/rule/group/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j}>=0    返回的机器人知识规则数量不正确：${resp.content}

获取知识库模板new(/v1/Tenants/{tenantId}/robot/rule/items/template)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/rule/items/template    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #log    ${resp.headers.Content-Length}
    log    ${resp.headers}
    log    ${resp.headers['Content-Type']}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败

获取机器人自定义菜单new(/v1/Tenants/{tenantId}/robot/menu/items)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/menu/items    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人自定义菜单不正确：${resp.content}

获取智能场景应答(/v1/Tenants/{tenantId}/robots/intent/list)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robots/intent/list    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['logistics']['name']}'    '物流'    返回的机器人只能场景应答信息不正确：${resp.content}
