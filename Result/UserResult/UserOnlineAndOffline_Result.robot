*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${SingleUserStatus}    {"action":"get","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/users/1/status","entities":[],"data":{"%s":"%s"},"timestamp":1557202040221,"duration":9,"count":0}
${SingleUserStatusDiffEntity}    {"action":"get","entities":[],"data":{"%s":"%s"},"count":0}
${UserBatchStatus}    {"action":"get batch user status","data":[{"%s":"%s"},{"%s":"%s"}],"timestamp":1557205147734,"duration":4}
${UserBatchStatusDiffEntity}    {"action":"get batch user status","data":[{"%s":"%s"},{"%s":"%s"}]}
&{SingleUserStatusDictionary}    statusCode=200    reponseResult=${SingleUserStatus}
&{UserBatchStatusDictionary}    statusCode=200    reponseResult=${UserBatchStatus}
