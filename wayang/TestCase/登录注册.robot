*** Settings ***
Library           AsyncLibrary
Resource          ../Common/WSCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          ../Common/Login.robot

*** Test Cases ***
登录
    [Setup]    SDKLogout    ${WayangRes.device1}
    SDKLogin    "${WatyangUserinfo.username}"   "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device1}

登出
    [Teardown]    SDKLogin    "${WatyangUserinfo.username}"   "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device1}
    SDKLogout    ${WayangRes.device1}    