*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../Common/TokenCommon/TokenCommon.robot
Resource          ../Common/UserCommon/UserCommon.robot
Resource          ../Variable_Env.robot
Resource          ../Result/UserResult/UserManagement_Result.robot
Resource          ../Result/BaseResullt.robot

*** Test Cases ***
注册单个已存在的用户(/{orgName}/{appName}/users)
    [Template]    Create Exist User Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    true    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    false    ${ExistUserDictionary.statusCode}    ${ExistUserDictionary.reponseResult}    ${ExistUserDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.RUN}

注册单个新的用户(/{orgName}/{appName}/users)
    [Template]    Create New User Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    true    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserDictionary.statusCode}    ${NewUserDictionary.reponseResult}    ${NewUserDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.RUN}

注册单个用户-用户名为不合法(/{orgName}/{appName}/users)
    [Template]    Create New User With Illegal UserName Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.RUN}

注册单个用户-密码不合法(/{orgName}/{appName}/users)
    [Template]    Create New User With Illegal Password Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.RUN}

注册多个用户(/{orgName}/{appName}/users)
    [Template]    Create New Multi User Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    true    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewMutilUserDictionary.statusCode}    ${NewMutilUserDictionary.reponseResult}    ${NewMutilUserDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.RUN}

注册多个用户-用户名不合法(/{orgName}/{appName}/users)
    [Template]    Create New Multi User With Illegal UserName Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalUserNameDictionary.statusCode}    ${NewUserWithIllegalUserNameDictionary.reponseResult}    ${NewUserWithIllegalUserNameDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.RUN}

注册多个用户-密码不合法(/{orgName}/{appName}/users)
    [Template]    Create New Multi User With Illegal PassWord Template
    ${contentType.JSON}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    true    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    false    ${AppRegistrationNoOpenDictionary.statusCode}    ${AppRegistrationNoOpenDictionary.reponseResult}    ${AppRegistrationNoOpenDiffEntity}    ${RunStatus.NORUN}
    ...    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    false    ${NewUserWithIllegalPassWordDictionary.statusCode}    ${NewUserWithIllegalPassWordDictionary.reponseResult}    ${NewUserWithIllegalPassWordDiffEntity}    ${RunStatus.RUN}
    ...    ${RunStatus.RUN}
