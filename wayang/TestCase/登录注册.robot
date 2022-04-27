*** Settings ***
Library           AsyncLibrary
Resource          ../Common/WSCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          ../Common/LoginCommon.robot

*** Test Cases ***
登录
    [Setup]    SDKLogout    ${WayangRes.WSconn}    ${WayangRes.device}
    SDKLogin    ${WayangRes.WSconn}    "${WatyangUserinfo.username}"   "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device}    ${1}    ${1}

登出
    [Teardown]    SDKLogin    ${WayangRes.WSconn}    "${WatyangUserinfo.username}"   "${WatyangUserinfo.password}"    "${WayangappInfo.orgname}#${WayangappInfo.appname}"    ${WayangRes.device}    ${1}    ${1}
    SDKLogout    ${WayangRes.WSconn}    ${WayangRes.device}    