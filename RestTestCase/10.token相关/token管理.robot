*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/AppCommon/AppCommon.robot
Resource          ../../Variable_Env.robot
Resource          ../../Result/APPResult/AppManagement_Result.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot
*** Test Cases ***
设置apptoken过期时间
    [Template]    Set App Token Expire Tmplate
    