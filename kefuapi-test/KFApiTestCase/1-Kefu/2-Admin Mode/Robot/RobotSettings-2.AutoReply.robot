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
获取机器人欢迎语(/v1/Tenants/{tenantId}/robots/greetings)
    [Documentation]    获取机器人欢迎语
    ${j}=    Get Robot Greeting    ${AdminUser}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的tenantId值不正确：${j}

获取机器人默认回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    获取机器人默认回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人默认回复
    set to dictionary    ${filter}    type=0    #设置type=0，参数为获取默认回复数据
    ${j}    Set Robot AutoReply    get    ${AdminUser}    ${filter}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人默认回复不正确：${j}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人默认回复不正确：${j}

获取机器人重复回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    获取机器人重复回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人重复回复
    set to dictionary    ${filter}    type=1    #设置type=1，参数为获取重复回复数据
    ${j}    Set Robot AutoReply    get    ${AdminUser}    ${filter}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人重复回复不正确：${j}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人重复回复不正确：${j}


获取机器人超时回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    获取机器人超时回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人超时回复
    set to dictionary    ${filter}    type=2    #设置type=2，参数为获取超时回复数据
    ${j}    Set Robot AutoReply    get    ${AdminUser}    ${filter}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人超时回复不正确：${j}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人超时回复不正确：${j}

添加机器人默认回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    添加机器人默认回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=0    #设置type=0，参数为添加默认回复数据
    ${uuid}    Uuid 4
    #添加机器人默认回复
    &{defaultReplyEntity}    create dictionary    type=0    content=默认回复-${AdminUser.tenantId}-${uuid}    contentType=0
    ${data}    set variable    {"type":${defaultReplyEntity.type},"content":"${defaultReplyEntity.content}","contentType":${defaultReplyEntity.contentType}}
    ${j}    Set Robot AutoReply    post    ${AdminUser}    ${filter}    ${data}
    Should Be Equal    ${j['content']}    ${defaultReplyEntity.content}    返回的机器人默认回复content值不正确：${j}
    Should Be Equal    ${j['type']}    ${${defaultReplyEntity.type}}    返回的机器人默认回复type值不正确：${j}

添加机器人重复回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    添加机器人重复回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=1    #设置type=1，参数为添加重复回复数据
    ${uuid}    Uuid 4
    #添加机器人重复回复
    &{defaultReplyEntity}    create dictionary    type=1    content=重复回复-${AdminUser.tenantId}-${uuid}    contentType=0
    ${data}    set variable    {"type":${defaultReplyEntity.type},"content":"${defaultReplyEntity.content}","contentType":${defaultReplyEntity.contentType}}
    ${j}    Set Robot AutoReply    post    ${AdminUser}    ${filter}    ${data}
    Should Be Equal    ${j['content']}    ${defaultReplyEntity.content}    返回的机器人重复回复content值不正确：${j}
    Should Be Equal    ${j['type']}    ${${defaultReplyEntity.type}}    返回的机器人重复回复type值不正确：${j}

添加机器人超时回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    添加机器人超时回复
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=2    #设置type=1，参数为添加超时回复数据
    ${uuid}    Uuid 4
    #添加机器人超时回复
    &{defaultReplyEntity}    create dictionary    type=2    content=超时回复-${AdminUser.tenantId}-${uuid}    contentType=0
    ${data}    set variable    {"type":${defaultReplyEntity.type},"content":"${defaultReplyEntity.content}","contentType":${defaultReplyEntity.contentType}}
    ${j}    Set Robot AutoReply    post    ${AdminUser}    ${filter}    ${data}
    Should Be Equal    ${j['content']}    ${defaultReplyEntity.content}    返回的机器人超时回复content值不正确：${j}
    Should Be Equal    ${j['type']}    ${${defaultReplyEntity.type}}    返回的机器人超时回复type值不正确：${j}

删除机器人默认回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    删除机器人默认回复
    #添加默认回复数据
    ${type}    set variable    0
    ${autoReplyResult}    Add Robot AutoReply    ${AdminUser}    ${type}
    ${replyId}    set variable    ${autoReplyResult.replyId}
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=${type}    #设置type=0，参数为默认回复数据
    ${uuid}    Uuid 4
    #删除默认回复
    ${j}    Set Robot AutoReply    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${replyId}
    Should Be Equal    ${j}    ${1}    删除默认回复接口返回不为1：${j}

