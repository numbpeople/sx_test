*** Settings ***
Resource    ../../UITeset_Env.robot
Resource    ../../UICommon/UIUserCommon/FriendAndBlackListCommon.robot
Library    String

*** Test Cases ***
Apply Add friend
    [Documentation]
    ...    添加好友
    [Template]    Apply Add friend Template