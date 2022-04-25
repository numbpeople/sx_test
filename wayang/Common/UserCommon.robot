*** Settings ***
Documentation     登录注册相关关键字
Resource          ../../Common/BaseCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          BaseCommon.robot
Resource          WSCommon.robot
Resource    ../Resource/UserRes.resource
Resource    ../../Common/UserCommon/UserCommon.robot
Resource    ../../Result/UserResult/UserManagement_Result.robot

*** Keywords ***

SDKupdateCurrentUserNick
    [Arguments]    ${nickname}    ${device}
    IF    "${device}" == "Webim"
        WebimupdateCurrentUserNick    ${nickname}    ${updateCurrentUserNickCMD}
    ELSE IF    "${device}" == "Uniapp"
        Log    "Uniapp"
    ELSE IF    "${device}" == "Android"
        Log    "Android"
    ELSE IF    "${device}" == "IOS"
        Log    "IOS"
    ELSE IF    "${device}" == "Unity"
        Log    "Unity"
    ELSE
        Log    ${device}
        Log    "What?"
    END    


WebimupdateCurrentUserNick
    [Arguments]    ${nickname}    ${cmdjson}
    @{argumentValue}    create list    ${nickname}    
    ${cmdstr}    Format Jsonstr    ${cmdjson}    ${argumentValue}
    WSSend    ${WayangRes.WSconn}    ${cmdstr}
    ${res}    WSRecv    ${WayangRes.WSconn}
    Assert Response    ${res}    ${res}
    @{teardownlist}    Create List    ${cmdstr}    ${res}    ${savecasepath}    "WebimupdateCurrentUserNick"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}

 
 