*** Settings ***
Documentation     登录注册相关关键字
Library    JSONLibrary
Library    FakerLibrary    locale=en_US
Resource          ../../Varable_Wayang.robot
Resource          BaseCommon.robot
Resource          WSCommon.robot
Resource    ../Resource/UserRes.resource

*** Keywords ***

SDKupdateCurrentUserNick
    [Arguments]    ${conn}    ${nickname}    ${device}    ${cmdtype}    ${resptype}    ${bAssert}=${true} 
    IF    "${device}" == "Webim"
        WebimupdateCurrentUserNick    ${conn}    ${nickname}    ${cmdtype}    ${resptype}    ${bAssert}
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
    [Arguments]    ${conn}    ${nickname}    ${cmdtype}    ${resptype}    ${bAssert}
    IF    ${cmdtype} == ${1}
        @{argumentValue}    create list    ${nickname}    
        ${cmdstr}    Format Jsonstr    ${WebimupdateCurrentUserNickCMD1}    ${argumentValue}
    ELSE
        Log    ${cmdtype}
    END
    WSSend    ${conn}    ${cmdstr}
    ${res}    WSRecv    ${conn}
    IF    ${bAssert}
        ${tresjson}    Convert WayangResp to Json    ${res}   
        IF    ${resptype} == ${1}
            @{argument}    Create List    "${WayangappInfo.orgname}"    "${WatyangUserinfo.username}"    ${nickname}    "${WayangappInfo.appname}"
            ${texpectedstr}    Format Jsonstr    ${WebimupdateCurrentUserNickResp1}    ${argument}
            ${texpectedjson}    Convert String to JSON    ${texpectedstr}
            Assert Response    ${tresjson}    ${texpectedjson}    ${WebimupdateCurrentUserNickExclude1}    
        ELSE
            Log    ${resptype}    
        END     
    END
    @{teardownlist}    Create List    ${cmdstr}    ${res}    ${savecasepath}    "WebimupdateCurrentUserNick"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}

SDKaddContact
    [Arguments]    ${conn}    ${username}    ${msg}    ${device}    ${cmdtype}    ${resptype}    ${bAssert}=${true} 
    IF    "${device}" == "Webim"
        WebimaddContact    ${conn}    ${username}    ${msg}    ${cmdtype}    ${resptype}    ${bAssert}
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


WebimaddContact
    [Arguments]    ${conn}    ${username}    ${msg}    ${cmdtype}    ${resptype}    ${bAssert}
    IF    ${cmdtype} == ${1}
        @{argumentValue}    create list    ${username}    ${msg}    
        ${cmdstr}    Format Jsonstr    ${WebimaddContactCMD1}    ${argumentValue}
    ELSE
        Log    ${cmdtype}
    END
    WSSend    ${conn}    ${cmdstr}
    ${res}    WSRecv    ${conn}
    IF    ${bAssert}
        ${tresjson}    Convert WayangResp to Json    ${res}   
        IF    ${resptype} == ${1}
            @{argument}    Create List    "${WatyangUser2info.username}"    ${username}    "${WayangappInfo.appname}"
            ${texpectedstr}    Format Jsonstr    ${WebimupdateCurrentUserNickResp1}    ${argument}
            ${texpectedjson}    Convert String to JSON    ${texpectedstr}
            Assert Response    ${tresjson}    ${texpectedjson}    ${WebimupdateCurrentUserNickExclude1}
        ELSE
            Log    ${resptype}    
        END     
    END
    @{teardownlist}    Create List    ${cmdstr}    ${res}    ${savecasepath}    "WebimaddContact"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}
