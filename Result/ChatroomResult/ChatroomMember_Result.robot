*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${ChatroomMember}    {"action":"post","application":"edd11330-7ec5-11e9-ac1f-4f26f2297888","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5508232781/chatrooms/83229690363906/users/imautotest-4566827560","entities":[],"data":{"result":true,"action":"add_member","id":"83229690363906","user":"imautotest-4566827560"},"timestamp":1558772418537,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-5508232781"}
${ChatroomMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":true,"action":"%s","id":"%s","user":"%s"},"organization":"%s","applicationName":"%s"}
${GetChatroomMember}    {"action":"get","application":"aab257c0-807e-11e9-8810-1966ad1bac71","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-6119417234/chatrooms/83428181606401/users","entities":[],"data":[{"member":"imautotest-3438596799"},{"owner":"imautotest-4761630544"}],"timestamp":1558961714894,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-6119417234","count":2}
${GetChatroomMemberDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"member":"%s"},{"owner":"%s"}],"organization":"%s","applicationName":"%s","count":%s}
${AddMultiChatroomMember}    {"action":"post","application":"393dca40-820c-11e9-b550-3bd069ca3746","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5934691245/chatrooms/83607224909826/users","entities":[],"data":{"newmembers":["imautotest-1165178792","imautotest-1279758040"],"action":"add_member","id":"83607224909826"},"timestamp":1559132463728,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-5934691245"}
${AddMultiChatroomMemberDiffEntity}    {"action":"post","application":"%s","entities":[],"data":{"newmembers":["%s","%s"],"action":"%s","id":"%s"},"organization":"%s","applicationName":"%s"}
${DeleteMultiChatroomMember}    {"action":"delete","application":"50f7de60-8210-11e9-88ae-a923aef9e64a","entities":[],"data":[{"result":true,"action":"remove_member","user":"imautotest-0523117457","id":"83609068306433"},{"result":true,"action":"remove_member","user":"imautotest-8260972791","id":"83609068306433"}],"timestamp":1559134221832,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-4038087505"}
${DeleteMultiChatroomMemberDiffEntity}    {"action":"delete","application":"%s","entities":[],"data":[{"result":true,"action":"%s","id":"%s"},{"result":true,"action":"%s","id":"%s"}],"organization":"%s","applicationName":"%s"}
${ChatroomAdmin}    {"action":"post","application":"396311b0-868f-11e9-be13-9fb23f9ea9de","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-9546371596/chatrooms/84127390957570/admin","entities":[],"data":{"result":"success","%s":"imautotest-6199381767"},"timestamp":1559628532809,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-9546371596"}
${ChatroomAdminDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":"%s","%s":"%s"},"organization":"%s","applicationName":"%s"}
${GetChatroomAdminList}    {"action":"get","application":"927d7c90-8694-11e9-85b3-795f60fcf636","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8634588330/chatrooms/84129799536642/admin","entities":[],"data":["imautotest-7689100811"],"timestamp":1559630830117,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-8634588330","count":1}
${GetChatroomAdminListDiffEntity}    {"action":"get","application":"%s","entities":[],"data":["%s"],"organization":"%s","applicationName":"%s","count":%s}
&{ChatroomMemberDictionary}    statusCode=200    reponseResult=${ChatroomMember}
&{GetChatroomMemberDictionary}    statusCode=200    reponseResult=${GetChatroomMember}
&{AddMultiChatroomMemberDictionary}    statusCode=200    reponseResult=${AddMultiChatroomMember}
&{DeleteMultiChatroomMemberDictionary}    statusCode=200    reponseResult=${DeleteMultiChatroomMember}
&{ChatroomAdminDictionary}    statusCode=200    reponseResult=${ChatroomAdmin}
&{GetChatroomAdminListDictionary}    statusCode=200    reponseResult=${GetChatroomAdminList}
