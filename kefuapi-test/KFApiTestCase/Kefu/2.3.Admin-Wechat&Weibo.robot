*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../AgentRes.robot
Resource          ../../api/BaseApi/Channels/WeixinApi.robot

*** Test Cases ***
获取微信授权码(/v1/weixin/admin/preauthcode)
    ${resp}=    /v1/weixin/admin/preauthcode    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Contain    ${resp.content}    preauthcode    微信授权码格式不正确：${resp.content}
