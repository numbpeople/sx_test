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
Resource          ../../UIcommons/Kefu/sessionsearchres.robot
Resource          ../../UIcommons/Kefu/notesres.robot
Resource          ../../UIcommons/Kefu/visitorsres.robot
Resource          ../../UIcommons/Kefu/historyres.robot
Resource          ../../UIcommons/Kefu/qualityres.robot
Resource          ../../UIcommons/Kefu/exportsres.robot
Resource          ../../UIcommons/Kefu/currentres.robot
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
    Check Base Module    ${kefuurl}    ${uiadmin}    ${statisticindexbasejson}    Admin

查看成员管理
    [Template]    Check Base Module
    #查看客服
    ${kefuurl}    ${uiadmin}    ${teamindivisualbasejson}    Admin
    #查看技能组
    ${kefuurl}    ${uiadmin}    ${teamgroupsbasejson}    Admin

查看渠道管理
    [Template]    Check Base Module
    #查看app渠道
    ${kefuurl}    ${uiadmin}    ${channelsappbasejson}    Admin
    #查看webim渠道
    ${kefuurl}    ${uiadmin}    ${channelswebimbasejson}    Admin
    #查看微信渠道
    ${kefuurl}    ${uiadmin}    ${channelswechatbasejson}    Admin
    #查看微博渠道
    ${kefuurl}    ${uiadmin}    ${channelsweibobasejson}    Admin
    #查看slack渠道
    ${kefuurl}    ${uiadmin}    ${channelsslackbasejson}    Admin
    #查看呼叫中心渠道
    ${kefuurl}    ${uiadmin}    ${channelscallcenterbasejson}    Admin
    #查看rest渠道
    ${kefuurl}    ${uiadmin}    ${channelsrestbasejson}    Admin

查看智能机器人
    [Template]    Check Base Module
    #查看机器人设置
    ${kefuurl}    ${uiadmin}    ${robotsettingsbasejson}    Admin
    #查看如来
    ${kefuurl}    ${uiadmin}    ${robotrulaibasejson}    Admin
    #查看素材库
    ${kefuurl}    ${uiadmin}    ${robotmaterialbasejson}    Admin

查看设置
    [Template]    Check Base Module
    #查看企业信息
    ${kefuurl}    ${uiadmin}    ${settingsenterprisebasejson}    Admin
    #查看系统开关
    ${kefuurl}    ${uiadmin}    ${settingssystembasejson}    Admin
    #查看时间计划设置
    ${kefuurl}    ${uiadmin}    ${settingstimeplanbasejson}    Admin
    #查看时间计划设置
    ${kefuurl}    ${uiadmin}    ${settingstimeplanbasejson}    Admin
    #查看权限管理
    ${kefuurl}    ${uiadmin}    ${settingspermissionbasejson}    Admin
    #查看公共常用语
    ${kefuurl}    ${uiadmin}    ${settingsphrasebasejson}    Admin
    #查看自定义表情
    ${kefuurl}    ${uiadmin}    ${settingsemojibasejson}    Admin
    #查看会话标签
    ${kefuurl}    ${uiadmin}    ${settingssummarybasejson}    Admin
    #查看客户标签
    ${kefuurl}    ${uiadmin}    ${settingstagbasejson}    Admin
    #查看自定义信息接口
    ${kefuurl}    ${uiadmin}    ${settingsiframebasejson}    Admin
    #查看会话分配规则
    ${kefuurl}    ${uiadmin}    ${settingsroutesbasejson}    Admin
    #查看客户中心设置
    ${kefuurl}    ${uiadmin}    ${settingsvisitorsbasejson}    Admin
    #查看满意度评价邀请设置
    ${kefuurl}    ${uiadmin}    ${settingsevaluatebasejson}    Admin
    #查看质检评分设置
    ${kefuurl}    ${uiadmin}    ${settingsqualitysettingsbasejson}    Admin
    #查看单点登录
    ${kefuurl}    ${uiadmin}    ${settingsssobasejson}    Admin
    #查看留言设置
    ${kefuurl}    ${uiadmin}    ${settingsnotesbasejson}    Admin
    #查看关键字匹配
    ${kefuurl}    ${uiadmin}    ${settingsreganswerbasejson}    Admin
    #查看订单列表
    ${kefuurl}    ${uiadmin}    ${settingsorderinfobasejson}    Admin
    #查看问卷调查
    ${kefuurl}    ${uiadmin}    ${settingsquestionnairebasejson}    Admin
    #查看自定义事件推送
    ${kefuurl}    ${uiadmin}    ${settingscallbackbasejson}    Admin

查看审批管理
    Check Base Module    ${kefuurl}    ${uiadmin}    ${approvalbasejson}    Admin

查看知识库
    Check Base Module    ${kefuurl}    ${uiadmin}    ${knowledgebasejson}    Admin

查看搜索
    Check Base Module    ${kefuurl}    ${uiadmin}    ${sessionsearchbasejson}    Admin

查看留言
    Check Base Module    ${kefuurl}    ${uiadmin}    ${notesbasejson}    Admin

查看客户中心
    Check Base Module    ${kefuurl}    ${uiadmin}    ${visitorsbasejson}    Admin

查看自动消息
    Check Base Module    ${kefuurl}    ${uiadmin}    ${marketingbasejson}    Admin

查看历史会话
    Check Base Module    ${kefuurl}    ${uiadmin}    ${historybasejson}    Admin

查看质量检查
    [Template]    Check Base Module
    #查看基础质检
    ${kefuurl}    ${uiadmin}    ${qualityrecordbasejson}    Admin
    #查看随机质检
    ${kefuurl}    ${uiadmin}    ${randomqualitybasejson}    Admin
    #查看申述管理
    ${kefuurl}    ${uiadmin}    ${appealrecordbasejson}    Admin

查看导出管理
    Check Base Module    ${kefuurl}    ${uiadmin}    ${exportsbasejson}    Admin

查看当前会话
    Check Base Module    ${kefuurl}    ${uiadmin}    ${currentbasejson}    Admin

查看监控管理
    [Template]    Check Base Module
    #查看实时监控
    ${kefuurl}    ${uiadmin}    ${monitorbasejson}    Admin
    #查看现场管理
    ${kefuurl}    ${uiadmin}    ${supervisionbasejson}    Admin
    #查看告警记录
    ${kefuurl}    ${uiadmin}    ${warningnoticebasejson}    Admin

查看统计查询
    [Template]    Check Base Module
    #查看工作量
    ${kefuurl}    ${uiadmin}    ${statisticworksbasejson}    Admin
    #查看工作质量
    ${kefuurl}    ${uiadmin}    ${statisticqualitybasejson}    Admin
    #查看客服时长统计
    ${kefuurl}    ${uiadmin}    ${statistictimebasejson}    Admin
    #查看访客统计
    ${kefuurl}    ${uiadmin}    ${statisticfigurebasejson}    Admin
    #查看排队统计
    ${kefuurl}    ${uiadmin}    ${statisticqueuebasejson}    Admin
    #查看全站访客统计
    ${kefuurl}    ${uiadmin}    ${statisticgriobasejson}    Admin
    #查看自定义报表
    ${kefuurl}    ${uiadmin}    ${statisticreportbasejson}    Admin

查看客户声音
    Check Base Module    ${kefuurl}    ${uiadmin}    ${vocbasejson}    Admin

查看消息中心
    Check Base Module    ${kefuurl}    ${uiadmin}    ${notifybasejson}    Admin
