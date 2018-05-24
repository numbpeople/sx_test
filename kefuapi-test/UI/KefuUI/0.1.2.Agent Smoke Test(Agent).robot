*** Settings ***
Force Tags        agentuser
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
Resource          ../../UIcommons/Kefu/agentmoderes.robot

*** Test Cases ***
查看会话列表
    [Documentation]    1.检查进行中会话基本元素
    ...    2.检查昵称状态基本元素
    ...    3.检查最大接待人数基本元素1
    [Template]    chat smoketest case
    ${uiagent1}

查看待接入列表
    [Template]    smoketest case
    ${uiagent1}    ${waitbasejson}

查看我的知识库
    [Template]    smoketest case
    ${uiagent1}    ${knowledgebasejson}

查看我的留言列表
    [Template]    smoketest case
    ${uiagent1}    ${notesbasejson}

查看我的工单
    [Template]    smoketest case
    #查看工单列表
    ${uiagent1}    ${myticketlistbasejson}
    #查看工单导出
    ${uiagent1}    ${myticketdownloadbasejson}

查看我的历史会话
    [Template]    smoketest case
    ${uiagent1}    ${historybasejson}

查看我的质量检查
    [Template]    smoketest case
    #查看质检记录
    ${uiagent1}    ${qualityrecordbasejson}
    #查看申述记录
    ${uiagent1}    ${appealrecordbasejson}

查看我的搜索
    [Template]    smoketest case
    ${uiagent1}    ${sessionsearchbasejson}

查看我的客户中心
    [Template]    smoketest case
    ${uiagent1}    ${visitorsbasejson}

查看我的导出管理
    [Template]    smoketest case
    ${uiagent1}    ${exportsbasejson}

查看客服信息
    [Template]    smoketest case
    ${uiagent1}    ${agentinfobasejson}

查看个人常用语
    [Template]    smoketest case
    ${uiagent1}    ${myphrasebasejson}

查看消息中心
    [Template]    smoketest case
    ${uiagent1}    ${notifybasejson}

查看我的统计数据
    [Template]    smoketest case
    ${uiagent1}    ${mystatisticbasejson}
