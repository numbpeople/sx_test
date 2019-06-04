*** Settings ***
Resource          ../../Common/BaseCommon.robot

*** Keywords ***
/{orgName}/{appName}/chatgroups
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、不分页获取APP下的群组
    ...    2、创建群组
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、获取单个群详情
    ...    2、转让群组
    ...    3、修改群组信息
    ...    4、删除群组
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/users/{userName}/joined_chatgroups
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取IM用户加入的所有群组
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/users/${pathParamter.userName}/joined_chatgroups
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/users/{userName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、添加单个群组成员
    ...    2、移除群组成员
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/users/${pathParamter.userName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/users
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、分页获取一个群组的群成员列表。2、批量添加群组成员
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/admin
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、添加群管理员
    ...    2、获取群管理员列表
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/admin
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/admin/{adminName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    移除群管理员
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/admin/${pathParamter.adminName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/{userName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、添加单个用户到黑名单
    ...    2、从黑名单移除单个用户
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/blocks/users/${pathParamter.userName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、添加批量用户到群组黑名单
    ...    2、获取群组黑名单列表
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/blocks/users
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/mute
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    1、禁言群成员
    ...    2、获取禁言成员列表
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/mute
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatgroups/{groupId}/mute/{userName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    解除禁言
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatgroups/${pathParamter.groupId}/mute/${pathParamter.userName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{org_name}/{app_name}/publicchatgroups
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${header}    ${timeout}
    [Documentation]    不分页获取APP下的公开群组
    ${uri}=    set variable    /${org_name}/${app_name}/publicchatgroups
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatgroups/{groupid1}{groupid2}{groupid3}{groupid4}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${groupid1}    ${groupid2}    ${groupid3}
    ...    ${groupid4}    ${header}    ${timeout}
    [Documentation]    获取多个群详情
    ${uri}=    set variable    /${org_name}/${app_name}/chatgroups/${groupid1},${groupid2},${groupid3},${groupid4}
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatgroups/{groupid}/users/{memb1},{memb2},{memb3}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${groupid}    ${memb1}    ${memb2}
    ...    ${memb3}    ${header}    ${timeout}
    [Documentation]    批量删除群组成员
    ${uri}=    set variable    /${org_name}/${app_name}/chatgroups/${groupid}/users/${memb1},${memb2},${memb3}
    Run Keyword And Return    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatgroups/{groupid}/blocks/users/{blockuser1}{blockuser2}{blockuser3}
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${groupid}    ${blockuser1}    ${blockuser2}
    ...    ${blockuser3}    ${header}    ${timeout}
    [Documentation]    从群组黑名单中批量移除用户
    ${uri}=    set variable    /${org_name}/${app_name}/chatgroups/${groupid}/blocks/users/${blockuser1},${blockuser2},${blockuser3}
    Run Keyword And Return    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatgroups/{groupid}/apply
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${groupid}    ${header}    ${timeout}
    [Documentation]    用户申请加入群组
    ${uri}=    set variable    /${org_name}/${app_name}/chatgroups/${groupid}/apply
    ${joingrpBody}    set variable    {"message":"join group"}
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${joingrpBody}    timeout=${timeout}

/{org_name}/{app_name}/chatgroups/{groupid}/apply_verify
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${groupid}    ${header}    ${data}
    ...    ${timeout}
    [Documentation]    审批申请加入群组的用户
    ${uri}=    set variable    /${org_name}/${app_name}/chatgroups/${groupid}/apply_verify
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/{org_name}/{app_name}/chatgroups/{groupid}/quit
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${groupid}    ${header}    ${timeout}
    [Documentation]    离开群组
    ${uri}=    set variable    /${org_name}/${app_name}/chatgroups/${groupid}/quit
    Run Keyword And Return    delete Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/{org_name}/{app_name}/chatgroups/{groupid}/share_files
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${groupid}    ${header}    ${timeout}
    [Documentation]    获取群共享文件列表
    ${uri}=    set variable    /${org_name}/${app_name}/chatgroups/${groupid}/share_files
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
