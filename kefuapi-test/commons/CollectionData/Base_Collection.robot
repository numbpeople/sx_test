*** Settings ***
Resource          ../Base Common/InitData_Common.robot
Resource          ../admin common/Channels/App_Common.robot
Library           ../../lib/SendReport/Sender.py

*** Keywords ***
Setup Init Data
    [Documentation]    坐席账号初始化登录数据、获取灰度列表、获取租户所属organ信息、创建关联信息等的初始化工作
    Setup Data

Teardown Data
    [Documentation]    清除创建了的坐席、技能组、关联等信息
    Run Keyword And Ignore Error    Clear Data    #清除创建的多余数据

Test Init Data
    ${sub}    set variable    测试用例集：【${SUITE NAME}】下测试用例：【${TEST NAME}】状态为${TEST STATUS}
    ${status}    Run Keyword If Test Failed    sendReportMail    ${sub}    ${sub},${TEST MESSAGE}    ${revMaillList}
    run keyword if    '${TEST STATUS}' == 'PASS'    Pass Execution    测试用例【${TEST NAME}】是通过状态
    should be true    ${status}
