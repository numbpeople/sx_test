*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
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
Resource          commons/admin common/Webim_Common.robot
Resource          JsonDiff/WebimChannels/WebimChannelsJsonDiff.robot

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
    should be equal    ${j['status']}    OK
    #创建新的网页插件配置
    ${data}    set variable    {"configName":"测试${curTime}","isDefault":false}
    ${j}    Configs    ${AdminUser}    post    ${data}
    should be equal    ${j['status']}    OK
    #获取configId
    ${configId}    set variable    ${j['entity']['configId']}
    #修改网页插件配置
    &{WebimTemplateChannelJson1}    loads    ${WebimTemplateChannelJson}
    ${data}    set variable    ${WebimTemplateChannelJson1.entity}
    ${j}    Update Config    ${AdminUser}    ${configId}    ${data}
    should be equal    ${j['status']}    OK
    #删除网页插件配置
    ${j}    Configs    ${AdminUser}    delete    ${EMPTY}    ${configId}
    should be equal    ${j['status']}    OK
    should be true    ${j['entity']} == 1
