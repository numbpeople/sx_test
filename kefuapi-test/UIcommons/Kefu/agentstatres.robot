*** Variables ***
${agentstatUri}    /mo/agent/statistic/agent/stat
${agentstatTitleXPath}    //*[@id="em-workstat"]/article/header/h1
&{agentstatTitle}    zh-CN=统计数据    en-US=Analytics

*** Keywords ***
Check Basic Agentstat Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${agentstatTitleXPath}
    Wait Until Element Contains    xpath=${agentstatTitleXPath}    ${agentstatTitle.${language}}
