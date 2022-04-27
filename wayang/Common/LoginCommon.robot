*** Settings ***
Documentation     登录注册相关关键字
Library    JSONLibrary
Resource          ../../Common/BaseCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          BaseCommon.robot
Resource          WSCommon.robot
Resource    ../../Common/GroupCommon/GroupCommon.robot
Resource    ../../../../rf-py3/kefuapi-test/JsonDiff/KefuJsonDiff.robot

*** Keywords ***
SDKLogin
    [Arguments]    ${conn}    ${username}    ${password}    ${appkey}   ${device}    ${cmdtype}    ${resptype}    ${bAssert}=${true} 
    IF    "${device}" == "Webim"
        WebimLogin    ${conn}    ${username}    ${password}    ${appkey}    ${cmdtype}    ${resptype}    ${bAssert}
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
        WebimLogout    ${conn}
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
    [Arguments]    ${conn}    ${username}    ${password}    ${appkey}    ${cmdtype}    ${resptype}    ${bAssert}
    IF    ${cmdtype} == ${1}
        @{argumentValue}    create list    ${username}    ${password}    ${appkey}
        ${cmdstr}    Format Jsonstr    ${WebimLoginCMD1}    ${argumentValue}
    ELSE
        Log    ${cmdtype}
    END
    WSSend    ${conn}    ${cmdstr}
    ${res}    WSRecv    ${conn}
    IF    ${bAssert}
        ${tresjson}    Convert WayangResp to Json    ${res}
        IF    ${resptype} == ${1}
            ${texpectedjson}    Convert String to JSON    ${WebimLoginResp1}
            Assert Response    ${tresjson}    ${texpectedjson}    ${WebimLoginExclude1}
        ELSE
            Log    ${resptype}    
        END            
    END
    @{teardownlist}    Create List    ${cmdstr}    ${res}    ${savecasepath}    "WebimLogin"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}

WebimLogout
    [Arguments]    ${conn}
    WSSend    ${conn}    ${WebimLogoutCMD1}
    ${res}    WSRecv    ${conn}
    Log    ${res}
    @{teardownlist}    Create List    ${WebimLogoutCMD1}    ${res}    ${savecasepath}    "WebimLogout"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}
