*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Robot/Robot_Api.robot
Resource          ../../../../commons/admin common/Robot/RobotSettings_Common.robot

*** Test Cases ***
获取机器人知识规则(接口较旧，蓝月亮私有版本仍使用，暂存留)(/v1/Tenants/{tenantId}/robot/rules)
    [Documentation]    获取机器人知识规则
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人知识规则
    ${j}    Get Robot Rules(Old)    ${AdminUser}    ${filter}
    Should Be True    ${j['totalElements']}>=0    返回的机器人知识规则不正确：${j}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人知识规则不正确：${j}

获取机器人知识规则数量(接口较旧，蓝月亮私有版本仍使用，暂存留)(/v1/Tenants/{tenantId}/robot/rule/group/count)
    [Documentation]    获取机器人知识规则数量
    #获取机器人知识规则数量
    ${j}    Get Robot Rules Count(Old)    ${AdminUser}
    Should Be True    ${j}>=0    返回的机器人知识规则数量不正确：${j}

获取知识规则模板(接口较旧，蓝月亮私有版本仍使用，暂存留)(/v1/Tenants/{tenantId}/robot/rule/items/template)
    [Documentation]    获取机器人知识规则模板
    #获取机器人知识规则模板
    ${resp}=    Get Robot Rules Template(Old)    ${AdminUser}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败

获取机器人自定义菜单(接口较旧，蓝月亮私有版本仍使用，暂存留)(/v1/Tenants/{tenantId}/robot/menu/items)
    [Documentation]    获取机器人自定义菜单
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人自定义菜单
    ${j}    Get Robot Rules Menu(Old)    ${AdminUser}    ${filter}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${j}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人自定义菜单不正确：${j}

获取机器人人机协作推荐状态(/v1/Tenants/{tenantId}/robots/recommendation/status)
    [Documentation]    获取人机协作推荐状态
    #获取机器人推荐状态
    ${j}    Get Recommendation Status    ${AdminUser}

获取机器人人机协作推荐开关信息(/v1/Tenants/{tenantId}/robots/recommendationSwitch)
    [Documentation]    获取人机协作推荐开关信息
    #创建筛选参数
    ${switchType}    set variable    0
    ${switchId}    set variable    ${AdminUser.tenantId}
    #获取机器人推荐信息
    ${j}    Get Recommendation Info    ${AdminUser}    ${switchType}    ${switchId}

获取机器人信息(/v1/Tenants/{tenantId}/robot/profile/personalInfo)
    [Documentation]    获取机器人信息
    ${j}    Get Robot PersonalInfo    ${AdminUser}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${j}

获取多机器人信息(/v1/Tenants/{tenantId}/robot/profile/personalInfos)
    [Documentation]    获取多机器人信息
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Get MutilRobot PersonalInfos    ${AdminUser}    ${filter}

获取多机器人设置(/v1/Tenants/{tenantId}/robot/profile/settings)
    [Documentation]    获取多机器人设置
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Get MutilRobot PersonalInfos Settings    ${AdminUser}    ${filter}

获取机器人欢迎语(/v1/Tenants/{tenantId}/robots/greetings)
    [Documentation]    获取机器人欢迎语
    ${j}=    Get Robot Greeting    ${AdminUser}

获取机器人默认回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    获取机器人默认回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人默认回复
    set to dictionary    ${filter}    type=0    #设置type=0，参数为获取默认回复数据
    ${j}    Get Robot AutoReply    ${AdminUser}    ${filter}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人默认回复不正确：${j}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人默认回复不正确：${j}

获取机器人重复回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    获取机器人重复回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人重复回复
    set to dictionary    ${filter}    type=1    #设置type=1，参数为获取重复回复数据
    ${j}    Get Robot AutoReply    ${AdminUser}    ${filter}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人重复回复不正确：${j}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人重复回复不正确：${j}

获取机器人超时回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    获取机器人超时回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人超时回复
    set to dictionary    ${filter}    type=2    #设置type=2，参数为获取超时回复数据
    ${j}    Get Robot AutoReply    ${AdminUser}    ${filter}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人超时回复不正确：${j}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人超时回复不正确：${j}

获取机器人转人工设置(/v1/Tenants/{tenantId}/robots/robotUserTransferKf)
    [Documentation]    获取机器人转人工设置
    #获取机器人转人工设置
    ${j}    Get RobotUserTransferKf Setting    ${AdminUser}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人转人工设置不正确：${j}

获取智能场景应答(/v1/Tenants/{tenantId}/robots/intent/list)
    [Documentation]    获取机器人智能场景应答
    #获取机器人智能场景应答
    ${j}    Get Robot Scenarios    ${AdminUser}
    Should Be Equal    '${j['logistics']['name']}'    '物流'    返回的机器人只能场景应答信息不正确：${j}

