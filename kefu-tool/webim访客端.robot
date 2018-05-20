*** Settings ***
Documentation     Django Robot Tests
Suite Setup       Start Django and open Browser
Suite Teardown    Run Keyword And Ignore Error    Stop Django and close Browser
Default Tags      tool-webim    tool
Library           Selenium2Library    timeout=10    implicit_wait=10
Library           DjangoLibrary    ${HOSTNAME}    ${PORT}    path=mysite/mysite    manage=kefu-tool/mysite/manage.py    settings=mysite.settings

*** Variables ***
${HOSTNAME}       127.0.0.1
${PORT}           55001
${SERVER}         http://${HOSTNAME}:${PORT}/
${BROWSER}        chrome

*** Test Cases ***
webimPlugin
    Go To    ${SERVER}
    Maximize Browser Window
    Wait until page contains    正常版
    Page Should Contain    旧版多租户
    #切入到iframe窗口
    Select Frame    xpath=//iframe[contains(@id, 'easemob-iframe-')]
    Wait Until Page Contains Element    xpath=//*[@id="em-widgetPopBar"]/a
    #点击开聊天窗口
    Click Element    xpath=//*[@id="em-widgetPopBar"]/a
    #访客发消息
    Wait Until Page Contains Element    xpath=//*[@id="em-kefu-webim-chat"]/div[4]/textarea
    Click Element    xpath=//*[@id="em-kefu-webim-chat"]/div[4]/textarea
    #等待按钮变为发送状态
    Wait Until Element Contains    xpath=//*[@id="em-kefu-webim-chat"]/div[4]/span    Send
    #输入消息
    Input Text    xpath=//*[@id="em-kefu-webim-chat"]/div[4]/textarea    访客发消息
    #点击发送按钮
    Click Element    //*[@id="em-kefu-webim-chat"]/div[4]/span
    #获取坐席侧消息
    Wait until page contains    亲爱的顾客，机器人很高兴为您服务，您可以输入以下关键词进行咨询：【“物流，邮费，退款，退换货，代金券”】，或用简洁的语言描述您的问题。
    Wait until page contains    消息什么的就问我，我可是小灵通啊
    Wait Until Page Contains Element    xpath=//*[@class="em-widget-left"]/div/div/span
    @{msgList}    Get Webelements    xpath=//*[@class="em-widget-left"]/div/div/span
    ${msgLength}    get length    ${msgList}
    log    ${msgList}
    : FOR    ${i}    IN RANGE    ${msgLength}
    \    ${msg}    Get Text    ${msgList[${i}]}
    \    log    ${msg}

*** Keywords ***
Start Django and open Browser
    Start Django
    Open Browser    ${SERVER}    ${BROWSER}

Stop Django and close browser
    Close Browser
    Stop Django
