*** Variables ***
${mynotifyUri}    /mo/agent/webapp/center/mynotify
${mynotifyTitleXPath}    //*[@id="em-msgcenter"]/header/h1
&{mynotifyTitle}    zh_CN=消息中心    en_US=Notification

*** Keywords ***
Check Basic Mynotify Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${mynotifyTitleXPath}
    Wait Until Element Contains    xpath=${mynotifyTitleXPath}    ${mynotifyTitle.${language}}
