*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/UserCommon/UserOnlineAndOffline.robot
Resource          ../../Variable_Env.robot
Resource          ../../Result/UserResult/FriendsAndBlacklist_Result.robot
Resource          ../../Result/UserResult/UserManagement_Result.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/UserResult/UserOnlineAndOffline_Result.robot

*** Test Cases ***
待编写：用户账号禁用(/{orgName}/{appName}/users/{userName}/deactivate)
    [Template]
    ${contentType.JSON}    ${Token.orgToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：用户账号解禁(/{orgName}/{appName}/users/{userName}/activate)
    [Template]
    ${contentType.JSON}    ${Token.orgToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
