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
    ${j}    Set Robot PersonalInfo    get    ${AdminUser}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${j}

获取多机器人信息(/v1/Tenants/{tenantId}/robot/profile/personalInfos)
    [Documentation]    获取多机器人信息
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Get MutilRobot PersonalInfos    ${AdminUser}    ${filter}
