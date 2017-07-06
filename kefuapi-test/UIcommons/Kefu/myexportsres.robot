*** Variables ***
${myexportsUri}    /mo/agent/webapp/center/myexports
${myexportsTitleXPath}    //*[@id="em-download"]/header/h1
&{myexportsTitle}    zh_CN=导出管理    en_US=Export

*** Keywords ***
Check Basic Myexports Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${myexportsTitleXPath}
    Wait Until Element Contains    xpath=${myexportsTitleXPath}    ${myexportsTitle.${language}}
