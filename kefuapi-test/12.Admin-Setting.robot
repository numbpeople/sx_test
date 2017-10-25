*** Settings ***
Suite Setup       Run Keywords    Clear Stickers
...               AND    log    【Admin-Setting】case 执行开始
Suite Teardown    log    【Admin-Setting】case 执行结束
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/RoutingApi.robot
Resource          api/KefuApi.robot
Resource          JsonDiff/Channels/RestChannelsJsonDiff.robot
Library           uuid
Resource          commons/admin common/admin_common.robot
Resource          commons/admin common/BaseKeyword.robot
Resource          api/SessionCurrentApi.robot
Resource          api/SettingsApi.robot
Resource          api/ChannelsApi.robot
Resource          kefutool/Tools-Resource.robot
Library           lib/KefuUtils.py
Resource          commons/admin common/Setting_common.robot
Resource          commons/admin common/Stickers_Common.robot

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
    ${picpath}    set variable    ${EXECDIR}${/}${/}resource${/}${/}stickers.zip
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    should be equal    ${j['entities'][0]['fileName']}    beautiful_girl.jpeg    返回值中压缩包里的图片名字与预期不符: ${j}
    should be equal    ${j['entities'][0]['packageName']}.zip    ${fileEntity.filename}    返回值中压缩包名称与预期不符: ${j}

删除自定义表情包(/v1/emoj/tenants/{tenantId}/packages)
    #上传表情包
    ${picpath}    set variable    ${EXECDIR}${/}${/}resource${/}${/}stickers.zip
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #删除表情包
    ${j}    Delete Stickers    ${AdminUser}    ${j['entities'][0]['packageId']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

排序自定义表情包(/v1/emoj/tenants/{tenantId}/packages/sort)
    #上传表情包
    ${picpath}    set variable    ${EXECDIR}${/}${/}resource${/}${/}stickers.zip
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
