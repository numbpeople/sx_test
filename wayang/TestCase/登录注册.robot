*** Settings ***
Library           AsyncLibrary
Resource          ../Common/WSCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          ../Common/LoginCommon.robot

*** Test Cases ***
登录
    [Setup]    SDKLogout    ${WayangRes.device}
    SDKLogin    "${WatyangUserinfo.username}"   "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device}

登出
    [Teardown]    SDKLogin    "${WatyangUserinfo.username}"   "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device}
    SDKLogout    ${WayangRes.device}    