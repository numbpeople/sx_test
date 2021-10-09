*** Settings ***
Force Tags        chatgroupWhitelist
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/GroupCommon/GroupWhiteListCommon.robot
Resource          ../../Result/GroupResult/Group_Result.robot
Resource          ../../Result/GroupResult/GroupMember_Result.robot
Resource          ../../Result/GroupResult/ChatgroupBlacklist_Result.robot
Resource          ../../Result/GroupResult/ChatgroupWhiteList_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot
Resource          ../../Result/GroupResult/ChatgroupWhiteList_Result.robot


*** Test Cases ***
获取群组白名单
    [Template]    Get White List Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${GetWhiteListDictionary.statusCode}    ${GetWhiteListDictionary.reponseResult}    ${GetWhiteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetWhiteListDictionary.statusCode}    ${GetWhiteListDictionary.reponseResult}    ${GetWhiteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetWhiteListDictionary.statusCode}    ${GetWhiteListDictionary.reponseResult}    ${GetWhiteListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}

添加白名单（单个）
    [Template]    Add to White List Single Template
    [Documentation]    created by wudi
    ${contentType.JSON}    ${Token.orgToken}    ${AddtoWhiteListDictionary.statusCode}    ${AddtoWhiteListDictionary.reponseResult}    ${AddToWhiteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddToWhiteListDictionary.statusCode}    ${AddToWhiteListDictionary.reponseResult}    ${AddToWhiteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddtoWhiteListDictionary.statusCode}    ${AddtoWhiteListDictionary.reponseResult}    ${AddToWhiteListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}

添加白名单（批量）
    [Template]    Add to White List Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddtoWhiteListDictionary.statusCode}    ${AddtoWhiteListDictionary.reponseResult}    ${AddToWhiteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddToWhiteListDictionary.statusCode}    ${AddToWhiteListDictionary.reponseResult}    ${AddToWhiteListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddtoWhiteListDictionary.statusCode}    ${AddtoWhiteListDictionary.reponseResult}    ${AddToWhiteListDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}



