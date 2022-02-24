*** Settings ***
Force Tags        chatgroupManagement
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/GroupCommon/GroupCommon.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/GroupResult/Group_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
创建一个新的群组(/{orgName}/{appName}/chatgroups)
    [Template]    Create New Chatgroup Template
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个包含中文的群组(/{orgName}/{appName}/chatgroups)
    [Template]    Create Include Chinese groups Template
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
    [Documentation]    created by shuangxi
    ...    1.修改群组描述
    ...    2.修改群组最大人数
    ...    3.修改群组名称
    ${contentType.JSON}    ${Token.orgToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupDictionary.reponseResult}    ${EditChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
修改群组最大人数(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Edit Chatgroup Maxuser Template
    [Documentation]    created by shuangxi
    ...    1.修改群组最大人数
    ${contentType.JSON}    ${Token.orgToken}    ${EditChatgroupMaxuserDictionary.statusCode}    ${EditChatgroupMaxuserDictionary.reponseResult}    ${EditChatgroupMaxuserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${EditChatgroupMaxuserDictionary.statusCode}    ${EditChatgroupMaxuserDictionary.reponseResult}    ${EditChatgroupMaxuserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${EditChatgroupDictionary.statusCode}    ${EditChatgroupMaxuserDictionary.reponseResult}    ${EditChatgroupMaxuserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${EditChatgroupMaxuserDictionary.statusCode}    ${EditChatgroupMaxuserDictionary.reponseResult}    ${EditChatgroupMaxuserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
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
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupMemberDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

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

分页获取APP下所有群组(/{orgName}/{appName}/chatgroups?limit=)  
    [Template]    Get All Groups Of App by page Template
    [Documentation]    created by wudi     
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    
获取app下公开群组(/{orgName}/{appName}/publicchatgroups)  
    [Template]    Get Public Group Template
    [Documentation]    created by wudi  
    ${contentType.JSON}    ${Token.orgToken}    ${GetPublicChatgroupDictionary.statusCode}    ${GetPublicChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}   
    ${contentType.JSON}    ${Token.appToken}    ${GetPublicChatgroupDictionary.statusCode}    ${GetPublicChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetPublicChatgroupDictionary.statusCode}    ${GetPublicChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}

创建私有化群组-不允许拉人(/{orgName}/{appName}/chatgroups)
    [Template]    Create Private Chatgroup Template
    [Documentation]    created by wudi  
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}    false
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}    false
    ${EMPTY}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}    false
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}    false
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}    false
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}    false

创建私有化群组-允许拉人(/{orgName}/{appName}/chatgroups)
    [Template]    Create Private Chatgroup Template
    [Documentation]    created by wudi  
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}    true
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}    true
    ${EMPTY}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}    true
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}    true
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}    true
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}    true
    
创建公开群组（需要验证)(/{orgName}/{appName}/chatgroups)
    [Template]    Create Public Chatgroup Without Invite Template
    [Documentation]    created by wudi  
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}    false
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}    false
    ${EMPTY}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}    false
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}    false
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}    false
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}    false
    
