*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/ConversationTagApi.robot

*** Keywords ***
Get Conversation Tags
    [Arguments]    ${method}    ${agent}    ${summaryId}    ${conversationTagEntity}
    [Documentation]    获取会话标签
    #获取会话标签
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree    ${method}    ${agent}    ${summaryId}    ${conversationTagEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Get Conversation TagId
    [Arguments]    @{ServiceSessionSummaryList}
    [Documentation]    获取标签中第一个根节点的叶子标签id值
    #设置初始值为0，代表租户下没有会话标签
    ${id}    set variable    0
    ${length}    get length    @{ServiceSessionSummaryList}
    return from Keyword if    ${length} == 0    ${id}
    #递归取数据中叶子节点的值
    : FOR    ${i}    IN    @{ServiceSessionSummaryList}
    \    set suite variable    ${id}    ${i[0]['id']}
    \    ${status}    Run Keyword And Return Status    Should Not Be Equal    "${i[0]['children']}"    "None"
    \    Exit For Loop If    not ${status}
    \    Get Conversation TagId    ${i[0]['children']}
    return from keyword    ${id}

Set ServiceSessionSummary
    [Arguments]    ${method}    ${agent}    ${ServiceSessionSummaryId}    ${data}=
    [Documentation]    增加/修改/删除会话标签
    #增加/修改/删除会话标签
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessionSummaries/{ServiceSessionSummaryId}/children    ${method}    ${agent}    ${ServiceSessionSummaryId}    ${data}    ${timeout}
    run keyword if    '${method}'=='put' or '${method}'=='delete'    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    ('${method}'=='put' or '${method}'=='delete') and ${resp.status_code}!=204    log    测试用例集名称:${SUITE NAME}、调用方法:Set ServiceSessionSummary、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    run keyword if    '${method}'=='post' and ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Set ServiceSessionSummary、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    return from keyword if    '${method}'=='put' or '${method}'=='delete'    ${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Create ServiceSessionSummary
    [Arguments]    ${agent}
    [Documentation]    创建会话标签
    #创建请求体
    ${uuid}    Uuid 4
    ${serviceSessionSummaryId}    set variable    0
    &{summaryEntity}    create dictionary    name=新增标签-${AdminUser.tenantId}-${uuid}    color=2709962495    tenantId=${AdminUser.tenantId}
    ${data}    set variable    {"name":"${summaryEntity.name}","color":${summaryEntity.color},"tenantId":${summaryEntity.tenantId}}
    #创建会话标签
    ${j}    Set ServiceSessionSummary    post    ${AdminUser}    ${serviceSessionSummaryId}    ${data}
    Should Be Equal      ${j['name']}    ${summaryEntity.name}    接口返回name不是${summaryEntity.name},${j}
    Should Be Equal      ${j['color']}    ${${summaryEntity.color}}    接口返回color不是${summaryEntity.color},${j}
    #将会话标签id返回
    set to dictionary    ${summaryEntity}    id=${j['id']}
    return from keyword    ${summaryEntity}

Export ServiceSessionSummaries
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出会话标签
    #导出会话标签
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessionSummaries/exportfile    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword    ${resp}

Export ServiceSessionSummary Template
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出会话标签下载模板
    #导出会话标签下载模板
    ${resp}=    /download/tplfiles/%E4%BC%9A%E8%AF%9D%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword    ${resp}

Delete ServiceSessionSummaries With SpecifiedKey
    [Documentation]    删除包含模板的会话标签
    #设置会话标签名称包含指定关键字
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #创建参数字典,根据指定key搜索会话标签
    &{conversationTagEntity}    create dictionary    systemOnly=false    buildCount=true
    #获取会话标签数据
    ${j}    Get Conversation Tags    get    ${AdminUser}    0    ${conversationTagEntity}
    :FOR    ${i}    IN    @{j}
    \    ${username}=    convert to string    ${i['name']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}    set variable    ${i['id']}
    \    Run Keyword If    '${status}' == 'True'    Delete ServiceSessionSummaries With ServiceSessionSummaryId   ${AdminUser}    ${userIdValue}

Delete ServiceSessionSummaries With ServiceSessionSummaryId
    [Arguments]    ${agent}    ${ServiceSessionSummaryId}
    [Documentation]    根据id删除会话标签
    #删除会话标签
    ${j}    Set ServiceSessionSummary    delete    ${agent}    ${ServiceSessionSummaryId}
    Should Be Equal      ${j}    ${EMPTY}    接口返回不是空,${j}