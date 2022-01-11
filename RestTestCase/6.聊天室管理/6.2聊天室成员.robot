*** Settings ***
Force Tags        chatroomMember
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Common/ChatroomCommon/ChatroomMemberCommon.robot
Resource          ../../Result/ChatroomResult/ChatroomMember_Result.robot
Resource          ../../Result/GroupResult/Group_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
添加单个聊天室成员(/{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName})
    [Template]    Add Single Chatroom Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加单个聊天室成员-聊天室ID不存在(/{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName})
    [Template]    Add Single Chatroom Member With Inexistent ChatroomId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加单个聊天室成员-聊天室成员不存在(/{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName})
    [Template]    Add Single Chatroom Member With Inexistent Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

删除单个聊天室成员(/{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName})
    [Template]    Delete Single Chatroom Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatroomMemberDictionary.statusCode}    ${ChatroomMemberDictionary.reponseResult}    ${ChatroomMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

分页获取聊天室成员(/{orgName}/{appName}/chatrooms/{chatroomId}/users)
    [Template]    Get Chatroom Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomMemberDictionary.statusCode}    ${GetChatroomMemberDictionary.reponseResult}    ${GetChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatroomMemberDictionary.statusCode}    ${GetChatroomMemberDictionary.reponseResult}    ${GetChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomMemberDictionary.statusCode}    ${GetChatroomMemberDictionary.reponseResult}    ${GetChatroomMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatroomMemberDictionary.statusCode}    ${GetChatroomMemberDictionary.reponseResult}    ${GetChatroomMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量添加聊天室成员(/{orgName}/{appName}/chatrooms/{chatroomId}/users)
    [Template]    Add Multi Chatroom Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddMultiChatroomMemberDictionary.statusCode}    ${AddMultiChatroomMemberDictionary.reponseResult}    ${AddMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddMultiChatroomMemberDictionary.statusCode}    ${AddMultiChatroomMemberDictionary.reponseResult}    ${AddMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddMultiChatroomMemberDictionary.statusCode}    ${AddMultiChatroomMemberDictionary.reponseResult}    ${AddMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddMultiChatroomMemberDictionary.statusCode}    ${AddMultiChatroomMemberDictionary.reponseResult}    ${AddMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量删除聊天室成员(/{orgName}/{appName}/chatrooms/{chatroomId}/users/{userName})
    [Template]    Delete Multi Chatroom Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteMultiChatroomMemberDictionary.statusCode}    ${DeleteMultiChatroomMemberDictionary.reponseResult}    ${DeleteMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteMultiChatroomMemberDictionary.statusCode}    ${DeleteMultiChatroomMemberDictionary.reponseResult}    ${DeleteMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteMultiChatroomMemberDictionary.statusCode}    ${DeleteMultiChatroomMemberDictionary.reponseResult}    ${DeleteMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteMultiChatroomMemberDictionary.statusCode}    ${DeleteMultiChatroomMemberDictionary.reponseResult}    ${DeleteMultiChatroomMemberDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加聊天室管理员(/{orgName}/{appName}/chatrooms/{chatroomId}/admin)
    [Template]    Add Chatroom Admin Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加聊天室管理员-聊天室ID不存在(/{orgName}/{appName}/chatrooms/{chatroomId}/admin)
    [Template]    Add Chatroom Admin With Inexistent ChatroomId Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加聊天室管理员-聊天室成员不存在(/{orgName}/{appName}/chatrooms/{chatroomId}/admin)
    [Template]    Add Chatroom Admin With Inexistent Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

移除聊天室管理员(/{orgName}/{appName}/chatrooms/{chatroomId}/admin/{userName})
    [Template]    Remove Chatroom Admin Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatroomAdminDictionary.statusCode}    ${ChatroomAdminDictionary.reponseResult}    ${ChatroomAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取聊天室管理员列表(/{orgName}/{appName}/chatrooms/{chatroomId}/admin)
    [Template]    Get Chatroom Admin List Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomAdminListDictionary.statusCode}    ${GetChatroomAdminListDictionary.reponseResult}    ${GetChatroomAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatroomAdminListDictionary.statusCode}    ${GetChatroomAdminListDictionary.reponseResult}    ${GetChatroomAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomAdminListDictionary.statusCode}    ${GetChatroomAdminListDictionary.reponseResult}    ${GetChatroomAdminListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatroomAdminListDictionary.statusCode}    ${GetChatroomAdminListDictionary.reponseResult}    ${GetChatroomAdminListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

屏蔽聊天室
    [Template]    Shield Chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${ShieldChatroomDictionary.statusCode}    ${ShieldChatroomDictionary.reponseResult}    ${ShieldChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ShieldChatroomDictionary.statusCode}    ${ShieldChatroomDictionary.reponseResult}    ${ShieldChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}

分页获取聊天室超级管理员列表-未设置超级管理员
    [Documentation]    create by shuang
    [Template]    Get Chatroom SuperAdminZero Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomZeroSuperAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomZeroSuperAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomZeroSuperAdminListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomZeroSuperAdminListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

分页获取聊天室超级管理员列表-已添加超级管理员
    [Documentation]    create by shuang
    [Template]    Get Chatroom SuperAdmin Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomSuperAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomSuperAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomSuperAdminListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatroomSuperAdminDictionary.statusCode}    ${GetChatroomSuperAdminDictionary.reponseResult}    ${GetChatroomSuperAdminListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

添加超级管理员
    [Documentation]    create by shuang
    [Template]    Add Chatroom SuperAdmin Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatroomSuperAdminDictionary.statusCode}    ${ChatroomSuperAdminDictionary.reponseResult}    ${ChatroomSuperAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatroomSuperAdminDictionary.statusCode}    ${ChatroomSuperAdminDictionary.reponseResult}    ${ChatroomSuperAdminDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatroomSuperAdminDictionary.statusCode}    ${ChatroomSuperAdminDictionary.reponseResult}    ${ChatroomSuperAdminDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatroomSuperAdminDictionary.statusCode}    ${ChatroomSuperAdminDictionary.reponseResult}    ${ChatroomSuperAdminDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
移除超级管理员
    [Documentation]    create by shuang
    [Template]    Remove Chatroom SuperAdmin Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveChatRoomsSuperAdminDictionary.statusCode}    ${RemoveChatRoomsSuperAdminDictionary.reponseResult}    ${RemoveChatRoomsSuperAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${RemoveChatRoomsSuperAdminDictionary.statusCode}    ${RemoveChatRoomsSuperAdminDictionary.reponseResult}    ${RemoveChatRoomsSuperAdminListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveChatRoomsSuperAdminDictionary.statusCode}    ${RemoveChatRoomsSuperAdminDictionary.reponseResult}    ${RemoveChatRoomsSuperAdminListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${RemoveChatRoomsSuperAdminDictionary.statusCode}    ${RemoveChatRoomsSuperAdminDictionary.reponseResult}    ${RemoveChatRoomsSuperAdminListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取聊天室屏蔽
    [Documentation]    create by wudi
    [Template]    Get chatroom shield Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomShieldDictionary.statusCode}    ${GetChatroomShieldDictionary.reponseResult}    ${GetChatroomShieldDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomShieldDictionary.statusCode}    ${GetChatroomShieldDictionary.reponseResult}    ${GetChatroomShieldDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

解除聊天室屏蔽
    [Documentation]    create by wudi
    [Template]    Unshield chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${UnShieldChatroomDictionary.statusCode}    ${UnShieldChatroomDictionary.reponseResult}    ${UnShieldChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UnShieldChatroomDictionary.statusCode}    ${UnShieldChatroomDictionary.reponseResult}    ${UnShieldChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

添加单个用户至聊天室黑名单
    [Documentation]    create by wudi
    [Template]    Add Single User Chatroom Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${addSingleBlackDictionary.statusCode}    ${addSingleBlackDictionary.reponseResult}    ${addSingleBlackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${addSingleBlackDictionary.statusCode}    ${addSingleBlackDictionary.reponseResult}    ${addSingleBlackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

添加多个用户至聊天室黑名单
    [Documentation]    create by wudi
    [Template]    Add Multi User Chatgroup Blacklist Template
    ${contentType.JSON}    ${Token.orgToken}    ${addMultiBlackDictionary.statusCode}    ${addMultiBlackDictionary.reponseResult}    ${addMultiBlackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${addMultiBlackDictionary.statusCode}    ${addMultiBlackDictionary.reponseResult}    ${addMultiBlackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

获取聊天室黑名单列表
    [Documentation]    create by wudi
    [Template]    Get Chatroom BlackList Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomBlackDictionary.statusCode}    ${GetChatroomBlackDictionary.reponseResult}    ${GetChatroomBlackDiffentity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomBlackDictionary.statusCode}    ${GetChatroomBlackDictionary.reponseResult}    ${GetChatroomBlackDiffentity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

从聊天室黑名单移除单个用户
    [Documentation]    create by wudi
    [Template]    Remove Chatroom BlackList Template
    ${contentType.JSON}    ${Token.orgToken}    ${RemoveChatroomBlackDictionary.statusCode}    ${RemoveChatroomBlackDictionary.reponseResult}    ${RemoveChatroomBlackDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${RemoveChatroomBlackDictionary.statusCode}    ${RemoveChatroomBlackDictionary.reponseResult}    ${RemoveChatroomBlackDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}



