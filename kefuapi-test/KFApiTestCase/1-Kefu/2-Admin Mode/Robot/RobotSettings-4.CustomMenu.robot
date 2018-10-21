*** Settings ***
Force Tags        customMenu
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
获取机器人自定义菜单(接口较旧，蓝月亮私有版本仍使用，暂存留)(/v1/Tenants/{tenantId}/robot/menu/items)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取机器人自定义菜单，调用接口：/v1/Tenants/{tenantId}/robot/menu/items，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、first字段值等于True。
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #获取机器人自定义菜单
    ${j}    Get Robot Rules Menu(Old)    ${AdminUser}    ${filter}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${j}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人自定义菜单不正确：${j}

创建机器人自定义菜单(/v3/Tenants/{tenantId}/robots/menus/item)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建机器人自定义菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、返回值中各字段等于预期值。
    #使用局部变量进行筛选
    ${filter}    copy dictionary    ${RobotFilter}
    #创建数据字典
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.nicename}
    &{menuEntity}    create dictionary    parentId=null    name=添加父级自定义菜单-${AdminUser.tenantId}-${randoNumber}    menuAnswerType=MENU    level=0    desc=
    ...    rootId=null    robotId=${AdminUser.tenantId}    returnUpperLayer=false
    #设置请求体
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"parentId":"${menuEntity.parentId}","name":"${menuEntity.name}","menuAnswerType":"${menuEntity.menuAnswerType}","level":"${menuEntity.level}","desc":"${menuEntity.desc}","rootId":"${menuEntity.rootId}","robotId":${menuEntity.robotId},"returnUpperLayer":${menuEntity.returnUpperLayer}}}
    #创建机器人自定义菜单
    ${j}    Set Robot Menu    post    ${AdminUser}    ${data}
    Should Be Equal    '${j['status']}'    'OK'    返回的接口字段status不正确：${j}
    Should Be Equal    '${j['entity']['robotId']}'    '${menuEntity.robotId}'    返回的接口字段robotId不正确：${j}
    Should Be Equal    '${j['entity']['parentId']}'    'root'    返回的接口字段parentId不正确：${j}
    Should Be Equal    '${j['entity']['name']}'    '${menuEntity.name}'    返回的接口字段name不正确：${j}

删除自定义菜单(/v3/Tenants/{tenantId}/robots/menus/item)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建机器人自定义菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step1、删除自定义菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #创建父级菜单
    ${parentResult}    Create Robot Parent Menu    ${AdminUser}
    #创建数据字典
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.nicename}
    #设置请求体
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"}}
    #删除机器人自定义菜单
    ${j}    Set Robot Menu    delete    ${AdminUser}    ${data}    ${parentResult.parentId}
    Should Be Equal    '${j['status']}'    'OK'    返回的接口字段status不正确：${j}

创建机器人子菜单(/v3/Tenants/{tenantId}/robots/menus/item)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建机器人自定义父级菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step2、基于父级菜单，创建子级菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #创建父级菜单
    ${parentResult}    Create Robot Parent Menu    ${AdminUser}
    #创建子菜单
    ${sunMenuResult}    Create Robot Sub Menu    ${AdminUser}    ${parentResult.parentId}
    Should Be Equal    '${sunMenuResult.parentId}'    '${parentResult.parentId}'    返回的接口字段parentId不正确: ${sunMenuResult}

添加子菜单的文本答案(/v3/Tenants/{tenantId}/robots/menus/item/{itemId}/menu-answer)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建机器人自定义父级菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step2、基于父级菜单，创建子级菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step3、在子级菜单添加文本答案，调用接口：/v3/Tenants/{tenantId}/robots/menus/item/{itemId}/menu-answer，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、并且各自段返回值等于预期值。
    #创建父级菜单
    ${parentResult}    Create Robot Parent Menu    ${AdminUser}
    #创建子菜单
    ${sunMenuResult}    Create Robot Sub Menu    ${AdminUser}    ${parentResult.parentId}
    Should Be Equal    '${sunMenuResult.parentId}'    '${parentResult.parentId}'    返回的接口字段parentId不正确: ${sunMenuResult}
    #创建数据字典
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    &{adminEntity}    create dictionary    userId=${AdminUser.userId}    name=${AdminUser.nicename}
    &{answerEntity}    create dictionary    answer=子菜单的文本答案-${AdminUser.tenantId}-${randoNumber}    type=TEXT
    #设置请求体
    ${data}    set variable    {"admin":{"userId":"${adminEntity.userId}","name":"${adminEntity.name}"},"entity":{"answer":"${answerEntity.answer}","type":"${answerEntity.type}"}}
    #添加子菜单的文本答案
    ${j}    Add Menu Answer    ${AdminUser}    ${data}    ${sunMenuResult.subMenuId}
    Should Be Equal    '${j['status']}'    'OK'    返回的接口字段status不正确：${j}
    Should Be Equal    '${j['entity']['answer']}'    '${answerEntity.answer}'    返回的接口字段answer不正确：${j}
    Should Be Equal    '${j['entity']['type']}'    '${answerEntity.type}'    返回的接口字段type不正确：${j}

获取自定义菜单(/v3/Tenants/{tenantId}/robots/menus/search)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建机器人自定义父级菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/item，接口请求状态码为200。
    ...    - Step2、获取自定义菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/search，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、并且各自段返回值等于预期值。
    #创建父级菜单
    ${parentResult}    Create Robot Parent Menu    ${AdminUser}
    #创建请求数据
    ${filter}    copy dictionary    ${RobotFilter}
    #获取自定义菜单
    ${j}    Get Robot Menus    ${AdminUser}    ${filter}
    Should Be Equal    ${j['status']}    OK    接口返回的status不正确,正确值是:OK,返回结果:${j}
    Should Be Equal    ${j['entity'][0]['menu']['name']}    ${parentResult.name}    接口返回的name不正确,正确值是:${parentResult.name}返回结果:${j}
    Should Be Equal    ${j['entity'][0]['menu']['id']}    ${parentResult.parentId}    接口返回的id不正确,正确值是:${parentResult.parentId},返回结果:${j}
    Should Be Equal    ${${j['entity'][0]['menu']['robotId']}}    ${parentResult.robotId}    接口返回的robotId不正确,正确值是:${parentResult.robotId},返回结果:${j}

下载自定义菜单模板(/v1/Tenants/{tenantId}/robot/menu/template/export)
    [Documentation]    【操作步骤】：
    ...    - Step1、下载自定义菜单模板，调用接口：/v1/Tenants/{tenantId}/robot/menu/template/export，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回headers中Content-Type值等于application/octet-stream; charset=UTF-8。
    #下载自定义菜单模板
    ${resp}=    Download Robot Menu Template    ${AdminUser}
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败

导出自定义菜单(/v3/Tenants/{tenantId}/robots/menus/items/export)
    [Documentation]    【操作步骤】：
    ...    - Step1、导出自定义菜单，调用接口：/v3/Tenants/{tenantId}/robots/menus/items/export，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、返回headers中Content-Type值等于application/octet-stream; charset=UTF-8。
    #导出自定义菜单
    ${resp}=    Export Robot Menu    ${AdminUser}
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败
