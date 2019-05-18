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
