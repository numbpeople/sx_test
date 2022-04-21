*** Settings ***
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../UICommon/UIUserCommon/FriendAndBlackListCommon.robot
Library    String

*** Test Cases ***
向其他用户发起好友申请
    [Documentation]    添加好友
    ...    1.参数1:发起方,参数2:参数1的密码,参数3:接收方,参数4:不执行此case
    [Tags]    smoke
    [Template]    Apply Add Friends Template
    [Setup]    Set UserName Password
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}     fasle

拒绝其他用户好友申请
    [Documentation]
    ...    拒绝其他好友申请
    [Tags]    smoke
    [Template]    Refused Friends Request Operation Template
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}

接受其他用户好友申请
    [Documentation]    
    ...    接受其他好友申请
    [Tags]    smoke
    [Template]    Agreen Friends Request Operation Template
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}

连续添加多个好友
    [Documentation]    
    ...    添加好友后，查看好友列表
    [Template]    Add Multiple Friends Template
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown   
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2}    ${rightusername.username3}

删除其他好友
    [Documentation]    
    ...    用户主动删除好友
    [Tags]    smoke
    [Template]    Delete Friend Template
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown  
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2} 

被其他用户删除好友
    [Documentation]    
    ...    用户被其他用户删除
    [Tags]    smoke
    [Template]    Deleted Friends By User Template
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown  
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2} 

添加其他好友到黑名单
    [Documentation]    添加黑名单
    [Tags]    smoke
    [Template]    Add BLocklist Templeate
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown  
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2} 

被其他用户添加黑名单
    [Documentation]    被其他用户添加到黑名单
    [Tags]    smoke
    [Template]    Blacklisted Templeate
    [Setup]    Set UserName Password    
    [Teardown]    UI Test Data Teardown  
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username2} 