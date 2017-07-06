*** Variables ***
${teammeUri}      /mo/agent/webapp/team/me
${teammeTitleXPath}    //*[@id="em-profile"]/header/h1
&{teammeTitle}    zh_CN=客服信息    en_US=Personal

*** Keywords ***
Check Basic Teamme Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${teammeTitleXPath}
    Wait Until Element Contains    xpath=${teammeTitleXPath}    ${teammeTitle.${language}}
