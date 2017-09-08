*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/KefuApi.robot
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

*** Test Cases ***
查看首页
    go to    ${kefuurl}${statisticindexUri}
    Check Basic Statisticindex Element    ${uiagent.language}

查看成员管理
    #查看客服
    go to    ${kefuurl}${teamindivisualUri}
    Check Basic Teamindivisual Element    ${uiagent.language}
    #查看技能组
    go to    ${kefuurl}${teamgroupsUri}
    Check Basic Teamgroups Element    ${uiagent.language}

查看渠道管理
    #查看app渠道
    go to    ${kefuurl}${channelsappUri}
    Check Basic Channelsapp Element    ${uiagent.language}
    #查看webim渠道
    go to    ${kefuurl}${channelswebUri}
    Check Basic Channelsweb Element    ${uiagent.language}
    #查看微信渠道
    go to    ${kefuurl}${channelswechatUri}
    Check Basic Channelswechat Element    ${uiagent.language}
    #查看微博渠道
    go to    ${kefuurl}${channelsweiboUri}
    Check Basic Channelsweibo Element    ${uiagent.language}
    #查看呼叫中心渠道
    go to    ${kefuurl}${channelscallUri}
    Check Basic Channelscall Element    ${uiagent.language}

查看智能机器人
    #查看客服
    go to    ${kefuurl}${robotsettingsUri}
    Check Basic Robotsettings Element    ${uiagent.language}
    #查看技能组
    go to    ${kefuurl}${robotmaterialUri}
    Check Basic Robotmaterial Element    ${uiagent.language}

查看搜索
    ${jbase}    to json    ${sessionsearchbasejson}
    goto    ${kefuurl}${jbase['entities'][0]['uri']}
    #如果灰度列表没有该key，输出log，否则检查元素
    : FOR    ${e}    IN    @{jbase['entities']}
    \    ${i}    Get Index From List    ${uiagent.graylist}    ${e['GrayKey']}
    \    Run Keyword If    ${i}==-1    log    未灰度此功能：${jbase['entities'][0]['GrayKey']}
    \    ...    ELSE    Check Element Contains Text    ${e['TitleXPath']}    ${e['Title']['${uiagent.language}']}

查看留言
    ${jbase}    to json    ${notesbasejson}
    goto    ${kefuurl}${jbase['entities'][0]['uri']}
    #如果灰度列表没有该key，输出log，否则检查元素
    :
    ${i}    Get Index From List    ${uiagent.graylist}    ${jbase['entities'][0]['GrayKey']}
    Run Keyword If    ${i}==-1    log    未灰度此功能：${jbase['entities'][0]['GrayKey']}
    ...    ELSE    Check Element Contains Text    ${jbase['entities'][0]['TitleXPath']}    ${jbase['entities'][0]['Title']['${uiagent.language}']}
