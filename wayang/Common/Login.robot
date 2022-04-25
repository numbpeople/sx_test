*** Settings ***
Documentation     登录注册相关关键字
Resource          ../../Common/BaseCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          BaseCommon.robot
Resource          WSCommon.robot
Resource    ../../Common/GroupCommon/GroupCommon.robot

*** Keywords ***
SDKLogin
    [Arguments]    ${username}    ${password}    ${appkey}   ${device} 
    IF    "${device}" == "Webim"
        WebimLogin    ${username}    ${password}    ${appkey}    ${WebimLoginCMD}
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

SDKLogout
    [Arguments]    ${device} 
    Log    ${device}
    IF    "${device}" == "Webim"
        WebimLogout    ${WebimLogoutCMD}
    ELSE IF    "${device}" == "Uniapp"
        Log    "Uniapp"
    ELSE IF    "${device}" == "Android"
        Log    "Android"
    ELSE IF    "${device}" == "IOS"
        Log    "IOS"
    ELSE IF    "${device}" == "Unity"
        Log    "Unity"
    ELSE
        Log    "What?"
    END
WebimLogin
    [Arguments]    ${username}    ${password}    ${appkey}    ${cmdjson}
    @{argumentValue}    create list    ${username}    ${password}    ${appkey}
    ${cmdstr}    Format Jsonstr    ${cmdjson}    ${argumentValue}
    WSSend    ${WayangRes.WSconn}    ${cmdstr}
    ${res}    WSRecv    ${WayangRes.WSconn}
    @{teardownlist}    Create List    ${cmdstr}    ${res}    ${savecasepath}    "WebimLogin"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}

WebimLogout
    [Arguments]    ${cmdjson}
    WSSend    ${WayangRes.WSconn}    ${cmdjson}
    ${res}    WSRecv    ${WayangRes.WSconn}
    @{teardownlist}    Create List    ${cmdjson}    ${res}    ${savecasepath}    "WebimLogout"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}
