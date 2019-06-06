*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${AddChatroomMemberMute}    {"action":"post","application":"5e3410a0-86af-11e9-af06-bb3a6c11b7be","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-3369425217/chatrooms/84141867597826/mute","entities":[],"data":[{"result":true,"expire":1559728739225,"user":"imautotest-1825836757"}],"timestamp":1559642339227,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-3369425217"}
${AddChatroomMemberMuteDiffEntity}    {"action":"post","application":"%s","entities":[],"data":[{"result":true,"user":"%s"}],"organization":"%s","applicationName":"%s"}
${MemberNotBelongChatroom}    {"error":"invalid_parameter","timestamp":1559643634258,"duration":0,"exception":"com.easemob.group.exception.InvalidParameterException","error_description":"users [imautotest-8326632078] are not members of this group!"}
${MemberNotBelongChatroomDiffEntity}    {"error":"invalid_parameter","exception":"com.easemob.group.exception.InvalidParameterException","error_description":"users [%s] are not members of this group!"}
${RemoveChatroomMemberMute}    {"action":"delete","application":"468ae0e0-86b5-11e9-9342-b1002216a649","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-7127953790/chatrooms/84144527835138/mute/imautotest-6964795697","entities":[],"data":[{"result":true,"user":"imautotest-6964795697"}],"timestamp":1559644875767,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-7127953790"}
${RemoveChatroomMemberMuteDiffEntity}    {"action":"delete","application":"%s","entities":[],"data":[{"result":true,"user":"%s"}],"organization":"%s","applicationName":"%s"}
${GetChatroomMemberMuteList}    {"action":"post","application":"f8f48dd0-86b5-11e9-9a90-afbed376ef12","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-7834201751/chatrooms/84144841359363/mute","entities":[],"data":[{"expire":1559731574937,"user":"imautotest-3273736000"}],"timestamp":1559645175112,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-7834201751"}
${GetChatroomMemberMuteListDiffEntity}    {"action":"post","application":"%s","entities":[],"data":[{"user":"%s"}],"organization":"%s","applicationName":"%s"}
&{AddChatroomMemberMuteDictionary}    statusCode=200    reponseResult=${AddChatroomMemberMute}
&{MemberNotBelongChatroomDictionary}    statusCode=400    reponseResult=${MemberNotBelongChatroom}
&{RemoveChatroomMemberMuteDictionary}    statusCode=200    reponseResult=${RemoveChatroomMemberMute}
&{GetChatroomMemberMuteListDictionary}    statusCode=200    reponseResult=${GetChatroomMemberMuteList}
