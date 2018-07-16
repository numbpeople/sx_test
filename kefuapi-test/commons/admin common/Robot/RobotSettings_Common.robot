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
    Return From Keyword    ${resp}

Set Robot PersonalInfo
    [Arguments]    ${method}    ${agent}    ${language}=zh-CN    ${data}=
    [Documentation]    获取/修改机器人信息
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfo    ${method}    ${agent}    ${language}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot PersonalInfo、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
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
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Get MutilRobot PersonalInfos Settings、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Set Robot Setting
    [Arguments]    ${method}    ${agent}    ${data}
    [Documentation]    创建/修改机器人设置
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/setting    ${method}    ${agent}    ${data}    ${timeout}
    run keyword if    '${method}'=='put'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='put' and ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot Rule、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    run keyword if    '${method}'=='post' and ${resp.status_code}!=201    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot Rule、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Greeting
    [Arguments]    ${agent}
    [Documentation]    获取机器人欢迎语
    ${resp}=    /v1/Tenants/{tenantId}/robots/greetings    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    Return From Keyword    ${resp}

Set Robot AutoReply
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}=    ${replyId}=
    [Documentation]    获取机器人自动回复
    ...    参数：${filter}中  1、type=0 默认回复    2、type=1 重复回复    3、type=2 超时回复    4、type=3 图片默认回复(增值功能)
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${method}    ${agent}    ${filter}    ${data}    ${replyId}    ${timeout}
    run keyword if    '${method}'=='get' or '${method}'=='delete'   Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='post' and ${resp.status_code}!=201    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot AutoReply、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    run keyword if    ('${method}'=='get' or '${method}'=='delete') and ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot AutoReply、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Add Robot AutoReply
    [Arguments]    ${agent}    ${type}
    [Documentation]    添加机器人自动回复
    ...    参数：${filter}中  1、type=0 默认回复    2、type=1 重复回复    3、type=2 超时回复    4、type=3 图片默认回复(增值功能)
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=${type}    #设置自动回复参数
    ${uuid}    Uuid 4
    #创建type和文本的关系
    ${content}    set variable    默认回复-${agent.tenantId}-${uuid}
    run keyword if    ${type} == 1    set suite variable    ${content}    重复回复-${agent.tenantId}-${uuid}
    run keyword if    ${type} == 2    set suite variable    ${content}    超时回复-${agent.tenantId}-${uuid}
    run keyword if    ${type} == 3    set suite variable    ${content}    图片默认回复-${agent.tenantId}-${uuid}
    #添加机器人自动回复
    &{defaultReplyEntity}    create dictionary    type=${type}    content=${content}    contentType=0
    ${data}    set variable    {"type":${defaultReplyEntity.type},"content":"${defaultReplyEntity.content}","contentType":${defaultReplyEntity.contentType}}
    ${j}    Set Robot AutoReply    post    ${agent}    ${filter}    ${data}
    Should Be Equal    ${j['content']}    ${defaultReplyEntity.content}    返回的机器人自动回复content值不正确：${j}
    Should Be Equal    ${j['type']}    ${${defaultReplyEntity.type}}    返回的机器人自动回复type值不正确：${j}
    set to dictionary    ${defaultReplyEntity}    replyId=${j['replyId']}
    Return From Keyword    ${defaultReplyEntity}

Set RobotUserTransferKf Setting
    [Arguments]    ${method}    ${agent}    ${data}=
    [Documentation]    获取机器人转人工设置
    ${resp}=    /v1/Tenants/{tenantId}/robots/robotUserTransferKf    ${method}    ${agent}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Scenarios
    [Arguments]    ${agent}
    [Documentation]    获取机器人智能场景应答
    ${resp}=    /v1/Tenants/{tenantId}/robots/intent/list    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    Should Not Be Empty    ${resp.text}    获取智能场景应答接口返回值为空。返回值：${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Category Tree
    [Arguments]    ${agent}
    [Documentation]    获取机器人分类树
    ${resp}=    /v3/Tenants/{tenantId}/robots/categorys/trees    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Get Robot Category Tree、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}
    
Set Robot Category
    [Arguments]    ${method}    ${agent}    ${data}    ${categoryId}=
    [Documentation]    添加/删除/修改分类
    ${resp}=    /v3/Tenants/{tenantId}/robots/categorys/item    ${method}    ${agent}    ${data}    ${categoryId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot Category、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
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
    [Documentation]    根据知识分类id删除分类
    #删除分类
    ${j}    Set Robot Category    delete    ${AdminUser}    ${data}    ${categoryId}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j} 
    Should Be True    ${j['entity']}    接口返回的entity不正确,正确值是:true,返回结果:${j} 

