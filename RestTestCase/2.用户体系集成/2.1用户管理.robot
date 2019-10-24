*** Settings ***
Force Tags        userManagement
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

*** Test Cases ***
注册单个已存在的用户(/{orgName}/{appName}/users)
    [Template]    Create Exist User Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    false    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    false    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #该条接口用例会执行不通过，因为token值为空时，开发注册接口调用报错401，预期结果：200请求通过

注册单个用户(/{orgName}/{appName}/users)
    [Template]    Create New User Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    false    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

注册单个用户-用户名为不合法(/{orgName}/{appName}/users)
    [Template]    Create New User With Illegal UserName Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    false    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

注册单个用户-密码不合法(/{orgName}/{appName}/users)
    [Template]    Create New User With Illegal Password Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    false    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

注册多个用户(/{orgName}/{appName}/users)
    [Template]    Create New Multi User Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    false    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #该条接口用例会执行不通过，因为token值为空时，开发注册接口调用报错401，预期结果：200请求通过

注册多个用户-用户名不合法(/{orgName}/{appName}/users)
    [Template]    Create New Multi User With Illegal UserName Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    false    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #该条接口用例会执行不通过，因为token值为空时，开发注册接口调用报错401，预期结果：200请求通过

注册多个用户-密码不合法(/{orgName}/{appName}/users)
    [Template]    Create New Multi User With Illegal PassWord Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    false    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #该条接口用例会执行不通过，因为token值为空时，开发注册接口调用报错401，预期结果：200请求通过

