*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/ConversationTagApi.robot
Resource          ../../../../commons/admin common/Setting/ConversationTags_Common.robot

*** Test Cases ***
获取所有会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取所有会话标签，调用接口：/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #创建参数字典
    &{conversationTagEntity}    create dictionary    systemOnly=false    buildCount=true
    #获取会话标签数据
    ${j}    Get Conversation Tags    get    ${AdminUser}    0    ${conversationTagEntity}
    # Should Not Be Empty    ${j[0]['children']}    会话标签为空

创建会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建会话标签，调用接口：/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、各字段值等于预期。
    #创建请求体
    ${uuid}    Uuid 4
    ${serviceSessionSummaryId}    set variable    0
    &{summaryEntity}    create dictionary    name=新增标签-${AdminUser.tenantId}-${uuid}    color=2709962495    tenantId=${AdminUser.tenantId}
    ${data}    set variable    {"name":"${summaryEntity.name}","color":${summaryEntity.color},"tenantId":${summaryEntity.tenantId}}
    #创建会话标签
    ${j}    Set ServiceSessionSummary    post    ${AdminUser}    ${serviceSessionSummaryId}    ${data}
    Should Be Equal      ${j['name']}    ${summaryEntity.name}    接口返回name不是${summaryEntity.name},${j}
    Should Be Equal      ${j['color']}    ${${summaryEntity.color}}    接口返回color不是${summaryEntity.color},${j}

修改会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建会话标签，调用接口：/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children，接口请求状态码为200。
    ...    - Step2、修改会话标签，调用接口：/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children，接口请求状态码为204。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，修改会话标签请求状态码为204、返回值等于空。
    #创建会话标签
    ${summaryResult}    Create ServiceSessionSummary    ${AdminUser}
    ${serviceSessionSummaryId}    set variable    ${summaryResult.id}
    #创建请求体
    ${uuid}    Uuid 4
    &{summaryEntity}    create dictionary    name=updateSummary-${AdminUser.tenantId}-${uuid}    color=2709962495    description=null
    ${data}    set variable    {"id":${serviceSessionSummaryId},"name":"${summaryEntity.name}","description":${summaryEntity.description},"color":${summaryEntity.color}}
    #修改会话标签
    ${j}    Set ServiceSessionSummary    put    ${AdminUser}    ${serviceSessionSummaryId}    ${data}
    Should Be Equal      ${j}    ${EMPTY}    接口返回不是空,${j}

删除会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建会话标签，调用接口：/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children，接口请求状态码为200。
    ...    - Step2、删除会话标签，调用接口：/v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children，接口请求状态码为204。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，删除会话标签请求状态码为204、返回值等于空。
    #创建会话标签
    ${summaryResult}    Create ServiceSessionSummary    ${AdminUser}
    ${serviceSessionSummaryId}    set variable    ${summaryResult.id}
    #删除会话标签
    ${j}    Set ServiceSessionSummary    delete    ${AdminUser}    ${serviceSessionSummaryId}
    Should Be Equal      ${j}    ${EMPTY}    接口返回不是空,${j}

导出会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/exportfile)
    [Documentation]    【操作步骤】：
    ...    - Step1、导出会话标签，调用接口：/v1/Tenants/{tenantId}/ServiceSessionSummaries/exportfile，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回值中headers字段值等于“attachment;filename=会话标签”。
    #导出会话标签
    ${resp}    Export ServiceSessionSummaries    ${AdminUser}
    Should Contain    ${resp.headers['Content-Disposition']}    attachment;filename=会话标签    导出会话标签失败
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    导出会话标签失败

导出会话标签下载模板(/download/tplfiles/%E4%BC%9A%E8%AF%9D%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx)
    [Documentation]    【操作步骤】：
    ...    - Step1、导出会话标签下载模板，调用接口：/download/tplfiles/%E4%BC%9A%E8%AF%9D%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #导出会话标签下载模板
    ${resp}    Export ServiceSessionSummary Template    ${AdminUser}
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream    导出会话标签下载模板失败
