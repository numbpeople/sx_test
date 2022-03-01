*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${SingleChatgroupMember}    {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81787263975425/users/1","entities":[],"data":{"result":true,"groupid":"81787263975425","action":"add_member","user":"1"},"timestamp":1557483191359,"duration":1,"organization":"talent-leoli123"}
${SingleChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":true,"groupid":"%s","action":"%s","user":"%s"},"organization":"%s"}

${MemberNotBelongChatgroup}    {"error":"forbidden_op","timestamp":1557723182960,"duration":0,"exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"users [imautotest-8756313249] are not members of this group!"}
${MemberNotBelongChatgroupDiffEntity}    {"error":"forbidden_op","error_description":"users [%s] are not members of this group!"}

${MultiChatgroupMember}    {"action":"get","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81787263975425/users","entities":[],"data":[{"member":"1"},{"owner":"2"}],"timestamp":1557736421440,"duration":0,"organization":"talent-leoli123","count":2}
${MultiChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"member":"%s"},{"owner":"%s"}],"organization":"%s","count":%s}

${AddMultiChatgroupMember}    {"action":"post","application":"6a4e4860-7566-11e9-aac2-e5074acde8a3","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-2546992557/chatgroups/82149045764097/users","entities":[],"data":{"newmembers":["imautotest-9706071831"],"groupid":"82149045764097","action":"add_member"},"timestamp":1557741835432,"duration":0,"organization":"1104190221201050"}
${AddMultiChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"newmembers":["%s"],"groupid":"%s","action":"%s"},"organization":"%s"}

${MultiChatgroupNotFound}    {"error":"service_resource_not_found","timestamp":1557742914671,"duration":0,"exception":"com.easemob.group.exception.ServiceResourceNotFoundException","error_description":"do not find this group:imautotest-4934709933"}
${MultiChatgroupNotFoundDiffEntity}    {"error":"service_resource_not_found","error_description":"do not find this group:%s"}

${DeleteMultiChatgroupMember}    {"action":"delete","application":"9ade4840-756b-11e9-9c39-d791dab6c18b","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5227550856/chatgroups/82151381991425/users/imautotest-4437680913,imautotest-9839253704","entities":[],"data":[{"result":true,"action":"remove_member","user":"imautotest-4437680913","groupid":"82151381991425"},{"result":true,"action":"remove_member","user":"imautotest-9839253704","groupid":"82151381991425"}],"timestamp":1557744064716,"duration":0,"organization":"1104190221201050"}
${DeleteMultiChatgroupMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"result":true,"action":"%s","groupid":"%s"},{"result":true,"action":"%s","groupid":"%s"}],"organization":"%s"}

${ChatgroupAdmin}    {"action":"post","application":"7f788180-7578-11e9-9bb5-4b6f7647c959","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5154507455/chatgroups/82157189005314/admin","entities":[],"data":{"result":"success","%s":"imautotest-6879370040"},"timestamp":1557749602071,"duration":0,"organization":"1104190221201050"}
${ChatgroupAdminDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":"success","%s":"%s"},"organization":"%s"}

${MemberNotExistChatgroup}    {"error":"resource_not_found","timestamp":1557998296742,"duration":0,"exception":"com.easemob.group.exception.ResourceNotFoundException","error_description":"user: imautotest-5631448984 doesn't exist in group: 82417964613633"}
${MemberNotExistChatgroupDiffEntity}    {"error":"resource_not_found","error_description":"user: %s doesn\\'t exist in group: %s"}

${ChatgroupMemberNotAdmin}    {"error":"forbidden_op","timestamp":1558003629850,"duration":1,"exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"user:imautotest-0503070105 is not admin of group:82423556669441"}
${ChatgroupMemberNotAdminDiffEntity}    {"error":"forbidden_op","error_description":"user:%s is not admin of group:%s"}

${GetChatgroupAdmin}    {"action":"get","application":"d90d1680-77cf-11e9-9c3a-852f15981063","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-1381761688/chatgroups/82427112390658/admin","entities":[],"data":["imautotest-1025830921"],"timestamp":1558007021082,"duration":0,"organization":"1104190221201050","count":1}
${GetChatgroupAdminDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":["%s"],"organization":"%s","count":1}

${TransferChatgroup}    {"action":"put","application":"fe03fda0-7897-11e9-b5b6-5d14dbbcfc1c","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-6756529181/chatgroups/82517250080769","entities":[],"data":{"newowner":true},"timestamp":1558092982898,"duration":0,"organization":"1104190221201050"}
${TransferChatgroupDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"%s":true},"organization":"%s"}

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

${InviteToGroup}    {"action":"post","application":"e019c634-e3f2-4e9c-9393-463657845f4f","uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatgroups/157793548042241/invite","entities":[],"data":[{"result":true,"action":"invite","user":"dee2","id":"157793548042241"}],"timestamp":1629946146696,"duration":0,"organization":"easemob-demo"}
${InviteToGroupDiffEntity}    {"action":"post","application":"%s","entities":[],"data":[{"result":%s,"action":"invite","user":"%s","id":"%s"}],"organization":"%s"}
&{InviteToGroupDictionary}    statusCode=200    reponseResult=${InviteToGroup}  

${ApplyToJoinIn}    {"action":"post","application":"e019c634-e3f2-4e9c-9393-463657845f4f","uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatgroups/154605632684033/apply","entities":[],"data":{"result":true,"action":"apply","user":"dee1","id":"154605632684033"},"timestamp":1629978476754,"duration":3,"organization":"easemob-demo"}
${ApplyToJoinInDiffEntity}    {"action":"post","application":"%s","entities":[],"data":{"result":%s,"action":"apply","user":"%s","id":"%s"},"organization":"%s"}
&{ApplyToJoinInDictionary}    statusCode=200    reponseResult=${ApplyToJoinIn}
        
${QuitGroup}    {"action":"delete","application":"a17c6fdb-7319-45a8-ab18-031cbb10bc6f","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-0439460962/chatgroups/159491350921217/quit","entities":[],"data":{"result":true},"timestamp":1631501206641,"duration":4,"organization":"easemob-demo"}
${QuitGroupDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":%s},"organization":"%s"}    
&{QuitGroupDictionary}    statusCode=200    reponseResult=${QuitGroup}

${ApplyVerify}    {"action":"post","application":"160720c7-06f2-45b3-8e03-72e123214931","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-8163396229/chatgroups/159962347143171/apply_verify","entities":[],"data":{"result":true,"action":"applyVerify","user":"imautotest-4674588577","id":"159962347143171"},"timestamp":1631950382957,"duration":1,"organization":"easemob-demo"}
${ApplyVerifyDiffEntity}    {"action":"post","application":"%s","entities":[],"data":{"result":%s,"action":"%s","user":"%s","id":"%s"},"organization":"%s"}
&{ApplyVerifyDictionary}    statusCode=200    reponseResult=${ApplyVerify}

${InviteVerify}    {"action":"post","application":"c7313f67-fb88-461a-90b3-251f8e9b4bf2","data":{"result":true,"action":"inviteVerify","user":"imautotest-8523027696","id":"160395620843521"},"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1632363586657,"uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-4459530824/chatgroups/160395620843521/invite_verify"}
${InviteVerifyDiffEntity}    {"action":"%s","application":"%s","data":{"result":%s,"action":"%s","user":"%s","id":"%s"},"entities":[],"organization":"%s","properties":{}}
&{InviteVerifyDictionary}    statusCode=200    reponseResult=${InviteVerify}
