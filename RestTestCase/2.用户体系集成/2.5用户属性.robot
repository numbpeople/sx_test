*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/UserCommon/UserCommon.robot
Resource          ../../Variable_Env.robot
Resource          ../../Result/UserResult/UserManagement_Result.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot
Resource          ../../Common/UserCommon/UserAttributesCommon.robot
Resource          ../../Result/UserResult/UserAttribute_Result.robot
Test Teardown    Test User Attribute Teardown

*** Test Cases ***
获取属性容量(未设置用户属性)
    [Documentation]    create by shuang

    [Template]    Get Attribute CapacityZero Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity1}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity1}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #不支持usettoken
    #${contentType.JSON}    ${Token.userToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}

获取用户属性-未设置用户属性
    [Documentation]    create by shuang
    [Tags]    usertoken
    [Template]    Get User Attribute Empty Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    ${contentType.JSON}    ${Token.userToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}

批量获取用户属性——未设置用户属性
    [Documentation]    create by shuang
    [Tags]    usertoken
    [Template]    Get More Attribute Empty Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetMoreEmptyUserAttributeDictionary.statusCode}    ${GetMoreEmptyUserAttributeDictionary.reponseResult}    ${GetMoreEmptyUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GetMoreEmptyUserAttributeDictionary.statusCode}    ${GetMoreEmptyUserAttributeDictionary.reponseResult}    ${GetMoreEmptyUserAttributeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetMoreEmptyUserAttributeDictionary.statusCode}    ${GetMoreEmptyUserAttributeDictionary.reponseResult}    ${GetMoreEmptyUserAttributeDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetMoreEmptyUserAttributeDictionary.statusCode}    ${GetMoreEmptyUserAttributeDictionary.reponseResult}    ${GetMoreEmptyUserAttributeDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    ${contentType.JSON}    ${Token.userToken}    ${GetMoreEmptyUserAttributeDictionary.statusCode}    ${GetMoreEmptyUserAttributeDictionary.reponseResult}    ${GetMoreEmptyUserAttributeDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}

获取属性容量(已设置用户属性)
    [Documentation]    create by shuang
    ...    由于目前无法清理用户属性容量导致部分case失败
    [Template]    Get Attribute Capacity Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity1}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity1}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetUserAttributeCapacityDictionary.statusCode}    ${GetUserAttributeCapacityDictionary.reponseResult}    ${GetUserAttributeCapacityDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

设置用户属性
    [Documentation]    create by shuang
    [Tags]
    [Template]    Add User Attribute Template
    ${contentType.urlencoded}    ${Token.orgToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.urlencoded}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.urlencoded}    ${Token.appToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.urlencoded}    ${Token.bestToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #不支持usertoken
    # ${contentType.urlencoded}    ${Token.userToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}

批量获取用户属性——已设置用户属性
    [Documentation]    create by shuang
    [Tags]    usertoken
    [Template]    Get More Attribute Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetMoreUserAttributeDictionary.statusCode}    ${GetMoreUserAttributeDictionary.reponseResult}    ${GetMoreUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GetMoreUserAttributeDictionary.statusCode}    ${GetMoreUserAttributeDictionary.reponseResult}    ${GetMoreUserAttributeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetMoreUserAttributeDictionary.statusCode}    ${GetMoreUserAttributeDictionary.reponseResult}    ${GetMoreUserAttributeDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetMoreUserAttributeDictionary.statusCode}    ${GetMoreUserAttributeDictionary.reponseResult}    ${GetMoreUserAttributeDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    ${contentType.JSON}    ${Token.userToken}    ${GetMoreUserAttributeDictionary.statusCode}    ${GetMoreUserAttributeDictionary.reponseResult}    ${GetMoreUserAttributeDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}

删除用户属性(通过Delete)
    [Documentation]    create by shuang
    [Tags]
    [Template]    Delete User Attribute Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${NoneTokenDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #不支持usertoken
    # ${contentType.JSON}    ${Token.userToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}

删除用户属性(将属性value置为空)
    [Documentation]    create by shuang   
    [Tags]    usertoken
    [Template]    Rmove User Attribute Template
    ${contentType.urlencoded}    ${Token.orgToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.urlencoded}    ${EMPTY}    ${ErrorTokeneDictionary.statusCode}    ${ErrorTokeneDictionary.reponseResult}    ${ErrorTokenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${NoneContentTypeDictionary.statusCode}    ${NoneContentTypeDictionary.reponseResult}    ${NoneContentTypeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.urlencoded}    ${Token.appToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.urlencoded}    ${Token.bestToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #不支持usertoken
    # ${contentType.urlencoded}    ${Token.userToken}    ${DeleteUserAttributeDictionary.statusCode}    ${DeleteUserAttributeDictionary.reponseResult}    ${DeleteUserAttributeDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}

获取用户属性-已设置用户属性
    [Documentation]    create by shuang
    [Tags]    usertoken
    [Template]    Get User Attribute Template
    ${contentType.JSON}    ${Token.orgToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    ${contentType.JSON}    ${Token.userToken}    ${AddUserAttributeDictionary.statusCode}    ${AddUserAttributeDictionary.reponseResult}    ${AddUserAttributeDiffEntity}    ${ModelCaseRunStatus.userToken_ContentType}