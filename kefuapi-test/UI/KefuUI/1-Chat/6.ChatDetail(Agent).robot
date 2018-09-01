*** Settings ***
Suite Setup       Kefu Chat Suite Setup    ${uiadmin}    ${uiagent1}    # 步骤：创建关联；禁用所有溢出规则；坐席登录，设置该接待数为0，清空该坐席进行中会话，创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组；设置路由规则优先入口指定
Suite Teardown    Kefu Chat Suite Teardown    ${uiadmin}    #步骤：删除关联；删除技能组
Force Tags        ui    adminschedule    adminuser
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Library           uuid
Library           urllib
Library           Selenium2Library
Resource          ../../../api/HomePage/Login/Login_Api.robot
Resource          ../../../UIcommons/Kefu/chatres.robot
Resource          ../../../commons/Base Common/Base_Common.robot
Resource          ../../../commons/admin common/Channels/App_Common.robot
Resource          ../../../commons/admin common/Members/AgentQueue_Common.robot
Resource          ../../../UIcommons/Kefu/agentmoderes.robot

*** Test Cases ***
查看聊窗title信息
    [Documentation]    组合预调度开关、上班时间调度开关和上下班时间控制来测试
    [Setup]    Set Agent StatusAndMaxServiceUserNumber    ${uiagent1}    ${kefustatus[0]}    1
    [Template]    Check ChatDetail Case
    ${uiadmin}    ${uiagent1}
