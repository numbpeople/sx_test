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
Resource          ../../UIcommons/Kefu/chatres.robot
Resource          ../../UIcommons/Kefu/waitres.robot
Resource          ../../UIcommons/Kefu/historyres.robot
Resource          ../../UIcommons/Kefu/visitorsres.robot
Resource          ../../UIcommons/Kefu/agentstatres.robot
Resource          ../../UIcommons/Kefu/sessionsearchres.robot
Resource          ../../UIcommons/Kefu/exportsres.robot
Resource          ../../UIcommons/Kefu/knowledgeres.robot
Resource          ../../UIcommons/Kefu/myticketsres.robot
Resource          ../../UIcommons/Kefu/qualityres.robot
Resource          ../../UIcommons/Kefu/notesres.robot
Resource          ../../UIcommons/Kefu/agentinfores.robot
Resource          ../../UIcommons/Kefu/myphraseres.robot
Resource          ../../UIcommons/Kefu/notifyres.robot
Resource          ../../UIcommons/Kefu/mystatistic.robot

*** Test Cases ***
查看会话列表
    goto and checkchatebasejson    ${uiadmin}

查看待接入列表
    Check Base Module    ${kefuurl}    ${uiadmin}    ${waitbasejson}

查看我的知识库
    Check Base Module    ${kefuurl}    ${uiadmin}    ${knowledgebasejson}

查看我的留言列表
    Check Base Module    ${kefuurl}    ${uiadmin}    ${notesbasejson}

查看我的工单
    Check Base Module    ${kefuurl}    ${uiadmin}    ${myticketsbasejson}

查看我的历史会话
    Check Base Module    ${kefuurl}    ${uiadmin}    ${historybasejson}

查看我的质量检查
    [Template]    Check Base Module
    #查看质检记录
    ${kefuurl}    ${uiadmin}    ${qualityrecordbasejson}
    #查看申述记录
    ${kefuurl}    ${uiadmin}    ${appealrecordbasejson}

查看我的搜索
    Check Base Module    ${kefuurl}    ${uiadmin}    ${sessionsearchbasejson}

查看我的客户中心
    Check Base Module    ${kefuurl}    ${uiadmin}    ${visitorsbasejson}

查看我的导出管理
    Check Base Module    ${kefuurl}    ${uiadmin}    ${exportsbasejson}

查看客服信息
    Check Base Module    ${kefuurl}    ${uiadmin}    ${agentinfobasejson}

查看个人常用语
    Check Base Module    ${kefuurl}    ${uiadmin}    ${myphrasebasejson}

查看消息中心
    Check Base Module    ${kefuurl}    ${uiadmin}    ${notifybasejson}

查看我的统计数据
    Check Base Module    ${kefuurl}    ${uiadmin}    ${mystatisticbasejson}
