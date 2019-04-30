*** Keywords ***
/{orgName}/{appName}/users
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    创建单个和批量用户，获取批量IM用户
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{org_name}/{app_name}/users/{username}
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${username}    ${header}
    ...    ${data}    ${timeout}
    [Documentation]    获取单个IM用户详情，删除单个IM用户, 修改用户昵称和device_token，修改推送显示方式
    ${uri}=    set variable    /${org_name}/${app_name}/users/${username}
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='delete'    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='put'    Put Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/{org_name}/{app_name}/users?limit=8
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${header}    ${timeout}
    [Documentation]    分页获取批量IM用户，批量删除IM用户
    ${uri}=    set variable    /${org_name}/${app_name}/users?limit=8
    Run Keyword And Return if    ${method}=='delete'    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{IMuser}/password
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${IMuser}    ${header}    ${data}
    ...    ${timeout}
    [Documentation]    重置IM用户密码API
    ${uri}=    set variable    /${org_name}/${app_name}/users/${IMuser}/password
    Run Keyword And Return    Put Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/{org_name}/{app_name}/users/{user_name}/status
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user_name}    ${header}    ${timeout}
    [Documentation]    查看单个用户在线状态
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user_name}/status
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/batch/status
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${header}    ${data}    ${timeout}
    [Documentation]    查看批量用户在线状态
    ${uri}=    set variable    /${org_name}/${app_name}/users/batch/status
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/{org_name}/{app_name}/users/{user_name}/deactivate
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user_name}    ${header}    ${timeout}
    [Documentation]    封禁用户帐号
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user_name}/deactivate
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{user_name}/activate
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user_name}    ${header}    ${timeout}
    [Documentation]    解除用户帐号封禁
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user_name}/activate
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{user_name}/disconnect
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user_name}    ${header}    ${timeout}
    [Documentation]    强制用户下线
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user_name}/disconnect
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{user1}/contacts/users/{user2}
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${user1}    ${user2}
    ...    ${header}    ${timeout}
    [Documentation]    添加和删除好友接口
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user1}/contacts/users/${user2}
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='delete'    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{username}/contacts/users
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${username}    ${header}    ${timeout}
    [Documentation]    获取IM用户好友列表
    ${uri}=    set variable    /${org_name}/${app_name}/users/${username}/contacts/users
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{username}/blocks/users
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${username}    ${header}
    ...    ${data}    ${timeout}
    [Documentation]    1、往 IM 用户的黑名单中加人
    ...    2、获取IM用户黑名单
    ${uri}=    set variable    /${org_name}/${app_name}/users/${username}/blocks/users
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{user1}/blocks/users/{user2}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user1}    ${user2}    ${header}
    ...    ${timeout}
    [Documentation]    从 IM 用户的黑名单中减人
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user1}/blocks/users/${user2}
    Run Keyword And Return    Delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{user1}/offline_msg_count
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user1}    ${header}    ${timeout}
    [Documentation]    获取用户离线消息数
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user1}/offline_msg_count
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
