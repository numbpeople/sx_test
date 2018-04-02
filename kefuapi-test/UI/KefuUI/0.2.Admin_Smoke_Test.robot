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
    ${jbase}    to json    ${statisticindexbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看成员管理
    #查看客服
    ${jbase}    to json    ${teamindivisualbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看技能组
    ${jbase}    to json    ${teamgroupsbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看渠道管理
    #查看app渠道
    ${jbase}    to json    ${channelsappbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看webim渠道
    ${jbase}    to json    ${channelswebimbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看微信渠道
    ${jbase}    to json    ${channelswechatbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看微博渠道
    ${jbase}    to json    ${channelsweibobasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看slack渠道
    ${jbase}    to json    ${channelsslackbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看呼叫中心渠道
    ${jbase}    to json    ${channelscallcenterbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看rest渠道
    ${jbase}    to json    ${channelsrestbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看智能机器人
    #查看机器人设置
    ${jbase}    to json    ${robotsettingsbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看如来
    ${jbase}    to json    ${robotrulaibasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看素材库
    ${jbase}    to json    ${robotmaterialbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看设置
    #查看企业信息
    ${jbase}    to json    ${settingsenterprisebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看系统开关
    ${jbase}    to json    ${settingssystembasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看时间计划设置
    ${jbase}    to json    ${settingstimeplanbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看时间计划设置
    ${jbase}    to json    ${settingstimeplanbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看权限管理
    ${jbase}    to json    ${settingspermissionbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看公共常用语
    ${jbase}    to json    ${settingsphrasebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看自定义表情
    ${jbase}    to json    ${settingsemojibasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看会话标签
    ${jbase}    to json    ${settingssummarybasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看客户标签
    ${jbase}    to json    ${settingstagbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看自定义信息接口
    ${jbase}    to json    ${settingsiframebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看会话分配规则
    ${jbase}    to json    ${settingsroutesbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看客户中心设置
    ${jbase}    to json    ${settingsvisitorsbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看满意度评价邀请设置
    ${jbase}    to json    ${settingsevaluatebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看质检评分设置
    ${jbase}    to json    ${settingsqualitysettingsbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看单点登录
    ${jbase}    to json    ${settingsssobasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看留言设置
    ${jbase}    to json    ${settingsnotesbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看关键字匹配
    ${jbase}    to json    ${settingsreganswerbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看订单列表
    ${jbase}    to json    ${settingsorderinfobasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看问卷调查
    ${jbase}    to json    ${settingsquestionnairebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看自定义事件推送
    ${jbase}    to json    ${settingscallbackbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看审批管理
    ${jbase}    to json    ${approvalbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看知识库
    ${jbase}    to json    ${knowledgebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看搜索
    ${jbase}    to json    ${sessionsearchbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看留言
    ${jbase}    to json    ${notesbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看客户中心
    ${jbase}    to json    ${visitorsbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看自动消息
    ${jbase}    to json    ${marketingbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看历史会话
    ${jbase}    to json    ${historybasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看质量检查
    #查看基础质检
    ${jbase}    to json    ${qualityrecordbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看随机质检
    ${jbase}    to json    ${randomqualitybasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看申述管理
    ${jbase}    to json    ${appealrecordbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看导出管理
    ${jbase}    to json    ${exportsbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看当前会话
    ${jbase}    to json    ${currentbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看监控管理
    #查看实时监控
    ${jbase}    to json    ${monitorbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看现场管理
    ${jbase}    to json    ${supervisionbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看告警记录
    ${jbase}    to json    ${warningnoticebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看统计查询
    #查看工作量
    ${jbase}    to json    ${statisticworksbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看工作质量
    ${jbase}    to json    ${statisticqualitybasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看客服时长统计
    ${jbase}    to json    ${statistictimebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看访客统计
    ${jbase}    to json    ${statisticfigurebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看排队统计
    ${jbase}    to json    ${statisticqueuebasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看全站访客统计
    ${jbase}    to json    ${statisticgriobasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
    #查看自定义报表
    ${jbase}    to json    ${statisticreportbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看客户声音
    ${jbase}    to json    ${vocbasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin

查看消息中心
    ${jbase}    to json    ${notifybasejson}
    Check Base Module    ${kefuurl}    ${uiadmin}    ${jbase}    Admin