删除机器人重复回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    删除机器人重复回复
    #添加默认重复数据
    ${type}    set variable    1
    ${autoReplyResult}    Add Robot AutoReply    ${AdminUser}    ${type}
    ${replyId}    set variable    ${autoReplyResult.replyId}
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=${type}    #设置type=1，参数为重复回复数据
    ${uuid}    Uuid 4
    #删除重复回复
    ${j}    Set Robot AutoReply    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${replyId}
    Should Be Equal    ${j}    ${1}    删除重复回复接口返回不为1：${j}

删除机器人超时回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Documentation]    删除机器人超时回复
    #添加默认超时数据
    ${type}    set variable    2
    ${autoReplyResult}    Add Robot AutoReply    ${AdminUser}    ${type}
    ${replyId}    set variable    ${autoReplyResult.replyId}
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    type=${type}    #设置type=2，参数为超时回复数据
    ${uuid}    Uuid 4
    #删除超时回复
    ${j}    Set Robot AutoReply    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${replyId}
    Should Be Equal    ${j}    ${1}    删除重复回复接口返回不为1：${j}

获取机器人转人工设置(/v1/Tenants/{tenantId}/robots/robotUserTransferKf)
    [Documentation]    获取机器人转人工设置
    #获取机器人转人工设置
    ${j}    Set RobotUserTransferKf Setting    get    ${AdminUser}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人转人工设置不正确：${j}

修改机器人转人工设置(/v1/Tenants/{tenantId}/robots/robotUserTransferKf)
    [Documentation]    修改机器人转人工设置
    #获取机器人转人工设置
    &{j}    Set RobotUserTransferKf Setting    get    ${AdminUser}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人转人工设置不正确：${j}
    #设置修改请求数据
    set to dictionary    ${j}    enableTransferReply=update-${j.enableTransferReply}    disableTransferReply=update-${j.disableTransferReply}
    ${data}    dumps    ${j}
    #修改机器人转人工设置
    ${j1}    Set RobotUserTransferKf Setting    put    ${AdminUser}    ${data}
    Should Be Equal    '${j1['enableTransferReply']}'    '${j.enableTransferReply}'    修改转人工设置后的enableTransferReply值不正确：${j1}
    Should Be Equal    '${j1['disableTransferReply']}'    '${j.disableTransferReply}'    修改转人工设置后的disableTransferReply值不正确：${j1}

获取多机器人设置(/v1/Tenants/{tenantId}/robot/profile/settings)
    [Documentation]    获取多机器人设置
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取多机器人资料信息
    ${j}    Get MutilRobot PersonalInfos Settings    ${AdminUser}    ${filter}
    ${length}    set variable    @{j['content']} 
    Should Be True    ${length} > 0    接口返回值中content的数据不正确 ,${j}
    Should Be True    ${j['totalElements']} > 0    接口返回值中totalElements不正确 ,${j}

修改机器人设置(/v1/Tenants/{tenantId}/robot/profile/settings)
    [Documentation]    1、获取机器人的资料信息    2、获取机器人设置    3、修改第一个机器人的设置
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取多机器人资料信息
    ${robotInfo}    Get MutilRobot PersonalInfos	${AdminUser}    ${filter}
    ${robotName}    set variable    ${robotInfo['content'][0]['name']}
    ${robotRulesCount}    set variable    ${robotInfo['content'][0]['rulesCount']}
    #获取多机器人设置
    ${robotSettings}    Get MutilRobot PersonalInfos Settings    ${AdminUser}    ${filter}
    ${length}    set variable    @{robotSettings['content']} 
    Should Be True    ${length} > 0    接口返回值中content的数据不正确 ,${robotSettings}
    Should Be True    ${robotSettings['totalElements']} > 0    接口返回值中totalElements不正确 ,${robotSettings}
    #获取第一个机器人的设置，并添加name和rulesCount字段
    &{robotDic}    set variable    ${robotSettings['content'][0]}    #获取第一个机器人的设置
    set to dictionary    ${robotDic}    name=${robotName}    rulesCount=${robotRulesCount}
    ${robotEntity}    dumps    ${robotDic}
    #创建修改请求数据
    ${data}    set variable    ${robotEntity}
    #修改机器人设置
    ${j}    Update Robot Settings    ${AdminUser}    ${data}
    #移除新增的name和rulesCount字段，并验证结果
    Remove From Dictionary    ${robotDic}    name    rulesCount
    Dictionaries Should Be Equal    ${j}    ${robotDic}    字典的结果不相同,实际返回值:${j}, 预期值:${robotDic}
