*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/GroupCommon/GroupBlacklistCommon.robot
Resource          ../../Result/GroupResult/Group_Result.robot
Resource          ../../Result/GroupResult/GroupMember_Result.robot
Resource          ../../Result/GroupResult/ChatgroupBlacklist_Result.robot

*** Test Cases ***
添加单个用户至群组黑名单(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/{userName})
    [Template]    Add Single User Chatgroup Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加单个用户至群组黑名单-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/{userName})
    [Template]    Add Single User Chatgroup Blacklist With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加单个用户至群组黑名单-用户不是组内成员(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/{userName})
    [Template]    Add Not Belong Single User Chatgroup Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

从群组黑名单移除单个用户(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/{userName})
    [Template]    Remove Single User Chatgroup Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SingleUserChatgroupBlacklistDictionary.statusCode}    ${SingleUserChatgroupBlacklistDictionary.reponseResult}    ${SingleUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

查询群组黑名单(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/)
    [Template]    Get Chatgroup Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupBlacklistDictionary.statusCode}    ${GetChatgroupBlacklistDictionary.reponseResult}    ${GetChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupBlacklistDictionary.statusCode}    ${GetChatgroupBlacklistDictionary.reponseResult}    ${GetChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupBlacklistDictionary.statusCode}    ${GetChatgroupBlacklistDictionary.reponseResult}    ${GetChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupBlacklistDictionary.statusCode}    ${GetChatgroupBlacklistDictionary.reponseResult}    ${GetChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

查询群组黑名单-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/)
    [Template]    Get Chatgroup Blacklist With Inexistent GroupIdTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量添加用户至群组黑名单(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/)
    [Template]    Add Multi User Chatgroup Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddMultiUserChatgroupBlacklistDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddMultiUserChatgroupBlacklistDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddMultiUserChatgroupBlacklistDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddMultiUserChatgroupBlacklistDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量添加用户至群组黑名单-用户不存在(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/)
    [Template]    Add Multi User Chatgroup Blacklist With Inexistent IMUser Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.statusCode}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary.reponseResult}    ${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量从群组黑名单移除用户(/{orgName}/{appName}/chatgroups/{groupId}/blocks/users/{userName})
    [Template]    Remove Multi User Chatgroup Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveMultiUserChatgroupBlacklistDictionary.statusCode}    ${RemoveMultiUserChatgroupBlacklistDictionary.reponseResult}    ${RemoveMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${RemoveMultiUserChatgroupBlacklistDictionary.statusCode}    ${RemoveMultiUserChatgroupBlacklistDictionary.reponseResult}    ${RemoveMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveMultiUserChatgroupBlacklistDictionary.statusCode}    ${RemoveMultiUserChatgroupBlacklistDictionary.reponseResult}    ${RemoveMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${RemoveMultiUserChatgroupBlacklistDictionary.statusCode}    ${RemoveMultiUserChatgroupBlacklistDictionary.reponseResult}    ${RemoveMultiUserChatgroupBlacklistDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
