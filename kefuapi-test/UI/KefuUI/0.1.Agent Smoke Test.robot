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
Resource          ../../UIcommons/Kefu/mynotesres.robot
Resource          ../../UIcommons/Kefu/historyres.robot
Resource          ../../UIcommons/Kefu/myvisitorsres.robot
Resource          ../../UIcommons/Kefu/myexportsres.robot
Resource          ../../UIcommons/Kefu/teammeres.robot
Resource          ../../UIcommons/Kefu/mynotifyres.robot
Resource          ../../UIcommons/Kefu/agentstatres.robot
Resource          ../../UIcommons/Kefu/sessionsearchres.robot
Resource          ../../UIcommons/Kefu/exportsres.robot

*** Test Cases ***
查看会话列表
    ${t}    Clear Dictionary    &{ChatListSelected}
    ${k}    Get Dictionary Keys    ${t}
    Update Tab Selector    &{ChatListSelected}
    Comment    go to    ${kefuurl}${chatUri}
    Comment    Check Basic Chat Element    ${uiagent.language}

查看待接入列表
    go to    ${kefuurl}${waitUri}
    Check Basic Wait Element    ${uiagent.language}

查看我的留言列表
    go to    ${kefuurl}${mynotesUri}
    Check Basic Mynotes Element    ${uiagent.language}

查看我的历史会话
    ${jbase}    to json    ${historybasejson}
    Check Base Module    ${kefuurl}${jbase['navigator']['Agent']['uri']}    ${jbase['navigator']['Agent']['ShowKey']}    ${uiagent}    ${jbase}

查看我的客户中心
    go to    ${kefuurl}${myvisitorsUri}
    Check Basic Myvisitors Element    ${uiagent.language}

查看我的导出管理
    go to    ${kefuurl}${myexportsUri}
    Check Basic Myexports Element    ${uiagent.language}

查看客服信息
    go to    ${kefuurl}${teammeUri}
    Check Basic Teamme Element    ${uiagent.language}

查看我的留言
    go to    ${kefuurl}${mynotifyUri}
    Check Basic Mynotify Element    ${uiagent.language}

查看我的统计数据
    go to    ${kefuurl}${agentstatUri}
    Check Basic Agentstat Element    ${uiagent.language}

查看搜索
    ${jbase}    to json    ${sessionsearchbasejson}
    Check Base Module    ${kefuurl}${jbase['navigator']['Agent']['uri']}    ${jbase['navigator']['Agent']['ShowKey']}    ${uiagent}    ${jbase}

查看导出管理
    ${jbase}    to json    ${exportsbasejson}
    Check Base Module    ${kefuurl}${jbase['navigator']['Agent']['uri']}    ${jbase['navigator']['Agent']['ShowKey']}    ${uiagent}    ${jbase}
