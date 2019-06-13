*** Settings ***
Force Tags        userFriendsAndBlacklist
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/UserCommon/FriendsAndBlacklistCommon.robot
Resource          ../../Variable_Env.robot
Resource          ../../Result/UserResult/FriendsAndBlacklist_Result.robot
Resource          ../../Result/UserResult/UserManagement_Result.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
添加好友(/{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername})
    [Tags]    adduser
    [Template]    Add Friend Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddFriendDictionary.statusCode}    ${AddFriendDictionary.reponseResult}    ${AddFriendDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddFriendDictionary.statusCode}    ${AddFriendDictionary.reponseResult}    ${AddFriendDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddFriendDictionary.statusCode}    ${AddFriendDictionary.reponseResult}    ${AddFriendDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddFriendDictionary.statusCode}    ${AddFriendDictionary.reponseResult}    ${AddFriendDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加单个不存在的好友(/{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername})
    [Template]    Add Inexistent Friend Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除好友(/{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername})
    [Template]    Remove Friend Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveFriendDictionary.statusCode}    ${RemoveFriendDictionary.reponseResult}    ${RemoveFriendDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${RemoveFriendDictionary.statusCode}    ${RemoveFriendDictionary.reponseResult}    ${RemoveFriendDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveFriendDictionary.statusCode}    ${RemoveFriendDictionary.reponseResult}    ${RemoveFriendDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${RemoveFriendDictionary.statusCode}    ${RemoveFriendDictionary.reponseResult}    ${RemoveFriendDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取IM用户的好友列表(/{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername})
    [Template]    Get Friend Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetFriendDictionary.statusCode}    ${GetFriendDictionary.reponseResult}    ${GetFriendDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetFriendDictionary.statusCode}    ${GetFriendDictionary.reponseResult}    ${GetFriendDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetFriendDictionary.statusCode}    ${GetFriendDictionary.reponseResult}    ${GetFriendDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetFriendDictionary.statusCode}    ${GetFriendDictionary.reponseResult}    ${GetFriendDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取不存在用户的好友列表(/{orgName}/{appName}/users/{ownerUsername}/contacts/users/{friendUsername})
    [Template]    Get Inexistent Friend Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #token为空时获取不存在的用户，应该是返回状态码为401才对，现在看是返回404，并且返回值是说用户不存在{"error":"service_resource_not_found","timestamp":1556610427272,"duration":0,"exception":"org.apache.usergrid.services.exceptions.ServiceResourceNotFoundException","error_description":"Service resource not found"}

添加IM用户的黑名单(/{orgName}/{appName}/users/{ownerUsername}/blocks/users)
    [Template]    Add User Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserBlackListDictionary.statusCode}    ${UserBlackListDictionary.reponseResult}    ${UserBlackListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserBlackListDictionary.statusCode}    ${UserBlackListDictionary.reponseResult}    ${UserBlackListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserBlackListDictionary.statusCode}    ${UserBlackListDictionary.reponseResult}    ${UserBlackListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserBlackListDictionary.statusCode}    ${UserBlackListDictionary.reponseResult}    ${UserBlackListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加IM用户的黑名单-黑名单用户不存在(/{orgName}/{appName}/users/{ownerUsername}/blocks/users)
    [Template]    Add Inexistent User Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${BlackUserNotFoundDictionary.statusCode}    ${BlackUserNotFoundDictionary.reponseResult}    ${BlackUserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${BlackUserNotFoundDictionary.statusCode}    ${BlackUserNotFoundDictionary.reponseResult}    ${BlackUserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${BlackUserNotFoundDictionary.statusCode}    ${BlackUserNotFoundDictionary.reponseResult}    ${BlackUserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${BlackUserNotFoundDictionary.statusCode}    ${BlackUserNotFoundDictionary.reponseResult}    ${BlackUserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除IM用户的黑名单(/{orgName}/{appName}/users/{ownerUsername}/blocks/users/{blockedUsername})
    [Template]    Remove User Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveBlacklistUserDictionary.statusCode}    ${RemoveBlacklistUserDictionary.reponseResult}    ${RemoveBlacklistUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${RemoveBlacklistUserDictionary.statusCode}    ${RemoveBlacklistUserDictionary.reponseResult}    ${RemoveBlacklistUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveBlacklistUserDictionary.statusCode}    ${RemoveBlacklistUserDictionary.reponseResult}    ${RemoveBlacklistUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${RemoveBlacklistUserDictionary.statusCode}    ${RemoveBlacklistUserDictionary.reponseResult}    ${RemoveBlacklistUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除IM用户的黑名单-黑名单用户不存在(/{orgName}/{appName}/users/{ownerUsername}/blocks/users/{blockedUsername})
    [Template]    Remove Inexistent User Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取IM用户的黑名单(/{orgName}/{appName}/users/{ownerUsername}/blocks/users)
    [Template]    Get User BlacklistTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${GetUserBlackListDictionary.statusCode}    ${GetUserBlackListDictionary.reponseResult}    ${GetUserBlackListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetUserBlackListDictionary.statusCode}    ${GetUserBlackListDictionary.reponseResult}    ${GetUserBlackListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserUnAuthorizedDictionary.statusCode}    ${UserUnAuthorizedDictionary.reponseResult}    ${UserUnAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetUserBlackListDictionary.statusCode}    ${GetUserBlackListDictionary.reponseResult}    ${GetUserBlackListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetUserBlackListDictionary.statusCode}    ${GetUserBlackListDictionary.reponseResult}    ${GetUserBlackListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取IM用户的黑名单-IM用户不存在(/{orgName}/{appName}/users/{ownerUsername}/blocks/users)
    [Template]    Get Inexistent User BlacklistTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #token为空时获取不存在的用户，应该是返回状态码为401才对，现在看是返回404，并且返回值是说用户不存在{"error":"service_resource_not_found","timestamp":1556610427272,"duration":0,"exception":"org.apache.usergrid.services.exceptions.ServiceResourceNotFoundException","error_description":"Service resource not found"}
