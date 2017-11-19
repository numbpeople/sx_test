*** Settings ***
Resource          ../../admin common/Channels/App_Common.robot
Resource          ../../../tool/Tools-Resource.robot

*** Keywords ***
Conversation Setup
    [Documentation]    快速创建关联
    Create Channel    #快速创建一个关联

Conversation Teardown
    [Documentation]    删除创建的坐席、关联、技能组
    Delete Agentusers    #删除坐席
    Delete Queues    #删除技能组
    Delete Channels    #删除关联
