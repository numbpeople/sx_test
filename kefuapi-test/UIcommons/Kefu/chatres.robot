*** Variables ***
${chatUri}        /mo/agent/webapp/sessions/chat
${chatTitleXPath}    //*[@id='em-chat']/header/h1
&{chatTitle}      zh_CN=会话    en_US=Conversations
${ChatJson}       {"navigator":{"Agent":{"uri":"/mo/agent/webapp/sessions/chat","GrayKey":"base","ResourceKey":"agent_currentsession"}},"elements":[{"name":"header","xPath":"//*[@id='em-chat']/header/h1","text":{"zh_CN":"会话","en_US":"Conversations"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]},{"name":"MaxCallinText","xPath":"//*[@id='em-chat']/header/div[2]/label","text":{"zh_CN":"最大接待人数","en_US":"Maximum conversations"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]},{"name":"MaxCallinNumDiv","xPath":"//*[@id='em-chat']/header/div[2]/div","text":{"zh_CN":"","en_US":""},"op":"click","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[{"name":"MaxCallinNum","xPath":"//*[@id='em-chat']/header/div[2]/div/span/label","text":{"zh_CN":"${AgentsMeEntities.maxServiceUserNumber}","en_US":"${AgentsMeEntities.maxServiceUserNumber}"},"op":"click","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]},{"name":"MaxCallinSelector","xPath":"//*[@id='em-chat']/header/div[2]/div/span/span","text":{"zh_CN":"","en_US":""},"op":"click","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]},{"name":"StatsBar","xPath":"//*[@id='em-chat']/header/div[3]","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[{"name":"OpenSessionNumText","xPath":"//*[@id='em-chat']/header/div[3]/ul/li[1]/label","text":{"zh_CN":"${AgentsMeEntities.maxServiceUserNumber}","en_US":"${AgentsMeEntities.maxServiceUserNumber}"},"op":"click","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]},{"name":"MaxCallinSelector","xPath":"//*[@id='em-chat']/header/div[2]/div/span/span","text":{"zh_CN":"","en_US":""},"op":"click","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}]}
&{ChatListSelected}    visitor=selected    agent=
&{ChatAdditionSelected}    iframe=selected    info=    resp=    knowledge=

*** Keywords ***
Check Basic Chat Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${chatTitleXPath}
    Wait Until Element Contains    xpath=${chatTitleXPath}    ${chatTitle.${language}}
