*** Settings ***
Resource    ../../UITeset_Env.robot
Force Tags    user

*** Keywords ***

UI Add User
    [Documentation]    封装添加用户

Accept Reject Friend Requests Template
    [Arguments]
    [Documentation]    向用户发送添加好友请求
    ...    
    #创建用户
Add Friend Template
    [Arguments]
    [Documentation]    
Delete Friend Template
    [Arguments]
    [Documentation]    删除好友
    ...    
Deleted friends By User