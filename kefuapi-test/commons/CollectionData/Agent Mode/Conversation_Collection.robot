*** Settings ***
Resource          ../../admin common/Channels/App_Common.robot

*** Keywords ***
Conversation Setup
    [Documentation]    快速创建关联
    Comment    Create Channel    #快速创建一个关联

Conversation Teardown
    [Documentation]    删除创建的坐席、关联、技能组
    Comment    Delete Agentusers    #删除坐席
    Comment    Delete Queues    #删除技能组
    Comment    Delete Channels    #删除关联
