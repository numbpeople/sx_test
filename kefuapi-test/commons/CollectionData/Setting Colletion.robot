*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../admin common/Setting/Permissions_Common.robot
Resource          ../admin common/Setting/Stickers_Common.robot
Resource          ../admin common/Setting/Phrases_Common.robot

*** Keywords ***
Setting Setup
    [Documentation]    该关键字为初始化的工作，目前操作为：清除自定义表情包
    Clear Stickers    #删除自定义表情包

Setting Teardown
    [Documentation]    该关键字是清理的工作，目前操作为：清除权限管理->自定义角色
    Clear Roles    #删除自定义角色
    Clear Phrases    #删除公共常用语
