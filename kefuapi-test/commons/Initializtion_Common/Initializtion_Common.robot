*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/InitApi.robot
Resource          ../../api/MicroService/Organ/OrgApi.robot
Resource          ../../api/MicroService/WebGray/WebGrayApi.robot

*** Keywords ***
Initdata
    [Arguments]    ${agent}
    [Documentation]    获取登录客服账号的初始化的数据
    ...    参数:
    ...    ${agent}:登录的账号、密码信息、状态等参数
    #获取登录客服账号的初始化的数据
    ${resp}=    /home/initdata    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get OrganInfo
    [Arguments]    ${agent}
    [Documentation]    获取租户id所在的organ信息
    ...    参数:
    ...    ${agent}:登录的账号、密码信息、状态等参数
    #获取租户id所在的organ信息
    ${resp}=    /v2/infos    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get Tenant GrayLists
    [Arguments]    ${agent}
    [Documentation]    获取租户id的灰度列表
    ...    参数:
    ...    ${agent}:登录的账号、密码信息、状态等参数
    #获取租户id的灰度列表
    ${resp}=    /v1/grayscale/tenants/{tenantId}    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get Agent Status
    [Arguments]    ${agent}
    [Documentation]    获取客服登录后的最大接待数、状态、userId值
    ...    参数:
    ...    ${agent}:登录的账号、密码信息、状态等参数
    #获取客服登录后的最大接待数、状态、userId值
    ${resp}=    /v1/Agents/me    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get Agent Info
    [Arguments]    ${agent}
    [Documentation]    获取客服登录后账号、接待人数、个人信息等
    ...    参数:
    ...    ${agent}:登录的账号、密码信息、状态等参数
    #获取客服登录后账号、接待人数、个人信息等
    ${resp}=    /v1/Tenants/me/Agents/me    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Get Tenant Info
    [Arguments]    ${agent}
    [Documentation]    获取租户信息
    ...    参数:
    ...    ${agent}:登录的账号、密码信息、状态等参数
    #获取租户信息
    ${resp}=    /v1/Tenants/me    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}