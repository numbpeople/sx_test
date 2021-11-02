*** Settings ***
Resource          ../../Common/BaseCommon.robot

*** Keywords ***
/{orgName}/{appName}/chatrooms
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、创建一个聊天室
    ...    2、不分页获取聊天室
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、获取一个聊天室详情
    ...    2、修改聊天室信息
    ...    3、删除聊天室
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}/joined_chatrooms
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取用户加入的聊天室
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}/joined_chatrooms
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、添加单个聊天室成员
    ...    2、删除单个聊天室成员
    ...    3、批量删除聊天室成员
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/users/${pathParamter.userName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}/users
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、批量添加聊天室成员
    ...    2、不分页获取聊天室成员
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}/admin
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、添加聊天室管理员
    ...    2、获取管理员列表
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/admin
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}/admin/{userName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    移除聊天室管理员
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/admin/${pathParamter.userName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}/mute
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、添加聊天室禁言成员
    ...    2、获取聊天室禁言列表
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/mute
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}/mute/{userName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    解除被禁言成员
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/mute/${pathParamter.userName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{org_name}/{app_name}/chatrooms/{RoomID}/blocks/users/{user}
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${user}
    ...    ${header}    ${timeout}
    [Documentation]    1、添加单个用户到聊天室黑名单
    ...    2、从聊天室黑名单移除单个用户
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/blocks/users/${user}
    Run Keyword And Return if    ${method}=='delete'    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/blocks/users
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${header}
    ...    ${data}    ${timeout}
    [Documentation]    1、添加批量用户至聊天室黑名单
    ...    2、获取聊天室黑名单列表
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/blocks/users
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/blocks/users/{user1},{user2}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${user1}    ${user2}
    ...    ${header}    ${timeout}
    [Documentation]    从聊天室黑名单批量移除用户
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/blocks/users/${user1},${user2}
    Run Keyword And Return    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{orgName}/{appName}/chatrooms/{roomId}/announcement
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=    ${file}=
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/announcement
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{roomId}/ban
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=    ${file}=
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/ban
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{roomId}/users
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=    ${file}=
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}    ${data}    ${file}

/{orgName}/{appName}/chatrooms/{chatroomId}/shield
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=    ${file}=
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/${pathParamter.chatroomId}/shield
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}    ${data}    ${file}
/{org_name}/{app_name}/chatrooms/super_admin
    [Documentation]    分页获取聊天室超级管理员列表/添加聊天室超级管理员
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=    ${file}=
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/super_admin
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}
/{org_name}/{app_name}/chatrooms/super_admin/{super_admin}
    [Documentation]    移除超级管理员
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=    ${file}=
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatrooms/super_admin/${pathParamter.super_admin}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}