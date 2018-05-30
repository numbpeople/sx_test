*** Settings ***
Resource          ../Base Common/InitData_Common.robot
Resource          ../admin common/Channels/App_Common.robot
Library           ../../lib/SendReport/Sender.py

*** Keywords ***
Setup Init Data
    [Documentation]    坐席账号初始化登录数据、获取灰度列表、获取租户所属organ信息、创建关联信息等的初始化工作
    Login Init    #坐席登录，初始化cookie、tenantId、userid等信息
    OrganInfo Init    #坐席登录后，获取租户所属的organId和organName
    Agent Data Init    #获取坐席登录后的坐席账号等信息
    Create Channel    #快速创建一个关联，以便于全局使用
    Robot Account Init    #判断租户下是否有机器人账号，如果有则不创建，如果没有则创建机器人账号
    Ticket Data Init    #获取租户id下的projectId和留言状态等值

Teardown Data
    [Documentation]    清除创建了的坐席、技能组、关联等信息
    Run Keyword And Ignore Error    Clear Data    #清除创建的多余数据

Test Init Data
    ${sub}    set variable    测试用例集：【${SUITE NAME}】下测试用例：【${TEST NAME}】状态为${TEST STATUS}
    ${status}    Run Keyword If Test Failed    sendReportMail    ${sub}    ${sub},${TEST MESSAGE}    ${revMaillList}
    run keyword if    '${TEST STATUS}' == 'PASS'    Pass Execution    测试用例【${TEST NAME}】是通过状态
    should be true    ${status}
