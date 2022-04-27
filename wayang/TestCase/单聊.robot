*** Settings ***
Library           AsyncLibrary
Resource          ../Common/WSCommon.robot
Resource          ../../Varable_Wayang.robot
Resource    ../Common/MessageCommon.robot

*** Test Cases ***
单聊消息
    Log    "message"


