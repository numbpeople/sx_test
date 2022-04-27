*** Settings ***
Library           AsyncLibrary
Resource          ../Common/WSCommon.robot
Resource          ../../Varable_Wayang.robot
Resource    ../Common/UserCommon.robot

*** Test Cases ***
修改用户昵称
    SDKupdateCurrentUserNick    ${WayangRes.WSconn}    "test123"    ${WayangRes.device}

添加好友
    ${contactmsg}    FakerLibrary.Sentence    
    SDKaddContact    ${WayangRes.WSconn}    "${WatyangUser2info.username}"    "${contactmsg}"    ${WayangRes.device}    ${false}
