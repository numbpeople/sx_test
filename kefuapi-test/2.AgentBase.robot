*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          AgentRes.robot
Resource          api/KefuApi.robot
Resource          JsonDiff/KefuJsonDiff.robot

*** Test Cases ***
获取机器人推荐状态(/v1/Tenants/{tenantId}/robots/recommendation/status)
    ${resp}=    /v1/Tenants/{tenantId}/robots/recommendation/status    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    log    ${j}

获取机器人推荐开关信息？(/v1/Tenants/{tenantId}/robots/recommendationSwitch)
    ${resp}=    /v1/Tenants/{tenantId}/robots/recommendationSwitch    ${AdminUser}    ${switchType}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}

获取客服App登录IMSDK的账号和密码(/v1/tenantapp/imUser)
    ${resp}=    /v1/tenantapp/imUser    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j['appKey']}    appkey为空

获取callcenter属性(/v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs)
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    callcenter属性数据不正确：${resp.content}

获取常用语信息（个人&企业）(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/commonphrases    ${AdminUser}    ${orgEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    获取常用语数据不正确：${resp.content}

客服设置状态&接待数(/v1/Agents/{agentId})
    : FOR    ${s}    IN    @{kefustatus}
    \    set to dictionary    ${AdminUser}    status    ${s}
    \    ${resp}=    /v1/Agents/{agentId}    ${AdminUser}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    ${j}    to json    ${resp.content}
    \    Should Be Equal    ${j['status']}    ${s}    设置状态失败：${resp.status_code}

获取访客列表(/v1/Agents/me/Visitors)
    [Tags]    sdk
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    没有访客列表
    ...    ELSE    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取访客列表失败

获取访客标签数据(/v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/)
    : FOR    ${visitorid}    IN    @{visitorUserId}
    \    ${resp}=    /v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/    ${AdminUser}    ${visitorid}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    Should Not Be Empty    ${resp.content}    返回值为空
    \    ${j}    to json    ${resp.content}
    \    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的访客数据中tenantId不正确
    \    Should Be Equal    ${j[0]['visitorUserId']}    ${visitorid}    返回的访客数据中userId不正确

获取所有会话标签(/v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree)
    ${resp}=    /v1/Tenants/{tenantId}/ServiceSessionSummaries/{summaryId}/tree    ${AdminUser}    0    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j[0]['children']}    会话标签为空

获取未读消息数(/v1/Tenants/me/Agents/me/UnReadTags/Count)
    ${resp}=    /v1/Tenants/me/Agents/me/UnReadTags/Count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Be True    ${j}>=0    未读消息数不正确

获取当前客服列表(/v1/Agents/{AdminUserId}/Agents)
    ${resp}=    /v1/Agents/{AdminUserId}/Agents    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无同事
    ...    ELSE    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取同事列表失败:${resp.content}

获取租户系统配置信息(/v1/Tenant/me/Configuration)
    [Tags]    unused
    ${resp}=    /v1/Tenant/me/Configuration    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无app关联
    ...    ELSE    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    获取app关联失败:${resp.content}

获取默认导出管理数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['numberOfElements']} >= 0    导出管理数据不正确

获取默认历史会话数据(/v1/Tenant/me/ServiceSessionHistorys)
    log    ${DateRange}
    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} >= 0    历史会话数不正确
    log    ${j['total_entries']}

获取默认消息中心数据(/users/{agentId}/activities)
    ${resp}=    /users/{agentId}/activities    ${AdminUser}    ${FilterEntity}    ${MsgCenterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} >= 0    消息中心数据不正确

获取默认消息中心数量(/users/{agentId}/feed/info)
    ${resp}=    /users/{agentId}/feed/info    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['count_total']} >= 0    消息中心总数不正确：${resp.content}
    Should Be True    ${j['count_unread']} >= 0    消息中心未读数不正确：${resp.content}

获取留言信息(/tenants/{tenantId}/projects)
    ${resp}=    /tenants/{tenantId}/projects    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['last']}    返回的留言信息不正确：${resp.content}

获取访客中心列表(/v1/crm/tenants/{tenantId}/agents/{agentId}/visitors)
    ${resp}=    /v1/crm/tenants/{tenantId}/agents/{agentId}/customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} >= 0    访客中心人数不正确：${resp.content}

获取待接入列表(/v1/Tenant/me/Agents/me/UserWaitQueues)
    [Tags]    sdk
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} >= 0    待接入数不正确

获取待接入总数(/v1/Tenant/me/Agents/me/UserWaitQueues/count)
    ${resp}=    /v1/Tenant/me/Agents/me/UserWaitQueues/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j} >= 0    待接入总数不正确：${resp.content}

