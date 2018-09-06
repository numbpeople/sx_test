*** Settings ***
Suite Setup       Webim Setup
Suite Teardown    Webim Teardown
Force Tags        webim
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../../AgentRes.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../../commons/admin common/Channels/Webim_Common.robot
Resource          ../../../../JsonDiff/WebimChannels/WebimChannelsJsonDiff.robot
Resource          ../../../../commons/admin common/Setting/Stickers_Common.robot
Resource          ../../../../commons/admin common/Setting/Business-Hours_Common.robot
Resource          ../../../../api/BaseApi/Channels/WebimApi.robot
Resource          ../../../../commons/CollectionData/Admin Mode/Webim_Collection.robot
Resource          ../../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
网页插件获取欢迎语(/v1/webimplugin/welcome)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户的企业欢迎语信息，调用接口：/v1/webimplugin/welcome，接口请求状态码为200。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200。
    Get Welcome    ${AdminUser}

网页插件获取主题信息(/v1/webimplugin/theme/options)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户网页插件获取主题信息，调用接口：/v1/webimplugin/theme/options，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，如果接口不为[]，tenantId字段等于租户id。
    ${j}    Get Theme Option    ${AdminUser}
    Run Keyword If    "${j}"!="[]"    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确,${j}

网页插件获取信息栏信息(/v1/webimplugin/notice/options)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户网页插件获取信息栏信息，调用接口：/v1/webimplugin/notice/options，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，如果接口不为[]，tenantId字段等于租户id。
    ${j}    Get Notice Option    ${AdminUser}
    Run Keyword If    "${j}"!="[]"    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确,${j}

网页插件获取模板信息(/v1/webimplugin/settings/template)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户网页插件获取模板信息，调用接口：/v1/webimplugin/settings/template，接口请求状态码为200。
    ...    - Step2、根据模板，判断返回实际值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，并且实际返回值各字段结构与预期模板相同。
    #获取网页插件模板返回值
    ${j}    Get Template    ${AdminUser}
    #将json转化成字典
    &{j1}    loads    ${j}
    &{WebimTemplateChannelJson1}    loads    ${WebimTemplateChannelJson}
    log    ${j1}
    log    ${WebimTemplateChannelJson1}
    #断言返回状态值和json结构与值是否一致
    Should Be Equal    ${j1.status}    OK    获取的模板返回值status不等于OK: {j1}
    #获取实际结果和预期结果的entity值
    ${prej}    set variable    ${j1['entity']}
    ${webimjsonResult}    set variable    ${WebimTemplateChannelJson1['entity']}
    WebimTemplate Result Should Be Equal    ${prej}    ${webimjsonResult}

网页插件获取配置(/v1/webimplugin/settings/tenants/{tenantId}/configs)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户网页插件获取配置，调用接口：/v1/webimplugin/settings/tenants/{tenantId}/configs，接口请求状态码为200。
    ...    - Step2、新增网页插件获取配置，调用接口：/v1/webimplugin/settings/tenants/{tenantId}/configs，接口请求状态码为200。
    ...    - Step3、修改网页插件配置，调用接口：/v1/webimplugin/settings/tenants/{tenantId}/configs/{configId}/global，接口请求状态码为200。
    ...    - Step4、删除网页插件配置，调用接口：/v1/webimplugin/settings/tenants/{tenantId}/configs，接口请求状态码为200。
    ...    - Step5、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    删除网页插件配置接口返回值中，status字段值等于OK、entity字段值等于1。
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

根据configId获取访客端配置(/v1/webimplugin/settings/visitors/configs/{configId})
    [Documentation]    【操作步骤】：
    ...    - Step1、根据configId获取访客端配置，调用接口：/v1/webimplugin/settings/visitors/configs/{configId}，接口请求状态码为200。
    ...    - Step2、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段值等于OK、configId字段值等于预期configId值、tenantId字段值等于租户id。
    #获取网页插件配置返回值
    ${j}    Get Configinfo Via ConfigId    ${AdminUser}    ${templateConfigId}
    #断言返回状态值和json结构与值是否一致
    Should Be Equal    ${j['status']}    OK    获取的模板返回值status不等于OK: {j}
    Should Be Equal    ${j['entity']['configId']}    ${templateConfigId}    返回值的configId与预期不相等: {j}
    Should Be Equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值的tenantId与预期不相等: {j}

获取网页插件的所有关联(/v1/webimplugin/targetChannels)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户网页插件的所有关联，调用接口：/v1/webimplugin/targetChannels，接口请求状态码为200。
    ...    - Step2、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，包含channelId和run字段。
    #获取网页插件配置返回值
    ${j}    Get Webimplugin Channels    ${AdminUser}
    #断言返回状态值和json结构与值是否一致
    ${status}    Run Keyword And Return Status    Should Contain    ${j}    channelId
    Run Keyword If    "${j}" == "[]"    Fail    租户下没有创建关联 ，请创建关联，返回结果为：-- > ${j}
    Run Keyword If    ${status}    Should Be Equal    ${j[0]['run']}    true    接口返回值不正确：${j}

