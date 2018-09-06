*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../AgentRes.robot
Resource          ../../JsonDiff/KefuJsonDiff.robot
Resource          ../../commons/admin common/BaseKeyword.robot
Resource          ../HomePage_Common/Login_Common.robot
Resource          ../admin common/Channels/App_Common.robot
Resource          ../admin common/Robot/RobotSettings_Common.robot
Resource          ../agent common/Export/Export_Common.robot
Resource          ../admin common/Setting/ConversationTags_Common.robot
Resource          ../admin common/Setting/CustomerTags_Common.robot
Resource          ../admin common/Note/Note_Common.robot
Resource          ../Initializtion_Common/Initializtion_Common.robot
Resource          ../admin common/Knowledge/Knowledge_Common.robot

*** Keywords ***
Login Init
    [Documentation]    坐席登录，初始化cookie、tenantId、userid等信息
    Create Session    adminsession    ${kefuurl}
    ${j}    ${resp}    Login    adminsession    ${AdminUser}
    ${temp}    to json    ${loginJson}
    set to dictionary    ${temp['agentUser']}    username=${AdminUser.username}    onLineState=${AdminUser.status}    state=${AdminUser.status}    currentOnLineState=${AdminUser.status}
    ${r}=    loginJsonDiff    ${temp}    ${j}
    set global variable    ${loginJson}    ${j}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=adminsession    nicename=${j['agentUser']['nicename']}
    set global variable    ${AdminUser}    ${AdminUser}
    ${DR}=    InitFilterTime
    set global variable    ${DateRange}    ${DR}

OrganInfo Init
    [Documentation]    坐席登录后，获取租户所属的organId和organName
    ${j}    Get OrganInfo    ${AdminUser}
    ${temp}    to json    ${infosJson}
    ${r}=    infosJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    infos数据不正确：${r}
    set global variable    ${infosJson}    ${j}
    set to dictionary    ${orgEntity}    organId=${j['entity']['orgId']}    organName=${j['entity']['orgName']}
    set global variable    ${orgEntity}    ${orgEntity}

Agent Data Init
    [Documentation]    获取坐席登录后的坐席账号等信息
    ${j}    Get Agent Info    ${AdminUser}
    ${r}=    TenantsMeAgentsMeJsonDiff    ${loginJson['agentUser']}    ${j}
    Should Be True    ${r['ValidJson']}    获取坐席数据失败：${r}
    set global variable    ${TenantsMeAgentsMeJson}    ${j}

Robot Account Init
    [Documentation]    判断租户下是否有机器人账号，如果有则不创建，如果没有则创建机器人账号
    #判断该租户下是否有机器人账号，有则跳过，无则创建并训练机器人完成任务(多机器人暂未考虑，只考虑使用默认机器人)
    ${robotInfoLength}    Get Mutil Robot Count    ${AdminUser}
    run keyword if    ${robotInfoLength} == 0    Create Robot Account    #租户下没有机器人账号，创建机器人账号并设置信息
    run keyword if    ${robotInfoLength} >= 1    Update Robot Profile    #租户下有机器人账号，为机器人训练完成
    #创建机器人账号完毕

Ticket Data Init
    [Documentation]    获取租户id下的projectId和留言状态等值
    Get ProjectId    ${AdminUser}    #获取projectId,并设置projectId为全局变量

Setup Data
    [Documentation]    坐席账号初始化登录数据、获取灰度列表、获取租户所属organ信息、创建关联信息等的初始化工作
    Login Init    #坐席登录，初始化cookie、tenantId、userid等信息
    Run Keyword And Ignore Error	OrganInfo Init    #坐席登录后，获取租户所属的organId和organName
    Run Keyword And Ignore Error	Agent Data Init    #获取坐席登录后的坐席账号等信息
    Run Keyword And Ignore Error    Create Channel    #快速创建一个关联，以便于全局使用
    Run Keyword And Ignore Error    Robot Account Init    #判断租户下是否有机器人账号，如果有则不创建，如果没有则创建机器人账号
    Run Keyword And Ignore Error    Ticket Data Init    #获取租户id下的projectId和留言状态等值
    Run Keyword And Ignore Error    Get GrayList    #查询增值/灰度功能列表

Clear Data
    Delete Channels    #删除关联
    Delete Queues    #删除技能组
    Delete Agentusers    #删除坐席
    Delete Robot Datas With SpecifiedKey    #删除机器人分类、知识规则、自定义菜单
    Delete ServiceSessionSummaries With SpecifiedKey    #删除会话标签测试数据
    Delete UserTag With SpecifiedKey    #删除客户标签测试数据
    Del Export Files    #删除导出缓存在目录下的文件
    Delete Knowledge Entry And Category With Specify Name    #删除知识库中知识和分类
