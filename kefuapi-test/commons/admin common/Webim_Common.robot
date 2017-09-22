*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../api/KefuApi.robot
Resource          ../../api/RoutingApi.robot
Resource          ../../api/SystemSwitch.robot
Resource          ../../api/SessionCurrentApi.robot
Resource          ../../api/SettingsApi.robot
Resource          ../../api/WebimChannels.robot

*** Keywords ***
Get Template
    [Arguments]    ${agent}
    [Documentation]    获取网页插件模板
    #获取时间计划
    ${resp}=    /v1/webimplugin/settings/template    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    set variable    ${resp.content}
    Return From Keyword    ${j}

Configs
    [Arguments]    ${agent}    ${method}=get    ${data}=    ${configId}=
    [Documentation]    获取/新增/删除/修改 网页插件配置信息
    #获取时间计划
    ${resp}=    /v1/webimplugin/settings/tenants/{tenantId}/configs    ${AdminUser}    ${method}    ${timeout}    ${data}    ${configId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Update Config
    [Arguments]    ${agent}    ${configId}    ${data}
    [Documentation]    修改 网页插件配置信息
    #更新配置
    ${resp}=    /v1/webimplugin/settings/tenants/{tenantId}/configs/{configId}/global    ${AdminUser}    ${timeout}    ${configId}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