添加知识规则(/v3/Tenants/{tenantId}/robots/rules/item)
    [Documentation]    添加知识规则
    ${uuid}    UUID 4
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.userId}
    #创建问题的文本
    ${question}    set variable    question-${AdminUser.tenantId}-${uuid}
    #启用状态
    ${status}    set variable    ENABLE
    #发送策略ID
    ${strategyGroupId}    set variable    ${uuid}
    #创建答案字典元数据
    &{answersDic}    create dictionary    answer=answer-${AdminUser.tenantId}-${uuid}    type=TEXT    index=1    answerId=${uuid}
    #创建问题的字典数据
    @{questionsList}    create list    {"question": "${question}"}
    #创建答案的字典数据
    @{answersList}    create list    {"answer":"${answersDic.answer}","type":"${answersDic.type}","index":${answersDic.index},"answerId":"${answersDic.answerId}"}
    #创建添加规则的字典元数据
    @{categoryIdsList}    create list    "root"
    #创建添加规则的字典元数据
    &{ruleEntity}    create dictionary    robotId=${AdminUser.tenantId}    name=    questions=${questionsList}    answers=${answersList}    status=${status}
    ...    strategyGroupId=${strategyGroupId}    categoryIds=${categoryIdsList}    extInfo={}
    #设置添加规则的请求数据
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"robotId":${ruleEntity.robotId},"name":"${ruleEntity.name}","questions":${ruleEntity.questions},"answers":${ruleEntity.answers},"status":"${ruleEntity.status}","strategyGroupId":"${ruleEntity.strategyGroupId}","categoryIds":${ruleEntity.categoryIds},"extInfo":${ruleEntity.extInfo}}}
    ${data}    Replace String    ${data}    u'    ${EMPTY}
    ${data}    Replace String    ${data}    '    ${EMPTY}
    #添加知识规则
    ${j}    Set Robot Rule    post    ${AdminUser}    ${data}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    Should Be Equal    ${j['entity']['questions'][0]['question']}    ${question}    接口返回的question不正确,正确值是:${question}返回结果:${j}
    Should Be Equal    ${j['entity']['answers'][0]['answer']}    ${answersDic.answer}    接口返回的answer不正确,正确值是:${answersDic.answer},返回结果:${j}
    Should Be Equal    ${j['entity']['status']}    ${status}    接口返回的status不正确,正确值是:${status},返回结果:${j}

删除知识规则(/v3/Tenants/{tenantId}/robots/rules/item)
    [Documentation]    删除知识规则
    #创建知识规则
    ${ruleResult}    Create Robot Rule    ${AdminUser}
    #创建请求数据
    ${data}    set variable    {"admin":{"userId":"${AdminUser.userId}","name":"${AdminUser.userId}"},"entity":false}
    #删除知识规则
    Delete Robot Rule With RuleId    ${AdminUser}    ${data}    ${ruleResult.ruleId}

获取知识规则(/v3/Tenants/{tenantId}/robots/rules/item)
    [Documentation]    获取知识规则
    #创建知识规则
    ${ruleResult}    Create Robot Rule    ${AdminUser}
    #创建请求数据
    ${filter}    copy dictionary    ${RobotFilter}
    #获取知识规则
    ${j}    Get Robot Rules    ${AdminUser}    ${filter}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    Should Be Equal    ${j['entity'][0]['questions'][0]['question']}    ${ruleResult.question}    接口返回的question不正确,正确值是:${ruleResult.question}返回结果:${j}
    Should Be Equal    ${j['entity'][0]['answers'][0]['answer']}    ${ruleResult.answer}    接口返回的answer不正确,正确值是:${ruleResult.answer},返回结果:${j}
    Should Be Equal    ${j['entity'][0]['status']}    ${ruleResult.status}    接口返回的status不正确,正确值是:${ruleResult.status},返回结果:${j}
    
知识库测试(/v1/Tenants/{tenantId}/robots/kb/ask)
    [Documentation]    1、创建知识规则 2、知识库测试
    #创建知识规则
    ${ruleResult}    Create Robot Rule    ${AdminUser}
    #创建请求数据
    ${data}    set variable    {"question":"${ruleResult.question}","tenantId":${AdminUser.tenantId}}
    #知识库测试
    ${j}    Knowledge base test    ${AdminUser}    ${data}
    #获取content结果字段
    ${content}    set variable    ${j['content']}
    ${content}    Replace String    ${content}    &quot;    ${EMPTY}
    ${content}    Replace String    ${content}    [    ${EMPTY}
    ${content}    Replace String    ${content}    ]    ${EMPTY}
    @{content}     Split String    ${content}    ,
    ${answerResult}    set variable    ${content[1]}    #获取知识库测试返回的答案
    #断言接口数据
    Should Be Equal    ${answerResult}    ${ruleResult.answer}    接口返回的content值不正确,正确值是:${ruleResult.answer},返回结果:${j}
    Should Be Equal    ${j['answerMode']}    KNOWLEDGE_RULE    接口返回的answerMode不正确,正确值是:KNOWLEDGE_RULE,返回结果:${j}
    Should Be Equal    ${j['ruleId']}    ${ruleResult.ruleId}    接口返回的ruleId不正确,正确值是:${ruleResult.ruleId},返回结果:${j}
    Should Be Equal    ${${j['score']}}    ${1}    接口返回的score不正确,正确值是:1,返回结果:${j}

