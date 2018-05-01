*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Robot/Robot_Api.robot

*** Keywords ***
Get Robot Rules(Old)
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取机器人知识规则
    ${resp}=    /v1/Tenants/{tenantId}/robot/rules    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Rules Count(Old)
    [Arguments]    ${agent}
    [Documentation]    获取机器人知识规则总数
    ${resp}=    /v1/Tenants/{tenantId}/robot/rule/group/count    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Rules Template(Old)
    [Arguments]    ${agent}
    [Documentation]    获取机器人知识规则模板
    ${resp}=    /v1/Tenants/{tenantId}/robot/rule/items/template    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Return From Keyword    ${resp}

Get Robot Rules Menu(Old)
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取机器人自定义菜单
    ${resp}=    /v1/Tenants/{tenantId}/robot/menu/items    get    ${agent}    ${filter}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Recommendation Status
    [Arguments]    ${agent}
    [Documentation]    获取机器人推荐状态
    #获取机器人推荐状态
    ${resp}=    /v1/Tenants/{tenantId}/robots/recommendation/status    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Recommendation Info
    [Arguments]    ${agent}    ${switchType}    ${switchId}
    [Documentation]    获取机器人推荐信息
    ${resp}=    /v1/Tenants/{tenantId}/robots/recommendationSwitch    ${agent}    ${switchType}    ${switchId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot PersonalInfo
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    获取机器人信息
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfo    ${agent}    ${language}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get MutilRobot PersonalInfos
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取多机器人信息
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfos    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get MutilRobot PersonalInfos Settings
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取多机器人设置
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/settings    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Greeting
    [Arguments]    ${agent}
    [Documentation]    获取机器人欢迎语
    ${resp}=    /v1/Tenants/{tenantId}/robots/greetings    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot AutoReply
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取机器人自动回复
    ...    参数：${filter}中  1、type=0 默认回复    2、type=1 重复回复    3、type=0 超时回复    4、type=3 图片默认回复(增值功能)
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get RobotUserTransferKf Setting
    [Arguments]    ${agent}
    [Documentation]    获取机器人转人工设置
    ${resp}=    /v1/Tenants/{tenantId}/robots/robotUserTransferKf    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Scenarios
    [Arguments]    ${agent}
    [Documentation]    获取机器人智能场景应答
    ${resp}=    /v1/Tenants/{tenantId}/robots/intent/list    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Category Tree
    [Arguments]    ${agent}
    [Documentation]    获取机器人菜单树
    ${resp}=    /v3/Tenants/{tenantId}/robots/categorys/trees    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}
    
Set Robot Category
    [Arguments]    ${method}    ${agent}    ${data}    ${categoryId}=
    [Documentation]    添加/删除/修改分类
    ${resp}=    /v3/Tenants/{tenantId}/robots/categorys/item    ${method}    ${agent}    ${data}    ${categoryId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Creat Robot Category
    [Arguments]    ${agent}
    [Documentation]    添加机器人分类
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    #创建分类名称
    ${categoryName}    set variable    category-${agent.tenantId}-${randoNumber}
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${agent.userId}    name=${agent.nicename}
    #创建添加分类的字典元数据
    &{categoryEntity}    create dictionary    robotId=${agent.tenantId}    level=0    rootId=    parentId=root    name=${categoryName}    desc=    
    #设置添加分类的请求数据
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"robotId":${categoryEntity.robotId},"level":${categoryEntity.level},"rootId":"${categoryEntity.rootId}","parentId":"${categoryEntity.parentId}","name":"${categoryEntity.name}","desc":"${categoryEntity.desc}"}}
    #创建分类
    ${j}    Set Robot Category    post    ${agent}    ${data}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    set to dictionary    ${categoryEntity}    categoryId=${j['entity']['id']}
    Return From Keyword    ${categoryEntity}

Delete Robot Category With CategoryId
    [Arguments]    ${agent}    ${data}    ${categoryId}
    [Documentation]    根据知识菜单id删除菜单
    #删除知识规则
    ${j}    Set Robot Category    delete    ${AdminUser}    ${data}    ${categoryId}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j} 
    Should Be True    ${j['entity']}    接口返回的entity不正确,正确值是:true,返回结果:${j} 

Delete Robot Category With SpecifiedKey
    [Documentation]    删除包含模板的菜单
    #设置菜单名称包含指定关键字
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.nicename}
    #设置删除分类的请求数据
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":"CHECK"}
    #根据指定key搜索机器人菜单
    ${j}    Get Robot Category Tree    ${AdminUser}
    :FOR    ${i}    IN    @{j['entity']}
    \    ${username}=    convert to string    ${i['category']['name']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}    set variable    ${i['category']['id']}
    \    Run Keyword If    '${status}' == 'True'    Delete Robot Category With CategoryId   ${AdminUser}    ${data}    ${userIdValue}

