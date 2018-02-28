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
    log    ${chattest}
    ${jbase}    to json    ${chatbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看待接入列表
    ${jbase}    to json    ${waitbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的知识库
    ${jbase}    to json    ${knowledgebasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的留言列表
    ${jbase}    to json    ${notesbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的工单
    ${jbase}    to json    ${myticketsbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的历史会话
    ${jbase}    to json    ${historybasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的质量检查
    #查看质检记录
    ${jbase}    to json    ${qualityrecordbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}
    #查看申述记录
    ${jbase}    to json    ${appealrecordbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的搜索
    ${jbase}    to json    ${sessionsearchbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的客户中心
    ${jbase}    to json    ${visitorsbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的导出管理
    ${jbase}    to json    ${exportsbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看客服信息
    ${jbase}    to json    ${agentinfobasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看个人常用语
    ${jbase}    to json    ${myphrasebasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看消息中心
    ${jbase}    to json    ${notifybasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}

查看我的统计数据
    ${jbase}    to json    ${mystatisticbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}
