*** Settings ***
Force Tags        userActivateAndDeactivate
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/UserCommon/UserActivateAndDeactivate.robot
Resource          ../../Result/UserResult/UserActivateAndDeactivate_Result.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
用户账号禁用(/{orgName}/{appName}/users/{userName}/deactivate)
    [Template]    Activate User Template
    ${contentType.JSON}    ${Token.orgToken}    ${ActivateUserDictionary.statusCode}    ${ActivateUserDictionary.reponseResult}    ${ActivateUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${NoAdminUserAccessAuthorizedDictionary.statusCode}    ${NoAdminUserAccessAuthorizedDictionary.reponseResult}    ${NoAdminUserAccessAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ActivateUserDictionary.statusCode}    ${ActivateUserDictionary.reponseResult}    ${ActivateUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${NoAdminUserAccessAuthorizedDictionary.statusCode}    ${NoAdminUserAccessAuthorizedDictionary.reponseResult}    ${NoAdminUserAccessAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ActivateUserDictionary.statusCode}    ${ActivateUserDictionary.reponseResult}    ${ActivateUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ActivateUserDictionary.statusCode}    ${ActivateUserDictionary.reponseResult}    ${ActivateUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

用户账号解禁(/{orgName}/{appName}/users/{userName}/activate)
    [Template]    Deactivate User Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeactivateUserDictionary.statusCode}    ${DeactivateUserDictionary.reponseResult}    ${DeactivateUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${NoAdminUserAccessAuthorizedDictionary.statusCode}    ${NoAdminUserAccessAuthorizedDictionary.reponseResult}    ${NoAdminUserAccessAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeactivateUserDictionary.statusCode}    ${DeactivateUserDictionary.reponseResult}    ${DeactivateUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${NoAdminUserAccessAuthorizedDictionary.statusCode}    ${NoAdminUserAccessAuthorizedDictionary.reponseResult}    ${NoAdminUserAccessAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeactivateUserDictionary.statusCode}    ${DeactivateUserDictionary.reponseResult}    ${DeactivateUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeactivateUserDictionary.statusCode}    ${DeactivateUserDictionary.reponseResult}    ${DeactivateUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
