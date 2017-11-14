*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Channels/WeixinApi.robot
Resource          ../../../../api/BaseApi/Channels/WeiboApi.robot

*** Test Cases ***
获取微信授权码(/v1/weixin/admin/preauthcode)
    ${resp}=    /v1/weixin/admin/preauthcode    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Contain    ${resp.content}    preauthcode    微信授权码格式不正确：${resp.content}

获取微博&微信设置(/v1/Admin/TechChannel/WeiboTechChannel)
    : FOR    ${t}    IN    @{WeiboTechChannelType}
    \    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel    ${AdminUser}    ${t}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    Should Not Be Empty    ${resp.content}    返回值为空
    \    ${j}    to json    ${resp.content}
    \    log    ${j}
    \    Run Keyword If    ${j}==[]    log    没有${t}信息
    \    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确

获取微博配置平台接口的URL(/v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl)
    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    微博配置平台接口的url为空
    log    ${resp.content}

获取微博配置平台接口的appkey(/v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey)
    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    微博配置平台接口的APPKEY为空格
