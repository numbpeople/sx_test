*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../admin common/Channels/Webim_Common.robot
Resource          ../../admin common/Setting/Stickers_Common.robot


*** Keywords ***
Webim Setup
    [Documentation]    该关键字为网页渠道初始化的工作，目前操作为：创建网页插件配置、清除自定义表情包
    Run Keyword And Ignore Error    Webim Setup Data

Webim Teardown
    [Documentation]    该关键字为网页渠道清理的工作，目前操作为：删除网页插件配置、清除自定义表情包
    Run Keyword And Ignore Error    Webim Teatdown Data

Webim Setup Data
    [Documentation]    创建网页插件配置、清除自定义表情包
    Create Template    #创建网页插件配置
    Clear Stickers    #清除自定义表情包

Webim Teatdown Data
    [Documentation]    删除网页插件配置、清除自定义表情包
    Delete Template    #删除网页插件配置
    Clear Stickers    #清除自定义表情包
