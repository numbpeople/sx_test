*** Settings ***
Resource          ../../../../../commons/agent common/Queue/Queue_Common.robot

*** Keywords ***
Close APPUI Queue Sessions
    [Documentation]    清除待接入数据
    #定义变量值
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    page=0
    #清除待接入数据
    Close Queue Sessions    ${AdminUser}    ${filter}    ${range}
