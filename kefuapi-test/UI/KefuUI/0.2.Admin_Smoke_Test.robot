*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Library           uuid
Library           urllib
Library           Selenium2Library
Resource          ../../UIcommons/Utils/baseUtils.robot
Resource          ../../UIcommons/Kefu/statisticindexres.robot
Resource          ../../UIcommons/Kefu/teamres.robot
Resource          ../../UIcommons/Kefu/channelsres.robot
Resource          ../../UIcommons/Kefu/robotres.robot
Resource          ../../UIcommons/Kefu/material.robot
Resource          ../../UIcommons/Kefu/sessionsearchres.robot
Resource          ../../UIcommons/Kefu/notesres.robot
Resource          ../../UIcommons/Kefu/visitorsres.robot
Resource          ../../UIcommons/Kefu/historyres.robot
Resource          ../../UIcommons/Kefu/qualityres.robot
Resource          ../../UIcommons/Kefu/exportsres.robot
Resource          ../../UIcommons/Kefu/currentres.robot
Resource          ../../UIcommons/Kefu/waitres.robot
Resource          ../../UIcommons/Kefu/settingsres.robot
Resource          ../../UIcommons/Kefu/approvalres.robot
Resource          ../../UIcommons/Kefu/knowledgeres.robot
Resource          ../../UIcommons/Kefu/marketingres.robot
Resource          ../../UIcommons/Kefu/monitorres.robot
Resource          ../../UIcommons/Kefu/statisticres.robot
Resource          ../../UIcommons/Kefu/vocres.robot
Resource          ../../UIcommons/Kefu/notifyres.robot

*** Test Cases ***
查看首页
    [Template]    smoketest case
    ${uiadmin}    ${statisticindexbasejson}    Admin

查看成员管理
    [Template]    smoketest case
    #查看客服
    ${uiadmin}    ${teamindivisualbasejson}    Admin
    #查看技能组
    ${uiadmin}    ${teamgroupsbasejson}    Admin

查看渠道管理
    [Template]    smoketest case
    #查看app渠道
    ${uiadmin}    ${channelsappbasejson}    Admin
    #查看webim渠道
    ${uiadmin}    ${channelswebimbasejson}    Admin
    #查看微信渠道
    ${uiadmin}    ${channelswechatbasejson}    Admin
    #查看微博渠道
    ${uiadmin}    ${channelsweibobasejson}    Admin
    #查看slack渠道
    ${uiadmin}    ${channelsslackbasejson}    Admin
    #查看呼叫中心渠道
    ${uiadmin}    ${channelscallcenterbasejson}    Admin
    #查看rest渠道
    ${uiadmin}    ${channelsrestbasejson}    Admin

查看智能机器人
    [Template]    smoketest case
    #查看机器人设置
    ${uiadmin}    ${robotsettingsbasejson}    Admin
    #查看如来
    ${uiadmin}    ${robotrulaibasejson}    Admin

查看素材库
    [Template]    smoketest case
    ${uiadmin}    ${robotmaterialbasejson}    Admin

查看设置
    [Template]    smoketest case
    #查看企业信息
    ${uiadmin}    ${settingsenterprisebasejson}    Admin
    #查看系统开关
    ${uiadmin}    ${settingssystembasejson}    Admin
    #查看时间计划设置
    ${uiadmin}    ${settingstimeplanbasejson}    Admin
    #查看权限管理
    ${uiadmin}    ${settingspermissionbasejson}    Admin
    #查看公共常用语
    ${uiadmin}    ${settingsphrasebasejson}    Admin
    #查看自定义表情
    ${uiadmin}    ${settingsemojibasejson}    Admin
    #查看会话标签
    ${uiadmin}    ${settingssummarybasejson}    Admin
    #查看客户标签
    ${uiadmin}    ${settingstagbasejson}    Admin
    #查看自定义信息接口
    ${uiadmin}    ${settingsiframebasejson}    Admin
    #查看会话分配规则
    ${uiadmin}    ${settingsroutesbasejson}    Admin
    #查看客户中心设置
    ${uiadmin}    ${settingsvisitorsbasejson}    Admin
    #查看满意度评价邀请设置
    ${uiadmin}    ${settingsevaluatebasejson}    Admin
    #查看质检评分设置
    ${uiadmin}    ${settingsqualitysettingsbasejson}    Admin
    #查看单点登录
    ${uiadmin}    ${settingsssobasejson}    Admin
    #查看留言设置
    ${uiadmin}    ${settingsnotesbasejson}    Admin
    #查看关键字匹配
    ${uiadmin}    ${settingsreganswerbasejson}    Admin
    #查看订单列表
    ${uiadmin}    ${settingsorderinfobasejson}    Admin
    #查看问卷调查
    ${uiadmin}    ${settingsquestionnairebasejson}    Admin
    #查看自定义事件推送
    ${uiadmin}    ${settingscallbackbasejson}    Admin

查看审批管理
    [Template]    smoketest case
    ${uiadmin}    ${approvalbasejson}    Admin

查看知识库
    [Template]    smoketest case
    ${uiadmin}    ${knowledgebasejson}    Admin

查看搜索
    [Template]    smoketest case
    ${uiadmin}    ${sessionsearchbasejson}    Admin

查看留言
    [Template]    smoketest case
    ${uiadmin}    ${notesbasejson}    Admin

查看客户中心
    [Template]    smoketest case
    ${uiadmin}    ${visitorsbasejson}    Admin

查看自动消息
    [Template]    smoketest case
    ${uiadmin}    ${marketingbasejson}    Admin

查看历史会话
    [Template]    smoketest case
    ${uiadmin}    ${historybasejson}    Admin

查看质量检查
    [Template]    smoketest case
    #查看基础质检
    ${uiadmin}    ${qualityrecordbasejson}    Admin
    #查看随机质检
    ${uiadmin}    ${randomqualitybasejson}    Admin
    #查看申述管理
    ${uiadmin}    ${appealrecordbasejson}    Admin

查看导出管理
    [Template]    smoketest case
    ${uiadmin}    ${exportsbasejson}    Admin

查看待接入
    [Template]    smoketest case
    ${uiadmin}    ${waitbasejson}    Admin

查看当前会话
    [Template]    smoketest case
    ${uiadmin}    ${currentbasejson}    Admin

查看监控管理
    [Template]    smoketest case
    #查看实时监控
    ${uiadmin}    ${monitorbasejson}    Admin
    #查看现场管理
    ${uiadmin}    ${supervisionbasejson}    Admin
    #查看告警记录
    ${uiadmin}    ${warningnoticebasejson}    Admin

查看统计查询
    [Template]    smoketest case
    #查看工作量
    ${uiadmin}    ${statisticworksbasejson}    Admin
    #查看工作质量
    ${uiadmin}    ${statisticqualitybasejson}    Admin
    #查看客服时长统计
    ${uiadmin}    ${statistictimebasejson}    Admin
    #查看访客统计
    ${uiadmin}    ${statisticfigurebasejson}    Admin
    #查看排队统计
    ${uiadmin}    ${statisticqueuebasejson}    Admin
    #查看全站访客统计
    ${uiadmin}    ${statisticgriobasejson}    Admin
    #查看自定义报表
    ${uiadmin}    ${statisticreportbasejson}    Admin

查看客户声音
    [Template]    smoketest case
    ${uiadmin}    ${vocbasejson}    Admin

查看消息中心
    [Template]    smoketest case
    ${uiadmin}    ${notifybasejson}    Admin