Delete Robot Categorys With SpecifiedKey
    [Documentation]    删除包含模板的分类
    #设置分类名称包含指定关键字
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.nicename}
    #设置删除分类的请求数据
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":"CHECK"}
    #根据指定key搜索机器人分类
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
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Get Robot Rules、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Set Robot Rule
    [Arguments]    ${method}    ${agent}    ${data}    ${ruleId}=
    [Documentation]    添加/删除知识规则
    ${resp}=    /v3/Tenants/{tenantId}/robots/rules/item    ${method}    ${agent}    ${data}    ${ruleId}    ${timeout}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='delete'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='post' and ${resp.status_code}!=201    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot Rule、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    run keyword if    '${method}'=='delete' and ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot Rule、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
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

Delete Robot Datas With SpecifiedKey
    [Documentation]    删除机器人分类、知识规则、自定义菜单
    #删除机器人的分类
    Delete Robot Categorys With SpecifiedKey
    #删除机器人的知识规则
    Delete Robot Rules With SpecifiedKey
    #删除机器人的自定义菜单
    Delete Robot Menus With SpecifiedKey
    #删除机器人的自动回复
    Delete Robot AutoReplys With SpecifiedKey

Delete Robot Rules With SpecifiedKey
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
    ${randoNumber}    Generate Random String    10    [NUMBERS]
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${agent.userId}    name=${agent.userId}
    #创建问题的文本
    ${question}    set variable    question-${agent.tenantId}-${randoNumber}
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

Set Robot Menu
    [Arguments]    ${method}    ${agent}    ${data}    ${itemId}=
    [Documentation]    添加/修改/删除机器人菜单
    ${resp}=    /v3/Tenants/{tenantId}/robots/menus/item    ${method}    ${agent}    ${data}    ${itemId}    ${timeout}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='delete'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='post' and ${resp.status_code}!=201    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot Menu、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    run keyword if    '${method}'=='delete' and ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Set Robot Menu、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Create Robot Parent Menu
    [Arguments]    ${agent}
    [Documentation]    添加机器人父级菜单
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #创建数据字典
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    &{adminEntity}    create dictionary    userId=${agent.userId}    name=${agent.nicename}
    &{menuEntity}    create dictionary    parentId=null    name=添加父级自定义菜单-${AdminUser.tenantId}-${randoNumber}    menuAnswerType=MENU    level=0    desc=    rootId=null    robotId=${agent.tenantId}    returnUpperLayer=false
    #设置请求体
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"parentId":"${menuEntity.parentId}","name":"${menuEntity.name}","menuAnswerType":"${menuEntity.menuAnswerType}","level":"${menuEntity.level}","desc":"${menuEntity.desc}","rootId":"${menuEntity.rootId}","robotId":${menuEntity.robotId},"returnUpperLayer":${menuEntity.returnUpperLayer}}}
    #创建机器人自定义父菜单
    ${j}    Set Robot Menu    post    ${agent}    ${data}
    Should Be Equal    '${j['status']}'    'OK'    返回的接口字段status不正确：${j}
    #设置菜单id到字典中，做为返回数据
    set to dictionary    ${menuEntity}    parentId=${j['entity']['id']}
    Return From Keyword    ${menuEntity}

Create Robot Sub Menu
    [Arguments]    ${agent}    ${parentMenuId}
    [Documentation]    添加器人子菜单
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #创建数据字典
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    &{adminEntity}    create dictionary    userId=${agent.userId}    name=${agent.nicename}
    &{menuEntity}    create dictionary    parentId=${parentMenuId}    name=添加子级自定义菜单-${AdminUser.tenantId}-${randoNumber}    menuAnswerType=NULL    level=1    desc=    rootId=${parentMenuId}    robotId=${agent.tenantId}    returnUpperLayer=false
    #设置请求体
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"parentId":"${menuEntity.parentId}","name":"${menuEntity.name}","menuAnswerType":"${menuEntity.menuAnswerType}","level":"${menuEntity.level}","desc":"${menuEntity.desc}","rootId":"${menuEntity.rootId}","robotId":${menuEntity.robotId},"returnUpperLayer":${menuEntity.returnUpperLayer}}}
    #创建机器人自定义子菜单
    ${j}    Set Robot Menu    post    ${agent}    ${data}
    Should Be Equal    '${j['status']}'    'OK'    返回的接口字段status不正确：${j}
    Should Be Equal    '${j['entity']['robotId']}'    '${menuEntity.robotId}'    返回的接口字段robotId不正确：${j}
    Should Be Equal    '${j['entity']['parentId']}'    '${menuEntity.parentId}'    返回的接口字段parentId不正确：${j}
    Should Be Equal    ${j['entity']['name']}    ${menuEntity.name}    返回的接口字段name不正确：${j}
    #设置菜单id到字典中，做为返回数据
    set to dictionary    ${menuEntity}    subMenuId=${j['entity']['id']}    parentId=${menuEntity.parentId}
    Return From Keyword    ${menuEntity}

