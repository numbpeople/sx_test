*** Settings ***
Suite Setup       Kefu Chat Suite Setup    ${uiadmin}    ${uiagent1}    true    # 步骤：创建关联；禁用所有溢出规则；坐席登录，设置该接待数为0，清空该坐席进行中会话，创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组；设置路由规则优先入口指定
Suite Teardown    Kefu Chat Suite Teardown    ${uiadmin}    #步骤：删除关联；删除技能组
Force Tags        ui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Library           uuid
Library           urllib
Library           Selenium2Library
Resource          ../../api/HomePage/Login/Login_Api.robot
Resource          ../../UIcommons/Kefu/chatres.robot
Resource          ../../commons/Base Common/Base_Common.robot
Resource          ../../commons/admin common/Channels/App_Common.robot
Resource          ../../commons/admin common/Members/AgentQueue_Common.robot
Resource          ../../UIcommons/Kefu/agentmoderes.robot

*** Test Cases ***
调度1：管理员能自动调度
    [Documentation]    组合预调度开关、上班时间调度开关和上下班时间控制来测试
    [Setup]    Set Agent StatusAndMaxServiceUserNumber    ${uiagent1}    ${kefustatus[0]}    1
    [Template]    AutoSchedule Case
    ${uiadmin}    ${uiagent1}    true    true    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    true    true    off    ${false}    'agent'
    ${uiadmin}    ${uiagent1}    true    false    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    true    false    off    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    false    true    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    false    true    off    ${false}    'agent'
    ${uiadmin}    ${uiagent1}    false    false    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    false    false    off    ${true}    'agent'

调度2：管理员能心跳调度（修改接待数）
    [Documentation]    组合预调度开关、上班时间调度开关和上下班时间控制来测试
    [Setup]    Set Agent Status    ${uiagent1}    ${kefustatus[0]}
    [Template]    KeepaliveSchedule By Change MaxServiceUserNumber Case
    ${uiadmin}    ${uiagent1}    true    true    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    true    true    off    ${false}    'agent'
    ${uiadmin}    ${uiagent1}    true    false    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    true    false    off    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    false    true    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    false    true    off    ${false}    'agent'
    ${uiadmin}    ${uiagent1}    false    false    on    ${true}    'agent'
    ${uiadmin}    ${uiagent1}    false    false    off    ${true}    'agent'

调度3：管理员能心跳调度（修改状态）
    [Documentation]    组合预调度开关、上班时间调度开关和上下班时间控制来测试
    [Setup]    Set Agent StatusAndMaxServiceUserNumber    ${uiagent1}    ${kefustatus[0]}    1
    [Template]    KeepaliveSchedule By Change Status Case
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    true    true    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    true    true    off    ${false}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    true    false    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    true    false    off    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    false    true    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    false    true    off    ${false}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    false    false    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[1]}    false    false    off    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    true    true    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    true    true    off    ${false}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    true    false    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    true    false    off    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    false    true    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    false    true    off    ${false}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    false    false    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[2]}    false    false    off    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    true    true    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    true    true    off    ${false}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    true    false    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    true    false    off    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    false    true    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    false    true    off    ${false}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    false    false    on    ${true}
    ...    'agent'
    ${uiadmin}    ${uiagent1}    ${kefustatus[3]}    false    false    off    ${true}
    ...    'agent'
