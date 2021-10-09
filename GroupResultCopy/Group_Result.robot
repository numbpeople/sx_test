*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${CreateChatgroup}    {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups","entities":[],"data":{"groupid":"81787263975425"},"timestamp":1557396813145,"duration":0,"organization":"talent-leoli123","applicationName":"test"}
${CreateChatgroupDiffEntity}    {"action":"post","application":"%s","entities":[],"organization":"%s","applicationName":"%s"}
${GroupNoAuthorization}    {"error":"group_authorization","timestamp":1557398007623,"duration":0,"exception":"com.easemob.group.exception.GroupAuthorizationException","error_description":"token is blank!"}
${GroupNoAuthorizationDiffEntity}    {"error":"group_authorization","exception":"com.easemob.group.exception.GroupAuthorizationException","error_description":"token is blank!"}
${GroupMemberNotFound}    {"error":"resource_not_found","timestamp":1557398649392,"duration":0,"exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"username 111 doesn't exist!"}
${GroupMemberNotFoundDiffEntity}    {"error":"resource_not_found","exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"username %s doesn\\'t exist!"}
${GroupPublicNotFound}    {"error":"invalid_parameter","timestamp":1557402657886,"duration":0,"exception":"com.easemob.group.exception.InvalidParameterException","error_description":"group must contain public field!"}
${GroupPublicNotFoundDiffEntity}    {"error":"invalid_parameter","exception":"com.easemob.group.exception.InvalidParameterException","error_description":"group must contain public field!"}
${EditChatgroup}    {"action":"put","application":"8be024f0-e978-11e8-b697-5d598d5f8402","uri":"http://a1.easemob.com/easemob-demo/testapp/chatgroups/66021836783617","entities":[],"data":{"description":true,"maxusers":true,"groupname":true},"timestamp":1542363146301,"duration":0,"organization":"easemob-demo","applicationName":"testapp"}
${EditChatgroupDiffEntity}    {"action":"put","application":"%s","entities":[],"data":{"description":true,"maxusers":true,"groupname":true},"organization":"%s","applicationName":"%s"}
${ChatgroupIdNotFound}    {"error":"resource_not_found","timestamp":1542363205192,"duration":0,"exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"grpID 6602183678361 does not exist!"}
${ChatgroupIdNotFoundDiffEntity}    {"error":"resource_not_found","exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"grpID %s does not exist!"}
${DeleteChatgroup}    {"action":"delete","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81793235615745","entities":[],"data":{"success":true,"groupid":"81793235615745"},"timestamp":1557463339484,"duration":0,"organization":"talent-leoli123","applicationName":"test"}
${DeleteChatgroupDiffEntity}    {"action":"delete","application":"%s","entities":[],"data":{"success":true,"groupid":"%s"},"organization":"%s","applicationName":"%s"}
${GetChatgroup}    {"action":"get","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/","entities":[],"data":[],"timestamp":1557468113965,"duration":0,"organization":"talent-leoli123","applicationName":"test","count":4}
${GetChatgroupDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[],"organization":"%s","applicationName":"%s"}
${GetIMUserJoinedChatgroups}    {"action":"get","application":"8be024f0-e978-11e8-b697-5d598d5f8402","uri":"http://a1.easemob.com/easemob-demo/testapp/users/user1/joined_chatgroups","entities":[],"data":[{"groupid":"%s","groupname":"%s"}],"timestamp":1542359565885,"duration":1,"organization":"easemob-demo","applicationName":"testapp","count":1}
${GetIMUserJoinedChatgroupsDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"groupid":"%s","groupname":"%s"}],"organization":"%s","applicationName":"%s","count":1}
${GetChatgroupDetail}    {"action":"get","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81873787224065","entities":[],"data":[{"id":"81873787224065","name":"validuser1234567890","description":"validuser1234567890","membersonly":false,"allowinvites":false,"maxusers":200,"owner":"validuser1234567890","created":1557479328046,"custom":"","affiliations_count":1,"affiliations":[{"owner":"validuser1234567890"}],"public":true}],"timestamp":1557479335883,"duration":0,"organization":"talent-leoli123","applicationName":"test","count":1}
${GetChatgroupDetailDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"id":"%s","name":"%s","description":"%s","membersonly":%s,"allowinvites":%s,"maxusers":%s,"owner":"%s","custom":"","affiliations_count":1,"affiliations":[{"owner":"%s"}],"public":%s}],"organization":"%s","applicationName":"%s","count":1}
${GetChatgroupDetailGroupIdNotFound}    {"error":"service_resource_not_found","timestamp":1557481611000,"duration":0,"exception":"com.easemob.group.exception.ServiceResourceNotFoundException","error_description":"do not find this group:1"}
${GetChatgroupDetailGroupIdNotFoundDiffEntity}    {"error":"service_resource_not_found","exception":"com.easemob.group.exception.ServiceResourceNotFoundException","error_description":"do not find this group:%s"}
&{CreateChatgroupDictionary}    statusCode=200    reponseResult=${CreateChatgroup}
&{GroupNoAuthorizationDictionary}    statusCode=401    reponseResult=${GroupNoAuthorization}
&{GroupMemberNotFoundDictionary}    statusCode=404    reponseResult=${GroupMemberNotFound}
&{GroupPublicNotFoundDictionary}    statusCode=400    reponseResult=${GroupPublicNotFound}
&{EditChatgroupDictionary}    statusCode=200    reponseResult=${EditChatgroup}
&{ChatgroupIdNotFoundDictionary}    statusCode=404    reponseResult=${ChatgroupIdNotFound}
&{DeleteChatgroupDictionary}    statusCode=200    reponseResult=${DeleteChatgroup}
&{GetChatgroupDictionary}    statusCode=200    reponseResult=${GetChatgroup}
&{GetIMUserJoinedChatgroupsDictionary}    statusCode=200    reponseResult=${GetIMUserJoinedChatgroups}
&{GetChatgroupDetailDictionary}    statusCode=200    reponseResult=${GetChatgroupDetail}
&{GetChatgroupDetailGroupIdNotFoundDictionary}    statusCode=404    reponseResult=${GetChatgroupDetailGroupIdNotFound}
&{GetPublicChatgroupDictionary}    statusCode=200    reponseResult=${GetChatgroup}
${GetPublicChatgroupDiffEntity}    {"action":"get","application":"e019c634-e3f2-4e9c-9393-463657845f4f","uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/publicchatgroups","entities":[],"data":[{"groupid":"147027147161601","groupname":"1234"},{"groupid":"143836097609729","groupname":"测试群组1"},{"groupid":"153807347580929","groupname":"This is Deegroup"},{"groupid":"151971804807169","groupname":"群组5"},{"groupid":"151972494770177","groupname":"群组5"},{"groupid":"145004709347329","groupname":"testshuxing4"},{"groupid":"152065749876737","groupname":"沙箱测试群组1"},{"groupid":"145018915454977","groupname":"zsgroup1"},{"groupid":"145280528875521","groupname":"我的群组12"},{"groupid":"1234567","groupname":"a test group"}],"timestamp":1626260510962,"duration":0,"organization":"easemob-demo","applicationName":"easeim","cursor":"1000","count":10}
${GetChatgroupsDetail}    {"action":"get","application":"cb687b0b-6241-4710-9691-a12adca97eb8","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-6367421720/chatgroups/157065380167683,157065381216257","entities":[],"data":[{"id":"157065380167683","name":"imautotest-1994895796","description":"imautotest-1994895796","membersonly":false,"allowinvites":false,"invite_need_confirm":true,"maxusers":200,"created":1629187619926,"custom":"","mute":false,"scale":"normal","affiliations_count":1,"affiliations":[{"owner":"initvaliduser-7840869146"}],"public":true},{"id":"157065381216257","name":"imautotest-1616920883","description":"imautotest-1616920883","membersonly":false,"allowinvites":false,"invite_need_confirm":true,"maxusers":200,"created":1629187620047,"custom":"","mute":false,"scale":"normal","affiliations_count":1,"affiliations":[{"owner":"initvaliduser-7840869146"}],"public":true}],"timestamp":1629187620163,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-6367421720","count":2}
${GetChatgroupsDetailDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"id":"%s","name":"%s","description":"%s","membersonly":%s,"allowinvites":%s,"invite_need_confirm":true,"maxusers":%s,"custom":"","affiliations_count":1,"affiliations":[{"owner":"%s"}],"public":%s},{"id":"%s","name":"%s","description":"%s","membersonly":%s,"allowinvites":%s,"invite_need_confirm":true,"maxusers":%s,"custom":"","affiliations_count":1,"affiliations":[{"owner":"%s"}],"public":%s}],"organization":"%s","applicationName":"%s","count":2}
&{GetChatgroupsDetailDictionary}    statusCode=200    reponseResult=${GetChatgroupsDetail}

