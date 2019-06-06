*** Settings ***
Suite Teardown    Delete Temp Specific User For Loop
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/GroupCommon/GroupMuteCommon.robot
Resource          ../../Result/GroupResult/Group_Result.robot
Resource          ../../Result/GroupResult/GroupMute_Result.robot

*** Test Cases ***
添加禁言(/{orgName}/{appName}/chatgroups/{groupId}/mute)
    [Template]    Add Chatgroup User Mute Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupUserMuteDictionary.statusCode}    ${ChatgroupUserMuteDictionary.reponseResult}    ${ChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupUserMuteDictionary.statusCode}    ${ChatgroupUserMuteDictionary.reponseResult}    ${ChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupUserMuteDictionary.statusCode}    ${ChatgroupUserMuteDictionary.reponseResult}    ${ChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupUserMuteDictionary.statusCode}    ${ChatgroupUserMuteDictionary.reponseResult}    ${ChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加禁言-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/mute)
    [Template]    Add Chatgroup User Mute With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加禁言-IM用户不存在(/{orgName}/{appName}/chatgroups/{groupId}/mute)
    [Template]    Add Chatgroup User Mute With Inexistent IMUser Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupMuteUserNotBelongGroupDictionary.statusCode}    ${ChatgroupMuteUserNotBelongGroupDictionary.reponseResult}    ${ChatgroupMuteUserNotBelongGroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupMuteUserNotBelongGroupDictionary.statusCode}    ${ChatgroupMuteUserNotBelongGroupDictionary.reponseResult}    ${ChatgroupMuteUserNotBelongGroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupMuteUserNotBelongGroupDictionary.statusCode}    ${ChatgroupMuteUserNotBelongGroupDictionary.reponseResult}    ${ChatgroupMuteUserNotBelongGroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupMuteUserNotBelongGroupDictionary.statusCode}    ${ChatgroupMuteUserNotBelongGroupDictionary.reponseResult}    ${ChatgroupMuteUserNotBelongGroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除禁言(/{orgName}/{appName}/chatgroups/{groupId}/mute/{userName})
    [Template]    Remove Chatgroup User Mute Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除禁言-群组ID不存在(/{orgName}/{appName}/chatgroups/{groupId}/mute/{userName})
    [Template]    Remove Chatgroup User Mute With Inexistent GroupId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除禁言-IM用户不存在(/{orgName}/{appName}/chatgroups/{groupId}/mute/{userName})
    [Template]    Remove Chatgroup User Mute With Inexistent IMUser Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${RemoveChatgroupUserMuteDictionary.statusCode}    ${RemoveChatgroupUserMuteDictionary.reponseResult}    ${RemoveChatgroupUserMuteDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #如果IM用户不存在，则不应该接口通过，应该返回用户不存在的错误

获取禁言列表(/{orgName}/{appName}/chatgroups/{groupId}/mute/)
    [Template]    Get Chatgroup User Mute List Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatgroupUserMuteListDictionary.statusCode}    ${GetChatgroupUserMuteListDictionary.reponseResult}    ${GetChatgroupUserMuteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatgroupUserMuteListDictionary.statusCode}    ${GetChatgroupUserMuteListDictionary.reponseResult}    ${GetChatgroupUserMuteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatgroupUserMuteListDictionary.statusCode}    ${GetChatgroupUserMuteListDictionary.reponseResult}    ${GetChatgroupUserMuteListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatgroupUserMuteListDictionary.statusCode}    ${GetChatgroupUserMuteListDictionary.reponseResult}    ${GetChatgroupUserMuteListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
