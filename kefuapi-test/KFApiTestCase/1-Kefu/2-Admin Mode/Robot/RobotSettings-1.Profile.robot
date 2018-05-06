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

获取机器人引导业务场景(/v1/Tenants/{tenantId}/robots/robotGuide/categorys)
    [Documentation]    获取机器人引导业务场景。断言引导业务场景数据 ,包括字段: kbCategoryId、kbCategoryName、kbCategoryDesc
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Get RobotGuide Categorys    ${AdminUser}    ${filter}
    #断言接口数据
    ${length}    get length    ${j}
    Should Be True    ${length} == 4    获取数据不是四组, ${j}
    RobotGuide Categorys Should Be Equal    ${j}

获取机器人引导业务场景下各功能数据(/v1/Tenants/{tenantId}/robots/robotGuide/applyTemplates/{type})
    [Documentation]    获取机器人引导业务场景下各功能数据,分别在type为0、1、2、3下，断言返回结果
    #设置{type}可取值的总数
    ${sum}    set variable    ${4}
    &{type0}    create dictionary    ruleCount=${2}    menuCount=${4}    promptCount=${4}
    &{type1}    create dictionary    ruleCount=${2}    menuCount=${9}    promptCount=${4}
    &{type2}    create dictionary    ruleCount=${4}    menuCount=${17}    promptCount=${4}
    &{type3}    create dictionary    ruleCount=${1}    menuCount=${15}    promptCount=${4}
    #循环4个获取接口并断言返回值 
    :FOR    ${i}    IN RANGE    ${sum}
    \    #使用局部变量进行筛选
    \    &{j}    Get RobotGuide ApplyTemplates    ${AdminUser}    ${i}
    \    #断言接口数据
    \    Dictionaries Should Be Equal    ${j}    ${type${i}}    返回结果不正确：${j}

获取机器人引导自动回复模板数据(/v1/Tenants/{tenantId}/robots/robotGuide/applyTemplates/{type})
    [Documentation]    获取机器人引导自动回复模板数据,分别在type为0、1、2、3下，断言返回结果
    #设置{type}可取值的总数
    ${sum}    set variable    ${4}
    ${filter}    copy dictionary    ${RobotFilter}
    #type为0、1、2、3下,循环4个获取接口并断言返回值
    :FOR    ${i}    IN RANGE    ${sum}
    \    #使用局部变量进行筛选,设置{type}可取值的总数
    \    ${j}    Get RobotGuide Prompt    ${AdminUser}    ${filter}    ${i}
    \    #断言接口数据
    \    ${length}    get length    ${j}
    \    Should Be True    ${length} == 4    获取数据不是四组, ${j}
    \    RobotGuide ApplyTemplates Should Be Equal    ${${i}}    ${j}