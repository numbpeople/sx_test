*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../RestApi/SendMessage/SendMessageApi.robot
Resource          ../../Variable_Env.robot
Resource          ../BaseCommon.robot
Resource          ../UserCommon/UserCommon.robot
Resource          ../FileUploadDownloadCommon/FileUploadDownloadCommon.robot
Resource          ../../RestApi/RoamingMessage/RoamingMessageApi.robot
*** Keywords ***
创建一个新用户
    [Arguments]    ${session}
    [Documentation]    在指定的appkey下创建一个新用户
    ${pathParamter}    Create Dictionary    orgName=${appreciationservice.orgname}    appName=${appreciationservice.appname}
    ${header}    Create Dictionary    Accept=${appreciationservice.Accept}    Content-Type=${appreciationservice.ContentType}    Authorization=${appreciationservice.orgtoken}
    ${username}    random userid
    ${data}    Set Variable    {"username":"${username}", "password":"1"}
    ${resp}=    /{orgName}/{appName}/users    POST    ${session}    ${header}    ${pathParamter}    NONE    ${data}
    [Return]    ${resp}
random userid
    #产生一个随机字符串
    ${string}=    Generate Random String
    [Return]    ${string}
random username
    ${num}    Evaluate    str(random.random())[-6:]    random
    [Return]    ${num}
random password
    [Documentation]
    ${password}    Evaluate    str(random.random())[-3:]    random
    [Return]    ${password}
    
# 获取漫游消息
#     # [Arguments]
#     [Documentation]    获取漫游消息
#     ${resp}=    创建一个新用户    session
#     ${result}    to json    ${resp.content}
#     ${user_name}    Set Variable    ${result["entities"][0]["username"]}
#     ${header}    Create Dictionary    Accept=${Accept}    Content-Type=${Content-Type}    Authorization=${orgtoken}
#     ${data}    Set Variable    {"queue":"test2@easemob.com","start":-1,"end":-1}
#     ${resp1}=    /{org_name}/{app_name}/users/{user_name}/messageroaming    session    ${orgname}    ${appname}    ${user_name}    ${uri}    ${header}    ${data}    ${timeout}
# 查询漫游消息设置
#     ${resp}=    创建一个新用户    session
#     ${result}    to json    ${resp.content}
#     ${user_name}    Set Variable    ${result["entities"][0]["username"]}
#     ${header}    Create Dictionary    Accept=${Accept}    Content-Type=${Content-Type}    Authorization=${orgtoken}
#     ${data}    Set Variable    {"queue":"test2@easemob.com","start":-1,"end":-1}
#     ${resp1}=    /{orgName}/{appName}/chatmessages/roaming_settings?settingType={msg_type}   session    ${orgname}    ${appname}    ${user_name}    ${uri}    ${header}    ${data}    ${timeout}
