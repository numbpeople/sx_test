*** Settings ***
Resource    ../../Variable_Env.robot
Resource    ../../Common/CallbackCommon/CallbackCommon.robot
Resource    ../../Result/CallBackResult/CallBack_Result.robot
Resource    ../../Result/BaseResullt.robot
Default Tags    callback
Test Teardown    DeleteAppKeyAllCallBack

*** Test Cases ***
AddCallBack
    [Documentation]    添加一个发送后回调（create by shuang）
    [Tags]    SmokeTest
    [Template]    AddCallBackTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}


EditCallback
    [Documentation]    修改一个发送后回调（create by shuang）
    [Tags]    SmokeTest
    [Template]    EditCallbackTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}


DeleteCallBack
    [Documentation]    删除一个发送后回调（create by shuang）
    [Tags]    SmokeTest
    [Template]    DeleteCallBackTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
 

GetSingCallBack 
    [Documentation]    查询单个发送后回调详情（create by shuang）
    [Tags]    SmokeTest
    [Template]    GetSingCallBackTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CallBackDictionary.statusCode}    ${CallBackDictionary.reponseResult}    ${CallBackDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}


GetAllCallBack
    [Documentation]    查询所有发送后回调（create by shuang）
    [Template]    GetAllCallBackTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${MoreCallBackDictionary.statusCode}    ${MoreCallBackDictionary.reponseResult}    ${MoreCallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MoreCallBackDictionary.statusCode}    ${MoreCallBackDictionary.reponseResult}    ${MoreCallBackDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UnableToAuthenticateDictionary.statusCode}    ${UnableToAuthenticateDictionary.reponseResult}    ${UnableToAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MoreCallBackDictionary.statusCode}    ${MoreCallBackDictionary.reponseResult}    ${MoreCallBackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MoreCallBackDictionary.statusCode}    ${MoreCallBackDictionary.reponseResult}    ${MoreCallBackDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}