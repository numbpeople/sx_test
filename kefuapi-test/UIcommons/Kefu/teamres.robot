*** Variables ***
${teamindivisualUri}    /mo/admin/webapp/team/indivisual
${teamindivisualTitleXPath}    //*[@id="em-agent"]/header/h1
&{teamindivisualTitle}    zh_CN=客服    en_US=Agent
${teamgroupsUri}    /mo/admin/webapp/team/groups
${teamgroupsTitleXPath}    //*[@id="em-group"]/header/h1
&{teamgroupsTitle}    zh_CN=技能组    en_US=Team management

*** Keywords ***
Check Basic Teamindivisual Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${teamindivisualTitleXPath}
    Wait Until Element Contains    xpath=${teamindivisualTitleXPath}    ${teamindivisualTitle.${language}}

Check Basic Teamgroups Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${teamgroupsTitleXPath}
    Wait Until Element Contains    xpath=${teamgroupsTitleXPath}    ${teamgroupsTitle.${language}}
