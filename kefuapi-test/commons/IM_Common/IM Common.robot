*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../api/IM/IMApi.robot

*** Keywords ***
Upload File
    [Arguments]    ${rest}    ${files}    ${timeout}
    [Documentation]    使用第一通道上传文件
    #IM上传文件到服务器
    ${file_data}    evaluate    ('${files.filename}', open('${files.filepath}','rb'),'${files.contentType}',{'Expires': '0'})
    &{file}    Create Dictionary    file=${file_data}
    ${resp}=    /{orgName}/{appName}/chatfiles    ${restentity}    ${file}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

get token by credentials
    [Arguments]    ${session}    ${channel}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    #${postdata}=    Create Dictionary    grant_type=client_credentials    client_id=${client_id}    client_secret=${client_secret}
    ${postdata}=    set variable    {"grant_type": "client_credentials","client_id": "${channel['clientId']}","client_secret": "${channel['clientSecret']}"}
    ${str}=    Replace String    ${channel['appKey']}    \#    \/
    ${uri}=    set variable    /${str}/token
    ${data}    Post Request    ${session}    ${uri}    data=${postdata}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

get token by password
    [Arguments]    ${session}    ${appkey}    ${username}    ${password}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    #${postdata}=    Create Dictionary    grant_type=password    username=${username}    password=${password}
    ${postdata}=    set variable    {"grant_type": "password","username": "${username}","password": "${password}"}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/token
    ${data}    Post Request    ${session}    ${uri}    data=${postdata}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

send msg
    [Arguments]    ${rest}    ${guest}    ${msg}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${rest.token}
    ${postdata}    set variable    {"target_type":"users","target":["${rest.serviceEaseMobIMNumber}"],"msg":{"type":"${msg.type}","msg":"${msg.msg}"},"from":"${guest.userName}","ext":${msg.ext}}
    #判断如果msg中包含指定key，重新设置data值
    ${status}    Run Keyword And Return Status    Should Contain    ${msg.msg}    ${msg.key}
    log    ${status}
    Run Keyword If    ${status}    set test variable    ${postdata}    {"target_type":"users","target":["${rest.serviceEaseMobIMNumber}"],"msg":${msg.msg},"from":"${guest.userName}","ext":${msg.ext}}
    ${uri}=    set variable    /${rest.orgName}/${rest.appName}/messages
    ${data}    Post Request    ${rest.session}    ${uri}    data=${postdata}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

GetChannel
    [Arguments]    ${session}    ${appkey}    ${token}    ${target}    ${users}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/users/${users}/tenantApi/imchanel?imNumber=${target}
    ${data}    Get request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
    Return From Keyword    ${data}

Get IM Login Token
    [Arguments]    ${rest}    ${visitorEntity}
    [Documentation]    获取IM号的登录token
    ${header}=    Create Dictionary    Content-Type=application/json
    ${data}=    set variable    {"grant_type":"password","username":"${visitorEntity.username}","password":"${visitorEntity.password}"}
    ${resp}    /{orgName}/{appName}/token    ${rest}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}