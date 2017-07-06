*** Variables ***
${channelsappUri}    /mo/admin/webapp/channels/app
${channelsappTitleXPath}    //*[@id="em-attach"]/header/h1
&{channelsappTitle}    zh_CN=为您的手机APP加入环信移动客服    en_US=Bind your app with Easemob
${channelswebUri}    /mo/admin/webapp/channels/web
${channelswebTitleXPath}    //*[@id="em-widget"]/header/h1
&{channelswebTitle}    zh_CN=为您的网页加入环信移动客服    en_US=Add Easemob to your website
${channelswechatUri}    /mo/admin/webapp/channels/wechat
${channelswechatTitleXPath}    //*[@id="em-wechat"]/header/h1
&{channelswechatTitle}    zh_CN=将您的微信公众号绑定到环信移动客服    en_US=Bind your WeChat Official Account with Easemob
${channelsweiboUri}    /mo/admin/webapp/channels/weibo
${channelsweiboTitleXPath}    //*[@id="em-weibo"]/header/h1
&{channelsweiboTitle}    zh_CN=将您的微博绑定到环信移动客服    en_US=Bind your Weibo account with Easemob
${channelscallUri}    /mo/admin/webapp/channels/call
${channelscallTitleXPath}    //*[@id="em-callcenter"]/header/h1
&{channelscallTitle}    zh_CN=呼叫中心渠道    en_US=Call Center

*** Keywords ***
Check Basic Channelsapp Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${channelsappTitleXPath}
    Wait Until Element Contains    xpath=${channelsappTitleXPath}    ${channelsappTitle.${language}}

Check Basic Channelsweb Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${channelswebTitleXPath}
    Wait Until Element Contains    xpath=${channelswebTitleXPath}    ${channelswebTitle.${language}}

Check Basic Channelswechat Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${channelswechatTitleXPath}
    Wait Until Element Contains    xpath=${channelswechatTitleXPath}    ${channelswechatTitle.${language}}

Check Basic Channelsweibo Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${channelsweiboTitleXPath}
    Wait Until Element Contains    xpath=${channelsweiboTitleXPath}    ${channelsweiboTitle.${language}}

Check Basic Channelscall Element
    [Arguments]    ${language}
    Wait Until Page Contains Element    xpath=${channelscallTitleXPath}
    Wait Until Element Contains    xpath=${channelscallTitleXPath}    ${channelscallTitle.${language}}
