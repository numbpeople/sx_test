*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${ExistUser}      {"error":"duplicate_unique_property_exists","timestamp":1554888970981,"duration":0,"exception":"DuplicateUniquePropertyExistsException","error_description":"Application %s Entity user requires that property named username be unique, value of leoli exists"}
${ExistUserDiffEntity}    {"error":"duplicate_unique_property_exists"}    # 结果字段中去除了error_description字段比较，因为值中Application后面跟着的应用ID，返回值不固定，一会有值，一会null

${NewUser}        {"action":"post","application":"e2a6bac0-4d54-11e9-b80b-4b5efbf305f3","path":"/users","uri":"https://a1.easemob.com/ljp/8269772251/users","entities":[{"uuid":"67320040-5b67-11e9-8b90-1762aeba16b5","type":"user","created":1554883528260,"modified":1554883528260,"username":"123","activated":true,"nickname":"123"}],"timestamp":1554883528269,"duration":0,"organization":"ljp","applicationName":"8269772251"}
${NewUserDiffEntity}    {"action":"post","path":"/users","entities":[{"type":"user","username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${NewUserWithIllegalUserName}    {"error":"illegal_argument","exception":"java.lang.IllegalArgumentException","timestamp":1556539417934,"duration":0,"error_description":"username [%s] is not legal"}
${NewUserWithIllegalUserNameDiffEntity}    {"error":"illegal_argument","error_description":"username [%s] is not legal"}

${NewUserWithIllegalPassWord}    {"error":"illegal_argument","exception":"java.lang.IllegalArgumentException","timestamp":1556540353855,"duration":0,"error_description":"password or pin must provided"}
${NewUserWithIllegalPassWordDiffEntity}    {"error":"illegal_argument","error_description":"password or pin must provided"}

${NewMutilUser}    {"path":"/users","uri":"https://a1-hsb.easemob.com/easemob-demo/easeim/users","timestamp":1634649328314,"organization":"easemob-demo","application":"e019c634-e3f2-4e9c-9393-463657845f4f","entities":[{"uuid":"a0f92c00-30de-11ec-a3fa-eb428ad19deb","type":"user","created":1634649328325,"modified":1634649328325,"username":"123ddda1231","activated":true},{"uuid":"a0f9ef50-30de-11ec-b878-990b6a4e545d","type":"user","created":1634649328331,"modified":1634649328331,"username":"adfa11s123123sssdad","activated":true}],"action":"post","data":[],"duration":24,"applicationName":"easeim"}
${NewMutilUserDiffEntity}    {"action":"post","path":"/users","entities":[{"type":"user","username":"%s","activated":true},{"type":"user","username":"%s","activated":true}],"organization":"%s","applicationName":"%s"}

${GetSingleUser}    {"action":"get","path":"/users","uri":"http://a1-mesos.easemob.com/ljp/8776262879/users/1","entities":[{"uuid":"f1068e00-6a74-11e9-89ab-dd97cc4643af","type":"user","created":1556538610400,"modified":1556538610400,"username":"1","activated":true,"nickname":"1"}],"timestamp":1556599588754,"duration":7,"count":1}
${GetSingleUserDiffEntity}    {"action":"get","path":"/users","entities":[{"uuid":"%s","type":"user","created":%s,"modified":%s,"username":"%s","activated":true,"nickname":"%s"}],"count":1}

${UserNotFound}    {"error":"service_resource_not_found","timestamp":1556610036249,"duration":0,"exception":"UserNotFoundException","error_description":"Service resource not found"}
${UserNotFoundDiffEntity}    {"error":"service_resource_not_found","error_description":"Service resource not found"}

${UserNotFoundForBestToken}    {"error":"service_resource_not_found","exception":"UserNotFoundException","timestamp":1560836341107,"duration":0,"error_description":"Service resource not found"}
${UserNotFoundForBestTokenDiffEntity}    {"error":"service_resource_not_found","error_description":"Service resource not found"}

${SingleUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556606949667,"duration":1,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:get:0c6def40-6b14-11e9-a989-2f26c9bbeefa:/users/0e4dd2d0-6b14-11e9-b7e6-7925d1ca8636]"}
${SingleUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","error_description":"Subject does not have permission [applications:get:%s:/users/%s]"}

${GetMultiUser}    ${EMPTY}
${GetMultiUserDiffEntity}    ${EMPTY}

${MultiUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556606949667,"duration":1,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:get:0c6def40-6b14-11e9-a989-2f26c9bbeefa:/users]"}
${MultiUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","error_description":"Subject does not have permission [applications:get:%s:/users]"}

${DeleteSingleUser}    {"action":"delete","application":"1b708470-abc3-11e6-bfcc-e912e96b64fc","path":"/users","uri":"https://a1.easemob.com/talent-leoli123/local/users","entities":[{"uuid":"657cdf00-6e67-11e9-b9a0-33643467a898","type":"user","created":1556972597488,"modified":1556972597488,"username":"1","activated":true,"nickname":"1"}],"timestamp":1556972603505,"duration":117,"organization":"talent-leoli123","applicationName":"local"}
${DeleteSingleUserDiffEntity}    {"action":"delete","path":"/users","entities":[{"uuid":"%s","type":"user","created":%s,"username":"%s","activated":false,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${DeleteSingleUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556973625550,"duration":0,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:delete:c8620800-6e69-11e9-bbe5-1fd8dd782a1a:/users/ca2e8aa0-6e69-11e9-83b1-f73c042be086]"}
${DeleteSingleUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","error_description":"Subject does not have permission [applications:delete:%s:/users/%s]"}

${DeleteMultiUser}    {"action":"delete","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","params":{"limit":["2"]},"path":"/users","uri":"https://a1.easemob.com/talent-leoli123/test/users","entities":[{"uuid":"a96d18d0-462e-11e9-8fa0-c1bcb81eade6","type":"user","created":1552550183645,"modified":1552550183645,"username":"talent_leoli1","activated":true,"nickname":"talent_leoli1talent_leoli1talent"},{"uuid":"f05fa670-6ee4-11e9-abd9-dbf9cb5774f6","type":"user","created":1557026517591,"modified":1557026517591,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557026572737,"duration":166,"organization":"talent-leoli123","applicationName":"test"}
${DeleteMultiUserDiffEntity}    {"action":"delete","application":"%s","path":"/users","entities":[{"type":"user","activated":true},{"type":"user","activated":true}],"organization":"%s","applicationName":"%s"}

${DeleteMultiUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556606949667,"duration":1,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:delete:0c6def40-6b14-11e9-a989-2f26c9bbeefa:/users]"}
${DeleteMultiUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","error_description":"Subject does not have permission [applications:delete:%s:/users]"}

${ModifyUserPassword}    {"action":"set user password","timestamp":1542595598924,"duration":8}
${ModifyUserPasswordDiffEntity}    {"action":"set user password"}

${ModifyUserPasswordEntityNotFound}    {"error":"entity_not_found","timestamp":1557054005153,"duration":0,"exception":"EntityNotFoundException","error_description":"User null not found"}
${ModifyUserPasswordEntityNotFoundDiffEntity}    {"error":"entity_not_found","error_description":"User null not found"}

${ModifyUserPasswordEntityNotFoundForBestToken}    {"error":"entity_not_found","exception":"EntityNotFoundException","timestamp":1560836357021,"duration":0,"error_description":"User null not found"}
${ModifyUserPasswordEntityNotFoundForBestTokenDiffEntity}    {"error":"entity_not_found","error_description":"User null not found"}

${ModifyUserNickname}    {"action":"put","application":"44d9dae0-86c8-11e9-a1c1-c1a0888414e0","path":"/users","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-6880214993/users","entities":[{"uuid":"4582c510-86c8-11e9-a8c0-8363df179a77","type":"user","created":1559653032928,"modified":1559653033139,"username":"imautotest-8711724859","activated":true,"nickname":"change-imautotest-5017770175"}],"timestamp":1559653033134,"duration":24,"organization":"1104190221201050","applicationName":"imautotest-6880214993"}
${ModifyUserNicknameDiffEntity}    {"action":"put","application":"%s","entities":[{"uuid":"%s","type":"user","username":"%s","activated":%s,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${ModifyUserNotificationDisplayStyle}    {"action":"put","application":"52ae7eb0-8758-11e9-bb94-6907c2f8dbd7","path":"/users","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-1669166360/users","entities":[{"uuid":"5356f3ba-8758-11e9-839f-85b730f3fc3b","type":"user","created":1559714903659,"modified":1559714903873,"username":"imautotest-2585046663","activated":true,"notification_display_style":1,"nickname":"imautotest-2585046663"}],"timestamp":1559714903870,"duration":8,"organization":"1104190221201050","applicationName":"imautotest-1669166360"}
${ModifyUserNotificationDisplayStyleDiffEntity}    {"action":"put","application":"%s","entities":[{"uuid":"%s","type":"user","username":"%s","activated":%s,"notification_display_style":%s,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${ModifyUserNotificationNoDisturbing}    {"action":"put","application":"e5443220-8761-11e9-b5f2-f36e8b094562","path":"/users","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5333981490/users","entities":[{"uuid":"e695915a-8761-11e9-89b7-276fb1f94a31","type":"user","created":1559719016165,"modified":1559719016634,"username":"imautotest-3003281465","activated":true,"notification_no_disturbing":true,"notification_no_disturbing_start":1,"notification_no_disturbing_end":3,"nickname":"imautotest-3003281465"}],"timestamp":1559719016630,"duration":6,"organization":"1104190221201050","applicationName":"imautotest-5333981490"}
${ModifyUserNotificationNoDisturbingDiffEntity}    {"action":"put","application":"%s","entities":[{"uuid":"%s","type":"user","username":"%s","activated":%s,"notification_no_disturbing":%s,"notification_no_disturbing_start":%s,"notification_no_disturbing_end":%s,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${GetUserChannles}    {"path":"/users/adfa1123/user_channels","uri":"https://a1-hsb.easemob.com/easemob-demo/easeim/users/adfa1123/user_channels","timestamp":1635849856968,"organization":"easemob-demo","application":"e019c634-e3f2-4e9c-9393-463657845f4f","entities":[],"action":"get","data":{"channel_infos":[]},"duration":0,"applicationName":"easeim"}
${GetUserChannlesDiffEntity}    {"path":"/users/%s/user_channels","organization":"%s","application":"%s","entities":[],"action":"get","data":{"channel_infos":[]},"applicationName":"%s"}

&{GetUserChannlesDictionary}    statusCode=200    reponseResult=${GetUserChannles}
&{ExistUserDictionary}    statusCode=400    reponseResult=${ExistUser}
&{NewUserDictionary}    statusCode=200    reponseResult=${NewUser}
&{NewUserWithIllegalUserNameDictionary}    statusCode=400    reponseResult=${NewUserWithIllegalUserName}
&{NewUserWithIllegalPassWordDictionary}    statusCode=400    reponseResult=${NewUserWithIllegalPassWord}
&{NewMutilUserDictionary}    statusCode=200    reponseResult=${NewMutilUser}
&{GetSingleUserDictionary}    statusCode=200    reponseResult=${GetSingleUser}
&{UserNotFoundDictionary}    statusCode=404    reponseResult=${UserNotFound}
&{UserNotFoundForBestTokenDictionary}    statusCode=404    reponseResult=${UserNotFoundForBestToken}
&{GetMultiUserDictionary}    statusCode=200    reponseResult=${GetMultiUser}
&{SingleUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${SingleUserNoUnauthorized}
&{MultiUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${MultiUserNoUnauthorized}
&{DeleteSingleUserDictionary}    statusCode=200    reponseResult=${DeleteSingleUser}
&{DeleteSingleUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${DeleteSingleUserNoUnauthorized}
&{DeleteMultiUserDictionary}    statusCode=200    reponseResult=${DeleteMultiUser}
&{DeleteMultiUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${DeleteMultiUserNoUnauthorized}
&{ModifyUserPasswordDictionary}    statusCode=200    reponseResult=${ModifyUserPassword}
&{ModifyUserPasswordEntityNotFoundDictionary}    statusCode=404    reponseResult=${ModifyUserPasswordEntityNotFound}
&{ModifyUserPasswordEntityNotFoundForBestTokenDictionary}    statusCode=404    reponseResult=${ModifyUserPasswordEntityNotFoundForBestToken}
&{ModifyUserNicknameDictionary}    statusCode=200    reponseResult=${ModifyUserNickname}
&{ModifyUserNotificationDisplayStyleDictionary}    statusCode=200    reponseResult=${ModifyUserNotificationDisplayStyle}
&{ModifyUserNotificationNoDisturbingDictionary}    statusCode=200    reponseResult=${ModifyUserNotificationNoDisturbing}
