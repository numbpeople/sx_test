*** Settings ***
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
获取访客标签数据(/v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/)
    :FOR    ${visitorid}    IN    @{visitorUserId}
    \    ${resp}=    /v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/    ${AdminUser}    ${visitorid}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    Should Not Be Empty    ${resp.content}    返回值为空
    \    ${j}    to json    ${resp.content}
    \    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的访客数据中tenantId不正确
    \    Should Be Equal    ${j[0]['visitorUserId']}    ${visitorid}    返回的访客数据中userId不正确

获取访客标签(/v1/Admin/UserTags)
    [Documentation]    获取访客标签
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity}   
    set to dictionary    ${filter}    per_page=100
    #获取访客标签
    ${j}    Set UserTags    get    ${AdminUser}    ${filter}
    Should Be True    ${j['total_entries']}>=0    获取的访客标签数不正确：${j}

添加访客标签(/v1/Admin/UserTags)
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

修改访客标签(/v1/Admin/UserTags)
    [Documentation]    1、添加客户标签    2、修改访客标签
    #创建客户标签
    ${userTagResult}    Create UserTag    ${AdminUser}
    ${userTagId}    set variable   ${userTagResult.userTagId}    #获取客户标签id
    ${createDateTime}    set variable   ${userTagResult.createDateTime}    #获取客户标签创建时间
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
    Should Be Equal      ${j}    ${EMPTY}    接口返回不是空,${j}

删除访客标签(/v1/Admin/UserTags)
    [Documentation]    1、添加客户标签    2、删除访客标签
    #创建局部变量筛选条件
    ${filter}    copy dictionary    ${FilterEntity} 
    #创建客户标签
    ${userTagResult}    Create UserTag    ${AdminUser}
    ${userTagId}    set variable   ${userTagResult.userTagId}    #获取客户标签id
    #删除访客标签
    ${j}    Set UserTags    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${userTagId}
    Should Be Equal      ${j}    ${EMPTY}    接口返回不是空,${j}

导出客户标签(/v1/Admin/UserTags/exportfile)
    [Documentation]    导出客户标签
    #导出客户标签
    ${resp}    Export UserTag    ${AdminUser}
    Should Contain    ${resp.headers['Content-Disposition']}    attachment;filename=客户标签    导出客户标签失败
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    导出客户标签失败

导出客户标签下载模板(/download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx)
    [Documentation]    导出客户标签下载模板
    #导出客户标签下载模板
    ${resp}    Export UserTag Template    ${AdminUser}
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream    导出客户标签下载模板失败