群组统计(/{org_name}/{app_name}/chatgroups/count)
    [Template]    Chatgroup Count Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupDictionary.statusCode}    ${GetChatgroupDictionary.reponseResult}    ${GetChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群组成员数(/{org_name}/{app_name}/chatgroups/{groupid}/count)
    [Template]    Chatgroup Member Count Template
    [Documentation]    created by shuangxi
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupMemberDictionary.statusCode}    ${GetChatgroupMemberDictionary.reponseResult}    ${GetChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupMemberDictionary.statusCode}    ${GetChatgroupMemberDictionary.reponseResult}    ${GetChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupMemberDictionary.statusCode}    ${GetChatgroupMemberDictionary.reponseResult}    ${GetChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupMemberDictionary.statusCode}    ${GetChatgroupMemberDictionary.reponseResult}    ${GetChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    
批量获取群组详情(/{orgName}/{appName}/chatgroups/{groupId1},{groupId2})
    [Template]    Get ChatgroupS Detail Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupsDetailDictionary.statusCode}    ${GetChatgroupsDetailDictionary.reponseResult}    ${GetChatgroupsDetailDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupsDetailDictionary.statusCode}    ${GetChatgroupsDetailDictionary.reponseResult}    ${GetChatgroupsDetailDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupsDetailDictionary.statusCode}    ${GetChatgroupsDetailDictionary.reponseResult}    ${GetChatgroupsDetailDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupsDetailDictionary.statusCode}    ${GetChatgroupsDetailDictionary.reponseResult}    ${GetChatgroupsDetailDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群组角色列表(/{orgName}/{appName}/chatgroups/{grpID}/roles)
    [Template]    Get Chatgroup roles Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgrouprolesDictionary.statusCode}    ${GetChatgrouprolesDictionary.reponseResult}    ${GetChatgrouprolesDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgrouprolesDictionary.statusCode}    ${GetChatgrouprolesDictionary.reponseResult}    ${GetChatgrouprolesDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgrouprolesDictionary.statusCode}    ${GetChatgrouprolesDictionary.reponseResult}    ${GetChatgrouprolesDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgrouprolesDictionary.statusCode}    ${GetChatgrouprolesDictionary.reponseResult}    ${GetChatgrouprolesDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加、修改群公告（/{orgName}/{appName}/chatgroups/{grpID}/announcement）
    [Template]    Add Group Announcement Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${AddGroupAnnouncementDictionary.statusCode}    ${AddGroupAnnouncementDictionary.reponseResult}    ${AddGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddGroupAnnouncementDictionary.statusCode}    ${AddGroupAnnouncementDictionary.reponseResult}    ${AddGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddGroupAnnouncementDictionary.statusCode}    ${AddGroupAnnouncementDictionary.reponseResult}    ${AddGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddGroupAnnouncementDictionary.statusCode}    ${AddGroupAnnouncementDictionary.reponseResult}    ${AddGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群公告（/{orgName}/{appName}/chatgroups/{grpID}/announcement）
    [Template]    Get Group Announcement Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetGroupAnnouncementDictionary.statusCode}    ${GetGroupAnnouncementDictionary.reponseResult}    ${GetGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetGroupAnnouncementDictionary.statusCode}    ${GetGroupAnnouncementDictionary.reponseResult}    ${GetGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetGroupAnnouncementDictionary.statusCode}    ${GetGroupAnnouncementDictionary.reponseResult}    ${GetGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetGroupAnnouncementDictionary.statusCode}    ${GetGroupAnnouncementDictionary.reponseResult}    ${GetGroupAnnouncementDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

屏蔽群消息
    [Template]    Shield Group Message Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${ShiledGroupMessageDictionary.statusCode}    ${ShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${ShiledGroupMessageDictionary.statusCode}    ${ShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ShiledGroupMessageDictionary.statusCode}    ${ShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${EMPTY}    ${EMPTY}    ${ShiledGroupMessageDictionary.statusCode}    ${ShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ShiledGroupMessageDictionary.statusCode}    ${ShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ShiledGroupMessageDictionary.statusCode}    ${ShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

解除屏蔽群消息
    [Template]    Unshield Group Message Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${UnShiledGroupMessageDictionary.statusCode}    ${UnShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${UnShiledGroupMessageDictionary.statusCode}    ${UnShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UnShiledGroupMessageDictionary.statusCode}    ${UnShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${EMPTY}    ${EMPTY}    ${UnShiledGroupMessageDictionary.statusCode}    ${UnShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UnShiledGroupMessageDictionary.statusCode}    ${UnShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UnShiledGroupMessageDictionary.statusCode}    ${UnShiledGroupMessageDictionary.reponseResult}    ${ShieldGroupMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

查询开启屏蔽群消息的成员
    [Template]    Get Member Who Open Shield Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetMemberWhoOpenShieldDictionary.statusCode}    ${GetMemberWhoOpenShieldDictionary.reponseResult}    ${GetMemberWhoOpenShieldDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetMemberWhoOpenShieldDictionary.statusCode}    ${GetMemberWhoOpenShieldDictionary.reponseResult}    ${GetMemberWhoOpenShieldDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetMemberWhoOpenShieldDictionary.statusCode}    ${GetMemberWhoOpenShieldDictionary.reponseResult}    ${GetMemberWhoOpenShieldDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetMemberWhoOpenShieldDictionary.statusCode}    ${GetMemberWhoOpenShieldDictionary.reponseResult}    ${GetMemberWhoOpenShieldDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

用户批量加入群组
    [Template]    Users join groups in batches Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${UsersJoinGroupsInBatchesDictionary.statusCode}    ${UsersJoinGroupsInBatchesDictionary.reponseResult}    ${UsersJoinGroupsInBatchesDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UsersJoinGroupsInBatchesDictionary.statusCode}    ${UsersJoinGroupsInBatchesDictionary.reponseResult}    ${UsersJoinGroupsInBatchesDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UsersJoinGroupsInBatchesDictionary.statusCode}    ${UsersJoinGroupsInBatchesDictionary.reponseResult}    ${UsersJoinGroupsInBatchesDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

群组静音
    [Template]    Ban Group Message Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${BanGroupMessageDictionary.statusCode}    ${BanGroupMessageDictionary.reponseResult}    ${BanGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${BanGroupMessageDictionary.statusCode}    ${BanGroupMessageDictionary.reponseResult}    ${BanGroupMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${BanGroupMessageDictionary.statusCode}    ${BanGroupMessageDictionary.reponseResult}    ${BanGroupMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

解除群组静音
    [Template]    Allow Group Message Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${AllowGroupMessageDictionary.statusCode}    ${AllowGroupMessageDictionary.reponseResult}    ${AllowGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AllowGroupMessageDictionary.statusCode}    ${AllowGroupMessageDictionary.reponseResult}    ${AllowGroupMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AllowGroupMessageDictionary.statusCode}    ${AllowGroupMessageDictionary.reponseResult}    ${AllowGroupMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群消息已读成员列表
    [Template]    Get Received Members Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetReceiveMemberDictionary.statusCode}    ${GetReceiveMemberDictionary.reponseResult}    ${GetReceiveMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetReceiveMemberDictionary.statusCode}    ${GetReceiveMemberDictionary.reponseResult}    ${GetReceiveMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}

获取群共享文件列表
    [Template]    Get File List Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetFileListDictionary.statusCode}    ${GetFileListDictionary.reponseResult}    ${GetFileListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    


