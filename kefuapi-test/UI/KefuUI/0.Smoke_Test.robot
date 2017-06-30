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
Library           jsonschema
Library           urllib
Library           Selenium2Library
Resource          ../../UIcommons/Kefu/chatres.robot
Resource          ../../UIcommons/Kefu/waitres.robot
Resource          ../../UIcommons/Kefu/mynotesres.robot
Resource          ../../UIcommons/Kefu/myhistoryres.robot

*** Test Cases ***
查看会话列表
    go to    ${kefuurl}${chatUri}
    Check Basic Chat Element    ${uiagent.language}

查看待接入列表
    go to    ${kefuurl}${waitUri}
    Wait Until Page Contains Element    xpath=${waitTitleXPath}
    Wait Until Element Contains    xpath=${waitTitleXPath}    ${waitTitle.${uiagent.language}}

查看我的留言列表
    go to    ${kefuurl}${mynotesUri}
    Wait Until Page Contains Element    xpath=${mynotesTitleXPath}
    Wait Until Element Contains    xpath=${mynotesTitleXPath}    ${mynotesTitle.${uiagent.language}}

查看我的历史会话
    go to    ${kefuurl}${myhistoryUri}
    Wait Until Page Contains Element    xpath=${myhistoryTitleXPath}
    Wait Until Element Contains    xpath=${myhistoryTitleXPath}    ${myhistoryTitle.${uiagent.language}}
