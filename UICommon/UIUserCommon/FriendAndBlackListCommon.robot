*** Settings ***
Library    String
Library    Collections
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../UITest_Env/RegisterLoginElement/LoginPageElement.robot
Resource    ../../UITest_Env/SessionElement/SessionTabPageElement.robot
Force Tags    usermanagement

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