Get Robot Rules
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取知识规则
    ${resp}=    /v3/Tenants/{tenantId}/robots/rules/search    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Set Robot Rule
    [Arguments]    ${method}    ${agent}    ${data}    ${ruleId}=
    [Documentation]    添加/删除知识规则
    ${resp}=    /v3/Tenants/{tenantId}/robots/rules/item    ${method}    ${agent}    ${data}    ${ruleId}    ${timeout}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='delete'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Delete Robot Rule With RuleId
    [Arguments]    ${agent}    ${data}    ${ruleId}
    [Documentation]    根据知识规则id删除规则
    #删除知识规则
    ${j}    Set Robot Rule    delete    ${agent}    ${data}    ${ruleId}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j} 
    Should Be True    ${j['entity']}    接口返回的entity不正确,正确值是:true,返回结果:${j} 

Get Robot Rules With SpecifiedKey
    [Arguments]    ${agent}    ${specifiedKey}
    [Documentation]    根据指定key搜索知识规则
    &{rulesList}    create dictionary
    #创建请求数据
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    per_page=100    q=${specifiedKey}
    #根据指定key搜索知识规则
    ${j}    Get Robot Rules    ${agent}    ${filter}
    :FOR    ${i}    IN    @{j['entity']}
    \    log    ${i}
    \    set to dictionary    ${rulesList}    ${i['questionsArray'][0]}=${i['id']}
    Return From Keyword    ${rulesList}

Delete Robot Rules And Category With SpecifiedKey
    [Documentation]    删除指定关键字问句知识规则
    #删除机器人的菜单
    Delete Robot Category With SpecifiedKey
    #设置规则问句包含指定关键字
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #获取所有包含模板的知识规则列表
    ${agentlist}=    Get Robot Rules With SpecifiedKey    ${AdminUser}    ${preUsername}    #返回字典
    ${userNameList}=    Get Dictionary Keys    ${agentlist}
    ${listlength}=    Get Length    ${userNameList}
    log    ${agentlist}
    #创建请求数据
    ${data}    set variable    {"admin":{"userId":"${AdminUser.userId}","name":"${AdminUser.userId}"},"entity":false}
    #循环判断规则问句是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${username}=    convert to string    ${userNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}=    Get From Dictionary    ${agentlist}    ${userNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Robot Rule With RuleId    ${AdminUser}    ${data}    ${userIdValue}

Create Robot Rule
    [Arguments]    ${agent}
    [Documentation]    创建知识规则，并返回知识规则数据
    ${uuid}    UUID 4
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${agent.userId}    name=${agent.userId}
    #创建问题的文本
    ${question}    set variable    question-${agent.tenantId}-${uuid}
    #启用状态
    ${status}    set variable    ENABLE
    #发送策略ID
    ${strategyGroupId}    set variable   ${uuid}
    #创建答案字典元数据
    &{answersDic}    create dictionary    answer=answer-${agent.tenantId}-${uuid}    type=TEXT    index=1    answerId=${uuid}
    
    #创建问题的字典数据
    @{questionsList}    create list    {"question": "${question}"}
    #创建答案的字典数据
    @{answersList}    create list    {"answer":"${answersDic.answer}","type":"${answersDic.type}","index":${answersDic.index},"answerId":"${answersDic.answerId}"}
    #创建添加规则的字典元数据
    @{categoryIdsList}    create list    "root"
    #创建添加规则的字典元数据
    &{ruleEntity}    create dictionary    robotId=${agent.tenantId}    name=    questions=${questionsList}    answers=${answersList}    status=${status}    strategyGroupId=${strategyGroupId}    categoryIds=${categoryIdsList}    extInfo={}
    #设置添加规则的请求数据
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"robotId":${ruleEntity.robotId},"name":"${ruleEntity.name}","questions":${ruleEntity.questions},"answers":${ruleEntity.answers},"status":"${ruleEntity.status}","strategyGroupId":"${ruleEntity.strategyGroupId}","categoryIds":${ruleEntity.categoryIds},"extInfo":${ruleEntity.extInfo}}}
    ${data}    Replace String    ${data}    u'    ${EMPTY}
    ${data}    Replace String    ${data}    '    ${EMPTY}
    #添加知识规则
    ${j}    Set Robot Rule    post    ${agent}    ${data}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    set to dictionary    ${ruleEntity}    question=${question}    answer=${answersDic.answer}    ruleId=${j['entity']['id']}
    Return From Keyword    ${ruleEntity}

Knowledge Base Test
    [Arguments]    ${agent}    ${data}
    [Documentation]    知识库测试
    ${resp}=    /v1/Tenants/{tenantId}/robots/kb/ask    ${agent}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Rules Template
    [Arguments]    ${agent}
    [Documentation]    获取机器人知识规则模板
    ${resp}=    /v3/Tenants/{tenantId}/robots/rule/template    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Return From Keyword    ${resp}

Export Robot Rules
    [Arguments]    ${agent}
    [Documentation]    导出知识规则
    ${resp}=    /v3/Tenants/{tenantId}/robots/rule/export    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Return From Keyword    ${resp}

Get Logs Management
    [Arguments]    ${agent}    ${filter}
    [Documentation]    查看日志管理
    ${resp}=    /v3/Tenants/{tenantId}/robots/rules/records    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}