${GetChatgrouproles}    {"action":"get","application":"e019c634-e3f2-4e9c-9393-463657845f4f","uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatgroups/157793548042241/roles","entities":[],"data":[{"username":"dee1","role":"owner","online":true}],"timestamp":1629891430226,"duration":0,"organization":"easemob-demo","applicationName":"easeim","count":1}
${GetChatgrouprolesDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"username":"%s","role":"%s","online":true}],"duration":0,"organization":"%s","applicationName":"%s","count":1}
&{GetChatgrouprolesDictionary}    statusCode=200    reponseResult=${GetChatgrouproles}

${AddGroupAnnouncement}    {"action":"post","application":"e019c634-e3f2-4e9c-9393-463657845f4f","uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatgroups/157242675494913/announcement","entities":[],"data":{"id":"157242675494913","result":true},"timestamp":1631517528086,"duration":0,"organization":"easemob-demo","applicationName":"easeim"}
${AddGroupAnnouncementDiffEntity}    {"action":"post","application":"%s","entities":[],"data":{"id":"%s","result":%s},"organization":"%s","applicationName":"%s"}
&{AddGroupAnnouncementDictionary}    statusCode=200    reponseResult=${AddGroupAnnouncement} 

${GetGroupAnnouncement}    {"action":"get","application":"e019c634-e3f2-4e9c-9393-463657845f4f","uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatgroups/157242675494913/announcement","entities":[],"data":{"announcement":"test"},"timestamp":1631524608396,"duration":0,"organization":"easemob-demo","applicationName":"easeim","count":0}    
${GetGroupAnnouncementDiffEntity}    {"action":"get","application":"%s","entities":[],"data":{"announcement":"%s"},"organization":"%s","applicationName":"%s","count":0}    
&{GetGroupAnnouncementDictionary}    statusCode=200    reponseResult=${GetGroupAnnouncement} 
        
