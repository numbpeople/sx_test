*** Settings ***
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../UICommon/UIUserCommon/FriendAndBlackListCommon.robot
Library    String

*** Test Cases ***
向其他用户发起好友申请
    [Documentation]    添加好友
    ...    1.参数1:发起方,参数2:参数1的密码,参数3:接收方
    [Template]    Apply Add Friend Template
    [Setup]    Set UserName Password
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}     

拒绝其他用户好友申请
    [Documentation]
    ...    拒绝其他好友申请
    [Template]    Refused Friends Request Operation Template
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}

接受其他用户好友申请
    [Documentation]    
    ...    接受其他好友申请
    [Template]    Agreen Friends Request Operation Template
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}

查看好友列表
    [Documentation]    
    ...    添加好友后，查看好友列表
    [Template]    Check Friends List Templeate    
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}