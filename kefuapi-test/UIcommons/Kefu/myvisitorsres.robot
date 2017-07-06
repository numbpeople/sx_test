*** Variables ***
${myvisitorsUri}    /mo/agent/webapp/center/myvisitors
${myvisitorsTitleXPath}    //*[@id="em-visitors"]/header/h1
&{myvisitorsTitle}    zh_CN=客户中心    en_US=Customers

*** Keywords ***
Check Basic Myvisitors Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${myvisitorsTitleXPath}
    Wait Until Element Contains    xpath=${myvisitorsTitleXPath}    ${myvisitorsTitle.${language}}
