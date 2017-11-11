*** Settings ***
Suite Setup       Run Keywords    Setting Setup
...               AND    log    【Admin-Setting】case 执行开始
Suite Teardown    Run Keywords    Setting Teardown
...               AND    log    【Admin-Setting】case 执行结束
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Library           lib/KefuUtils.py
Resource          AgentRes.robot
Resource          JsonDiff/Channels/RestChannelsJsonDiff.robot
Resource          commons/admin common/BaseKeyword.robot
Resource          tool/Tools-Resource.robot
Resource          commons/admin common/Setting/Business-Hours_Common.robot
Resource          commons/admin common/Setting/Permissions_Common.robot
Resource          commons/admin common/Setting/Stickers_Common.robot
Resource          commons/admin common/Setting/Questionnaire_Common.robot
Resource          commons/admin common/Setting/Phrases_Common.robot
Resource          commons/CollectionData/Setting Colletion.robot
Resource          api/BaseApi/Settings/RemindApi.robot

*** Test Cases ***
查询所有短信配置(/v1/tenants/{tenantId}/sms/reminds)
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

添加超时短信配置(/v1/tenants/{tenantId}/sms/create-remind)
    ${data}=    set variable    {"tenantId":${AdminUser.tenantId},"remindType":"WaitingsessionTimeout","remindName":"待接入超时提醒","receiver":[{"userName":"421351841@qq.com","niceName":"myqq","queueId":10,"phone":"13810515454"}],"sendShortMessageTimeZone":"timeAllDuty","sendCount":1,"remainCount":100,"waitTimeout":60,"twoShortMessageDiffTime":70}
    ${resp}=    /v1/tenants/{tenantId}/sms/create-remind    ${AdminUser}    ${data}    ${timeout}
    @{code_list}    Create List    ${400}    ${200}
    List Should Contain Value    ${code_list}    ${resp.status_code}    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

按id查询、更改、删除短信配置(/v1/tenants/{tenantId}/sms/reminds/{id}/status)
    #按id查询
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}    get    ${AdminUser}    ${SmsRemindEntity.id}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #按id更改
    ${data}    set variable    {"id":${SmsRemindEntity.id},"tenantId":${AdminUser.tenantId},"remindType":"WaitingsessionTimeout","remindName":"待接入超时提醒1","receiver":[{"userName":"421351841@qq.com","niceName":"myqq","queueId":10,"phone":"13810515454"}],"sendShortMessageTimeZone":"timeAllDuty","sendCount":1,"remainCount":100,"waitTimeout":60,"twoShortMessageDiffTime":70}
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}    put    ${AdminUser}    ${SmsRemindEntity.id}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #按id删除
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}    delete    ${AdminUser}    ${SmsRemindEntity.id}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}

修改短信提醒开关(/v1/tenants/{tenantId}/sms/reminds/{id}/status)
    #按id更改
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}/status    ${AdminUser}    ${SmsRemindEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

获取所有的时间计划(/v1/tenants/{tenantId}/timeplans/schedules)
    #获取时间计划
    ${j}=    Business hours    ${AdminUser}
    should be equal    ${j['status']}    OK
    #将返回的时间列表设置为全局变量
    set global variable    ${timePlanSchedulesIds}    ${j}

获取工作日设置(/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/weekdays)
    #使用第一个时间计划数据
    ${scheduleId}    set variable    ${timePlanSchedulesIds['entities'][0]['scheduleId']}
    #根据时间计划获取工作日设置
    ${j}=    Workdays    ${AdminUser}    ${scheduleId}
    should be equal    ${j['status']}    OK

获取自定义工作日设置(/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes)
    #使用第一个时间计划数据
    ${scheduleId}    set variable    ${timePlanSchedulesIds['entities'][0]['scheduleId']}
    #根据时间计划获取自定义工作设置
    ${j}=    Custom Workdays    ${AdminUser}    ${scheduleId}
    should be equal    ${j['status']}    OK

获取节假日设置(/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays)
    #使用第一个时间计划数据
    ${scheduleId}    set variable    ${timePlanSchedulesIds['entities'][0]['scheduleId']}
    #根据时间计划获取节假日设置
    ${j}=    Holidays    ${AdminUser}    ${scheduleId}
    should be equal    ${j['status']}    OK

获取自定义表情包(/v1/emoj/tenants/{tenantId}/packages)
    #获取表情包
    ${j}    Get Stickers    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['type']}    CUSTOM    返回值中type字段不等于CUSTOM: ${j}

上传自定义表情包(/v1/emoj/tenants/{tenantId}/packages)
    #获取当前的表情包个数
    ${length}    Get Stickers Numbers    ${AdminUser}
    Run Keyword If    ${length} >= 5    Fail    租户下的表情包超过5个，该用例会执行失败，标识为fail
    #上传表情包
    ${picpath}    set variable    ${CURDIR}${/}${/}resource${/}${/}stickers.zip
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    should be equal    ${j['entities'][0]['fileName']}    beautiful_girl.jpeg    返回值中压缩包里的图片名字与预期不符: ${j}
    should be equal    ${j['entities'][0]['packageName']}.zip    ${fileEntity.filename}    返回值中压缩包名称与预期不符: ${j}

