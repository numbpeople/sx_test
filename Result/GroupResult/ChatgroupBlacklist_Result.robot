*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${SingleUserChatgroupBlacklist}    {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81787263975425/blocks/users/1","entities":[],"data":{"result":true,"action":"add_blocks","user":"1","groupid":"81787263975425"},"timestamp":1558151386504,"duration":0,"organization":"talent-leoli123"}
${SingleUserChatgroupBlacklistDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":true,"action":"%s","user":"%s","groupid":"%s"},"organization":"%s"}
${GetChatgroupBlacklist}    {"action":"get","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatgroups/81787263975425/blocks/users","entities":[],"data":["1"],"timestamp":1558154878209,"duration":0,"organization":"talent-leoli123","count":1}
${GetChatgroupBlacklistDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":["%s"],"organization":"%s","count":%s}
${AddMultiUserChatgroupBlacklist}    {"action":"post","application":"1f24bd00-7940-11e9-820f-cba830aa1180","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-0986445867/chatgroups/82592967753729/blocks/users","entities":[],"data":[{"result":true,"action":"add_blocks","user":"imautotest-9507754521","groupid":"82592967753729"},{"result":true,"action":"add_blocks","user":"imautotest-9274163462","groupid":"82592967753729"}],"timestamp":1558165193671,"duration":2,"organization":"1104190221201050"}
${AddMultiUserChatgroupBlacklistDiffEntity}    {"action":"post","application":"%s","entities":[],"data":[{"result":true,"action":"add_blocks","groupid":"%s"},{"result":true,"action":"add_blocks","groupid":"%s"}],"organization":"%s"}
${AddMultiUserChatgroupBlacklistWithNotBelongChatgroup}    {"action":"post","application":"356d0e20-7943-11e9-84c3-e184a8555c9b","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-1339274448/chatgroups/82594358165505/blocks/users","entities":[],"data":[{"result":false,"action":"add_blocks","user":"imautotest-1855144687","groupid":"82594358165505"},{"result":true,"action":"add_blocks","user":"imautotest-3547408840","groupid":"82594358165505"}],"timestamp":1558166519240,"duration":0,"organization":"1104190221201050"}
${AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDiffEntity}    {"action":"post","application":"%s","entities":[],"data":[{"action":"add_blocks","groupid":"%s"},{"action":"add_blocks","groupid":"%s"}],"organization":"%s"}
${RemoveMultiUserChatgroupBlacklist}    {"action":"delete","application":"692b1c70-7948-11e9-acd7-d52ee3daef29","entities":[],"data":[{"result":true,"action":"remove_blocks","user":"imautotest-4381330189","groupid":"82596700684289"},{"result":true,"action":"remove_blocks","user":"imautotest-4218763702","groupid":"82596700684289"}],"timestamp":1558168754361,"duration":0,"organization":"1104190221201050"}
${RemoveMultiUserChatgroupBlacklistDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":[{"result":true,"action":"%s","groupid":"%s"},{"result":true,"action":"%s","groupid":"%s"}],"organization":"%s"}
&{SingleUserChatgroupBlacklistDictionary}    statusCode=200    reponseResult=${SingleUserChatgroupBlacklist}
&{GetChatgroupBlacklistDictionary}    statusCode=200    reponseResult=${GetChatgroupBlacklist}
&{AddMultiUserChatgroupBlacklistDictionary}    statusCode=200    reponseResult=${AddMultiUserChatgroupBlacklist}
&{AddMultiUserChatgroupBlacklistWithNotBelongChatgroupDictionary}    statusCode=200    reponseResult=${AddMultiUserChatgroupBlacklistWithNotBelongChatgroup}
&{RemoveMultiUserChatgroupBlacklistDictionary}    statusCode=200    reponseResult=${RemoveMultiUserChatgroupBlacklist}
