*** Variables ***
${chatUri}        /mo/agent/webapp/sessions/chat
${chatTitleXPath}    //*[@id='em-chat']/header/h1
&{chatTitle}      zh_CN=会话    en_US=Conversations

*** Keywords ***
Check Basic Chat Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${chatTitleXPath}
    Wait Until Element Contains    xpath=${chatTitleXPath}    ${chatTitle.${language}}
