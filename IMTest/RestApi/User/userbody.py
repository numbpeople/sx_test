#coding:utf-8

import sys
sys.path.append("..")
from apiconfig import *
true = True
false = False
user6 = "rest116"
user7= "rest117"
user8 = "rest118"
user9 = "rest119"

userToken = {
    "grant_type": "password",
    "username": user1,
    "password": "1"
  }

cteUserBody = {"username": user6, "password":"1"}

cteMultiUsrBody = [{"username":user7,"password":"1"},{"username":user8,"password":"1"},{"username":user9,"password":"1"},
                    {"username":"rest120","password":"1"},{"username":"rest121","password":"1"},
                   ]

setPWordBody = {"newpassword" : "2"}

nicknameBody = {"nickname": "new_name"}

MulUserStatBody = {"usernames":[user1,user2,user3]}

