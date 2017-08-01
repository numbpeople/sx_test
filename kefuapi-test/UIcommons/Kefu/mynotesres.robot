*** Variables ***
${mynotesUri}     /mo/agent/webapp/center/mynotes
${mynotesTitleXPath}    //*[@id="em-note"]/header/h1
&{mynotesTitle}    zh_CN=留言    en_US=Note

*** Keywords ***
Check Basic Mynotes Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${mynotesTitleXPath}
    Wait Until Element Contains    xpath=${mynotesTitleXPath}    ${mynotesTitle.${language}}
