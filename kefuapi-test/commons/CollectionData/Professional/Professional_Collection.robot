*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../admin common/Setting/Stickers_Common.robot
Resource          ../../admin common/Setting/Business-Hours_Common.robot

*** Keywords ***
Professional Setup
    [Documentation]    该关键字为初始化的工作，目前操作为：查询增值/灰度功能列表、清除自定义表情包、获取默认时间计划
    Run Keyword And Ignore Error    Professional Setup Data

Professional Teardown
    [Documentation]    该关键字是清理的工作，目前操作为：无
    Run Keyword And Ignore Error    Professional Teatdown Data

Professional Setup Data
    [Documentation]    清除自定义表情包、获取默认时间计划
    Get GrayList    #查询增值/灰度功能列表
    Get ScheduleId    #获取时间计划列表，并取默认时间的${scheduleId}作为全局变量
    Clear Stickers    #删除自定义表情包

Professional Teatdown Data
    [Documentation]    
