*** Variables ***
${statisticindexUri}    /mo/admin/statistic/index
${statisticindexTitleXPath}    //*[@id="em-chart"]/header/h1/span
&{statisticindexTitle}    zh_CN=，欢迎回来    en_US=. Welcome back.

*** Keywords ***
Check Basic Statisticindex Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${statisticindexTitleXPath}
    Wait Until Element Contains    xpath=${statisticindexTitleXPath}    ${statisticindexTitle.${language}}
