#coding:utf-8

import sys
sys.path.append("..")
from apiconfig import *
true = True
false = False

CteroomBody = {
    "name":"rest_chatroom",
    "description":"Rest create chatroom",
    "maxusers":5000,
    "owner":user1
}

modifyBody = {
    "name":"new chatroom update",
    "description":"modify chatroom",
    "maxusers":1000
}

MultiMemBody = {"usernames":[user3,user4]}