获取单个IM用户(/{orgName}/{appName}/users/{userName})
    [Tags]    singleuser
    [Template]    Get Single User Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetSingleUserDictionary.statusCode}    ${GetSingleUserDictionary.reponseResult}    ${GetSingleUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetSingleUserDictionary.statusCode}    ${GetSingleUserDictionary.reponseResult}    ${GetSingleUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetSingleUserDictionary.statusCode}    ${GetSingleUserDictionary.reponseResult}    ${GetSingleUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetSingleUserDictionary.statusCode}    ${GetSingleUserDictionary.reponseResult}    ${GetSingleUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取单个不存在的IM用户(/{orgName}/{appName}/users/{userName})
    [Template]    Get Single Inexistent User Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量获取用户-不分页方式(/{orgName}/{appName}/users)
    [Template]    Get Multi User With Non-Paged Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

批量获取用户-分页方式(/{orgName}/{appName}/users)
    [Template]    Get Multi User With Paged Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetMultiUserDictionary.statusCode}    ${GetMultiUserDictionary.reponseResult}    ${GetMultiUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

删除单个的IM用户(/{orgName}/{appName}/users/{userName})
    [Template]    Delete Single User Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteSingleUserDictionary.statusCode}    ${DeleteSingleUserDictionary.reponseResult}    ${DeleteSingleUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteSingleUserDictionary.statusCode}    ${DeleteSingleUserDictionary.reponseResult}    ${DeleteSingleUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteSingleUserDictionary.statusCode}    ${DeleteSingleUserDictionary.reponseResult}    ${DeleteSingleUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteSingleUserDictionary.statusCode}    ${DeleteSingleUserDictionary.reponseResult}    ${DeleteSingleUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

删除单个不存在的IM用户(/{orgName}/{appName}/users/{userName})
    [Template]    Delete Single Inexistent User Template
    ${contentType.JSON}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${UserNotFoundDictionary.statusCode}    ${UserNotFoundDictionary.reponseResult}    ${UserNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

暂时不执行：批量删除用户(/{orgName}/{appName}/users)
    [Documentation]    - 发现批量删除接口不能指定用户方式去删除，他是按照创建时间正序去批量删除，所以避免为了造成数据误删除，该用例暂时不执行
    [Template]    Delete Multi User Template
    ${contentType.JSON}    ${Token.orgToken}    ${DeleteMultiUserDictionary.statusCode}    ${DeleteMultiUserDictionary.reponseResult}    ${DeleteMultiUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${DeleteMultiUserNoUnauthorizedDictionary.statusCode}    ${DeleteMultiUserNoUnauthorizedDictionary.reponseResult}    ${DeleteMultiUserNoUnauthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DeleteMultiUserDictionary.statusCode}    ${DeleteMultiUserDictionary.reponseResult}    ${DeleteMultiUserDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${DeleteMultiUserNoUnauthorizedDictionary.statusCode}    ${DeleteMultiUserNoUnauthorizedDictionary.reponseResult}    ${DeleteMultiUserNoUnauthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DeleteMultiUserDictionary.statusCode}    ${DeleteMultiUserDictionary.reponseResult}    ${DeleteMultiUserDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DeleteMultiUserDictionary.statusCode}    ${DeleteMultiUserDictionary.reponseResult}    ${DeleteMultiUserDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #发现批量删除不能指定用户方式去删除，他是按照创建时间正序去批量删除，所以避免为了造成数据误删除，该用例暂时不执行

重置IM用户密码(/{orgName}/{appName}/users/{imUser}/password)
    [Template]    Modify User Password Template
    ${contentType.JSON}    ${Token.orgToken}    ${ModifyUserPasswordDictionary.statusCode}    ${ModifyUserPasswordDictionary.reponseResult}    ${ModifyUserPasswordDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ModifyUserPasswordDictionary.statusCode}    ${ModifyUserPasswordDictionary.reponseResult}    ${ModifyUserPasswordDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ModifyUserPasswordDictionary.statusCode}    ${ModifyUserPasswordDictionary.reponseResult}    ${ModifyUserPasswordDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ModifyUserPasswordDictionary.statusCode}    ${ModifyUserPasswordDictionary.reponseResult}    ${ModifyUserPasswordDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

重置不存在的IM用户密码(/{orgName}/{appName}/users/{imUser}/password)
    [Template]    Modify Inexistent User Password Template
    ${contentType.JSON}    ${Token.orgToken}    ${ModifyUserPasswordEntityNotFoundDictionary.statusCode}    ${ModifyUserPasswordEntityNotFoundDictionary.reponseResult}    ${ModifyUserPasswordEntityNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ModifyUserPasswordEntityNotFoundDictionary.statusCode}    ${ModifyUserPasswordEntityNotFoundDictionary.reponseResult}    ${ModifyUserPasswordEntityNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ModifyUserPasswordEntityNotFoundDictionary.statusCode}    ${ModifyUserPasswordEntityNotFoundDictionary.reponseResult}    ${ModifyUserPasswordEntityNotFoundDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ModifyUserPasswordEntityNotFoundDictionary.statusCode}    ${ModifyUserPasswordEntityNotFoundDictionary.reponseResult}    ${ModifyUserPasswordEntityNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

修改用户昵称(/{orgName}/{appName}/users/{userName})
    [Template]    Modify User Nickname Template
    ${contentType.JSON}    ${Token.orgToken}    ${ModifyUserNicknameDictionary.statusCode}    ${ModifyUserNicknameDictionary.reponseResult}    ${ModifyUserNicknameDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ModifyUserNicknameDictionary.statusCode}    ${ModifyUserNicknameDictionary.reponseResult}    ${ModifyUserNicknameDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ModifyUserNicknameDictionary.statusCode}    ${ModifyUserNicknameDictionary.reponseResult}    ${ModifyUserNicknameDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ModifyUserNicknameDictionary.statusCode}    ${ModifyUserNicknameDictionary.reponseResult}    ${ModifyUserNicknameDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

设置推送消息展示方式(/{orgName}/{appName}/users/{userName})
    [Template]    Modify User Notification_Display_Style Template
    ${contentType.JSON}    ${Token.orgToken}    ${ModifyUserNotificationDisplayStyleDictionary.statusCode}    ${ModifyUserNotificationDisplayStyleDictionary.reponseResult}    ${ModifyUserNotificationDisplayStyleDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ModifyUserNotificationDisplayStyleDictionary.statusCode}    ${ModifyUserNotificationDisplayStyleDictionary.reponseResult}    ${ModifyUserNotificationDisplayStyleDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ModifyUserNotificationDisplayStyleDictionary.statusCode}    ${ModifyUserNotificationDisplayStyleDictionary.reponseResult}    ${ModifyUserNotificationDisplayStyleDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ModifyUserNotificationDisplayStyleDictionary.statusCode}    ${ModifyUserNotificationDisplayStyleDictionary.reponseResult}    ${ModifyUserNotificationDisplayStyleDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

设置免打扰(/{orgName}/{appName}/users/{userName})
    [Template]    Modify User Notification_No_Disturbing Template
    ${contentType.JSON}    ${Token.orgToken}    ${ModifyUserNotificationNoDisturbingDictionary.statusCode}    ${ModifyUserNotificationNoDisturbingDictionary.reponseResult}    ${ModifyUserNotificationNoDisturbingDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${ModifyUserNotificationNoDisturbingDictionary.statusCode}    ${ModifyUserNotificationNoDisturbingDictionary.reponseResult}    ${ModifyUserNotificationNoDisturbingDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${ModifyUserNotificationNoDisturbingDictionary.statusCode}    ${ModifyUserNotificationNoDisturbingDictionary.reponseResult}    ${ModifyUserNotificationNoDisturbingDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${ModifyUserNotificationNoDisturbingDictionary.statusCode}    ${ModifyUserNotificationNoDisturbingDictionary.reponseResult}    ${ModifyUserNotificationNoDisturbingDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
