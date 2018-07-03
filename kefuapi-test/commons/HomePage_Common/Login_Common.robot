*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../AgentRes.robot
Resource          ../../api/HomePage/Login/Login_Api.robot

*** Keywords ***
Login
    [Arguments]    ${session}    ${agent}
    [Documentation]    登录客服账号
    ...    参数:
    ...    ${session}:创建连接的别名
    ...    ${agent}:登录的账号、密码信息、状态等参数
    #登录客服账号
    ${resp}=    /login    ${session}    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.text}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Login、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    return from keyword    ${j}    ${resp}