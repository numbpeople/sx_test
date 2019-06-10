*** Settings ***
Resource          ../../Common/BaseCommon.robot

*** Keywords ***
/{orgName}/{appName}/users
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    创建单个用户、批量用户、获取批量IM用户、批量删除用户
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取单个IM用户详情，删除单个IM用户, 修改用户昵称和device_token，修改推送显示方式
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{imUser}/password
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    重置IM用户密码API
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.imUser}/password
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    添加和删除好友接口
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.ownerUsername}/contacts/users/${pathParamter.friendUsername}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{ownerUsername}/contacts/users
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取IM用户好友列表
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.ownerUsername}/contacts/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{ownerUsername}/blocks/users
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、往 IM 用户的黑名单中加人
    ...    2、获取IM用户黑名单
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.ownerUsername}/blocks/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{ownerUsername}/blocks/users/{blockedUsername}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    从 IM 用户的黑名单中减人
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.ownerUsername}/blocks/users/${pathParamter.blockedUsername}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}/status
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    查看单个用户在线状态
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}/status
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/batch/status
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    查看批量用户在线状态
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/batch/status
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}/offline_msg_count
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取用户离线消息数
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}/offline_msg_count
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}/offline_msg_status/{msgId}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取某条离线消息状态
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}/offline_msg_status/${pathParamter.msgId}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}/deactivate
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    封禁用户帐号
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}/deactivate
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}/activate
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    解除用户帐号封禁
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}/activate
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{org_name}/{app_name}/users/{user_name}/disconnect
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user_name}    ${header}    ${timeout}
    [Documentation]    强制用户下线
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user_name}/disconnect
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