删除自定义表情包(/v1/emoj/tenants/{tenantId}/packages)
    #上传表情包
    ${picpath}    set variable    ${CURDIR}${/}${/}resource${/}${/}stickers.zip
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #删除表情包
    ${j}    Delete Stickers    ${AdminUser}    ${j['entities'][0]['packageId']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

排序自定义表情包(/v1/emoj/tenants/{tenantId}/packages/sort)
    #上传表情包
    ${picpath}    set variable    ${CURDIR}${/}${/}resource${/}${/}stickers.zip
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    @{list}    Create List
    #获取当前的表情包个数
    ${length}    Get Stickers Numbers    ${AdminUser}
    Run Keyword If    ${length} >= 3    Fail    租户下的表情包超过3个，该用例会执行失败，标识为fail
    #上传多个表情包
    : FOR    ${i}    IN RANGE    2
    \    Upload Stickers    ${AdminUser}    ${fileEntity}
    #获取表情包
    ${j}    Get Stickers    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #将所有的packageId存入list
    : FOR    ${i}    IN    @{j['entities']}
    \    ${id}    convert to integer    ${i['id']}
    \    Append To List    ${list}    ${id}
    #将所得到的list进行排序
    ${k}    Sort Stickers    ${AdminUser}    ${list}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${k}

获取自定义表情包文件(/v1/emoj/tenants/{tenantId}/packages/{packageId}/files)
    #获取当前的表情包个数
    ${length}    Get Stickers Numbers    ${AdminUser}
    Run Keyword If    ${length} >= 5    Fail    租户下的表情包超过5个，该用例会执行失败，标识为fail
    #上传表情包
    ${picpath}    set variable    ${CURDIR}${/}${/}resource${/}${/}stickers.zip
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j1}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j1['status']}    OK    返回值中status不等于OK: ${j1}
    #获取表情文件
    ${j}    Get Stickers Files    ${AdminUser}    ${j1['entities'][0]['packageId']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Fail    租户下的表情包文件不存在，需要检查下，${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['fileName']}    beautiful_girl.jpeg    返回值中压缩包里的图片名字与预期不符: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['packageId']}    ${j1['entities'][0]['packageId']}    返回值中压缩包的id不是预期: ${j}

获取问卷账号列表(/v1/tenants/{tenantId}/questionnaires/accounts)
    #获取问卷账号列表
    ${j}    Set Questionnaire    ${AdminUser}    get    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

创建问卷账号列表(/v1/tenants/{tenantId}/questionnaires/accounts)
    #创建问卷账号列表
    ${data}    set variable    {"type":"WJW" }
    ${j}    Set Questionnaire    ${AdminUser}    post    ${data}
    ${tenantid}    convert to string    ${AdminUser.tenantId}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['tenant_id']}    ${AdminUser.tenantId}    返回值中租户id不正确: ${j}
    should be equal    ${j['entity']['type']}    WJW    返回值中的类型不正确: ${j}
    should be equal    ${j['entity']['status']}    Enable    返回值中的状态不正确: ${j}
    Should Contain    ${j['entity']['username']}    ${tenantid}    返回值中的账号名称不正确: ${j}

获取问卷问题列表(/v1/tenants/{tenantId}/questionnaires/list)
    #获取问卷账号列表
    ${j}    Get Questionnaires List    WJW
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

删除问卷账号列表(/v1/tenants/{tenantId}/questionnaires/accounts)
    #创建问卷账号列表
    ${data}    set variable    {"type":"WJW" }
    ${j}    Set Questionnaire    ${AdminUser}    delete    ${data}
    ${tenantid}    convert to string    ${AdminUser.tenantId}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['tenant_id']}    ${AdminUser.tenantId}    返回值中租户id不正确: ${j}
    should be equal    ${j['entity']['type']}    WJW    返回值中的类型不正确: ${j}
    should be equal    ${j['entity']['status']}    Deleted    返回值中的状态不正确: ${j}
    Should Contain    ${j['entity']['username']}    ${tenantid}    返回值中的账号名称不正确: ${j}

获取权限角色列表(/v1/permission/tenants/{tenantId}/roles)
    #获取角色列表
    ${j}    Set Roles    get    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entities'][0]['role_name']}    admin    返回值中role_name不正确: ${j}
    should be equal    ${j['entities'][0]['role_type']}    SYSTEM    返回值中role_type不正确: ${j}
    should be equal    ${j['entities'][0]['role_description']}    管理员    返回值中role_description不正确: ${j}
    should be equal    ${j['entities'][1]['role_name']}    agent    返回值中role_name不正确: ${j}
    should be equal    ${j['entities'][1]['role_description']}    座席    返回值中role_description不正确: ${j}
    should be equal    ${j['entities'][0]['status']}    ENABLE    返回值中status不正确: ${j}

