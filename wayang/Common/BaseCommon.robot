*** Settings ***
Resource          WSCommon.robot
Library           AsyncLibrary
Library    ../Lib/wayangutils.py
Library           deepdiff    
Resource          ../../Varable_Wayang.robot
Resource          ../Resource/LoginRes.resource
Resource          ../Common/LoginCommon.robot

*** Keywords ***
WayangSetup
    ${conn}    WSConnect    ${WayangRes.WSUrl}${WayangRes.topic1}    ${${WayangRes.timeout}}
    Set Global Variable    ${WayangRes.WSconn}    ${conn}
    SDKLogin    "${WatyangUserinfo.username}"    "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device}    ${1}    ${1}    ${false}
    ${handle}    Async Run    WSPING    ${WayangRes.WSconn}    ${WayangRes.delay}
    Set Global Variable    ${wshandle}    ${handle}
    ${conn2}    WSConnect    ${Wayang2Res.WSUrl}${Wayang2Res.topic1}    ${${Wayang2Res.timeout}}
    Set Global Variable    ${Wayang2Res.WSconn}    ${conn2}
    SDKLogin    "${WatyangUser2info.username}"    "${WatyangUser2info.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${Wayang2Res.device}    ${1}    ${1}    ${false}
    ${handle2}    Async Run    WSPING    ${Wayang2Res.WSconn}    ${Wayang2Res.delay}
    Set Global Variable    ${wshandle2}    ${handle2}

WayangTeardown
    SDKLogout    ${WayangRes.WSconn}    ${WayangRes.device}
    WSCLOSE    ${WayangRes.WSconn}
    SDKLogout    ${Wayang2Res.WSconn}    ${Wayang2Res.device}
    WSCLOSE    ${Wayang2Res.WSconn}

WayangCMDTeardown
    [Arguments]    @{args}
    Log    @{args}

Convert WayangResp to Json
    [Arguments]    ${Resp}    
    ${res}    Convert String to JSON    ${Resp}
    ${tresjson}    Convert String to JSON    ${res['info']['return']}
    [Return]    ${tresjson}

Assert Response
    [Arguments]    ${Resp}    ${Expected}    ${Exclude}
    #${res}    ${deepdiff.DeepDiff()}    ${Respstr}    ${Expectedstr}    'exclude_paths=${Exclude}'
    Log    ${Resp}
    Log    ${Expected}
    Log    ${Exclude}
    ${res}    Respdiff    ${Resp}    ${Expected}    ${Exclude}
    Should Be Empty    ${res}