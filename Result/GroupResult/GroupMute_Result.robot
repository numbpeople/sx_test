*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${ChatgroupUserMute}    {"action":"post","application":"cef552f0-7ac9-11e9-9543-398cbe730822","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-9229138137/chatgroups/82770268323841/mute","entities":[],"data":[{"result":true,"expire":1558420680313,"user":"imautotest-5817865707"}],"timestamp":1558334280314,"duration":0,"organization":"1104190221201050"}
${ChatgroupUserMuteDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"result":true,"user":"%s"}],"organization":"%s"}
${ChatgroupMuteUserNotBelongGroup}    {"error":"invalid_parameter","timestamp":1558335604796,"duration":0,"exception":"com.easemob.group.exception.InvalidParameterException","error_description":"users [imautotest-9009839441] are not members of this group!"}
${ChatgroupMuteUserNotBelongGroupDiffEntity}    {"error":"invalid_parameter","exception":"com.easemob.group.exception.InvalidParameterException","error_description":"users [%s] are not members of this group!"}
${RemoveChatgroupUserMute}    {"action":"delete","application":"eb2f1b70-7ad0-11e9-a561-534f55f6b5c3","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-1377913191/chatgroups/82773470674945/mute/imautotest-2269259556","entities":[],"data":[{"result":true,"user":"imautotest-2269259556"}],"timestamp":1558337334295,"duration":1,"organization":"1104190221201050"}
${RemoveChatgroupUserMuteDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"result":true,"user":"%s"}],"organization":"%s"}
${GetChatgroupUserMuteList}    {"action":"post","application":"caf2ea70-7afe-11e9-a161-3dd64d87740a","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8767242519/chatgroups/82794130767873/mute","entities":[],"data":[{"expire":1558443436981,"user":"imautotest-8722232287"}],"timestamp":1558357037144,"duration":0,"organization":"1104190221201050"}
${GetChatgroupUserMuteListDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"user":"%s"}],"organization":"%s"}
&{ChatgroupUserMuteDictionary}    statusCode=200    reponseResult=${ChatgroupUserMute}
&{ChatgroupMuteUserNotBelongGroupDictionary}    statusCode=400    reponseResult=${ChatgroupMuteUserNotBelongGroup}
&{RemoveChatgroupUserMuteDictionary}    statusCode=200    reponseResult=${RemoveChatgroupUserMute}
&{GetChatgroupUserMuteListDictionary}    statusCode=200    reponseResult=${GetChatgroupUserMuteList}

${RemoveMuteByRole}    {"action":"delete","application":"024663e6-d99c-42f2-97f3-cc734388651d","data":[{"result":true,"user":"imautotest-5368765495"}],"duration":0,"entities":[],"organization":"easemob-demo","params":{"role":["member"]},"properties":{},"timestamp":1632307417409,"uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-7016991165/chatgroups/160336724426753/mute"}
${RemoveMuteByRoleDiffEntity}    {"action":"delete","application":"%s","data":[{"result":%s}],"entities":[],"organization":"easemob-demo","params":{"role":["member"]},"properties":{}}
&{RemoveMuteByRoleDictionary}    statusCode=200    reponseResult=${RemoveMuteByRole}