*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${ExistUser}      {"error":"duplicate_unique_property_exists","timestamp":1554888970981,"duration":0,"exception":"org.apache.usergrid.persistence.exceptions.DuplicateUniquePropertyExistsException","error_description":"Application %s Entity user requires that property named username be unique, value of leoli exists"}
${ExistUserDiffEntity}    {"error":"duplicate_unique_property_exists","exception":"org.apache.usergrid.persistence.exceptions.DuplicateUniquePropertyExistsException"}    # 结果字段中去除了error_description字段比较，因为值中Application后面跟着的应用ID，返回值不固定，一会有值，一会null
${NewUser}        {"action":"post","application":"e2a6bac0-4d54-11e9-b80b-4b5efbf305f3","path":"/users","uri":"https://a1.easemob.com/ljp/8269772251/users","entities":[{"uuid":"67320040-5b67-11e9-8b90-1762aeba16b5","type":"user","created":1554883528260,"modified":1554883528260,"username":"123","activated":true,"nickname":"123"}],"timestamp":1554883528269,"duration":0,"organization":"ljp","applicationName":"8269772251"}
${NewUserDiffEntity}    {"action":"post","path":"/users","entities":[{"type":"user","username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}
${NewUserWithIllegalUserName}    {"error":"illegal_argument","exception":"java.lang.IllegalArgumentException","timestamp":1556539417934,"duration":0,"error_description":"username [%s] is not legal"}
${NewUserWithIllegalUserNameDiffEntity}    {"error":"illegal_argument","exception":"java.lang.IllegalArgumentException","error_description":"username [%s] is not legal"}
${NewUserWithIllegalPassWord}    {"error":"illegal_argument","exception":"java.lang.IllegalArgumentException","timestamp":1556540353855,"duration":0,"error_description":"password or pin must provided"}
${NewUserWithIllegalPassWordDiffEntity}    {"error":"illegal_argument","exception":"java.lang.IllegalArgumentException","error_description":"password or pin must provided"}
${NewMutilUser}    {"action":"post","application":"0fe29850-6a7f-11e9-aee8-6dfcb7778d07","path":"/users","uri":"http://a1-hsb.easemob.com/1104190221201050/1090504196/users","entities":[{"uuid":"102805ca-6a7f-11e9-b3c7-65df579a605d","type":"user","created":1556542957596,"modified":1556542957596,"username":"7755305405","activated":true},{"uuid":"102aebfa-6a7f-11e9-a675-2b7869cd643c","type":"user","created":1556542957615,"modified":1556542957615,"username":"2260246304","activated":true}],"timestamp":1556542957596,"duration":51,"organization":"1104190221201050","applicationName":"1090504196"}
${NewMutilUserDiffEntity}    {"action":"post","path":"/users","entities":[{"type":"user","username":"%s","activated":true},{"type":"user","username":"%s","activated":true}],"organization":"%s","applicationName":"%s"}
${GetSingleUser}    {"action":"get","path":"/users","uri":"http://a1-mesos.easemob.com/ljp/8776262879/users/1","entities":[{"uuid":"f1068e00-6a74-11e9-89ab-dd97cc4643af","type":"user","created":1556538610400,"modified":1556538610400,"username":"1","activated":true,"nickname":"1"}],"timestamp":1556599588754,"duration":7,"count":1}
${GetSingleUserDiffEntity}    {"action":"get","path":"/users","entities":[{"uuid":"%s","type":"user","created":%s,"modified":%s,"username":"%s","activated":true,"nickname":"%s"}],"count":1}
${UserNotFound}    {"error":"service_resource_not_found","timestamp":1556610036249,"duration":0,"exception":"org.apache.usergrid.services.exceptions.ServiceResourceNotFoundException","error_description":"Service resource not found"}
${UserNotFoundDiffEntity}    {"error":"service_resource_not_found","exception":"org.apache.usergrid.services.exceptions.ServiceResourceNotFoundException","error_description":"Service resource not found"}
${SingleUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556606949667,"duration":1,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:get:0c6def40-6b14-11e9-a989-2f26c9bbeefa:/users/0e4dd2d0-6b14-11e9-b7e6-7925d1ca8636]"}
${SingleUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:get:%s:/users/%s]"}
${GetMultiUser}    {"action":"get","path":"/users","entities":[{"uuid":"f1068e00-6a74-11e9-89ab-dd97cc4643af","type":"user","created":1556538610400,"modified":1556538610400,"username":"1","activated":true,"nickname":"1"}],"timestamp":1556944517892,"duration":14,"count":3}
${GetMultiUserDiffEntity}    ${EMPTY}
${MultiUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556606949667,"duration":1,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:get:0c6def40-6b14-11e9-a989-2f26c9bbeefa:/users]"}
${MultiUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:get:%s:/users]"}
${DeleteSingleUser}    {"action":"delete","application":"1b708470-abc3-11e6-bfcc-e912e96b64fc","path":"/users","uri":"https://a1.easemob.com/talent-leoli123/local/users","entities":[{"uuid":"657cdf00-6e67-11e9-b9a0-33643467a898","type":"user","created":1556972597488,"modified":1556972597488,"username":"1","activated":true,"nickname":"1"}],"timestamp":1556972603505,"duration":117,"organization":"talent-leoli123","applicationName":"local"}
${DeleteSingleUserDiffEntity}    {"action":"delete","path":"/users","entities":[{"uuid":"%s","type":"user","created":%s,"modified":%s,"username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}
${DeleteSingleUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556973625550,"duration":0,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:delete:c8620800-6e69-11e9-bbe5-1fd8dd782a1a:/users/ca2e8aa0-6e69-11e9-83b1-f73c042be086]"}
${DeleteSingleUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:delete:%s:/users/%s]"}
${DeleteMultiUser}    {"action":"delete","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","params":{"limit":["2"]},"path":"/users","uri":"https://a1.easemob.com/talent-leoli123/test/users","entities":[{"uuid":"a96d18d0-462e-11e9-8fa0-c1bcb81eade6","type":"user","created":1552550183645,"modified":1552550183645,"username":"talent_leoli1","activated":true,"nickname":"talent_leoli1talent_leoli1talent"},{"uuid":"f05fa670-6ee4-11e9-abd9-dbf9cb5774f6","type":"user","created":1557026517591,"modified":1557026517591,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557026572737,"duration":166,"organization":"talent-leoli123","applicationName":"test"}
${DeleteMultiUserDiffEntity}    {"action":"delete","application":"%s","path":"/users","entities":[{"type":"user","activated":true},{"type":"user","activated":true}],"organization":"%s","applicationName":"%s"}
${DeleteMultiUserNoUnauthorized}    {"error":"unauthorized","timestamp":1556606949667,"duration":1,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:delete:0c6def40-6b14-11e9-a989-2f26c9bbeefa:/users]"}
${DeleteMultiUserNoUnauthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:delete:%s:/users]"}
${ModifyUserPassword}    {"action":"set user password","timestamp":1542595598924,"duration":8}
${ModifyUserPasswordDiffEntity}    {"action":"set user password"}
${ModifyUserPasswordEntityNotFound}    {"error":"entity_not_found","timestamp":1557054005153,"duration":0,"exception":"org.apache.usergrid.persistence.exceptions.EntityNotFoundException","error_description":"User null not found"}
${ModifyUserPasswordEntityNotFoundDiffEntity}    {"error":"entity_not_found","exception":"org.apache.usergrid.persistence.exceptions.EntityNotFoundException","error_description":"User null not found"}
&{ExistUserDictionary}    statusCode=400    reponseResult=${ExistUser}
&{NewUserDictionary}    statusCode=200    reponseResult=${NewUser}
&{NewUserWithIllegalUserNameDictionary}    statusCode=400    reponseResult=${NewUserWithIllegalUserName}
&{NewUserWithIllegalPassWordDictionary}    statusCode=400    reponseResult=${NewUserWithIllegalPassWord}
&{NewMutilUserDictionary}    statusCode=200    reponseResult=${NewMutilUser}
&{GetSingleUserDictionary}    statusCode=200    reponseResult=${GetSingleUser}
&{UserNotFoundDictionary}    statusCode=404    reponseResult=${UserNotFound}
&{GetMultiUserDictionary}    statusCode=200    reponseResult=${GetMultiUser}
&{SingleUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${SingleUserNoUnauthorized}
&{MultiUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${MultiUserNoUnauthorized}
&{DeleteSingleUserDictionary}    statusCode=200    reponseResult=${DeleteSingleUser}
&{DeleteSingleUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${DeleteSingleUserNoUnauthorized}
&{DeleteMultiUserDictionary}    statusCode=200    reponseResult=${DeleteMultiUser}
&{DeleteMultiUserNoUnauthorizedDictionary}    statusCode=401    reponseResult=${DeleteMultiUserNoUnauthorized}
&{ModifyUserPasswordDictionary}    statusCode=200    reponseResult=${ModifyUserPassword}
&{ModifyUserPasswordEntityNotFoundDictionary}    statusCode=404    reponseResult=${ModifyUserPasswordEntityNotFound}