获取待接入分组信息new(/v1/tenants/{tenantId}/agents/{agentId}/queues)
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/queues    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['entities'][0]['tenantId']}'    '${AdminUser.tenantId}'    待接入列表不正确：${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    待接入列表不正确：${resp.content}

获取待接入总数new(/v1/tenants/{tenantId}/queues/count)
    ${resp}=    /v1/tenants/{tenantId}/queues/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j} >= 0    待接入总数不正确：${resp.content}

获取待接入列表new(/v1/tenants/{tenantId}/queues)
    [Tags]    sdk
    ${resp}=    /v1/tenants/{tenantId}/queues    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} >= 0    待接入数不正确:${resp.content}

获取租户设置访客端是否显示坐席昵称的OPTION(/v1/webimplugin/agentnicename/options)
    ${resp}=    /v1/webimplugin/agentnicename/options    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    #${j}    to json    ${resp.content}
    #Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    tenantId不正确:${resp.content}
    #Should Be Equal    ${j[0]['optionValue']}    ${True}

获取所有app关联(/channels)
    ${resp}=    /channels    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无app关联
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    获取app关联失败
    log    ${j}

获取微博&微信设置(/v1/Admin/TechChannel/WeiboTechChannel)
    : FOR    ${t}    IN    @{WeiboTechChannelType}
    \    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel    ${AdminUser}    ${t}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    Should Not Be Empty    ${resp.content}    返回值为空
    \    ${j}    to json    ${resp.content}
    \    log    ${j}
    \    Run Keyword If    ${j}==[]    log    没有${t}信息
    \    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的主题信息中中tenantId不正确

获取微博配置平台接口的URL(/v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl)
    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel/weibo/callbackUrl    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    微博配置平台接口的url为空
    log    ${resp.content}

获取微博配置平台接口的appkey(/v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey)
    ${resp}=    /v1/Admin/TechChannel/WeiboTechChannel/weibo/appkey    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    微博配置平台接口的APPKEY为空格
    log    ${resp.content}

获取呼叫中心信息(/v1/tenants/{tenantId}/phone-tech-channel)
    ${resp}=    /v1/tenants/{tenantId}/phone-tech-channel    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无呼叫中心信息
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    呼叫中心信息不正确：${resp.content}

获取机器人知识规则(/v1/Tenants/me/robot/rules)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/rules    ${AdminUser}    ${RobotRulesEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的机器人知识规则不正确：${resp.content}

获取机器人知识规则条数(/v1/Tenants/me/robot/rule/group/count)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/rule/group/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j} >= 0    机器人知识规则条数：${resp.content}

获取机器人自定义菜单(/v1/Tenants/me/robot/menu/items)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/menu/items    ${AdminUser}    ${RobotRulesEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${resp.content}

获取机器人菜单素材库new(/v1/Tenants/{tenantId}/robot/media/items)
    ${resp}=    /v1/Tenants/{tenantId}/robot/media/items    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${resp.content}
    #Should Be Equal    '${j['first']}'    'True'    返回的机器人菜单素材库不正确：${resp.content}
    #Should Be Equal    '${j['last']}'    'True'    返回的机器人菜单素材库不正确：${resp.content}

获取知识库模板(/v1/Tenants/me/robot/rule/items/template)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/rule/items/template    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #log    ${resp.headers.Content-Length}
    log    ${resp.headers}
    log    ${resp.headers['Content-Type']}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败

获取常用语模板(/download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx)
    ${resp}=    /download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #log    ${resp.headers.Content-Length}
    log    ${resp.headers}
    log    ${resp.headers['Content-Type']}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream    获取知识库模板失败

获取机器人设置(/v1/Tenants/me/robot/profile/setting)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/profile/setting    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人设置信息不正确：${resp.content}

获取机器人信息(/v1/Tenants/me/robot/profile/personalInfo)
    [Tags]    unused
    ${resp}=    /v1/Tenants/me/robot/profile/personalInfo    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取机器人闲聊开关信息(/v1/Tenants/{tenantId}/robots/freechat)
    ${resp}=    /v1/Tenants/{tenantId}/robots/freechat    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    #Should Be Equal As Integers    ${j['tenantId']}    ${tenantId}    返回的机器人信息不正确：${resp.content}
    Run Keyword If    ${j}==${True}    log    闲聊功能开启
    ...    ELSE IF    ${j}==${False}    log    闲聊功能关闭
    ...    ELSE    Should Be True    ${j}    闲聊开关信息不正确：${resp.content}

获取搜索默认信息(/v1/tenants/{tenantId}/searchrecords)
    ${resp}=    /v1/tenants/{tenantId}/searchrecords    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    搜索默认信息不正确：${resp.content}

获取当前会话信息(/v1/tenants/{tenantId}/servicesessioncurrents)
    set suite variable    ${FilterEntity.state}    Processing,Resolved
    set suite variable    ${FilterEntity.isAgent}    ${False}
    set suite variable    ${AgentEntity.username}    ${Empty}
    ${resp}=    /v1/tenants/{tenantId}/servicesessioncurrents    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']}>=0    获取当前会话数不正确：${resp.content}

获取访客标签(/v1/Admin/UserTags)
    ${resp}=    /v1/Admin/UserTags    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']}>=0    获取的访客标签数不正确：${resp.content}

获取访客中心数据(/tenants/{tenantId}/visitorusers)
    ${resp}=    /tenants/{tenantId}/visitorusers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取的访客数不正确：${resp.content}

获取版本更新信息(/v1/tenants/{tenantId}/agents/{agentId}/news/latest)
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/news/latest    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j['entity']['content']}    获取版本更新信息不正确：${resp.content}

