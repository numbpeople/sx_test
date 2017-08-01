*** Variables ***
${myhistoryUri}    /mo/agent/webapp/sessions/myhistory
${myhistoryTitleXPath}    //*[@id="em-history"]/header/h1
&{myhistoryTitle}    zh_CN=历史会话    en_US=History

*** Keywords ***
Check Basic Myhistory Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${myhistoryTitleXPath}
    Wait Until Element Contains    xpath=${myhistoryTitleXPath}    ${myhistoryTitle.${language}}
