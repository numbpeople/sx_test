*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        webim
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          AgentRes.robot
Resource          KefuApi.robot

*** Test Cases ***
网页插件下班时间是否显示留言(/v1/webimplugin/showMessage)
    ${resp}=    /v1/webimplugin/showMessage    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==${True}    log    下班时间显示留言
    ...    ELSE IF    ${j}==${False}    log    下班时间不显示留言
    ...    ELSE    Should Be True    ${j}    下班时间是否显示留言返回结果不正确

网页插件获取欢迎语(/v1/webimplugin/welcome)
    ${resp}=    /v1/webimplugin/welcome    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}    #Run Keyword If    ${resp.content}==''    log
    ...    # 欢迎语未开启    # ELSE    log    ${resp.content}

网页插件获取主题信息(/v1/webimplugin/theme/options)
    ${resp}=    /v1/webimplugin/theme/options    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==[]    log    主题为空
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确

网页插件获取信息栏信息(/v1/webimplugin/notice/options)
    ${resp}=    /v1/webimplugin/notice/options    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==[]    log    主题为空
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确
