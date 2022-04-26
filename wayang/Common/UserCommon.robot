*** Settings ***
Documentation     登录注册相关关键字
Library    JSONLibrary
Resource          ../../Varable_Wayang.robot
Resource          BaseCommon.robot
Resource          WSCommon.robot
Resource    ../Resource/UserRes.resource
Resource    ../../../../rf-py3/kefuapi-test/UI/KefuAPPUI/Common/BaseCommon.robot

*** Keywords ***

SDKupdateCurrentUserNick
    [Arguments]    ${nickname}    ${device}
    IF    "${device}" == "Webim"
        WebimupdateCurrentUserNick    ${nickname}    ${WebimupdateCurrentUserNickCMD}
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
    ${tres}    Convert String to JSON    ${res}
    ${tresjson}    Convert String to JSON    ${tres['info']['return']}
    @{argument}    Create List    "${WayangappInfo.orgname}"    "${WatyangUserinfo.username}"    ${nickname}    "${WayangappInfo.appname}"
    ${texpectedstr}    Format Jsonstr    ${WebimupdateCurrentUserNickResp}    ${argument}
    ${texpectedjson}    Convert String to JSON    ${texpectedstr}
    #Assert Response    ${res}['info']['return']['entities']    ${updateCurrentUserNickResp}    ${updateCurrentUserNickExclude}
    Assert Response    ${tresjson}    ${texpectedjson}    ${WebimupdateCurrentUserNickExclude}
    @{teardownlist}    Create List    ${cmdstr}    ${res}    ${savecasepath}    "WebimupdateCurrentUserNick"    
    RETURN    ${res}
    [Teardown]    WayangCMDTeardown    ${teardownlist}

 
 