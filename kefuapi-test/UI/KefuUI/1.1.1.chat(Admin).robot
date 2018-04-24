*** Settings ***
Suite Setup       Kefu Chat Suite Setup    ${uiadmin}    ${uiadmin}    # 步骤：创建关联；禁用所有溢出规则；坐席登录，设置该接待数为0，清空该坐席进行中会话，创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组；设置路由规则优先入口指定
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
    [Setup]    Set Agent StatusAndMaxServiceUserNumber    ${uiadmin}    ${kefustatus[0]}    1
    [Template]    AutoSchedule Case
    ${uiadmin}    ${uiadmin}    true    true    on    ${true}
    ${uiadmin}    ${uiadmin}    true    true    off    ${false}
    ${uiadmin}    ${uiadmin}    true    false    on    ${true}
    ${uiadmin}    ${uiadmin}    true    false    off    ${true}
    ${uiadmin}    ${uiadmin}    false    true    on    ${true}
    ${uiadmin}    ${uiadmin}    false    true    off    ${false}
    ${uiadmin}    ${uiadmin}    false    false    on    ${true}
    ${uiadmin}    ${uiadmin}    false    false    off    ${true}

调度2：管理员能心跳调度（修改接待数）
    [Documentation]    组合预调度开关、上班时间调度开关和上下班时间控制来测试
    [Setup]    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    [Template]    KeepaliveSchedule By Change MaxServiceUserNumber Case
    ${uiadmin}    ${uiadmin}    true    true    on    ${true}
    ${uiadmin}    ${uiadmin}    true    true    off    ${false}
    ${uiadmin}    ${uiadmin}    true    false    on    ${true}
    ${uiadmin}    ${uiadmin}    true    false    off    ${true}
    ${uiadmin}    ${uiadmin}    false    true    on    ${true}
    ${uiadmin}    ${uiadmin}    false    true    off    ${false}
    ${uiadmin}    ${uiadmin}    false    false    on    ${true}
    ${uiadmin}    ${uiadmin}    false    false    off    ${true}

调度3：管理员能心跳调度（修改状态）
    [Documentation]    组合预调度开关、上班时间调度开关和上下班时间控制来测试
    [Setup]    Set Agent StatusAndMaxServiceUserNumber    ${uiadmin}    ${kefustatus[0]}    1
    [Template]    KeepaliveSchedule By Change Status Case
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    true    true    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    true    true    off    ${false}
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    true    false    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    true    false    off    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    false    true    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    false    true    off    ${false}
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    false    false    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[1]}    false    false    off    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    true    true    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    true    true    off    ${false}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    true    false    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    true    false    off    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    false    true    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    false    true    off    ${false}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    false    false    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[2]}    false    false    off    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    true    true    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    true    true    off    ${false}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    true    false    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    true    false    off    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    false    true    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    false    true    off    ${false}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    false    false    on    ${true}
    ${uiadmin}    ${uiadmin}    ${kefustatus[3]}    false    false    off    ${true}

调度4：管理员不能调度非本组的会话
    [Documentation]    步骤：
    ...    1.设置坐席接待数为1，状态为在线
    ...    2.创建一个新技能组（下面用queueb简称）
    ...    3.发送消息（扩展中技能技能组queueb）
    ...
    ...
    ...    期望结果：
    ...    1.坐席待接入中能查询到该会话
    ...    2.坐席不会自动接起该会话（3秒不从待接入中消失）
    [Setup]    Set Agent StatusAndMaxServiceUserNumber    ${uiadmin}    ${kefustatus[0]}    1
    #步骤6
    ${q2}    Create Random Agentqueue    ${uiadmin}
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #步骤8：发送消息，并指定到新技能组
    ${guest}    Generate Uuidguest    app
    Send Uuidmsg By Specified Queue    ${restentity}    ${guest}    ${q2.queueName}
    #检查结果
    #设置筛选条件：
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guest.userName}    page=0
    Session In Waitings And Not In Visitors By Specified Time    ${uiadmin}    ${filter}    ${range}    3    ${guest.userName}
    [Teardown]    Delete Agentqueue    ${q2.queueId}    ${uiadmin}

调度5：指定坐席能直接接起
    [Documentation]    步骤：
    ...    serviceSessionJudgeOverloadEnable为false，坐席预调度开启和关闭，接待人数为0或1（可接待），均可直接接入指定坐席的会话
    ...
    ...
    ...    期望结果：
    ...    坐席进行中会话有该会话
    [Setup]    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    [Template]    Specify Agent AutoSchedule Case
    ${uiadmin}    ${uiadmin}    true    0
    ${uiadmin}    ${uiadmin}    true    1
    ${uiadmin}    ${uiadmin}    false    0
    ${uiadmin}    ${uiadmin}    false    1

调度6：指定坐席不能直接接起
    [Documentation]    步骤：
    ...    serviceSessionJudgeOverloadEnable为true，坐席预调度开启和关闭，接待人数为0
    ...
    ...
    ...    期望结果：
    ...    会话进入待接入不会被调度，接待人数改为1后，被心跳调度
    [Tags]    private
    [Setup]    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    [Template]    Specify Agent KeepaliveSchedule Case
    ${uiadmin}    ${uiadmin}    true
    ${uiadmin}    ${uiadmin}    false
