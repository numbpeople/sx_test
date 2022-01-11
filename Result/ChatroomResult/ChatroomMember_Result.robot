*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${ChatroomMember}    {"action":"post","application":"edd11330-7ec5-11e9-ac1f-4f26f2297888","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5508232781/chatrooms/83229690363906/users/imautotest-4566827560","entities":[],"data":{"result":true,"action":"add_member","id":"83229690363906","user":"imautotest-4566827560"},"timestamp":1558772418537,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-5508232781"}
${ChatroomMemberDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":true,"action":"%s","id":"%s","user":"%s"},"organization":"%s","applicationName":"%s"}

${GetChatroomMember}    {"action":"get","application":"aab257c0-807e-11e9-8810-1966ad1bac71","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-6119417234/chatrooms/83428181606401/users","entities":[],"data":[{"member":"imautotest-3438596799"},{"owner":"imautotest-4761630544"}],"timestamp":1558961714894,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-6119417234","count":2}
${GetChatroomMemberDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"member":"%s"},{"owner":"%s"}],"organization":"%s","applicationName":"%s","count":%s}

${AddMultiChatroomMember}    {"action":"post","application":"393dca40-820c-11e9-b550-3bd069ca3746","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5934691245/chatrooms/83607224909826/users","entities":[],"data":{"newmembers":["imautotest-1165178792","imautotest-1279758040"],"action":"add_member","id":"83607224909826"},"timestamp":1559132463728,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-5934691245"}
${AddMultiChatroomMemberDiffEntity}    {"action":"post","application":"%s","entities":[],"organization":"%s","applicationName":"%s"}

${DeleteMultiChatroomMember}    {"action":"delete","application":"50f7de60-8210-11e9-88ae-a923aef9e64a","entities":[],"data":[{"result":true,"action":"remove_member","user":"imautotest-0523117457","id":"83609068306433"},{"result":true,"action":"remove_member","user":"imautotest-8260972791","id":"83609068306433"}],"timestamp":1559134221832,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-4038087505"}
${DeleteMultiChatroomMemberDiffEntity}    {"action":"delete","application":"%s","entities":[],"data":[{"result":true,"action":"%s","id":"%s"},{"result":true,"action":"%s","id":"%s"}],"organization":"%s","applicationName":"%s"}

${ChatroomAdmin}    {"action":"post","application":"396311b0-868f-11e9-be13-9fb23f9ea9de","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-9546371596/chatrooms/84127390957570/admin","entities":[],"data":{"result":"success","%s":"imautotest-6199381767"},"timestamp":1559628532809,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-9546371596"}
${ChatroomAdminDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":{"result":"%s","%s":"%s"},"organization":"%s","applicationName":"%s"}

${ChatroomSuperAdmin}    {"action":"post","application":"e019c634-e3f2-4e9c-9393-463657845f4f","applicationName":"easeim","data":{"result":"success","resource":""},"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1635252358332,"uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatrooms/super_admin"}
${ChatroomSuperAdminDiffEntity}    {"action":"post","application":"%s","applicationName":"%s","data":{"result":"success","resource":""},"duration":0,"entities":[],"organization":"%s","properties":{}}

${GetChatroomAdminList}    {"action":"get","application":"927d7c90-8694-11e9-85b3-795f60fcf636","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8634588330/chatrooms/84129799536642/admin","entities":[],"data":["imautotest-7689100811"],"timestamp":1559630830117,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-8634588330","count":1}
${GetChatroomAdminListDiffEntity}    {"action":"get","application":"%s","entities":[],"data":["%s"],"organization":"%s","applicationName":"%s","count":%s}

${GetChatroomSuperAdminList}    {"action":"get","application":"e019c634-e3f2-4e9c-9393-463657845f4f","applicationName":"easeim","count":1,"data":["1111"],"duration":1,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1635253015781,"uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatrooms/super_admin"}
${GetChatroomSuperAdminListDiffEntity}    {"action":"get","application":"%s","applicationName":"%s","data":["%s"],"count": %s,"entities":[],"organization":"%s"}
${GetChatroomZeroSuperAdminListDiffEntity}    {"action":"get","application":"%s","applicationName":"%s","data":[],"count": %s,"entities":[],"organization":"%s"}

${RemoveChatRoomsSuperAdmin}    {"action":"delete","application":"e019c634-e3f2-4e9c-9393-463657845f4f","applicationName":"easeim","data":{"newSuperAdmin":"1111","resource":""},"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1635306308413,"uri":"http://a1-hsb.easemob.com/easemob-demo/easeim/chatrooms/super_admin/1111"}
${RemoveChatRoomsSuperAdminListDiffEntity}    {"action":"delete","application":"%s","applicationName":"%s","data":{"newSuperAdmin":"%s","resource":""},"entities":[],"organization":"%s","properties":{}}

&{ChatroomMemberDictionary}    statusCode=200    reponseResult=${ChatroomMember}
&{GetChatroomMemberDictionary}    statusCode=200    reponseResult=${GetChatroomMember}
&{AddMultiChatroomMemberDictionary}    statusCode=200    reponseResult=${AddMultiChatroomMember}
&{DeleteMultiChatroomMemberDictionary}    statusCode=200    reponseResult=${DeleteMultiChatroomMember}
&{ChatroomAdminDictionary}    statusCode=200    reponseResult=${ChatroomAdmin}
&{GetChatroomAdminListDictionary}    statusCode=200    reponseResult=${GetChatroomAdminList}

&{ChatroomSuperAdminDictionary}    statusCode=200    reponseResult=${ChatroomSuperAdmin}
&{GetChatroomSuperAdminDictionary}     statusCode=200    reponseResult=${GetChatroomSuperAdminList}
&{RemoveChatRoomsSuperAdminDictionary}    statusCode=200    reponseResult=${RemoveChatRoomsSuperAdmin}

${ShieldChatroom}    {"action":"post","application":"07828e56-bf58-459d-a32d-dcd95be719e3","data":{"result":true,"action":"add_shield","user":"imautotest-7025924139","id":"160517962399747"},"duration":0,"entities":[],"organization":"easemob-demo","timestamp":1632480259087,"uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-1012325497/chatrooms/160517962399747/shield"}
${ShieldChatroomDiffEntity}    {"action":"%s","application":"%s","data":{"result":%s,"action":"%s","user":"%s","id":"%s"},"organization":"%s"}
&{ShieldChatroomDictionary}    statusCode=200    reponseResult=${ShieldChatroom}

${GetChatroomShield}    {"action":"get","application":"5d6c5f58-a650-4cdf-9399-5f7b7da51ba","applicationName":"shuang","count":0,"data":[],"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1641868756045,"uri":"http://a1.easemob.com/easemob-demo/shuang/chatrooms/170362515030018/shield"}
${GetChatroomShieldDiffEntity}    {"action":"%s","application":"%s","applicationName":"%s","count":%s,"data":[],"entities":[],"organization":"%s"}             
&{GetChatroomShieldDictionary}    statusCode=200    reponseResult=${GetChatroomShield}
        
${UnShieldChatroom}    {"action":"delete","application":"5d6c5f58-a650-4cdf-9399-5f7b57da51ba","applicationName":"shuang","data":{"result":true,"action":"remove_shield","user":"imautotest-3731203962","id":"170367860670466"},"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1641873854168,"uri":"http://a1.easemob.com/easemob-demo/shuang/chatrooms/170367860670466/shield"}
${UnShieldChatroomDiffEntity}    {"action":"%s","application":"%s","applicationName":"%s","data":{"result":%s,"action":"%s","user":"%s","id":"%s"},"organization":"%s"}   
&{UnShieldChatroomDictionary}    statusCode=200    reponseResult=${UnShieldChatroom}

${addSingleBlack}    {"action":"post","application":"5d6c5f58-a650-4cdf-9399-5f7b57da51ba","applicationName":"shuang","data":{"result":true,"action":"add_blocks","user":"imautotest-1596482921","id":"170378073800706"},"duration":1,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1641883594613,"uri":"http://a1.easemob.com/easemob-demo/shuang/chatrooms/170378073800706/blocks/users/imautotest-1596482921"}
${addSingleBlackDiffEntity}    {"action":"%s","application":"%s","applicationName":"%s","data":{"result":%s,"action":"%s","user":"%s","id":"%s"},"organization": "%s"}
&{addSingleBlackDictionary}    statusCode=200    reponseResult=${addSingleBlack}    

${addMultiBlack}    {"action":"post","application":"5d6c5f58-a650-4cdf-9399-5f7b57da51ba","applicationName":"shuang","data":[{"result":true,"action":"add_blocks","user":"imautotest-5305123096","id":"170382412808196"},{"result":true,"action":"add_blocks","user":"imautotest-8183356731","id":"170382412808196"}],"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1641887732735,"uri":"http://a1.easemob.com/easemob-demo/shuang/chatrooms/170382412808196/blocks/users"}
${addMultiBlackDiffEntity}    {"action":"%s","application":"%s","applicationName":"%s","data":[{"result":%s,"action":"%s","id":"%s"},{"result":%s,"action":"%s","id":"%s"}],"organization":"%s"}    
&{addMultiBlackDictionary}    statusCode=200    reponseResult=${addMultiBlack}

${GetChatroomBlack}    {"action":"get","application":"5d6c5f58-a650-4cdf-9399-5f7b57da51ba","applicationName":"shuang","count":1,"data":["imautotest-6215410554"],"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1641895321435,"uri":"http://a1.easemob.com/easemob-demo/shuang/chatrooms/170390370451458/blocks/users"}
${GetChatroomBlackDiffentity}    {"action":"%s","application":"%s","applicationName":"%s","count":%s,"data":["%s"],"organization":"%s"}
&{GetChatroomBlackDictionary}    statusCode=200    reponseResult=${GetChatroomBlack}

${RemoveChatroomBlack}    {"action":"delete","application":"5d6c5f58-a650-4cdf-9399-5f7b57da51ba","applicationName":"shuang","data":{"result":true,"action":"remove_blocks","user":"imautotest-5609921848","id":"170470116753409"},"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1641971373164,"uri":"http://a1.easemob.com/easemob-demo/shuang/chatrooms/170470116753409/blocks/users/imautotest-5609921848"}
${RemoveChatroomBlackDiffEntity}    {"action":"%s","application":"%s","applicationName":"%s","data":{"result":%s,"action":"%s","user":"%s","id":"%s"},"organization":"%s"}
&{RemoveChatroomBlackDictionary}    statusCode=200    reponseResult=${RemoveChatroomBlack}