获取网页插件是否上下班(/v1/webimplugin/tenants/show-message)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取时间计划并获取默认时间计划作为使用，调用接口：/v1/tenants/{tenantId}/timeplans/schedules，接口请求状态码为200。
    ...    - Step2、获取租户下所有的网页插件使用的关联数据，调用接口：/v1/webimplugin/targetChannels，接口请求状态码为200。
    ...    - Step3、获取网页插件是否上下班，调用接口：/v1/webimplugin/tenants/show-message，接口请求状态码为200。
    ...    - Step4、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，字段status等于OK。
    #获取时间计划并设置默认时间计划为全局变量使用
    Get ScheduleId
    #获取关联
    ${channelId}    Get Webimplugin Channels    ${AdminUser}
    #获取网页插件配置返回值
    ${paramData}    create dictionary    channelType=easemob    originType=webim    channelId=${channelId[0]['channelId']}    tenantId=${AdminUser.tenantId}    queueName=
    ...    agentUsername=    timeScheduleId=${timeScheduleId}
    ${j}    Show Message    ${AdminUser}    ${paramData}
    Should Be Equal    ${j['status']}    OK    返回值中status不等于OK: {j}

获取网页渠道系统欢迎语(/v1/webimplugin/welcome)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取网页渠道系统欢迎语，调用接口：/v1/webimplugin/welcome，接口请求状态码为200。
    ...    - Step2、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200。
    #获取网页插件系统欢迎语
    ${j}    Show Company Greeting    ${AdminUser}
    #断言返回状态值和json结构与值是否一致
    # ${status}    Run Keyword And Return Status    Should Be Empty    ${j}
    # Run Keyword if    ${status}    Pass Execution    该租户没有设置系统欢迎语
    # ${data}    Run Keyword Unless    ${status}    Decode Bytes To String In    ${j}    UTF-8
    # Run Keyword Unless    ${status}    log    该租户系统欢迎语为：${data}

获取网页渠道机器人欢迎语(/v1/webimplugin/tenants/robots/welcome)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户下所有的网页插件使用的关联数据，调用接口：/v1/webimplugin/targetChannels，接口请求状态码为200。
    ...    - Step1、获取网页渠道机器人欢迎语，调用接口：/v1/webimplugin/tenants/robots/welcome，接口请求状态码为200。
    ...    - Step2、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，接口返回值中，status字段等于OK。
    #获取关联
    ${channelId}    Get Webimplugin Channels    ${AdminUser}
    #获取网页插件机器人欢迎语
    ${paramData}    create dictionary    channelType=easemob    originType=webim    channelId=${channelId[0]['channelId']}    tenantId=${AdminUser.tenantId}    queueName=
    ...    agentUsername=
    ${j}    Show Robot Greeting    ${AdminUser}    ${paramData}
    Should Be Equal    ${j['status']}    OK    返回值中status不等于OK: {j}

获取网页插件技能组绑定欢迎语(/v1/webimplugin/tenants/{tenantId}/skillgroup-menu)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取网页插件技能组绑定欢迎语，调用接口：/v1/webimplugin/tenants/{tenantId}/skillgroup-menu，接口请求状态码为200。
    ...    - Step2、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，接口返回值中，status字段等于OK。
    #获取技能组绑定欢迎语列表
    ${j}    Get Skillgroup-menu    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    返回值中status不等于OK: {j}

获取租户设置访客端是否显示坐席昵称的OPTION(/v1/webimplugin/agentnicename/options)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户设置访客端是否显示坐席昵称的OPTION，调用接口：/v1/webimplugin/agentnicename/options，接口请求状态码为200。
    ...    - Step2、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200。
    ${resp}=    /v1/webimplugin/agentnicename/options    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}

获取自定义表情包(/v1/webimplugin/emoj/tenants/{tenantId}/packages)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户是否开通了自定义表情增值功能，如果未开通则不执行测试用例。
    ...    - Step2、获取自定义表情包，调用接口：/v1/webimplugin/emoj/tenants/{tenantId}/packages，接口请求状态码为200。
    ...    - Step3、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，接口返回值中，status等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status    customMagicEmoji
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #获取表情包
    ${j}    Get Webim Stickers    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['type']}    CUSTOM    返回值中type字段不等于CUSTOM: ${j}

获取自定义表情包文件(/v1/emoj/tenants/{tenantId}/packages/{packageId}/files)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户是否开通了自定义表情增值功能，如果未开通则不执行测试用例。
    ...    - Step2、获取自定义表情包总个数，如果超过5个，则不允许上传表情，调用接口：/v1/webimplugin/emoj/tenants/{tenantId}/packages，接口请求状态码为200。
    ...    - Step3、上传自定义表情，调用接口：/v1/emoj/tenants/{tenantId}/packages，接口请求状态码为200。
    ...    - Step4、获取自定义表情文件，调用接口：/v1/emoj/tenants/{tenantId}/packages/{packageId}/files，接口请求状态码为200。
    ...    - Step5、检查接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口请求状态码为200，接口返回值中，表情总数应大于0、status等于OK、tenantId等于租户id，等等。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status    customMagicEmoji
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #获取当前的表情包个数
    ${length}    Get Stickers Numbers    ${AdminUser}
    Run Keyword If    ${length} >= 5    Fail    租户下的表情包超过5个，该用例会执行失败，标识为fail
    #上传表情包
    ${picpath}    Open Sticker File
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j1}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j1['status']}    OK    返回值中status不等于OK: ${j1}
    #获取表情文件
    ${j}    Get Webim Stickers Files    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Fail    租户下的表情包文件不存在，需要检查下，${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['fileName']}    beautiful_girl    返回值中压缩包里的图片名字与预期不符: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['packageId']}    ${j1['entities'][0]['packageId']}    返回值中压缩包的id不是预期: ${j}

