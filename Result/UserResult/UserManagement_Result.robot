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
&{ExistUserDictionary}    statusCode=400    reponseResult=${ExistUser}
&{NewUserDictionary}    statusCode=200    reponseResult=${NewUser}
&{NewUserWithIllegalUserNameDictionary}    statusCode=400    reponseResult=${NewUserWithIllegalUserName}
&{NewUserWithIllegalPassWordDictionary}    statusCode=400    reponseResult=${NewUserWithIllegalPassWord}
&{NewMutilUserDictionary}    statusCode=200    reponseResult=${NewMutilUser}