获取新手任务信息(/v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser)
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取新手任务信息不正确：${resp.content}

获取机器人信息new(/v1/Tenants/{tenantId}/robot/profile/personalInfo)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfo    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取多机器人信息(/v1/Tenants/{tenantId}/robot/profile/personalInfos)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfos    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['content'][0]['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取机器人设置new(/v1/Tenants/{tenantId}/robot/profile/setting)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/setting    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取多机器人设置(/v1/Tenants/{tenantId}/robot/profile/settings)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/settings    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['content'][0]['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人信息不正确：${resp.content}
    log    ${resp.content}

获取机器人欢迎语(/v1/Tenants/{tenantId}/robots/greetings)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robots/greetings    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    #${j}    to json    ${resp.content}
    #Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人欢迎语不正确：${resp.content}
    #log    ${resp.content}

获取机器人默认回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Tags]
    set test variable    ${tf}    ${RobotFilter}
    set to dictionary    ${tf}    type=0
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${AdminUser}    ${tf}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人默认回复不正确：${resp.content}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人默认回复不正确：${resp.content}

获取机器人重复回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Tags]
    set test variable    ${tf}    ${RobotFilter}
    set to dictionary    ${tf}    type=1
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人重复回复不正确：${resp.content}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人重复回复不正确：${resp.content}

获取机器人超时回复(/v1/Tenants/{tenantId}/robot/profile/predefinedReplys)
    [Tags]
    set test variable    ${tf}    ${RobotFilter}
    set to dictionary    ${tf}    type=2
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/predefinedReplys    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人重复回复不正确：${resp.content}
    Should Be Equal    '${j['last']}'    'True'    返回的机器人重复回复不正确：${resp.content}

获取机器人转人工设置(/v1/Tenants/{tenantId}/robots/robotUserTransferKf)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robots/robotUserTransferKf    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    返回的机器人欢迎语不正确：${resp.content}
    log    ${resp.content}

获取机器人知识规则new(/v1/Tenants/{tenantId}/robot/rules)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/rules    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=0    返回的机器人知识规则不正确：${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人知识规则不正确：${resp.content}

获取机器人知识规则数量new(/v1/Tenants/{tenantId}/robot/rule/group/count)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/rule/group/count    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j}>=0    返回的机器人知识规则数量不正确：${resp.content}

获取知识库模板new(/v1/Tenants/{tenantId}/robot/rule/items/template)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/rule/items/template    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #log    ${resp.headers.Content-Length}
    log    ${resp.headers}
    log    ${resp.headers['Content-Type']}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    获取知识库模板失败

获取机器人自定义菜单new(/v1/Tenants/{tenantId}/robot/menu/items)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robot/menu/items    ${AdminUser}    ${RobotFilter}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j}    返回的机器人菜单素材库不正确：${resp.content}
    Should Be Equal    '${j['first']}'    'True'    返回的机器人自定义菜单不正确：${resp.content}

获取智能场景应答(/v1/Tenants/{tenantId}/robots/intent/list)
    [Tags]
    ${resp}=    /v1/Tenants/{tenantId}/robots/intent/list    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['logistics']['name']}'    '物流'    返回的机器人只能场景应答信息不正确：${resp.content}

个人统计数据概况(/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/total)
    [Tags]
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/total    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    个人统计数据概况status不正确：${resp.content}
    Should Be True    ${j['totalElements']}==1    个人统计数据概况数量不正确：${resp.content}

个人统计数据消息/会话数趋势(/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/trend)
    [Tags]
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/trend    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    个人统计数据消息/会话数趋势status不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    个人统计数据消息/会话数趋势数量不正确：${resp.content}

个人统计数据工作时长(/statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/serve)
    [Tags]
    ${resp}=    /statistics/internal/orgs/{organId}/tenants/{tenantId}/agent/detail/trend    ${AdminUser}    ${orgEntity}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    个人统计数据工作时长status不正确：${resp.content}
    Should Be True    ${j['totalElements']}>=0    个人统计数据工作时长不正确：${resp.content}
