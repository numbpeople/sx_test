*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${AddFriend}      {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"https://a1.easemob.com/talent-leoli123/test/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/contacts","entities":[{"uuid":"e12fc710-6f12-11e9-8830-8f84bf8799b1","type":"user","created":1557046248961,"modified":1557046248961,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557110604609,"duration":71,"organization":"talent-leoli123","applicationName":"test"}
${AddFriendDiffEntity}    {"action":"post","application":"%s","entities":[{"uuid":"%s","type":"user","username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${RemoveFriend}    {"action":"delete","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","path":"/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/contacts","uri":"https://a1.easemob.com/talent-leoli123/test/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/contacts","entities":[{"uuid":"e12fc710-6f12-11e9-8830-8f84bf8799b1","type":"user","created":1557046248961,"modified":1557046248961,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557110604609,"duration":71,"organization":"talent-leoli123","applicationName":"test"}
${RemoveFriendDiffEntity}    {"action":"delete","application":"%s","entities":[{"uuid":"%s","type":"user","username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${GetFriend}      {"action":"get","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/users/1/contacts/users","entities":[],"data":["1"],"timestamp":1557118002027,"duration":8,"count":1}
${GetFriendDiffEntity}    {"action":"get","entities":[],"data":["%s"],"count":%s}

${UserBlackList}    {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"https://a1.easemob.com/talent-leoli123/test","entities":[],"data":["1"],"timestamp":1557124912619,"duration":22,"organization":"talent-leoli123","applicationName":"test"}
${UserBlackListDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":["%s"],"organization":"%s","applicationName":"%s"}

${BlackUserNotFound}    {"error":"service_resource_not_found","timestamp":1557127373263,"duration":0,"exception":"UserNotFoundException","error_description":"Service resource not found"}
${BlackUserNotFoundDiffEntity}    {"error":"service_resource_not_found","error_description":"Service resource not found"}

${RemoveBlacklistUser}    {"action":"delete","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","path":"/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/blocks","uri":"https://a1.easemob.com/talent-leoli123/test/users/e12fc710-6f12-11e9-8830-8f84bf8799b1/blocks","entities":[{"uuid":"e12fc710-6f12-11e9-8830-8f84bf8799b1","type":"user","created":1557046248961,"modified":1557046248961,"username":"1","activated":true,"nickname":"1"}],"timestamp":1557131888854,"duration":20,"organization":"talent-leoli123","applicationName":"test"}
${RemoveBlacklistUserDiffEntity}    {"action":"delete","application":"%s","entities":[{"uuid":"%s","type":"user","username":"%s","activated":true,"nickname":"%s"}],"organization":"%s","applicationName":"%s"}

${GetUserBlackList}    {"action":"get","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8937351477/users/imautotest-9634930842/blocks/users","entities":[],"data":["imautotest-9634930842"],"timestamp":1557137826576,"duration":4,"count":1}
${GetUserBlackListDiffEntity}    {"action":"%s","entities":[],"data":["%s"],"count":%s}

${ApplyAddFriend}    {"path":"/users/1111/contacts/apply","uri":"https://a1-hsb.easemob.com/easemob-demo/easeim/users/1111/contacts/apply","timestamp":1636097367074,"organization":"easemob-demo","application":"e019c634-e3f2-4e9c-9393-463657845f4f","action":"post","data":{"applyContacts":["2222"]},"duration":19,"applicationName":"easeim"}
${ApplyAddFriendDiffEntity}    {"path":"/users/%s/contacts/apply","organization":"%s","application":"%s","action":"post","data":{"applyContacts":["%s"]},"applicationName":"%s"}
&{ApplyAddFriendDictionary}    statusCode=200    reponseResult=${ApplyAddFriend}

${RejectFriendRequest}    {"path":"/users/1111/contacts/decline/users/2222","uri":"https://a1-hsb.easemob.com/easemob-demo/easeim/users/1111/contacts/decline/users/2222","timestamp":1636098420528,"organization":"easemob-demo","application":"e019c634-e3f2-4e9c-9393-463657845f4f","action":"post","data":{"declineContacts":"2222"},"duration":27,"applicationName":"easeim"}
${RejectFriendRequestDiffEntity}     {"path":"/users/%s/contacts/decline/users/%s","organization":"%s","application":"%s","action":"post","data":{"declineContacts":["%s"]},"applicationName":"%s"}
&{RejectFriendRequestDictionary}    statusCode=200    reponseResult=${RejectFriendRequest}

${AgreeFriendRequest}    {"path":"/users/1111/contacts/accept/users/2222","uri":"https://a1-hsb.easemob.com/easemob-demo/easeim/users/1111/contacts/accept/users/2222","timestamp":1636098420528,"organization":"easemob-demo","application":"e019c634-e3f2-4e9c-9393-463657845f4f","action":"post","data":{"acceptContacts":"2222"},"duration":27,"applicationName":"easeim"}
${AgreeFriendRequestDiffEntity}     {"path":"/users/%s/contacts/accept/users/%s","organization":"%s","application":"%s","action":"post","data":{"acceptContacts":["%s"]},"applicationName":"%s"}
&{AgreeFriendRequestDictionary}    statusCode=200    reponseResult=${AgreeFriendRequest}

&{AddFriendDictionary}    statusCode=200    reponseResult=${AddFriend}
&{RemoveFriendDictionary}    statusCode=200    reponseResult=${RemoveFriend}
&{GetFriendDictionary}    statusCode=200    reponseResult=${GetFriend}
&{UserBlackListDictionary}    statusCode=200    reponseResult=${UserBlackList}
&{BlackUserNotFoundDictionary}    statusCode=404    reponseResult=${BlackUserNotFound}
&{RemoveBlacklistUserDictionary}    statusCode=200    reponseResult=${RemoveBlacklistUser}
&{GetUserBlackListDictionary}    statusCode=200    reponseResult=${GetUserBlackList}
