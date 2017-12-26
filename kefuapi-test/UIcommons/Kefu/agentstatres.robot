*** Variables ***
${agentstatUri}    /mo/agent/statistic/agent/stat
${agentstatTitleXPath}    //*[@id="em-workstat"]/article/header/h1
&{agentstatTitle}    zh_CN=统计数据    en_US=Analytics

*** Keywords ***
Check Basic Agentstat Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${agentstatTitleXPath}
    Wait Until Element Contains    xpath=${agentstatTitleXPath}    ${agentstatTitle.${language}}
