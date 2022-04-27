*** Settings ***
Documentation     登录注册相关关键字
Library    JSONLibrary
Resource          ../../Common/BaseCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          BaseCommon.robot
Resource          WSCommon.robot
Resource    ../../Common/GroupCommon/GroupCommon.robot

*** Keywords ***
SDKLogin
    [Arguments]    ${conn}    ${username}    ${password}    ${appkey}   ${device}    ${bAssert}=${true} 
    IF    "${device}" == "Webim"
        WebimLogin    ${conn}    ${username}    ${password}    ${appkey}    ${WebimLoginCMD}    ${bAssert}
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
    [Arguments]    ${conn}    ${device} 
    Log    ${device}
    IF    "${device}" == "Webim"
        WebimLogout    ${conn}    ${WebimLogoutCMD}
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
    [Arguments]    ${conn}    ${username}    ${password}    ${appkey}    ${cmdjson}    ${bAssert}
    @{argumentValue}    create list    ${username}    ${password}    ${appkey}
    ${cmdstr}    Format Jsonstr    ${cmdjson}    ${argumentValue}
    WSSend    ${conn}    ${cmdstr}
    ${res}    WSRecv    ${conn}
    IF    ${bAssert}
        ${tresjson}    Convert WayangResp to Json    ${res}    
        ${texpectedjson}    Convert String to JSON    ${WebimLoginResp}
        Assert Response    ${tresjson}    ${texpectedjson}    ${WebimLoginExclude}
    END
    @{teardownlist}    Create List    ${cmdstr}    ${res}    ${savecasepath}    "WebimLogin"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}

WebimLogout
    [Arguments]    ${conn}    ${cmdjson}
    WSSend    ${conn}    ${cmdjson}
    ${res}    WSRecv    ${conn}
    Log    ${res}
    @{teardownlist}    Create List    ${cmdjson}    ${res}    ${savecasepath}    "WebimLogout"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}
