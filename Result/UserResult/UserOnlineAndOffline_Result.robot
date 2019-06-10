*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${SingleUserStatus}    {"action":"get","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/users/1/status","entities":[],"data":{"%s":"%s"},"timestamp":1557202040221,"duration":9,"count":0}
${SingleUserStatusDiffEntity}    {"action":"get","entities":[],"data":{"%s":"%s"},"count":0}
${UserBatchStatus}    {"action":"get batch user status","data":[{"%s":"%s"},{"%s":"%s"}],"timestamp":1557205147734,"duration":4}
${UserBatchStatusDiffEntity}    {"action":"get batch user status","data":[{"%s":"%s"},{"%s":"%s"}]}
${UserOfflineMsgCount}    {"action":"get","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-2955003514/users/imautotest-2728929098/offline_msg_count","entities":[],"data":{"%s":%s},"timestamp":1560166578886,"duration":2,"count":0}
${UserOfflineMsgCountDiffEntity}    {"action":"get","entities":[],"data":{"%s":%s}}
&{SingleUserStatusDictionary}    statusCode=200    reponseResult=${SingleUserStatus}
&{UserBatchStatusDictionary}    statusCode=200    reponseResult=${UserBatchStatus}
&{UserOfflineMsgCountDictionary}    statusCode=200    reponseResult=${UserOfflineMsgCount}
