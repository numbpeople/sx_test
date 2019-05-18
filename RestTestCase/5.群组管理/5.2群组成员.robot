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
Resource          ../../Common/GroupCommon/GroupMemberCommon.robot
Resource          ../../Result/GroupResult/GroupMember_Result.robot

*** Test Cases ***
添加单个群组成员(/{orgName}/{appName}/chatgroups/{groupId}/users/{userName})
    [Template]    Add Single Chatgroup Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加单个群组成员-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/users/{userName})
    [Template]    Add Single Chatgroup Member With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加单个群组成员-添加成员IM用户不存在(/{orgName}/{appName}/chatgroups/{groupId}/users/{userName})
    [Template]    Add Single Chatgroup Member With Inexistent IMUser Template
    ${contentType.JSON}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除单个群组成员(/{orgName}/{appName}/chatgroups/{groupId}/users/{userName})
    [Template]    Remove Single Chatgroup Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SingleChatgroupMemberDictionary.statusCode}    ${SingleChatgroupMemberDictionary.reponseResult}    ${SingleChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除单个群组成员-用户不属于群组成员(/{orgName}/{appName}/chatgroups/{groupId}/users/{userName})
    [Template]    Remove Not Belong Single Chatgroup Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MemberNotBelongChatgroupDictionary.statusCode}    ${MemberNotBelongChatgroupDictionary.reponseResult}    ${MemberNotBelongChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除单个群组成员-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/users/{userName})
    [Template]    Remove Single Chatgroup Member With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群组成员(/{orgName}/{appName}/chatgroups/{groupId}/users)
    [Template]    Get Multi Chatgroup Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${MultiChatgroupMemberDictionary.statusCode}    ${MultiChatgroupMemberDictionary.reponseResult}    ${MultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MultiChatgroupMemberDictionary.statusCode}    ${MultiChatgroupMemberDictionary.reponseResult}    ${MultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MultiChatgroupMemberDictionary.statusCode}    ${MultiChatgroupMemberDictionary.reponseResult}    ${MultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MultiChatgroupMemberDictionary.statusCode}    ${MultiChatgroupMemberDictionary.reponseResult}    ${MultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群组成员-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/users)
    [Template]    Get Multi Chatgroup Member With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${MultiChatgroupNotFoundDictionary.statusCode}    ${MultiChatgroupNotFoundDictionary.reponseResult}    ${MultiChatgroupNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MultiChatgroupNotFoundDictionary.statusCode}    ${MultiChatgroupNotFoundDictionary.reponseResult}    ${MultiChatgroupNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MultiChatgroupNotFoundDictionary.statusCode}    ${MultiChatgroupNotFoundDictionary.reponseResult}    ${MultiChatgroupNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MultiChatgroupNotFoundDictionary.statusCode}    ${MultiChatgroupNotFoundDictionary.reponseResult}    ${MultiChatgroupNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量添加群组成员(/{orgName}/{appName}/chatgroups/{groupId}/users)
    [Template]    Add Multi Chatgroup Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddMultiChatgroupMemberDictionary.statusCode}    ${AddMultiChatgroupMemberDictionary.reponseResult}    ${AddMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddMultiChatgroupMemberDictionary.statusCode}    ${AddMultiChatgroupMemberDictionary.reponseResult}    ${AddMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddMultiChatgroupMemberDictionary.statusCode}    ${AddMultiChatgroupMemberDictionary.reponseResult}    ${AddMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddMultiChatgroupMemberDictionary.statusCode}    ${AddMultiChatgroupMemberDictionary.reponseResult}    ${AddMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量移除群组成员(/{orgName}/{appName}/chatgroups/{groupId}/users/{userName})
    [Template]    Remove Multi Chatgroup Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteMultiChatgroupMemberDictionary.statusCode}    ${DeleteMultiChatgroupMemberDictionary.reponseResult}    ${DeleteMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteMultiChatgroupMemberDictionary.statusCode}    ${DeleteMultiChatgroupMemberDictionary.reponseResult}    ${DeleteMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteMultiChatgroupMemberDictionary.statusCode}    ${DeleteMultiChatgroupMemberDictionary.reponseResult}    ${DeleteMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteMultiChatgroupMemberDictionary.statusCode}    ${DeleteMultiChatgroupMemberDictionary.reponseResult}    ${DeleteMultiChatgroupMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加群管理员(/{orgName}/{appName}/chatgroups/{groupId}/admin)
    [Template]    Add Chatgroup Admin Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加群管理员-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/admin)
    [Template]    Add Chatgroup Admin With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加群管理员-用户不属于群成员(/{orgName}/{appName}/chatgroups/{groupId}/admin)
    [Template]    Add Not Belong Chatgroup Admin Template
    ${contentType.JSON}    ${Token.orgToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加群管理员-用户不存在(/{orgName}/{appName}/chatgroups/{groupId}/admin)
    [Template]    Add Chatgroup Admin With Inexistent IMUser Template
    ${contentType.JSON}    ${Token.orgToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MemberNotExistChatgroupDictionary.statusCode}    ${MemberNotExistChatgroupDictionary.reponseResult}    ${MemberNotExistChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除群管理员(/{orgName}/{appName}/chatgroups/{groupId}/admin/{adminName})
    [Template]    Remove Chatgroup Admin Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupAdminDictionary.statusCode}    ${ChatgroupAdminDictionary.reponseResult}    ${ChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除群管理员-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/admin/{adminName})
    [Template]    Remove Chatgroup Admin With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除群管理员-用户属于群成员但不属于群管理员(/{orgName}/{appName}/chatgroups/{groupId}/admin/{adminName})
    [Template]    Remove Chatgroup Admin With IMUser Not Admin Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除群管理员-用户不属于群成员但不属于群管理员(/{orgName}/{appName}/chatgroups/{groupId}/admin/{adminName})
    [Template]    Remove Chatgroup Admin With IMUser Not Admin And Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupMemberNotAdminDictionary.statusCode}    ${ChatgroupMemberNotAdminDictionary.reponseResult}    ${ChatgroupMemberNotAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取群管理员(/{orgName}/{appName}/chatgroups/{groupId}/admin)
    [Template]    Get Chatgroup Admin Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupAdminDictionary.statusCode}    ${GetChatgroupAdminDictionary.reponseResult}    ${GetChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupAdminDictionary.statusCode}    ${GetChatgroupAdminDictionary.reponseResult}    ${GetChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupAdminDictionary.statusCode}    ${GetChatgroupAdminDictionary.reponseResult}    ${GetChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupAdminDictionary.statusCode}    ${GetChatgroupAdminDictionary.reponseResult}    ${GetChatgroupAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

转让群组(/{orgName}/{appName}/chatgroups/{groupId})
    [Template]    Transfer Chatgroup Template
    ${contentType.JSON}    ${Token.orgToken}    ${TransferChatgroupDictionary.statusCode}    ${TransferChatgroupDictionary.reponseResult}    ${TransferChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${TransferChatgroupDictionary.statusCode}    ${TransferChatgroupDictionary.reponseResult}    ${TransferChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${TransferChatgroupDictionary.statusCode}    ${TransferChatgroupDictionary.reponseResult}    ${TransferChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${TransferChatgroupDictionary.statusCode}    ${TransferChatgroupDictionary.reponseResult}    ${TransferChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
