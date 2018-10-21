*** Settings ***
Force Tags        customerTags
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/CustomerTagApi.robot
Resource          ../../../../commons/admin common/Setting/CustomerTags_Common.robot

*** Test Cases ***
获取访客标签(/v1/Admin/UserTags)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客标签，调用接口：/v1/Admin/UserTags，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、total_entries字段值大于0。
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    per_page=100
    #获取访客标签
    ${j}    Set UserTags    get    ${AdminUser}    ${filter}
    Should Be True    ${j['total_entries']}>=0    获取的访客标签数不正确：${j}

添加访客标签(/v1/Admin/UserTags)
    [Documentation]    【操作步骤】：
    ...    - Step1、添加访客标签，调用接口：/v1/Admin/UserTags，接口请求状态码为201。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为201、返回字段值等于预期。
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

修改访客标签(/v1/Admin/UserTags)
    [Documentation]    【操作步骤】：
    ...    - Step1、添加访客标签，调用接口：/v1/Admin/UserTags，接口请求状态码为200。
    ...    - Step2、修改访客标签，调用接口：/v1/Admin/UserTags，接口请求状态码为204。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为204、返回值等于空。
    #创建客户标签
    ${userTagResult}    Create UserTag    ${AdminUser}
    ${userTagId}    set variable    ${userTagResult.userTagId}    #获取客户标签id
    ${createDateTime}    set variable    ${userTagResult.createDateTime}    #获取客户标签创建时间
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    per_page=100
    #创建请求体
    ${uuid}    Uuid 4
    ${tagName}    set variable    修改客户标签-${AdminUser.tenantId}-${uuid}
    &{updateUserTagEntity}    create dictionary    tenantId=${AdminUser.tenantId}    userTagId=${userTagId}    tagName=${tagName}    createDateTime=${createDateTime}
    ${data}    set variable    {"tenantId":${AdminUser.tenantId},"userTagId":${updateUserTagEntity.userTagId},"tagName":"${updateUserTagEntity.tagName}","createDateTime":"${updateUserTagEntity.createDateTime}"}
    #修改访客标签
    ${j}    Set UserTags    put    ${AdminUser}    ${filter}    ${data}    ${updateUserTagEntity.userTagId}
    Should Be Equal    ${j}    ${EMPTY}    接口返回不是空,${j}

删除访客标签(/v1/Admin/UserTags)
    [Documentation]    【操作步骤】：
    ...    - Step1、添加访客标签，调用接口：/v1/Admin/UserTags，接口请求状态码为200。
    ...    - Step2、删除访客标签，调用接口：/v1/Admin/UserTags，接口请求状态码为204。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为204、返回值等于空。
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity}
    #创建客户标签
    ${userTagResult}    Create UserTag    ${AdminUser}
    ${userTagId}    set variable    ${userTagResult.userTagId}    #获取客户标签id
    #删除访客标签
    ${j}    Set UserTags    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${userTagId}
    Should Be Equal    ${j}    ${EMPTY}    接口返回不是空,${j}

导出客户标签(/v1/Admin/UserTags/exportfile)
    [Documentation]    【操作步骤】：
    ...    - Step1、导出客户标签，调用接口：/v1/Admin/UserTags/exportfile，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值headers中Content-Disposition字段值等于“attachment;filename=客户标签”。
    #导出客户标签
    ${resp}    Export UserTag    ${AdminUser}
    Should Contain    ${resp.headers['Content-Disposition']}    attachment;filename=客户标签    导出客户标签失败
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    导出客户标签失败

导出客户标签下载模板(/download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx)
    [Documentation]    【操作步骤】：
    ...    - Step1、导出客户标签下载模板，调用接口：/download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #导出客户标签下载模板
    ${resp}    Export UserTag Template    ${AdminUser}
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream    导出客户标签下载模板失败
