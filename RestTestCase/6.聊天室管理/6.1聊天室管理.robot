*** Settings ***
Force Tags        chatroomManagement
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Common/ChatroomCommon/ChatroomCommon.robot
Resource          ../../Result/ChatroomResult/Chatroom_Result.robot
Resource          ../../Result/GroupResult/Group_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
创建一个聊天室(/{orgName}/{appName}/chatrooms)
    [Template]    Create Chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatroomDictionary.statusCode}    ${CreateChatroomDictionary.reponseResult}    ${CreateChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CreateChatroomDictionary.statusCode}    ${CreateChatroomDictionary.reponseResult}    ${CreateChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatroomDictionary.statusCode}    ${CreateChatroomDictionary.reponseResult}    ${CreateChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatroomDictionary.statusCode}    ${CreateChatroomDictionary.reponseResult}    ${CreateChatroomDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个聊天室-聊天室管理员不存在(/{orgName}/{appName}/chatrooms)
    [Template]    Create Chatroom With Inexistent Owner Template
    ${contentType.JSON}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个聊天室-聊天室成员不存在(/{orgName}/{appName}/chatrooms)
    [Template]    Create Chatroom With Inexistent Member Template
    ${contentType.JSON}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GroupMemberNotFoundDictionary.statusCode}    ${GroupMemberNotFoundDictionary.reponseResult}    ${GroupMemberNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个聊天室-聊天室名称字段缺失(/{orgName}/{appName}/chatrooms)
    [Template]    Create Chatroom With Name Filed Discarded Template
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatroomWithNameFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithNameFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithNameFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CreateChatroomWithNameFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithNameFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithNameFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatroomWithNameFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithNameFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithNameFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatroomWithNameFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithNameFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithNameFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个聊天室-聊天室管理员字段缺失(/{orgName}/{appName}/chatrooms)
    [Template]    Create Chatroom With Owner Filed Discarded Template
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithOwnerFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithOwnerFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithOwnerFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.statusCode}    ${CreateChatroomWithOwnerFiledDiscardedDictionary.reponseResult}    ${CreateChatroomWithOwnerFiledDiscardedDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

修改聊天室信息(/{orgName}/{appName}/chatrooms/{chatroomId})
    [Template]    Modify Chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${ModifyChatroomDictionary.statusCode}    ${ModifyChatroomDictionary.reponseResult}    ${ModifyChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ModifyChatroomDictionary.statusCode}    ${ModifyChatroomDictionary.reponseResult}    ${ModifyChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ModifyChatroomDictionary.statusCode}    ${ModifyChatroomDictionary.reponseResult}    ${ModifyChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ModifyChatroomDictionary.statusCode}    ${ModifyChatroomDictionary.reponseResult}    ${ModifyChatroomDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

修改聊天室信息-最大成员数大于当前用户数(/{orgName}/{appName}/chatrooms/{chatroomId})
    [Template]    Modify Chatroom With MaxUser Larger Than Current User Template
    ${contentType.JSON}    ${Token.orgToken}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.statusCode}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.reponseResult}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.statusCode}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.reponseResult}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.statusCode}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.reponseResult}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.statusCode}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary.reponseResult}    ${ModifyChatroomWithMaxUserIsLargerThanCurrentDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

修改聊天室信息-聊天室ID不存在(/{orgName}/{appName}/chatrooms/{chatroomId})
    [Template]    Modify Chatroom With Inexistent ChatroomIdTemplate
    ${contentType.JSON}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ChatgroupIdNotFoundDictionary.statusCode}    ${ChatgroupIdNotFoundDictionary.reponseResult}    ${ChatgroupIdNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #返回值可能描述不正确，grpID不存在？{"error":"resource_not_found","timestamp":1558699941714,"duration":0,"exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"grpID imautotest-5015448462 does not exist!"}

删除聊天室信息(/{orgName}/{appName}/chatrooms/{chatroomId})
    [Template]    Delete Chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteChatroomDictionary.statusCode}    ${DeleteChatroomDictionary.reponseResult}    ${DeleteChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteChatroomDictionary.statusCode}    ${DeleteChatroomDictionary.reponseResult}    ${DeleteChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteChatroomDictionary.statusCode}    ${DeleteChatroomDictionary.reponseResult}    ${DeleteChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteChatroomDictionary.statusCode}    ${DeleteChatroomDictionary.reponseResult}    ${DeleteChatroomDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取聊天室详情(/{orgName}/{appName}/chatrooms/{chatroomId})
    [Template]    Get Specific Chatroom Detail Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetSpecificChatroomDetailDictionary.statusCode}    ${GetSpecificChatroomDetailDictionary.reponseResult}    ${GetSpecificChatroomDetailDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetSpecificChatroomDetailDictionary.statusCode}    ${GetSpecificChatroomDetailDictionary.reponseResult}    ${GetSpecificChatroomDetailDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetSpecificChatroomDetailDictionary.statusCode}    ${GetSpecificChatroomDetailDictionary.reponseResult}    ${GetSpecificChatroomDetailDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetSpecificChatroomDetailDictionary.statusCode}    ${GetSpecificChatroomDetailDictionary.reponseResult}    ${GetSpecificChatroomDetailDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取APP中所有的聊天室(/{orgName}/{appName}/chatrooms)
    [Template]    Get All Chatrooms Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomListDictionary.statusCode}    ${GetChatroomListDictionary.reponseResult}    ${GetChatroomListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetChatroomListDictionary.statusCode}    ${GetChatroomListDictionary.reponseResult}    ${GetChatroomListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomListDictionary.statusCode}    ${GetChatroomListDictionary.reponseResult}    ${GetChatroomListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetChatroomListDictionary.statusCode}    ${GetChatroomListDictionary.reponseResult}    ${GetChatroomListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取用户加入的聊天室(/{orgName}/{appName}/users/{userName}/joined_chatrooms)
    [Template]    Get IMUser Joined Chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetIMUserJoinedChatroomDictionary.statusCode}    ${GetIMUserJoinedChatroomDictionary.reponseResult}    ${GetIMUserJoinedChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetIMUserJoinedChatroomDictionary.statusCode}    ${GetIMUserJoinedChatroomDictionary.reponseResult}    ${GetIMUserJoinedChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetIMUserJoinedChatroomDictionary.statusCode}    ${GetIMUserJoinedChatroomDictionary.reponseResult}    ${GetIMUserJoinedChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetIMUserJoinedChatroomDictionary.statusCode}    ${GetIMUserJoinedChatroomDictionary.reponseResult}    ${GetIMUserJoinedChatroomDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

分页获取聊天室信息
    [Template]     Get Chatroom Detail By Page Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomListDictionary.statusCode}    ${GetChatroomListDictionary.reponseResult}    ${GetChatroomListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomListDictionary.statusCode}    ${GetChatroomListDictionary.reponseResult}    ${GetChatroomListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}

