*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${AddFriend}      {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","path":"/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/contacts","uri":"https://a1.easemob.com/talent-leoli123/test/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/contacts","entities":[{"uuid":"e12fc710-6f12-11e9-8830-8f84bf8799b1","type":"user","created":1557046248961,"modified":1557046248961,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557110604609,"duration":71,"organization":"talent-leoli123","applicationName":"test"}
${AddFriendDiffEntity}    {"action":"post","application":"%s","path":"/users/%s/contacts","entities":[{"uuid":"%s","type":"user","created":%s,"modified":%s,"username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}
${RemoveFriend}    {"action":"delete","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","path":"/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/contacts","uri":"https://a1.easemob.com/talent-leoli123/test/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/contacts","entities":[{"uuid":"e12fc710-6f12-11e9-8830-8f84bf8799b1","type":"user","created":1557046248961,"modified":1557046248961,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557110604609,"duration":71,"organization":"talent-leoli123","applicationName":"test"}
${RemoveFriendDiffEntity}    {"action":"delete","application":"%s","path":"/users/%s/contacts","entities":[{"uuid":"%s","type":"user","created":%s,"modified":%s,"username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}
${GetFriend}      {"action":"get","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/users/1/contacts/users","entities":[],"data":["1"],"timestamp":1557118002027,"duration":8,"count":1}
${GetFriendDiffEntity}    {"action":"get","entities":[],"data":["%s"],"count":%s}
${UserBlackList}    {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"https://a1.easemob.com/talent-leoli123/test","entities":[],"data":["1"],"timestamp":1557124912619,"duration":22,"organization":"talent-leoli123","applicationName":"test"}
${UserBlackListDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":["%s"],"organization":"%s","applicationName":"%s"}
${BlackUserNotFound}    {"error":"illegal_argument","timestamp":1557127373263,"duration":0,"exception":"java.lang.IllegalArgumentException","error_description":"attempt to adding new block[imautotest-0586617824] for user[imautotest-9039726473],but user[imautotest-0586617824] not found."}
${BlackUserNotFoundDiffEntity}    {"error":"illegal_argument","exception":"java.lang.IllegalArgumentException","error_description":"attempt to adding new block[%s] for user[%s],but user[%s] not found."}
${RemoveBlacklistUser}    {"action":"delete","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","path":"/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/blocks","uri":"https://a1.easemob.com/talent-leoli123/test/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/blocks","entities":[{"uuid":"e12fc710-6f12-11e9-8830-8f84bf8799b1","type":"user","created":1557046248961,"modified":1557046248961,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557131888854,"duration":20,"organization":"talent-leoli123","applicationName":"test"}
${RemoveBlacklistUserDiffEntity}    {"action":"delete","application":"%s","entities":[{"uuid":"%s","type":"user","created":%s,"modified":%s,"username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}
${GetUserBlackList}    {"action":"get","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8937351477/users/imautotest-9634930842/blocks/users","entities":[],"data":["imautotest-9634930842"],"timestamp":1557137826576,"duration":4,"count":1}
${GetUserBlackListDiffEntity}    {"action":"%s","entities":[],"data":["%s"],"count":%s}
&{AddFriendDictionary}    statusCode=200    reponseResult=${AddFriend}
&{RemoveFriendDictionary}    statusCode=200    reponseResult=${RemoveFriend}
&{GetFriendDictionary}    statusCode=200    reponseResult=${GetFriend}
&{UserBlackListDictionary}    statusCode=200    reponseResult=${UserBlackList}
&{BlackUserNotFoundDictionary}    statusCode=400    reponseResult=${BlackUserNotFound}
&{RemoveBlacklistUserDictionary}    statusCode=200    reponseResult=${RemoveBlacklistUser}
&{GetUserBlackListDictionary}    statusCode=200    reponseResult=${GetUserBlackList}
