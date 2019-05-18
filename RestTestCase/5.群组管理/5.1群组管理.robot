*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/GroupCommon/GroupCommon.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/GroupResult/Group_Result.robot

*** Test Cases ***
创建一个新的群组(/{orgName}/{appName}/chatgroups)
    [Template]    Create New Chatgroup Template
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个新的群组-群主用户ID不存在(/{orgName}/{appName}/chatgroups)
    [Template]    Create New Chatgroup With Inexistent Owner Template
    ${contentType.JSON}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个新的群组-是否公开群组字段不存在(/{orgName}/{appName}/chatgroups)
    [Template]    Create New Chatgroup With Inexistent PublicTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${GroupPublicNotFoundDictionary.statusCode}    ${GroupPublicNotFoundDictionary.reponseResult}    ${GroupPublicNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupPublicNotFoundDictionary.statusCode}    ${GroupPublicNotFoundDictionary.reponseResult}    ${GroupPublicNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupPublicNotFoundDictionary.statusCode}    ${GroupPublicNotFoundDictionary.reponseResult}    ${GroupPublicNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupPublicNotFoundDictionary.statusCode}    ${GroupPublicNotFoundDictionary.reponseResult}    ${GroupPublicNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

修改群组信息(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Edit Chatgroup Template
    ${contentType.JSON}    ${Token.orgToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

修改群组信息-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Edit Chatgroup With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

删除群组信息(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Delete Chatgroup Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteChatgroupDictionary.statusCode}    ${DeleteChatgroupDictionary.reponseResult}    ${DeleteChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteChatgroupDictionary.statusCode}    ${DeleteChatgroupDictionary.reponseResult}    ${DeleteChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteChatgroupDictionary.statusCode}    ${DeleteChatgroupDictionary.reponseResult}    ${DeleteChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteChatgroupDictionary.statusCode}    ${DeleteChatgroupDictionary.reponseResult}    ${DeleteChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

删除群组信息-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Delete Chatgroup With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取App中所有的群组(/{orgName}/{appName}/chatgroups)
    [Template]    Get Chatgroup Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取一个用户参与的所有群组(/{orgName}/{appName}/users/{userName}/joined_chatgroups)
    [Template]    Get IM User Joined Chatgroups Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetIMUserJoinedChatgroupsDictionary.statusCode}    ${GetIMUserJoinedChatgroupsDictionary.reponseResult}    ${GetIMUserJoinedChatgroupsDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetIMUserJoinedChatgroupsDictionary.statusCode}    ${GetIMUserJoinedChatgroupsDictionary.reponseResult}    ${GetIMUserJoinedChatgroupsDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetIMUserJoinedChatgroupsDictionary.statusCode}    ${GetIMUserJoinedChatgroupsDictionary.reponseResult}    ${GetIMUserJoinedChatgroupsDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetIMUserJoinedChatgroupsDictionary.statusCode}    ${GetIMUserJoinedChatgroupsDictionary.reponseResult}    ${GetIMUserJoinedChatgroupsDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取一个用户参与的所有群组-不存在的IM用户(/{orgName}/{appName}/users/{userName}/joined_chatgroups)
    [Template]    Get IM User Joined Chatgroups With Inexistent IM User Template
    ${contentType.JSON}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群组详情(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Get Chatgroup Detail Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupDetailDictionary.statusCode}    ${GetChatgroupDetailDictionary.reponseResult}    ${GetChatgroupDetailDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupDetailDictionary.statusCode}    ${GetChatgroupDetailDictionary.reponseResult}    ${GetChatgroupDetailDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupDetailDictionary.statusCode}    ${GetChatgroupDetailDictionary.reponseResult}    ${GetChatgroupDetailDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupDetailDictionary.statusCode}    ${GetChatgroupDetailDictionary.reponseResult}    ${GetChatgroupDetailDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群组详情-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Get Chatgroup Detail With Inexistent GroupIdTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupDetailGroupIdNotFoundDictionary.statusCode}    ${GetChatgroupDetailGroupIdNotFoundDictionary.reponseResult}    ${GetChatgroupDetailGroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupDetailGroupIdNotFoundDictionary.statusCode}    ${GetChatgroupDetailGroupIdNotFoundDictionary.reponseResult}    ${GetChatgroupDetailGroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupDetailGroupIdNotFoundDictionary.statusCode}    ${GetChatgroupDetailGroupIdNotFoundDictionary.reponseResult}    ${GetChatgroupDetailGroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupDetailGroupIdNotFoundDictionary.statusCode}    ${GetChatgroupDetailGroupIdNotFoundDictionary.reponseResult}    ${GetChatgroupDetailGroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
