*** Settings ***
Force Tags        register
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../../AgentRes.robot
Resource          ../../../api/HomePage/VerifyCode/VerifyCodeApi.robot

*** Test Cases ***
获取图片验证码(/imgVerifyCode)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取图片验证码，调用接口：/imgVerifyCode，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #获取codeId
    ${resp}=    /imgVerifyCode    ${AdminUser}    post    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j['codeId']}    获取图片验证码codeId失败：${j['codeId']}
    set suite variable    ${codeId}    ${j['codeId']}
    #获取验证图片
    ${resp}=    /imgVerifyCode    ${AdminUser}    get    ${timeout}    ${codeId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #log    ${resp.headers.Content-Length}
    log    ${resp.headers}
    log    ${resp.headers['Content-Length']}
    should be true    ${resp.headers['Content-Length']}>0    获取图片验证码失败
