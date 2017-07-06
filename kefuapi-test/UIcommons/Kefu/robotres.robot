*** Variables ***
${robotsettingsUri}    /mo/admin/robot/settings
${robotsettingsTitleXPath}    //*[@id="em-robot"]/header/h1
&{robotsettingsTitle}    zh_CN=机器人设置    en_US=Robot settings
${robotmaterialUri}    /mo/admin/robot/material
${robotmaterialTitleXPath}    //*[@id="em-material"]/header/h1
&{robotmaterialTitle}    zh_CN=素材库    en_US=Library

*** Keywords ***
Check Basic Robotsettings Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${robotsettingsTitleXPath}
    Wait Until Element Contains    xpath=${robotsettingsTitleXPath}    ${robotsettingsTitle.${language}}

Check Basic Robotmaterial Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${robotmaterialTitleXPath}
    Wait Until Element Contains    xpath=${robotmaterialTitleXPath}    ${robotmaterialTitle.${language}}
