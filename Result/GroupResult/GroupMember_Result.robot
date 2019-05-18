*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${SingleChatgroupMember}    {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81787263975425/users/1","entities":[],"data":{"result":true,"groupid":"81787263975425","action":"add_member","user":"1"},"timestamp":1557483191359,"duration":1,"organization":"talent-leoli123","applicationName":"test"}
${SingleChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":true,"groupid":"%s","action":"%s","user":"%s"},"organization":"%s","applicationName":"%s"}
${MemberNotBelongChatgroup}    {"error":"forbidden_op","timestamp":1557723182960,"duration":0,"exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"users [imautotest-8756313249] are not members of this group!"}
${MemberNotBelongChatgroupDiffEntity}    {"error":"forbidden_op","exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"users [%s] are not members of this group!"}
${MultiChatgroupMember}    {"action":"get","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81787263975425/users","entities":[],"data":[{"member":"1"},{"owner":"2"}],"timestamp":1557736421440,"duration":0,"organization":"talent-leoli123","applicationName":"test","count":2}
${MultiChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"member":"%s"},{"owner":"%s"}],"organization":"%s","applicationName":"%s","count":%s}
${AddMultiChatgroupMember}    {"action":"post","application":"6a4e4860-7566-11e9-aac2-e5074acde8a3","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-2546992557/chatgroups/82149045764097/users","entities":[],"data":{"newmembers":["imautotest-9706071831"],"groupid":"82149045764097","action":"add_member"},"timestamp":1557741835432,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-2546992557"}
${AddMultiChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"newmembers":["%s"],"groupid":"%s","action":"%s"},"organization":"%s","applicationName":"%s"}
${MultiChatgroupNotFound}    {"error":"service_resource_not_found","timestamp":1557742914671,"duration":0,"exception":"com.easemob.group.exception.ServiceResourceNotFoundException","error_description":"do not find this group:imautotest-4934709933"}
${MultiChatgroupNotFoundDiffEntity}    {"error":"service_resource_not_found","exception":"com.easemob.group.exception.ServiceResourceNotFoundException","error_description":"do not find this group:%s"}
${DeleteMultiChatgroupMember}    {"action":"delete","application":"9ade4840-756b-11e9-9c39-d791dab6c18b","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5227550856/chatgroups/82151381991425/users/imautotest-4437680913,imautotest-9839253704","entities":[],"data":[{"result":true,"action":"remove_member","user":"imautotest-4437680913","groupid":"82151381991425"},{"result":true,"action":"remove_member","user":"imautotest-9839253704","groupid":"82151381991425"}],"timestamp":1557744064716,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-5227550856"}
${DeleteMultiChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"result":true,"action":"%s","groupid":"%s"},{"result":true,"action":"%s","groupid":"%s"}],"organization":"%s","applicationName":"%s"}
${ChatgroupAdmin}    {"action":"post","application":"7f788180-7578-11e9-9bb5-4b6f7647c959","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5154507455/chatgroups/82157189005314/admin","entities":[],"data":{"result":"success","%s":"imautotest-6879370040"},"timestamp":1557749602071,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-5154507455"}
${ChatgroupAdminDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":"success","%s":"%s"},"organization":"%s","applicationName":"%s"}
${MemberNotExistChatgroup}    {"error":"resource_not_found","timestamp":1557998296742,"duration":0,"exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"user: imautotest-5631448984 doesn't exist in group: 82417964613633"}
${MemberNotExistChatgroupDiffEntity}    {"error":"resource_not_found","exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"user: %s doesn\\'t exist in group: %s"}
${ChatgroupMemberNotAdmin}    {"error":"forbidden_op","timestamp":1558003629850,"duration":1,"exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"user:imautotest-0503070105 is not admin of group:82423556669441"}
${ChatgroupMemberNotAdminDiffEntity}    {"error":"forbidden_op","exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"user:%s is not admin of group:%s"}
${GetChatgroupAdmin}    {"action":"get","application":"d90d1680-77cf-11e9-9c3a-852f15981063","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-1381761688/chatgroups/82427112390658/admin","entities":[],"data":["imautotest-1025830921"],"timestamp":1558007021082,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-1381761688","count":1}
${GetChatgroupAdminDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":["%s"],"organization":"%s","applicationName":"%s","count":1}
${TransferChatgroup}    {"action":"put","application":"fe03fda0-7897-11e9-b5b6-5d14dbbcfc1c","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-6756529181/chatgroups/82517250080769","entities":[],"data":{"newowner":true},"timestamp":1558092982898,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-6756529181"}
${TransferChatgroupDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"%s":true},"organization":"%s","applicationName":"%s"}
&{SingleChatgroupMemberDictionary}    statusCode=200    reponseResult=${SingleChatgroupMember}
&{MemberNotBelongChatgroupDictionary}    statusCode=403    reponseResult=${MemberNotBelongChatgroup}
&{MultiChatgroupMemberDictionary}    statusCode=200    reponseResult=${MultiChatgroupMember}
&{AddMultiChatgroupMemberDictionary}    statusCode=200    reponseResult=${AddMultiChatgroupMember}
&{MultiChatgroupNotFoundDictionary}    statusCode=404    reponseResult=${MultiChatgroupNotFound}
&{DeleteMultiChatgroupMemberDictionary}    statusCode=200    reponseResult=${DeleteMultiChatgroupMember}
&{ChatgroupAdminDictionary}    statusCode=200    reponseResult=${ChatgroupAdmin}
&{MemberNotExistChatgroupDictionary}    statusCode=404    reponseResult=${MemberNotExistChatgroup}
&{ChatgroupMemberNotAdminDictionary}    statusCode=403    reponseResult=${ChatgroupMemberNotAdmin}
&{GetChatgroupAdminDictionary}    statusCode=200    reponseResult=${GetChatgroupAdmin}
&{TransferChatgroupDictionary}    statusCode=200    reponseResult=${TransferChatgroup}
