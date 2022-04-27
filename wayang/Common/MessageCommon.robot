*** Settings ***
Library    JSONLibrary
Resource          ../../Common/BaseCommon.robot
Resource          ../../Varable_Wayang.robot
Resource          BaseCommon.robot
Resource          WSCommon.robot

*** Keywords ***
SDKsendMessage
    [Arguments]    ${conn}    ${msg}    ${device}
    IF    "${device}" == "Webim"
        Log    "webim"
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


WebsendMessage
    [Arguments]    ${conn}    ${msg}
    Log    ${msg}