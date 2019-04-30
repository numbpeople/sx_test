*** Variables ***
&{createroom_body}    name=rooms    owner=    maxusers=500    members=[]
&{modify_room}    name=room_newname    description=test_modify_chatroom    maxusers=888
&{add_multi_member}    usernames=[]
&{add_admin}      newadmin=
&{add_mute_body}    usernames=[]    mute_duration=${86400000}
&{add_multi_blockuser}    usernames=[]

*** Keywords ***
/{org_name}/{app_name}/chatrooms
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${header}    ${data}
    ...    ${timeout}
    [Documentation]    1、创建一个聊天室
    ...    2、不分页获取聊天室
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms?limit=5
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${header}    ${timeout}
    [Documentation]    分页获取所有聊天室
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms?limit=5
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${header}
    ...    ${data}    ${timeout}
    [Documentation]    1、获取一个聊天室详情
    ...    2、修改聊天室信息
    ...    3、删除聊天室
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}
    Run Keyword And Return if    ${method}=='put'    Put Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='delete'    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/users/{user}/joined_chatrooms
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${user}    ${header}    ${timeout}
    [Documentation]    获取用户加入的聊天室
    ${uri}=    set variable    /${org_name}/${app_name}/users/${user}/joined_chatrooms
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/users?pagenum=1&pagesize=3
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${header}    ${timeout}
    [Documentation]    分页获取聊天室成员
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/users?pagenum=1&pagesize=3
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/users/{user}
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${user}
    ...    ${header}    ${timeout}
    [Documentation]    1、添加单个聊天室成员
    ...    2、删除单个聊天室成员
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/users/${user}
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='delete'    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/users
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${header}
    ...    ${data}    ${timeout}
    [Documentation]    1、批量添加聊天室成员
    ...    2、不分页获取聊天室成员
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/users
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/users/{user1},{user2}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${user1}    ${user2}
    ...    ${header}    ${timeout}
    [Documentation]    批量删除聊天室成员
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/users/${user1},${user2}
    Run Keyword And Return    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/admin
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${header}
    ...    ${data}    ${timeout}
    [Documentation]    1、添加聊天室管理员
    ...    2、获取管理员列表
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/admin
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/admin/{adminuser}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${adminuser}    ${header}
    ...    ${timeout}
    [Documentation]    移除聊天室管理员
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/admin/${adminuser}
    Run Keyword And Return    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/mute
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${header}
    ...    ${data}    ${timeout}
    [Documentation]    1、添加聊天室禁言成员
    ...    2、获取聊天室禁言列表
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/mute
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/{org_name}/{app_name}/chatrooms/{RoomID}/mute/{muteuser}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${RoomID}    ${muteuser}    ${header}
    ...    ${timeout}
    [Documentation]    解除被禁言成员
    ${uri}=    set variable    /${org_name}/${app_name}/chatrooms/${RoomID}/mute/${muteuser}
    Run Keyword And Return    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

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
