#coding:utf-8

import sys
sys.path.append("..")
from apiconfig import *
true = True
false = False

CrePubGrpBody = {
    "groupname":"public_group",
    "desc":"RST created group",
    "public":true,
    "maxusers":800,
    "approval":false,
    "owner":user1,
    "members":[user2,user88]
}

multiMemBody = {"usernames":[user4,user5]}

grpTransBody = {"newowner":user2}

modgrpBody = {
    "groupname":"new_group123",
    "description":"updategroupinfo",
    "maxusers":185
}

mulMemtoblackBody = {"usernames":[user4,user5]}

muteMemBody = {"usernames":[user3], "mute_duration":86400000}

addAdminBody = {"newadmin":user1}


pubGrpVerifyBody = {
    "groupname":"public_needVerify",
    "desc":"RST created group",
    "public":true,
    "allowinvites":false,
    "maxusers":800,
    "approval":true,
    "owner":"rest111",
    "members":["rest112"]
}

verifyBody = {
    "applicant": user3,
    "verifyResult": true
}

privateBody = {
    "groupname":"private_group",
    "desc":"RST created group",
    "public":false,
    "allowinvites":false,
    "maxusers":800,
    "approval":true,
    "owner":user1,
    "members":[user2]
}

privateAllowBody = {
    "groupname":"private_group_allow",
    "desc":"RST created group",
    "public":false,
    "allowinvites":true,
    "maxusers":600,
    "approval":true,
    "owner":user1,
    "members":[user2]
}
