*** Settings ***
Resource          WSCommon.robot
Library           AsyncLibrary
Library    ../Lib/wayangutils.py
Library           deepdiff    WITH NAME    TDeep
Resource          ../../Varable_Wayang.robot
Resource          ../Resource/LoginRes.resource
Resource          ../Common/LoginCommon.robot

*** Keywords ***
WayangSetup
    ${conn}    WSConnect    ${WayangRes.WSUrl}${WayangRes.topic1}    ${${WayangRes.timeout}}
    Set Global Variable    ${WayangRes.WSconn}    ${conn}
    SDKLogin    "${WatyangUserinfo.username}"    "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device}
    ${handle}    Async Run    WSPING    ${WayangRes.WSconn}    ${WayangRes.delay}
    Set Global Variable    ${wshandle}    ${handle}

WayangTeardown
    SDKLogout    ${WayangRes.device}
    WSCLOSE    ${WayangRes.WSconn}

WayangCMDTeardown
    [Arguments]    @{args}
    Log    @{args}

Assert Response
    [Arguments]    ${Resp}    ${Expected}    ${Exclude}
    #${res}    ${deepdiff.DeepDiff()}    ${Respstr}    ${Expectedstr}    'exclude_paths=${Exclude}'
    Log    ${Resp}
    Log    ${Expected}
    Log    ${Exclude}
    ${res}    Respdiff    ${Resp}    ${Expected}    ${Exclude}
    Should Be Empty    ${res}