*** Settings ***
Force Tags        chatroomMute
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Common/ChatroomCommon/ChatroomMuteCommon.robot
Resource          ../../Result/ChatroomResult/ChatroomMember_Result.robot
Resource          ../../Result/GroupResult/Group_Result.robot
Resource          ../../Result/ChatroomResult/ChatroomMute_Result.robot
Resource          ../../Result/GroupResult/GroupMember_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
添加禁言用户(/{orgName}/{appName}/chatrooms/{chatroomId}/mute)
    [Template]    Add Chatroom Member Mute Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddChatroomMemberMuteDictionary.statusCode}    ${AddChatroomMemberMuteDictionary.reponseResult}    ${AddChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddChatroomMemberMuteDictionary.statusCode}    ${AddChatroomMemberMuteDictionary.reponseResult}    ${AddChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddChatroomMemberMuteDictionary.statusCode}    ${AddChatroomMemberMuteDictionary.reponseResult}    ${AddChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddChatroomMemberMuteDictionary.statusCode}    ${AddChatroomMemberMuteDictionary.reponseResult}    ${AddChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加禁言用户-聊天室ID不存在(/{orgName}/{appName}/chatrooms/{chatroomId}/mute)
    [Template]    Add Chatroom Member Mute With Inexistent ChatroomId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加禁言用户-聊天室成员不存在(/{orgName}/{appName}/chatrooms/{chatroomId}/mute)
    [Template]    Add Chatroom Member Mute With Inexistent Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${MemberNotBelongChatroomDictionary.statusCode}    ${MemberNotBelongChatroomDictionary.reponseResult}    ${MemberNotBelongChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${MemberNotBelongChatroomDictionary.statusCode}    ${MemberNotBelongChatroomDictionary.reponseResult}    ${MemberNotBelongChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${MemberNotBelongChatroomDictionary.statusCode}    ${MemberNotBelongChatroomDictionary.reponseResult}    ${MemberNotBelongChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${MemberNotBelongChatroomDictionary.statusCode}    ${MemberNotBelongChatroomDictionary.reponseResult}    ${MemberNotBelongChatroomDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除禁言用户(/{orgName}/{appName}/chatrooms/{chatroomId}/mute/{userName})
    [Template]    Remove Chatroom Member Mute Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveChatroomMemberMuteDictionary.statusCode}    ${RemoveChatroomMemberMuteDictionary.reponseResult}    ${RemoveChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${RemoveChatroomMemberMuteDictionary.statusCode}    ${RemoveChatroomMemberMuteDictionary.reponseResult}    ${RemoveChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveChatroomMemberMuteDictionary.statusCode}    ${RemoveChatroomMemberMuteDictionary.reponseResult}    ${RemoveChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${RemoveChatroomMemberMuteDictionary.statusCode}    ${RemoveChatroomMemberMuteDictionary.reponseResult}    ${RemoveChatroomMemberMuteDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取禁言用户(/{orgName}/{appName}/chatrooms/{chatroomId}/mute)
    [Template]    Get Chatroom Member Mute List Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomMemberMuteListDictionary.statusCode}    ${GetChatroomMemberMuteListDictionary.reponseResult}    ${GetChatroomMemberMuteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatroomMemberMuteListDictionary.statusCode}    ${GetChatroomMemberMuteListDictionary.reponseResult}    ${GetChatroomMemberMuteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomMemberMuteListDictionary.statusCode}    ${GetChatroomMemberMuteListDictionary.reponseResult}    ${GetChatroomMemberMuteListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatroomMemberMuteListDictionary.statusCode}    ${GetChatroomMemberMuteListDictionary.reponseResult}    ${GetChatroomMemberMuteListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

