*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/SendMessageCommon/SendMessageCommon.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/SendMessageResult/SendMessage_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot
Resource          ../../Common/GetMessageCommon/GetMessageCommo.robot
*** Test Cases ***
获取历史消息为空
    
获取历史消息有内容

获取用户消息漫游(/{org_name}/{app_name}/users/{user_name}/messageroaming)
    [Documentation]    获取漫游消息
    ${resp}=    创建一个新用户    session
    ${result}    to json    ${resp.content}
    ${user_name}    Set Variable    ${result["entities"][0]["username"]}
    ${header}    Create Dictionary    Accept=${appreciationservice.Accept}    Content-Type=${appreciationservice.ContentType}    Authorization=Bearer ${appreciationservice.orgtoken}
    ${data}    Set Variable    {"queue":"test2@easemob.com","start":-1,"end":-1}
    ${resp1}=    /{org_name}/{app_name}/users/{user_name}/messageroaming    session    ${appreciationservice.orgname}    ${appreciationservice.appname}    ${user_name}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    200    ${resp1.status_code}    不正确的状态码:${resp1.status_code},错误原因:${resp1.content}
    ${result}    to json    ${resp1.content}
    Should Be Equal As Strings    get message roaming    ${result["action"]}
    Should Be Empty    ${result["data"]["msgs"]}    
 
查询漫游消息消息设置
    