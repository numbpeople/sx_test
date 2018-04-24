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
Resource          ../../UIcommons/Kefu/agentmoderes.robot

*** Test Cases ***
查看会话列表
    [Documentation]    1.检查进行中会话基本元素
    ...    2.检查昵称状态基本元素
    ...    3.检查最大接待人数基本元素1
    set test variable    ${maxnum}    1
    #设置状态为在线，接待数为1
    ${j}    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    ${j}    Set Agent MaxServiceUserNumber    ${uiadmin}    ${maxnum}
    #跳转到进行中会话页面并检查页面元素
    goto and checkchatebasejson    ${uiadmin}
    #格式化昵称状态字符串并检查基本元素
    #默认状态ul属性为hide，状态li无属性
    @{p}    create List    '${uiadmin.nicename}'    ${elementstatelist[4]}    ${elementstatelist[0]}    ${elementstatelist[0]}    ${elementstatelist[0]}
    ...    ${elementstatelist[0]}
    ${jbase}    Format String To Json    format avatarloginstatstr    @{p}
    Check Base Elements    ${uiadmin.language}    ${jbase['elements']}
    #点击弹出状态选择列表，格式化状态列表字符串并检查基本元素
    click element    xpath=${jbase['elements'][0]['xPath']}
    #点击 后状态ul无属性，在线状态li为selected
    @{p}    create List    '${uiadmin.nicename}'    ${elementstatelist[0]}    ${elementstatelist[2]}    ${elementstatelist[0]}    ${elementstatelist[0]}
    ...    ${elementstatelist[0]}
    Format String And Check Elements    ${uiadmin}    format avatarloginstatstr    @{p}
    #格式化最大接待人数字符串并检查基本元素
    @{p}    create List    ${elementstatelist[0]}    ${maxnum}
    Format String And Check Elements    ${uiadmin}    format maxcallinselectorstr    @{p}

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
