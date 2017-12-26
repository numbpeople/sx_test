*** Variables ***
${waitUri}        /mo/agent/webapp/center/wait
${waitTitleXPath}    //*[@id="em-wait"]/header/h1
&{waitTitle}      zh_CN=待接入    en_US=Queue

*** Keywords ***
Check Basic Wait Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${waitTitleXPath}
    Wait Until Element Contains    xpath=${waitTitleXPath}    ${waitTitle.${language}}
