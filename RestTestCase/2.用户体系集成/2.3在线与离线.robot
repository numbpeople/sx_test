*** Settings ***
Force Tags        userOnlineAndOffline
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/UserCommon/UserOnlineAndOffline.robot
Resource          ../../Variable_Env.robot
Resource          ../../Result/UserResult/FriendsAndBlacklist_Result.robot
Resource          ../../Result/UserResult/UserManagement_Result.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/UserResult/UserOnlineAndOffline_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
获取IM用户在线状态(/{orgName}/{appName}/users/{userName}/status)
    [Template]    Get User Status Template
    ${contentType.JSON}    ${Token.orgToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SingleUserStatusDictionary.statusCode}    ${SingleUserStatusDictionary.reponseResult}    ${SingleUserStatusDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取不存在的IM用户在线状态(/{orgName}/{appName}/users/{userName}/status)
    [Template]    Get Inexistent User Status Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量获取用户在线状态(/{orgName}/{appName}/users/batch/status)
    [Template]    Get User Batch Status Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取用户离线消息数(/{orgName}/{appName}/users/{userName}/offline_msg_count)---数据是从msync取的，因为rest和msync之间会有数据异步处理，数据会延迟，所以目前是延迟一秒取数据。后续优化
    [Template]    Get User Offline Msg Count Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserOfflineMsgCountDictionary.statusCode}    ${UserOfflineMsgCountDictionary.reponseResult}    ${UserOfflineMsgCountDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserOfflineMsgCountDictionary.statusCode}    ${UserOfflineMsgCountDictionary.reponseResult}    ${UserOfflineMsgCountDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserOfflineMsgCountDictionary.statusCode}    ${UserOfflineMsgCountDictionary.reponseResult}    ${UserOfflineMsgCountDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserOfflineMsgCountDictionary.statusCode}    ${UserOfflineMsgCountDictionary.reponseResult}    ${UserOfflineMsgCountDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：获取某条离线消息状态(/{orgName}/{appName}/users/{userName}/offline_msg_count)
    [Template]    Get User Offline Msg Status Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}        ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserBatchStatusDictionary.statusCode}    ${UserBatchStatusDictionary.reponseResult}    ${UserBatchStatusDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
