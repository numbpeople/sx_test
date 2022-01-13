*** Settings ***
Resource    ../../Variable_Env.robot
Resource    ../../Common/CallbackCommon/MsgHooksCommon.robot
Resource    ../../Result/CallBackResult/CallBack_Result.robot
Resource    ../../Result/BaseResullt.robot
Default Tags    MsgHooks
Test Teardown    DeleteAppKeyAllMsgHooks

*** Test Cases ***
AddMsghooks
    [Documentation]    添加一个发送后回调（create by shuang）
    [Tags]    SmokeTest
    [Template]    AddMsghooksTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}


EditMsgHooks
    [Documentation]    修改一个发送后回调（create by shuang）
    ...    查询/删除发送前回调使用id，并非name
    [Tags]    SmokeTest
    [Template]    EditMsgHooksTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}


DeleteMsgHooks
    [Documentation]    删除一个发送后回调（create by shuang）
    ...    查询/删除发送前回调使用id，并非name
    [Tags]    SmokeTest
    [Template]    DeleteMsgHooksTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteMsgHooksDictionary.statusCode}    ${DeleteMsgHooksDictionary.reponseResult}    ${DeleteMsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteMsgHooksDictionary.statusCode}    ${DeleteMsgHooksDictionary.reponseResult}    ${DeleteMsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteMsgHooksDictionary.statusCode}    ${DeleteMsgHooksDictionary.reponseResult}    ${DeleteMsgHooksDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteMsgHooksDictionary.statusCode}    ${DeleteMsgHooksDictionary.reponseResult}    ${DeleteMsgHooksDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
 

GetSingMsgHooks 
    [Documentation]    查询单个发送后回调详情（create by shuang）
    ...    查询/删除发送前回调使用id，并非name
    [Tags]    SmokeTest
    [Template]    GetSingMsgHooksTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MsgHooksDictionary.statusCode}    ${MsgHooksDictionary.reponseResult}    ${MsgHooksDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}


GetAllMsgHooks
    [Documentation]    查询所有发送后回调（create by shuang）
    ...    查询/删除发送前回调使用id，并非name
    [Tags]    SmokeTest
    [Template]    GetAllMsgHooksTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${MoreMsgHooksDictionary.statusCode}    ${MoreMsgHooksDictionary.reponseResult}    ${MoreMsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MoreMsgHooksDictionary.statusCode}    ${MoreMsgHooksDictionary.reponseResult}    ${MoreMsgHooksDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MoreMsgHooksDictionary.statusCode}    ${MoreMsgHooksDictionary.reponseResult}    ${MoreMsgHooksDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MoreMsgHooksDictionary.statusCode}    ${MoreMsgHooksDictionary.reponseResult}    ${MoreMsgHooksDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}