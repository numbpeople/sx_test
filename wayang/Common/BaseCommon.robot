*** Settings ***
Resource          WSCommon.robot
Library           AsyncLibrary
Resource          ../../Varable_Wayang.robot
Resource          ../Resource/LoginRes.resource
Resource    ../Common/Login.robot

*** Keywords ***
WayangSetup
    ${conn}    WSConnect    ${WayangRes.WSUrl}${WayangRes.topic1}    ${${WayangRes.timeout}}
    Set Global Variable    ${WayangRes.WSconn}    ${conn}
    SDKLogin     "${WatyangUserinfo.username}"   "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device1}
    ${handle}    Async Run    WSPING    ${WayangRes.WSconn}    ${WayangRes.delay}
    Set Global Variable    ${wshandle}    ${handle}

WayangTeardown
    SDKLogout    ${WayangRes.device1}
    WSCLOSE    ${WayangRes.WSconn}

WayangCMDTeardown
    [Arguments]    @{args}
    Log    @{args}

Assert Response
    [Arguments]    ${keyword}    @{agrlist}
    Log    ${keyword}    ${agrlist}