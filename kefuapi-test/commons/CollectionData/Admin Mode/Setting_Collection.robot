*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../admin common/Setting/Permissions_Common.robot
Resource          ../../admin common/Setting/Stickers_Common.robot
Resource          ../../admin common/Setting/Phrases_Common.robot
Resource          ../../admin common/Setting/ReviewSettings_Common.robot
Resource          ../../admin common/Setting/Business-Hours_Common.robot

*** Keywords ***
Setting Setup
    [Documentation]    该关键字为初始化的工作，目前操作为：清除自定义表情包、获取默认时间计划
    Run Keyword And Ignore Error    Setting Setup Data

Setting Teardown
    [Documentation]    该关键字是清理的工作，目前操作为：清除权限管理->自定义角色
    Run Keyword And Ignore Error    Setting Teatdown Data

Setting Setup Data
    [Documentation]    清除自定义表情包、获取默认时间计划
    Clear Stickers    #删除自定义表情包
    Get ScheduleId    #获取时间计划列表，并取默认时间的${scheduleId}作为全局变量

Setting Teatdown Data
    [Documentation]    清除权限管理->自定义角色
    Clear Roles    #删除自定义角色
    Clear Phrases    #删除公共常用语
    Clear Review Category    #删除质检评分设置