*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Library    Collections
Resource    ../Variable_Env.robot
Resource    ../UITeset_Env.robot
Resource    ../RestApi/User/UserApi.robot
Resource    ../Common/BaseCommon.robot
Resource    ../Common/AppCommon/AppCommon.robot
Resource    ../Common/UserCommon/UserCommon.robot

*** Keywords ***
设置rest api请求header
    ${Authorization}    Set Variable    Bearer ${Token.orgToken}
    &{newRequestHeader}    Create Dictionary    Content-Type=application/json    Authorization=${Authorization}    Accept=application/json
    [Return]    &{newRequestHeader}