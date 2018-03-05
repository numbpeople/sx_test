*** Settings ***
Resource          ../Base Common/InitData_Common.robot
Library           ../../lib/SendReport/Sender.py

*** Keywords ***
Setup Init Data
    [Documentation]    坐席账号初始化登录数据、获取灰度列表、获取租户所属organ信息、创建关联信息等的初始化工作
    Login Init    #坐席登录，初始化cookie、tenantId、userid等信息
    Initdata Init    #获取租户的initdata数据，存储角色、sessionid、resource数据
    OrganInfo Init    #坐席登录后，获取租户所属的organId和organName
    Grayscale List Init    #获取租户灰度列表，如音视频、消息撤回、自定义报表等多个增值功能
    Agent Status Init    #获取坐席登录后的最大接待数、状态、userId值
    Agent Data Init    #获取坐席登录后的坐席账号等信息
    Tenant Info Init    #获取租户信息，如租户id、所属的organId和organName
    agentUserLanguage Init    #坐席登录后，获取坐席的当前浏览器语言
    Create Channel Init    #快速创建关联后，获取关联的appKey、clientId、clientSecret、im号等信息
    TargetChannels Init    #获取租户下的关联列表，如：token、restserver、xmppserver、Im登录的restSession
    Comment    Options List Init    #获取租户的开关信息，如optionName和optionValue
    UserChannelSwitches Init    #获取机器人渠道开关信息
    Channel Data Init    #获取关联的数据，包括：关联的appKey、clientId、clientSecret、im号等信息外，加入绑定的queueId和queueName
    Create Channel    #快速创建一个关联，以便于全局使用

Teardown Data
    [Documentation]    清除创建了的坐席、技能组、关联等信息
    Clear Data    #清除创建的多余数据

Test Init Data
    ${sub}    set variable    测试用例集：【${SUITE NAME}】下测试用例：【${TEST NAME}】状态为${TEST STATUS}
    ${status}    Run Keyword If Test Failed    sendReportMail    ${sub}    ${sub},${TEST MESSAGE}    ${revMaillList}
    run keyword if    '${TEST STATUS}' == 'PASS'    Pass Execution    测试用例【${TEST NAME}】是通过状态
    should be true    ${status}
