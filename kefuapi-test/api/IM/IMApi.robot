*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib

*** Keywords ***
/{orgName}/{appName}/chatfiles
    [Arguments]    ${rest}    ${files}    ${timeout}
    [Documentation]    IM上传文件到服务器
    ${header}=    Create Dictionary    Authorization=Bearer ${rest.token}    restrict-access=true
    ${uri}=    set variable    /${rest.orgName}/${rest.appName}/chatfiles
    Run Keyword And Return    Post Request    ${rest.session}    ${uri}    files=${files}    headers=${header}    timeout=${timeout}

/v1/tenantapp/imUser
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenantapp/imUser
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

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
