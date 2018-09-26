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
    [Documentation]    【操作步骤】：
    ...    - Step1、获取微信授权码，调用接口：/v1/weixin/admin/preauthcode，接口请求状态码为200。
    ...    - Step2、检查返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，返回值中应包含preauthcode字符。
    ${resp}=    /v1/weixin/admin/preauthcode    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    【实际结果】：获取微信授权码，返回实际状态码：${resp.status_code}，调用接口：${resp.url}，接口返回值：${resp.text}
    Should Contain    ${resp.content}    preauthcode    微信授权码格式不正确：${resp.content}

获取微博&微信设置(/v1/Admin/TechChannel/WeiboTechChannel)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取微博&微信设置，调用接口：/v1/Admin/TechChannel/WeiboTechChannel，接口请求状态码为200。
    ...    - Step2、检查返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，如果结果不为空，则tenantId等于租户id。
    : FOR    ${t}    IN    @{WeiboTechChannelType}
    \    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel    ${AdminUser}    ${t}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    【实际结果】：获取微博&微信设置，返回实际状态码：${resp.status_code}，调用接口：${resp.url}，接口返回值：${resp.text}
    \    Should Not Be Empty    ${resp.content}    返回值为空
    \    ${j}    to json    ${resp.content}
    \    log    ${j}
    \    Run Keyword If    ${j}==[]    log    没有${t}信息
    \    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确

获取微博配置平台接口的URL(/v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取微博配置平台接口的URL，调用接口：/v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl，接口请求状态码为200。
    ...    - Step2、检查返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，返回值不允许为空。
    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    【实际结果】：获取微博配置平台接口的URL，返回实际状态码：${resp.status_code}，调用接口：${resp.url}，接口返回值：${resp.text}
    Should Not Be Empty    ${resp.content}    微博配置平台接口的url为空
    log    ${resp.content}

获取微博配置平台接口的appkey(/v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取微博配置平台接口的appkey，调用接口：/v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey，接口请求状态码为200。
    ...    - Step2、检查返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，返回值不允许为空。
    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    【实际结果】：获取微博配置平台接口的appkey，返回实际状态码：${resp.status_code}，调用接口：${resp.url}，接口返回值：${resp.text}
    Should Not Be Empty    ${resp.content}    微博配置平台接口的APPKEY为空格