Add Menu Answer
    [Arguments]    ${agent}    ${data}    ${itemId}
    [Documentation]    为菜单添加答案
    ${resp}=    /v3/Tenants/{tenantId}/robots/menus/item/{itemId}/menu-answer    ${agent}    ${data}    ${itemId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Robot Menus
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取自定义菜单
    ${resp}=    /v3/Tenants/{tenantId}/robots/menus/search    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Get Robot Menus、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Download Robot Menu Template
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    下载自定义菜单模板
    ${resp}=    /v1/Tenants/{tenantId}/robot/menu/template/export    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Return From Keyword    ${resp}

Export Robot Menu
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出自定义菜单
    ${resp}=    /v3/Tenants/{tenantId}/robots/menus/items/export    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Return From Keyword    ${resp}

Delete Robot Menus With SpecifiedKey
    [Documentation]    删除包含模板的自定义菜单
    #设置菜单名称包含指定关键字
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #根据指定key搜索机器人自定义菜单
    ${j}    Search Robot Menus With SpecifiedKey    ${AdminUser}    ${preUsername}
    :FOR    ${i}    IN    @{j['entity']}
    \    ${username}=    convert to string    ${i['menu']['name']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}    set variable    ${i['menu']['id']}
    \    Run Keyword If    '${status}' == 'True'    Delete Robot Menu With ItemId   ${AdminUser}   ${userIdValue}

Search Robot Menus With SpecifiedKey
    [Arguments]    ${agent}    ${specifiedKey}
    [Documentation]    根据指定关键字搜索自定义菜单
    #创建请求数据
    ${filter}    copy dictionary    ${RobotFilter}
    ${j1}    Get Robot Menus    ${agent}    ${filter}
    #获取自定义菜单总数
    ${totalElements}    set variable    ${j1['totalElements']}
    #获取自定义菜单
    run keyword if    ${totalElements} == 0    set suite variable    ${totalElements}	10
    set to dictionary    ${filter}    q=${specifiedKey}    per_page=${totalElements}
    ${j}    Get Robot Menus    ${agent}    ${filter}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    Return From Keyword    ${j}

Delete Robot Menu With ItemId
    [Arguments]    ${agent}    ${ItemId}
    [Documentation]    根据知识菜单id删除自定义菜单
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${agent.userId}    name=${agent.nicename}
    #设置请求体
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"}}
    #删除机器人自定义菜单
    ${j}    Set Robot Menu    delete    ${agent}    ${data}    ${ItemId}
    Should Be Equal    '${j['status']}'    'OK'    返回的接口字段status不正确：${j}

Delete Robot AutoReplys With SpecifiedKey
    [Documentation]    根据包含关键字删除自动回复数据
    ...    参数${type}：0、1、2, 分别代表默认回复、重复回复、超时回复
    :FOR    ${i}    IN RANGE    3
    \    Delete Robot AutoReply With SpecifiedKey    ${i}

Delete Robot AutoReply With SpecifiedKey
    [Arguments]    ${type}
    [Documentation]    根据包含关键字删除自动回复数据
    ...    参数${type}：0、1、2, 分别代表默认回复、重复回复、超时回复
    #设置自动回复包含指定关键字
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人自动回复
    set to dictionary    ${filter}    type=${type}    per_page=100
    ${j}    Set Robot AutoReply    get    ${AdminUser}    ${filter}
    #循环删除数据
    :FOR    ${i}    IN    @{j['content']}
    \    ${username}=    convert to string    ${i['content']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}    set variable    ${i['replyId']}
    \    Run Keyword If    '${status}' == 'True'    Delete Robot AutoReply With ReplyId   ${AdminUser}   ${type}    ${userIdValue}

Delete Robot AutoReply With ReplyId
    [Arguments]    ${agent}    ${type}    ${replyId}
    [Documentation]    根据id删除自动回复数据
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=${type}
    #删除默认回复
    ${j}    Set Robot AutoReply    delete    ${agent}    ${filter}    ${EMPTY}    ${replyId}
    Should Be Equal    ${j}    ${1}    删除默认回复接口返回不为1：${j}
    
Get Mutil Robot Count
    [Arguments]    ${agent}
    [Documentation]    检查租户下多机器人账号个数
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取多机器人资料设置
    # ${j}    Get MutilRobot PersonalInfos Settings    ${agent}    ${filter}
    # ${settingLength}    get length    ${j['content']}
    #获取多机器人资料信息
    ${robotInfo}    Get MutilRobot PersonalInfos    ${agent}    ${filter}
    ${InfoLength}    get length    ${robotInfo['content']}
    Return From Keyword    ${InfoLength}

Create Robot Account
    [Documentation]    创建机器人账号、初始化机器人信息
    #创建机器人账号
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${nickname}    set variable    ${AdminUser.tenantId}-新创建的机器人账号哦！
    ${username}    set variable    robot-${randoNumber}@${AdminUser.tenantId}.com
    #创建机器人账号
    ${data}    set variable    {"name":"${nickname}","username":"${username}","password":"${username}","digitalMenu":false,"active":0,"rule":0,"type":0}
    #创建机器人设置
    ${robotSetting}    Set Robot Setting    post    ${AdminUser}    ${data}
    Should Be True    ${robotSetting['active']}    返回的机器人active值不正确：${robotSetting}
    Should Be True    "${robotSetting['tenantId']}" == "${AdminUser.tenantId}"   返回的机器人tenantId值不正确：${robotSetting}
    #初始化机器人资料信息
    Update Robot Profile

Update Robot Profile
    [Documentation]    初始化机器人信息
    #初始化机器人资料信息
    &{robotInfo}    Set Robot PersonalInfo    get    ${AdminUser}
    Should Be Equal    '${robotInfo['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${robotInfo}
    #判断默认机器人是否被训练完成
    return from keyword if    ${robotInfo['createStep']} == 0    租户下的默认机器人已被训练完毕
    #将createStep的值设置为0
    set to dictionary    ${robotInfo}    createStep=0
    ${data}    dumps    ${robotInfo}
    #初始化机器人资料信息
    ${j}    Set Robot PersonalInfo    post    ${AdminUser}    zh-CN    ${data}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${j}

Get RobotGuide Categorys
    [Arguments]    ${agent}    ${filter}
    [Documentation]    获取机器人引导业务场景
    ${resp}=    /v1/Tenants/{tenantId}/robots/robotGuide/categorys    ${agent}    ${filter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get RobotGuide ApplyTemplates
    [Arguments]    ${agent}    ${type}
    [Documentation]    获取机器人引导业务场景下各功能数据
    ...    参数：${type}值为0、1、2、3
    ${resp}=    /v1/Tenants/{tenantId}/robots/robotGuide/applyTemplates/{type}    ${agent}    ${type}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get RobotGuide Prompt
    [Arguments]    ${agent}    ${filter}    ${type}
    [Documentation]    获取机器人引导自动回复模板数据
    ...    参数：${type}值为0、1、2、3
    ${resp}=    /v1/Tenants/{tenantId}/robots/robotGuide/prompt/{type}    ${agent}    ${filter}    ${type}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

RobotGuide Categorys Should Be Equal
    [Arguments]    ${categoryResult}
    [Documentation]    断言引导业务场景数据 ,包括字段: kbCategoryId、kbCategoryName、kbCategoryDesc
    ${categoryTenantId}    set variable    8
    @{kbCategoryNameList}    create list    其他    金融    教育    电商
    @{kbCategoryDescList}    create list    若以上场景均不适用，请选择此项    支持金融行业典型场景    支持教育行业典型场景    支持电商行业典型场景
    Reverse List    ${categoryResult}
    log list    ${categoryResult}
    :FOR    ${i}    IN RANGE    4
    \    ${num}    evaluate    ${i} + 1
    \    should be true    ${${categoryResult[${i}]['tenantId']}} == ${categoryTenantId}    #判断tenantId值
    \    should be true    ${${categoryResult[${i}]['id']}} == ${num}    #判断id值是否在1-4范围
    \    should be true    ${${categoryResult[${i}]['kbCategoryId']}} == ${i}    #判断kbCategoryId值是否在0-3范围
    \    should be true    "${categoryResult[${i}]['kbCategoryName']}" == "${kbCategoryNameList[${i}]}"    #判断kbCategoryName值
    \    should be true    "${categoryResult[${i}]['kbCategoryDesc']}" == "${kbCategoryDescList[${i}]}"    #判断kbCategoryDesc值

RobotGuide ApplyTemplates Should Be Equal
    [Arguments]    ${type}    ${applyTemplatesResult}
    [Documentation]    断言引导业务场景数据
    #判断type为0时，接口中prompt正确性
    run keyword if    "${type}" == "0"    Should Contain    ${applyTemplatesResult[0]['prompt']}    您好，机器人XX很高兴为您服务，您可以输入以下关键词进行咨询：【XX，XX，XX，XX】，或用简洁的语言描述您的问题。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "0"    Should Contain    ${applyTemplatesResult[1]['prompt']}    对不起，很抱歉机器人XX没能解决您的问题，您可以输入以下关键词进行咨询：【“XX，XX，XX，XX”】，或点击转人工按钮由人工客服解答您的问题，人工客服上班时间：【XX:XX--XX:XX】。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "0"    Should Contain    ${applyTemplatesResult[2]['prompt']}    您好！您的问题已经连续多次发送了！请重新提问。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "0"    Should Contain    ${applyTemplatesResult[3]['prompt']}    您已经很久没有发送消息了，本次会话即将关闭，如您还需要咨询请发送消息即可。    接口返回值中不包含该文案，${applyTemplatesResult}
    #判断type为1时，接口中prompt正确性
    run keyword if    "${type}" == "1"    Should Contain    ${applyTemplatesResult[0]['prompt']}    亲爱的顾客，机器人很高兴为您服务，您可以输入以下关键词进行咨询：【“保单查询，理赔，续保，退保”】，或用简洁的语言描述您的问题。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "1"    Should Contain    ${applyTemplatesResult[1]['prompt']}    对不起，很抱歉机器人没能解决您的问题，您可以输入以下关键词进行咨询：【“保单查询，理赔，续保，退保”】，或点击转人工按钮由人工客服解答您的问题，人工客服上班时间：【9:00~20:00】。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "1"    Should Contain    ${applyTemplatesResult[2]['prompt']}    您好！您的问题已经连续多次发送了！请重新提问    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "1"    Should Contain    ${applyTemplatesResult[3]['prompt']}    您已经很久没有发送消息了，本次会话即将关闭，如您还需要咨询请发送消息即可。    接口返回值中不包含该文案，${applyTemplatesResult}
    #判断type为2时，接口中prompt正确性
    run keyword if    "${type}" == "2"    Should Contain    ${applyTemplatesResult[0]['prompt']}    亲爱的顾客，机器人很高兴为您服务，您可以输入以下关键词进行咨询：【“师资力量，入学测试，上课路线，调课，支付方式”】，或用简洁的语言描述您的问题。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "2"    Should Contain    ${applyTemplatesResult[1]['prompt']}    对不起，很抱歉机器人没能解决您的问题，您可以输入以下关键词进行咨询：【“师资力量，入学测试，上课路线，调课，支付方式”】，或点击转人工按钮由人工客服解答您的问题，人工客服上班时间：【9:00~20:00】。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "2"    Should Contain    ${applyTemplatesResult[2]['prompt']}    您好！您的问题已经连续多次发送了！请重新提问    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "2"    Should Contain    ${applyTemplatesResult[3]['prompt']}    您已经很久没有发送消息了，本次会话即将关闭，如您还需要咨询请发送消息即可。    接口返回值中不包含该文案，${applyTemplatesResult}
    #判断type为3时，接口中prompt正确性
    run keyword if    "${type}" == "3"    Should Contain    ${applyTemplatesResult[0]['prompt']}    亲爱的顾客，机器人很高兴为您服务，您可以输入以下关键词进行咨询：【“物流，邮费，退款，退换货，代金券”】，或用简洁的语言描述您的问题。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "3"    Should Contain    ${applyTemplatesResult[1]['prompt']}    对不起，很抱歉机器人没能解决您的问题，您可以输入以下关键词进行咨询：【“物流，邮费，退款，退换货，代金券”】，或点击转人工按钮由人工客服解答您的问题，人工客服上班时间：【9:00~20:00】。    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "3"    Should Contain    ${applyTemplatesResult[2]['prompt']}    您好！您的问题已经连续多次发送了！请重新提问    接口返回值中不包含该文案，${applyTemplatesResult}
    run keyword if    "${type}" == "3"    Should Contain    ${applyTemplatesResult[3]['prompt']}    您已经很久没有发送消息了，本次会话即将关闭，如您还需要咨询请发送消息即可。    接口返回值中不包含该文案，${applyTemplatesResult}
      