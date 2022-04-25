*** Settings ***
Library           AsyncLibrary
Resource          ../Common/WSCommon.robot
Resource          ../../Varable_Wayang.robot
Resource    ../Common/UserCommon.robot

*** Test Cases ***
修改用户昵称
    SDKupdateCurrentUserNick    "test"    ${WayangRes.device1}