添加机器人分类(/v3/Tenants/{tenantId}/robots/categorys/item)
    [Documentation]    添加机器人分类
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    #创建分类名称
    ${categoryName}    set variable    category-${AdminUser.tenantId}-${randoNumber}
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.nicename}
    #创建添加分类的字典元数据
    &{categoryEntity}    create dictionary    robotId=${AdminUser.tenantId}    level=0    rootId=    parentId=root    name=${categoryName}    desc=    
    #设置添加分类的请求数据
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"robotId":${categoryEntity.robotId},"level":${categoryEntity.level},"rootId":"${categoryEntity.rootId}","parentId":"${categoryEntity.parentId}","name":"${categoryEntity.name}","desc":"${categoryEntity.desc}"}}
    #创建分类
    ${j}    Set Robot Category    post    ${AdminUser}    ${data}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    Should Be Equal    ${j['entity']['name']}    ${categoryEntity.name}    接口返回的name不正确,正确值是:${categoryEntity.name}返回结果:${j}
    Should Be Equal    ${j['entity']['parentId']}    ${categoryEntity.parentId}    接口返回的parentId不正确,正确值是:${categoryEntity.parentId},返回结果:${j}
    Should Be Equal    ${${j['entity']['robotId']}}    ${categoryEntity.robotId}    接口返回的robotId不正确,正确值是:${categoryEntity.robotId},返回结果:${j}

删除机器人分类(/v3/Tenants/{tenantId}/robots/categorys/item)
    [Documentation]    1、添加机器人分类    2、删除分类
    #创建分类并获取分类Id
    ${categoryResult}    Creat Robot Category    ${AdminUser}
    ${categoryId}    set variable    ${categoryResult.categoryId}
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.nicename}
    #设置删除分类的请求数据
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":"CHECK"}
    #删除分类
    ${j}    Set Robot Category    delete    ${AdminUser}    ${data}    ${categoryId}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}

获取机器人分类树(/v3/Tenants/{tenantId}/robots/categorys/trees)
    [Documentation]    1、添加机器人分类    2、获取分类
    #创建分类并获取分类Id
    ${categoryResult}    Creat Robot Category    ${AdminUser}
    ${categoryId}    set variable    ${categoryResult.categoryId}
    #获取分类
    ${j}    Get Robot Category Tree    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    Should Be Equal    ${j['entity'][-1]['category']['id']}    ${categoryId}    接口返回的id不正确,正确值是:${categoryId},返回结果:${j}
    Should Be Equal    ${j['entity'][-1]['category']['name']}    ${categoryResult.name}    接口返回的name不正确,正确值是:${categoryResult.name},返回结果:${j}

获取知识规则模板(/v3/Tenants/{tenantId}/robots/rule/template)
    [Documentation]    获取机器人知识规则模板
    #获取机器人知识规则模板
    ${resp}=    Get Robot Rules Template    ${AdminUser}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败

导出知识规则(/v3/Tenants/{tenantId}/robots/rule/template)
    [Documentation]    导出知识规则
    #导出知识规则
    ${resp}=    Export Robot Rules    ${AdminUser}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败

查看日志管理(/v3/Tenants/{tenantId}/robots/rules/records)
    [Documentation]    查看日志管理
    #获取本月年月日
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${yn}=    Convert To Integer    ${yyyy}
    ${mn}=    Convert To Integer    ${mm}
    ${mr}=    Monthrange    ${yn}    ${mn}
    ${start}=    set variable    ${yyyy}-${mm}-01 0:0
    ${end}=    set variable    ${yyyy}-${mm}-${mr[1]} 23:59
    #创建请求数据
    ${filter}    copy dictionary    ${RobotFilter}
    #设置start和end为本月
    set to dictionary    ${filter}    page=0    start=${start}    end=${end}
    #查看日志管理
    ${j}=    Get Logs Management    ${AdminUser}    ${filter}
    ${length}=    get length    ${j['entity']}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    Should Be True    ${j['totalElements']}>0    接口返回的totalElements值不大于0,返回结果:${j}
    Should Be True    ${length}>0    接口返回的entity未查到有数据,返回结果:${j}
    