${ShieldGroupMessage}    {"action":"post","application":"865b8149-5e07-4722-8820-ac71e6761f42","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-0974891388/chatgroups/159583286919169/shield","entities":[],"data":{"result":true,"action":"add_shield","user":"initvaliduser-1781491640","groupid":"159583286919169"},"timestamp":1631588882793,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-0974891388"}    
${ShieldGroupMessageDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":%s,"action":"%s","user":"%s","groupid":"%s"},"organization":"%s","applicationName":"%s"}    
&{ShiledGroupMessageDictionary}    statusCode=200    reponseResult=${ShieldGroupMessage}

${UnShieldGroupMessage}    {"action":"delete","application":"b5dfe79c-4801-4651-832f-1d2f39c1ca1d","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-7626434313/chatgroups/159584272580609/shield","entities":[],"data":{"result":true,"action":"remove_shield","user":"initvaliduser-4831622154","groupid":"159584272580609"},"timestamp":1631589823258,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-7626434313"}    
${UnShieldGroupMessageDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":%s,"action":"%s","user":"%s","groupid":"%s"},"organization":"%s","applicationName":"%s"}    
&{UnShiledGroupMessageDictionary}    statusCode=200    reponseResult=${UnShieldGroupMessage}

${GetMemberWhoOpenShield}    {"action":"get","application":"7efd2c73-4253-46c1-a23b-5f4290411a16","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-5779896234/chatgroups/159607650582529/shield","entities":[],"data":[],"timestamp":1631612117524,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-5779896234","count":0}
${GetMemberWhoOpenShieldDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[],"organization":"%s","applicationName":"%s","count":%s}        
&{GetMemberWhoOpenShieldDictionary}    statusCode=200    reponseResult=${GetMemberWhoOpenShield}

${UsersJoinGroupsInBatches}    {"action":"post","application":"97f7e722-53b8-4ed5-95ff-c5a822078830","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-8039485135/users/imautotest-1990208120/joined_chatgroups","entities":[],"data":[{"id":"159609522290690","result":true},{"id":"159609522290691","result":true}],"timestamp":1631613902706,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-8039485135"}
${UsersJoinGroupsInBatchesDiffEntity}    {"action":"post","application":"%s","entities":[],"data":[{"id":"%s","result":true},{"id":"%s","result":true}],"organization":"%s","applicationName":"%s"}
&{UsersJoinGroupsInBatchesDictionary}    statusCode=200    reponseResult=${UsersJoinGroupsInBatches}

${BanGroupMessage}    {"action":"put","application":"ed12d486-881b-4346-a784-3ca083f88d7b","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-4703902562/chatgroups/159675625570305/ban","entities":[],"data":{"mute":true},"timestamp":1631676944214,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-4703902562"}
${BanGroupMessageDiffEntity}    {"action":"put","application":"%s","entities":[],"data":{"mute":%s},"organization":"%s","applicationName":"%s"}
&{BanGroupMessageDictionary}    statusCode=200    reponseResult=${BanGroupMessage}

${AllowGroupMessage}    {"action":"delete","application":"ed12d486-881b-4346-a784-3ca083f88d7b","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-4703902562/chatgroups/159675625570305/ban","entities":[],"data":{"mute":false},"timestamp":1631676944214,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-4703902562"}
${AllowGroupMessageDiffEntity}    {"action":"put","application":"%s","entities":[],"data":{"mute":%s},"organization":"%s","applicationName":"%s"}
&{AllowGroupMessageDictionary}    statusCode=200    reponseResult=${AllowGroupMessage}

${GetReceiveMember}    {"action":"group_read_ack","data":{"ackmid":"920022907831190548","userlist":[],"total":0,"next_key":"","is_last":true,"timestamp":1631774325921},"timestamp":1631774325918,"duration":8}
${GetReceiveMemberDiffEntity}    {"action":"%s"}
&{GetReceiveMemberDictionary}    statusCode=200    reponseResult=${GetReceiveMember}

${GetFileList}    {"action":"get","application":"a379d738-bf5c-4585-b331-435f4b05b0c4","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-0355406389/chatgroups/159942570999809/share_files","entities":[],"data":[],"timestamp":1631931523309,"duration":0,"organization":"easemob-demo","applicationName":"imautotest-0355406389","count":0}
${GetFileListDiffEntity}    {"action":"%s","application":"%s","organization":"%s","applicationName":"%s"}
&{GetFileListDictionary}    statusCode=200    reponseResult=${GetFileList}