更新聊天室公告
    [Template]    Update Chatroom Announment Template
    ${contentType.JSON}    ${Token.orgToken}    ${ChatroomAnnouncementDictionary.statusCode}    ${ChatroomAnnouncementDictionary.reponseResult}    ${ChatroomAnnouncementDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.orgToken}    ${ChatroomAnnouncementDictionary.statusCode}    ${ChatroomAnnouncementDictionary.reponseResult}    ${ChatroomAnnouncementDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

获取聊天室公告
    [Template]    Get Chatroom Announment Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetChatroomAnnouncementDictionary.statusCode}    ${GetChatroomAnnouncementDictionary.reponseResult}    ${GetChatroomAnnouncementDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetChatroomAnnouncementDictionary.statusCode}    ${EMPTY}    ${EMPTY}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

聊天室静音
    [Template]    Ban Chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${BanChatroomDictionary.statusCode}    ${BanChatroomDictionary.reponseResult}    ${BanChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${BanChatroomDictionary.statusCode}    ${BanChatroomDictionary.reponseResult}    ${BanChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

解除聊天室静音
    [Template]    Allow Chatroom Template
    ${contentType.JSON}    ${Token.orgToken}    ${BanChatroomDictionary.statusCode}    ${BanChatroomDictionary.reponseResult}    ${BanChatroomDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${BanChatroomDictionary.statusCode}    ${BanChatroomDictionary.reponseResult}    ${BanChatroomDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${TokenAuthorizationIsBlankDictionary.statusCode}    ${TokenAuthorizationIsBlankDictionary.reponseResult}    ${TokenAuthorizationIsBlankDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

