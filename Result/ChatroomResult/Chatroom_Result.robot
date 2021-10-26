*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${CreateChatroom}    {"action":"post","application":"e1af6e90-fccf-11e7-8cd3-5d660b6f51f2","uri":"http://a1-mesos.easemob.com/talent-leoli123/test/chatrooms","entities":[],"data":{"id":"82944105447425"},"timestamp":1558500063788,"duration":0,"organization":"talent-leoli123","applicationName":"test"}
${CreateChatroomDiffEntity}    {"action":"%s","application":"%s","entities":[],"organization":"%s","applicationName":"%s"}
${CreateChatroomWithNameFiledDiscarded}    {"error":"invalid_parameter","timestamp":1558606905572,"duration":0,"exception":"com.easemob.group.exception.InvalidParameterException","error_description":"chatroom must contain title/name field!"}
${CreateChatroomWithNameFiledDiscardedDiffEntity}    {"error":"invalid_parameter","exception":"com.easemob.group.exception.InvalidParameterException","error_description":"chatroom must contain title/name field!"}
${CreateChatroomWithOwnerFiledDiscarded}    {"error":"invalid_parameter","timestamp":1558607071240,"duration":0,"exception":"com.easemob.group.exception.InvalidParameterException","error_description":"owner must be provided"}
${CreateChatroomWithOwnerFiledDiscardedDiffEntity}    {"error":"invalid_parameter","exception":"com.easemob.group.exception.InvalidParameterException","error_description":"owner must be provided"}
${ModifyChatroom}    {"action":"put","application":"cd9a3420-7d58-11e9-ad38-63b766f0fdb9","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-3814068941/chatrooms/83065252675585","entities":[],"data":{"description":true,"maxusers":true,"groupname":true},"timestamp":1558615598262,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-3814068941"}
${ModifyChatroomDiffEntity}    {"action":"put","application":"%s","entities":[],"data":{"description":true,"maxusers":true,"groupname":true},"organization":"%s","applicationName":"%s"}
${ModifyChatroomWithMaxUserIsLargerThanCurrent}    {"error":"forbidden_op","timestamp":1558699424653,"duration":0,"exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"current user count is larger than the maxUsers that you want to update !"}
${ModifyChatroomWithMaxUserIsLargerThanCurrentDiffEntity}    {"error":"forbidden_op","exception":"com.easemob.group.exception.ForbiddenOpException","error_description":"current user count is larger than the maxUsers that you want to update !"}
${DeleteChatroom}    {"action":"delete","application":"c4425c00-7e1f-11e9-83d8-efc94289a428","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-9537174864/chatrooms/83154857689090","entities":[],"data":{"success":true,"id":"83154857689090"},"timestamp":1558701052638,"duration":1,"organization":"1104190221201050","applicationName":"imautotest-9537174864"}
${DeleteChatroomDiffEntity}    {"action":"delete","application":"%s","entities":[],"data":{"success":true,"id":"%s"},"organization":"%s","applicationName":"%s"}
${GetChatroomList}    {"action":"get","application":"d0303f70-7ea4-11e9-b71e-3f2b59b96069","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-3836506619/chatrooms","entities":[],"data":[{"id":"83214776467458","name":"imautotest-9105976690","owner":"imautotest-9105976690","affiliations_count":1}],"timestamp":1558758195675,"duration":0,"organization":"1104190221201050","count":1}
${GetChatroomListDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[],"organization":"%s"}
${GetSpecificChatroomDetail}    {"action":"get","application":"8369ad90-7ea7-11e9-b22e-1fe28719a175","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-5616018852/chatrooms/83215992815617","entities":[],"data":[{"id":"83215992815617","name":"imautotest-3578266576","description":"imautotest-3578266576","membersonly":false,"allowinvites":false,"maxusers":200,"owner":"imautotest-3578266576","created":1558759355082,"custom":"","affiliations_count":1,"affiliations":[{"owner":"imautotest-3578266576"}],"public":true}],"timestamp":1558759355275,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-5616018852","count":1}
${GetSpecificChatroomDetailDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"id":"%s","name":"%s","description":"%s","membersonly":%s,"allowinvites":%s,"maxusers":%s,"owner":"%s","custom":"","affiliations_count":%s,"affiliations":[{"owner":"%s"}],"public":%s}],"organization":"%s","applicationName":"%s","count":%s}
${GetIMUserJoinedChatroom}    {"action":"get","application":"f13b81a0-7eb5-11e9-bc65-b56cb87cec8d","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-1915126582/users/imautotest-3737234878/joined_chatrooms","entities":[],"data":[{"id":"83222490841089","name":"imautotest-3737234878"}],"timestamp":1558765552524,"duration":1,"organization":"1104190221201050","applicationName":"imautotest-1915126582","count":1}
${GetIMUserJoinedChatroomDiffEntity}    {"action":"get","application":"%s","entities":[],"data":[{"id":"%s","name":"%s"}],"organization":"%s","count":1}
&{CreateChatroomDictionary}    statusCode=200    reponseResult=${CreateChatroom}
&{CreateChatroomWithNameFiledDiscardedDictionary}    statusCode=400    reponseResult=${CreateChatroomWithNameFiledDiscarded}
&{CreateChatroomWithOwnerFiledDiscardedDictionary}    statusCode=400    reponseResult=${CreateChatroomWithOwnerFiledDiscarded}
&{ModifyChatroomDictionary}    statusCode=200    reponseResult=${ModifyChatroom}
&{ModifyChatroomWithMaxUserIsLargerThanCurrentDictionary}    statusCode=403    reponseResult=${ModifyChatroomWithMaxUserIsLargerThanCurrent}
&{DeleteChatroomDictionary}    statusCode=200    reponseResult=${DeleteChatroom}
&{GetChatroomListDictionary}    statusCode=200    reponseResult=${GetChatroomList}
&{GetSpecificChatroomDetailDictionary}    statusCode=200    reponseResult=${GetSpecificChatroomDetail}
&{GetIMUserJoinedChatroomDictionary}    statusCode=200    reponseResult=${GetIMUserJoinedChatroom}

${ChatroomAnnouncement}    {"action":"post","application":"1a1c08d5-7ad1-49ce-b426-d9160212c742","data":{"id":"160507876147203","result":true},"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1632470639699,"uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-9099207850/chatrooms/160507876147203/announcement"}
${ChatroomAnnouncementDiffEntity}    {"action":"%s","application":"%s","data":{"id":"%s","result":%s},"organization":"%s"}
&{ChatroomAnnouncementDictionary}    statusCode=200    reponseResult=${ChatroomAnnouncement}

${GetChatroomAnnouncement}    {"action":"get","application":"c7dece76-fad6-4f7e-a73d-ed120f611381","count":0,"data":{"announcement":"test"},"duration":1,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1632473712802,"uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-7262515131/chatrooms/160511098421251/announcement"}
${GetChatroomAnnouncementDiffEntity}    {"action":"%s","application":"%s","data":{"announcement":"%s"},"organization":"%s"}
&{GetChatroomAnnouncementDictionary}    statusCode=200    reponseResult=${GetChatroomAnnouncement}
 
${BanChatroom}    {"action":"put","application":"602c612f-4c2e-4e9d-ac19-d61d53db4740","data":{"mute":true},"duration":0,"entities":[],"organization":"easemob-demo","properties":{},"timestamp":1632469973448,"uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-5562764900/chatrooms/160507177795587/ban"}
${BanChatroomDiffEntity}    {"action":"%s","application":"%s","data":{"mute":%s},"organization":"%s"}
&{BanChatroomDictionary}    statusCode=200    reponseResult=${BanChatroom}