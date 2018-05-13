*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/CustomerTagApi.robot

*** Keywords ***
Set UserTags
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}=    ${userTagId}=
    [Documentation]    获取客户标签
    #获取客户标签
    ${resp}=    /v1/Admin/UserTags    ${method}    ${agent}    ${filter}    ${data}    ${userTagId}    ${timeout}
    run keyword if    '${method}'=='put' or '${method}'=='delete'    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='get'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword if    '${method}'=='put' or '${method}'=='delete'    ${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Create UserTag
    [Arguments]    ${agent}
    [Documentation]    添加访客标签
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity}   
    set to dictionary    ${filter}    per_page=100
    #创建请求体
    ${uuid}    Uuid 4
    ${tagName}    set variable    新增客户标签-${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"tagName":"${tagName}"}
    #添加访客标签
    ${j}    Set UserTags    post    ${AdminUser}    ${filter}    ${data}
    Should Be True    "${j['tagName']}"=="${tagName}"    接口返回tagName字段值不正确,应为:${tagName},${j}
    Should Be True    ${j['tenantId']}==${AdminUser.tenantId}    接口返回tenantId字段值不正确,应为:${AdminUser.tenantId},${j}
    #创建返回字典
    &{userTagEntity}    create dictionary    tagName=${tagName}    userTagId=${j['userTagId']}    createDateTime=${j['createDateTime']}
    return from keyword    ${userTagEntity}

Export UserTag
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出客户标签
    #导出客户标签
    ${resp}=    /v1/Admin/UserTags/exportfile    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword    ${resp}

Export UserTag Template
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出客户标签下载模板
    #导出客户标签下载模板
    ${resp}=    /download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword    ${resp}