获取权限菜单列表(/v1/permission/tenants/{tenantId}/users/{userId}/resource_categories)
    #获取菜单列表
    ${j}    Get Resource Categories
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['user_id']}    ${AdminUser.userId}    返回值中user_id不正确: ${j}

新增权限角色(/v1/permission/tenants/{tenantId}/roles)
    #新增角色
    ${uuid}    Uuid 4
    ${role_name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"role_name":"${role_name}"}
    ${j}    Set Roles    post    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['role_name']}    ${role_name}    返回值中role_name不正确: ${j}
    should be equal    ${j['entity']['role_type']}    CUSTOMIZED    返回值中role_type不正确: ${j}
    should be equal    ${j['entity']['status']}    ENABLE    返回值中status不正确: ${j}

根据roleId查询菜单(/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories)
    #新增角色
    ${uuid}    Uuid 4
    ${role_name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"role_name":"${role_name}"}
    ${j}    Set Roles    post    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['role_name']}    ${role_name}    返回值中role_name不正确: ${j}
    should be equal    ${j['entity']['role_type']}    CUSTOMIZED    返回值中role_type不正确: ${j}
    should be equal    ${j['entity']['status']}    ENABLE    返回值中status不正确: ${j}
    #根据roleId设置菜单
    ${j}    Set Resource Categories Via RoleId    get    ${j['entity']['role_id']}    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

根据roleId新增菜单(/v1/permission/tenants/{tenantId}/roles/{roleId}/resource_categories)
    #新增角色
    ${uuid}    Uuid 4
    ${role_name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${data}    set variable    {"role_name":"${role_name}"}
    ${j}    Set Roles    post    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['role_name']}    ${role_name}    返回值中role_name不正确: ${j}
    should be equal    ${j['entity']['role_type']}    CUSTOMIZED    返回值中role_type不正确: ${j}
    should be equal    ${j['entity']['status']}    ENABLE    返回值中status不正确: ${j}
    #根据roleId设置菜单
    ${data}    set variable    {"resource_categories":["agent_currentsession"]}
    ${j}    Set Resource Categories Via RoleId    post    ${j['entity']['role_id']}    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

获取分类以及常用语列表(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，坐席模式获取个人常用语
    &{phrasesEntity}    create dictionary    systemOnly=false    buildChildren=true    buildCount=true
    #获取常用语分类
    ${j}    Set Phrases    ${AdminUser}    get    ${orgEntity}    ${phrasesEntity}    ${EMPTY}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Fail    租户下的没有个人常用语分类，需要检查下，${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}

添加分类(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}

添加公共常用语(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在新建分类下新增公共常用语
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=1
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

添加子分类(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在分类下新增子分类
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=0
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

修改公共常用语(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在新建分类下新增公共常用语
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=1
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}
    #修改公共常用语
    &{changePhrasesEnt}    create dictionary    id=${j['entity']['id']}    leaf=true    parentId=${phrasesEnt.parentId}    phrase=${AdminUser.tenantId}-${uuid}-${uuid}    brief=
    ${data1}    set variable    {"id":${changepHrasesEnt.id},"leaf":${changepHrasesEnt.leaf},"parentId":${changepHrasesEnt.parentId},"phrase":"${changepHrasesEnt.phrase}","brief":"${changepHrasesEnt.brief}"}
    ${j}    Set Phrases    ${AdminUser}    put    ${orgEntity}    ${phrasesEntity}    ${data1}
    ...    ${changePhrasesEnt.id}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${changepHrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

修改子分类名称(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在分类下新增子分类
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=0
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}
    #修改子分类名称
    &{changePhrasesEnt}    create dictionary    id=${j['entity']['id']}    leaf=false    parentId=${phrasesEnt.parentId}    phrase=${AdminUser.tenantId}-${uuid}-${uuid}
    ${data1}    set variable    {"id":${changepHrasesEnt.id},"leaf":${changepHrasesEnt.leaf},"parentId":${changepHrasesEnt.parentId},"phrase":"${changepHrasesEnt.phrase}"}
    ${j}    Set Phrases    ${AdminUser}    put    ${orgEntity}    ${phrasesEntity}    ${data1}
    ...    ${changePhrasesEnt.id}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${changepHrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

删除分类(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #删除常用语分类
    ${j}    Set Phrases    ${AdminUser}    delete    ${orgEntity}    ${phrasesEntity}    ${EMPTY}
    ...    ${j['entity']['id']}
    should be equal    ${j['status']}    OK    获取status值不正确：${j}

删除公共常用语(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在新建分类下新增公共常用语
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=1
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}
    #删除共公常用语
    ${j}    Set Phrases    ${AdminUser}    delete    ${orgEntity}    ${phrasesEntity}    ${EMPTY}
    ...    ${j['entity']['id']}
    should be equal    ${j['status']}    OK    获取status值不正确：${j}
