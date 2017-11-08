*** Settings ***
Suite Setup       Run Keywords    Create Template
...               AND    Clear Stickers
...               AND    log    设置全局config ,【Webim】case 执行开始
Suite Teardown    Run Keywords    Delete Template
...               AND    Clear Stickers
...               AND    log    删除新增加的config ,【Webim】case 执行结束
Force Tags        webim
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          AgentRes.robot
Resource          api/KefuApi.robot
Resource          JsonDiff/KefuJsonDiff.robot
Resource          commons/admin common/Channels/Webim_Common.robot
Resource          JsonDiff/WebimChannels/WebimChannelsJsonDiff.robot
Resource          commons/admin common/Setting/Stickers_Common.robot
Resource          commons/admin common/Setting/Business-Hours_Common.robot
Resource          api/BaseApi/Channels/WebimApi.robot

*** Test Cases ***
网页插件下班时间是否显示留言(/v1/webimplugin/showMessage)
    ${resp}=    /v1/webimplugin/showMessage    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==${True}    log    下班时间显示留言
    ...    ELSE IF    ${j}==${False}    log    下班时间不显示留言
    ...    ELSE    Should Be True    ${j}    下班时间是否显示留言返回结果不正确

网页插件获取欢迎语(/v1/webimplugin/welcome)
    ${resp}=    /v1/webimplugin/welcome    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}    #Run Keyword If    ${resp.content}==''    log
    ...    # 欢迎语未开启    # ELSE    log    ${resp.content}

网页插件获取主题信息(/v1/webimplugin/theme/options)
    ${resp}=    /v1/webimplugin/theme/options    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==[]    log    主题为空
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确

网页插件获取信息栏信息(/v1/webimplugin/notice/options)
    ${resp}=    /v1/webimplugin/notice/options    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==[]    log    主题为空
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确

网页插件获取模板信息(/v1/webimplugin/settings/template)
    #获取网页插件模板返回值
    ${j}    Get Template    ${AdminUser}
    #将json转化成字典
    &{j1}    loads    ${j}
    &{WebimTemplateChannelJson1}    loads    ${WebimTemplateChannelJson}
    #断言返回状态值和json结构与值是否一致
    Should Be Equal    ${j1.status}    OK    获取的模板返回值status不等于OK: {j1}
    Dictionaries Should Be Equal    ${j1}    ${WebimTemplateChannelJson1}    模板的结果和预期不相等，实际：${j}，预期：${WebimTemplateChannelJson}

网页插件获取配置(/v1/webimplugin/settings/tenants/{tenantId}/configs)
    #获取网页插件配置返回值
    ${curTime}    get time    epoch
    ${j}    Configs    ${AdminUser}    get
    should be equal    ${j['status']}    OK    结果中不包含"OK", ${j}
    #创建新的网页插件配置
    ${data}    set variable    {"configName":"测试${curTime}","isDefault":false}
    ${j}    Configs    ${AdminUser}    post    ${data}
    should be equal    ${j['status']}    OK    结果中不包含"OK", ${j}
    #获取configId
    ${configId}    set variable    ${j['entity']['configId']}
    #修改网页插件配置
    &{WebimTemplateChannelJson1}    loads    ${WebimTemplateChannelJson}
    ${data}    set variable    ${WebimTemplateChannelJson1.entity}
    ${j}    Update Config    ${AdminUser}    ${configId}    ${data}
    should be equal    ${j['status']}    OK    结果中不包含"OK", ${j}
    #删除网页插件配置
    ${j}    Configs    ${AdminUser}    delete    ${EMPTY}    ${configId}
    should be equal    ${j['status']}    OK    结果中不包含"OK", ${j}
    should be true    ${j['entity']} == 1    结果中获取entity不为1, ${j}

根据configId获取访客端配置(/v1/webimplugin/settings/visitors/configs/${configId})
    #获取网页插件配置返回值
    ${j}    Get Configinfo Via ConfigId    ${AdminUser}    ${templateConfigId}
    #断言返回状态值和json结构与值是否一致
    Should Be Equal    ${j['status']}    OK    获取的模板返回值status不等于OK: {j}
    Should Be Equal    ${j['entity']['configId']}    ${templateConfigId}    返回值的configId与预期不相等: {j}
    Should Be Equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值的tenantId与预期不相等: {j}

获取网页插件的所有关联(/v1/webimplugin/targetChannels)
    #获取网页插件配置返回值
    ${j}    Get Channels
    #断言返回状态值和json结构与值是否一致
    ${status}    Run Keyword And Return Status    Should Contain    ${j}    channelId
    Run Keyword If    "${j}" == "[]"    Fail    租户下没有创建关联 ，请创建关联，返回结果为：-- > ${j}
    Run Keyword If    ${status}    Should Be Equal    ${j[0]['run']}    true    接口返回值不正确：${j}

获取网页插件是否上下班(/v1/webimplugin/tenants/show-message)
    #获取时间计划并设置默认时间计划为全局变量使用
    Get ScheduleId
    #获取关联
    ${channelId}    Get Channels
    #获取网页插件配置返回值
    ${paramData}    create dictionary    channelType=easemob    originType=webim    channelId=${channelId[0]['channelId']}    tenantId=${AdminUser.tenantId}    queueName=
    ...    agentUsername=    timeScheduleId=${timeScheduleId}
    ${j}    Show Message    ${paramData}
    Should Be Equal    ${j['status']}    OK    返回值中status不等于OK: {j}

获取网页渠道系统欢迎语(/v1/webimplugin/welcome)
    #获取网页插件系统欢迎语
    ${j}    Show Company Greeting
    #断言返回状态值和json结构与值是否一致
    ${status}    Run Keyword And Return Status    Should Be Empty    ${j}
    Run Keyword if    ${status}    Pass Execution    该租户没有设置系统欢迎语
    ${data}    Run Keyword Unless    ${status}    Decode Bytes To String In    ${j}    UTF-8
    Run Keyword Unless    ${status}    log    该租户系统欢迎语为：${data}

获取网页渠道机器人欢迎语(/v1/webimplugin/tenants/robots/welcome)
    #获取关联
    ${channelId}    Get Channels
    #获取网页插件机器人欢迎语
    ${paramData}    create dictionary    channelType=easemob    originType=webim    channelId=${channelId[0]['channelId']}    tenantId=${AdminUser.tenantId}    queueName=
    ...    agentUsername=
    ${j}    Show Robot Greeting    ${paramData}
    Should Be Equal    ${j['status']}    OK    返回值中status不等于OK: {j}

获取网页插件技能组绑定欢迎语(/v1/webimplugin/tenants/{tenantId}/skillgroup-menu)
    #获取技能组绑定欢迎语列表
    ${j}    Get Skillgroup-menu
    Should Be Equal    ${j['status']}    OK    返回值中status不等于OK: {j}

获取自定义表情包(/v1/webimplugin/emoj/tenants/{tenantId}/packages)
    #获取表情包
    ${j}    Get Webim Stickers
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['type']}    CUSTOM    返回值中type字段不等于CUSTOM: ${j}

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
    ${j}    Get Webim Stickers Files
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Fail    租户下的表情包文件不存在，需要检查下，${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['fileName']}    beautiful_girl.jpeg    返回值中压缩包里的图片名字与预期不符: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['packageId']}    ${j1['entities'][0]['packageId']}    返回值中压缩包的id不是预期: ${j}
