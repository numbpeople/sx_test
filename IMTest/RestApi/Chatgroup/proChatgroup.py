#coding:utf-8

import sys
sys.path.append("..")

from apiconfig import *
import requests
import json

class GroupsInfo:
    def __init__(self,headers):
        self.headers = headers

    @ornament
    def getAllGroups(self):
        #get All Groups infomation
        try:
            self.r = requests.get("%s/%s/%s/chatgroups" %(url,org,app), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def getLimitGroups(self):
        #get 10 Groups infomation
        try:
            self.r = requests.get("%s/%s/%s/chatgroups?limit=10" %(url,org,app), headers=self.headers)
            global groupid,data
            data = self.r.json()
            groupid = data['data'][0]['groupid']
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r
    @ornament
    def getPublicGroups(self):
        #get All Public Groups infomation
        try:
            self.r = requests.get("%s/%s/%s/publicchatgroups" %(url,org,app), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    def getGroupDetail(self):
        #get  Groups infomation
        print "groupid is: ",groupid
        try:
            self.r = requests.get("%s/%s/%s/chatgroups/%s" %(url,org,app,groupid), headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["data"][0]["owner"] and data1["data"][0]["id"] and data1["data"][0]["maxusers"]:
                    print "get group details success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get group details failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError,e:
            print "Your url is error: %s" % e
            return False

    @ornament
    def getMultiGrpDetail(self):
        #get multi Groups infomation
        groupid1 = data['data'][0]['groupid']
        groupid2 = data['data'][1]['groupid']
        groupid3 = data['data'][2]['groupid']
        print "multi groupid is: ",groupid1,groupid2,groupid3
        try:
            self.r = requests.get("%s/%s/%s/chatgroups/%s,%s,%s" %(url,org,app,groupid1,groupid2,groupid3), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    def getGroupMember(self):
        #get Groups member
        print "groupid is: ",groupid
        try:
            self.r = requests.get("%s/%s/%s/chatgroups/%s/users" %(url,org,app,groupid), headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["data"]:
                    print "get group members success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get group members failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError,e:
            print "Your url is error: %s" % e
            return False

    @ornament
    def getGrpBlacklit(self):
        # get Groups black list
        print "groupid is: ", groupid
        try:
            self.r = requests.get("%s/%s/%s/chatgroups/%s/blocks/users" % (url, org, app, groupid), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def getjoinAllGrp(self):
        # get user joined all Groups
        try:
            self.r = requests.get("%s/%s/%s/users/%s/joined_chatgroups" %(url, org, app, user1),
                                  headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def getmutelist(self):
        # get group muted list
        print "groupid is: ", groupid
        try:
            self.r = requests.get("%s/%s/%s/chatgroups/%s/mute" % (url, org, app, groupid),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def ShareFilelist(self):
        # get group share files list
        print "groupid is: ", groupid
        try:
            self.r = requests.get("%s/%s/%s/chatgroups/%s/share_files" % (url, org, app, groupid), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def getAdminlist(self):
        # get group admin list
        print "groupid is: ", groupid
        try:
            self.r = requests.get("%s/%s/%s/chatgroups/%s/admin" % (url, org, app, groupid), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r




class OperateGroup:
    def __init__(self,headers,CrePubGrpBody,multiMemBody,grpTransBody,modgrpBody,mulMemtoblackBody,
                 muteMemBody,addAdminBody,pubGrpVerifyBody,verifyBody,privateBody,privateAllowBody):
        self.headers = headers
        self.cpgbody = CrePubGrpBody
        self.multiMem = multiMemBody
        self.transbody = grpTransBody
        self.modifygrp = modgrpBody
        self.MemstoblkBody = mulMemtoblackBody
        self.muteMemBody = muteMemBody
        self.addAdminBody = addAdminBody
        self.CPGVbody = pubGrpVerifyBody
        self.verifyBody = verifyBody
        self.privateBody = privateBody
        self.privateAllowBody = privateAllowBody

    def CrePubGrp(self):
        try:
            self.r = requests.post("%s/%s/%s/chatgroups" % (url, org, app),data=json.dumps(self.cpgbody), headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                global groupid
                groupid = data1['data']['groupid']
                #get group all members api
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                for a in data2['data']:
                    for x, y in a.items():
                        if x == 'owner':
                            owners = y
                if owners == user1:
                    print "Create public groups success, group id is: ",groupid
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True,groupid
                else:
                    print "Create public groups Failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False,None
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e,None
            return False


    def groupAddMem(self,groupid):
        # add a member go group
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/chatgroups/%s/users/%s" % (url, org, app, groupid,user3), headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                newmembers = []
                for a in data2['data']:
                    for x, y in a.items():
                        newmembers.append(y)
                if user3 in newmembers:
                    print "add group member %s success, group all member is: %s" %(user3,data2["data"])
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "add group member %s failed, group all member is: %s" %(user3,data2["data"])
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False


    def GrpAddMulMem(self, groupid):
        # add multi membet go group
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/chatgroups/%s/users/" % (url, org, app, groupid),data=json.dumps(self.multiMem),
                                   headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    newmembers = []
                    for a in data2['data']:
                        for x, y in a.items():
                            newmembers.append(y)
                    if user4 in newmembers and user5 in newmembers:
                        print "add group multe members %s %s success, group all member is: %s" %(user4,user5,data2["data"])
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "add group multe members %s %s failed, group all member is: %s" %(user4,user5,data2["data"])
                        print json.dumps(data2, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, get groups all members request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False


    def GrpTransfer(self, groupid):
        # group Transfer
        print "groupid is: ", groupid
        try:
            self.r = requests.put("%s/%s/%s/chatgroups/%s" % (url, org, app, groupid),data=json.dumps(self.transbody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    for a in data2['data']:
                        for x, y in a.items():
                            if x == 'owner':
                                newowner = y
                    if newowner == user2:
                        print "Transfer groups new owner %s success, group members: %s" %(user2,data2["data"])
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True, groupid
                    else:
                        print "Transfer groups new owner %s Failed, group members: %s" %(user2,data2["data"])
                        print "group Transfer api return: "
                        print json.dumps(data1, sort_keys=True, indent=2)
                        print "get group all members api return: "
                        print json.dumps(data2, sort_keys=True, indent=2)
                        return False, None
                else:
                    print "status code is %s, get groups all members request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False,None


    def modifyGrp(self, groupid):
        # modify group
        print "groupid is: ", groupid
        try:
            # group details api
            get = requests.get("%s/%s/%s/chatgroups/%s" % (url, org, app, groupid), headers=self.headers)
            data0 =get.json()
            oldmaxuser = data0['data'][0]['maxusers']
            oldname = data0['data'][0]['name']
            self.r = requests.put("%s/%s/%s/chatgroups/%s" % (url, org, app, groupid),data=json.dumps(self.modifygrp),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                # group details api
                get = requests.get("%s/%s/%s/chatgroups/%s" % (url, org, app, groupid), headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    newmaxuser = data2['data'][0]['maxusers']
                    newname = data2['data'][0]['name']
                    if newmaxuser == self.modifygrp["maxusers"] and newname == self.modifygrp["groupname"]:
                        print "Modify groups infomation success, group maxuser old is: %s, new is: %s; groupname old is: %s, new is: %s" % (oldmaxuser,newmaxuser,oldname,newname)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "Modify groups infomation failed, group maxuser old is: %s, new is: %s; groupname old is: %s, new is: %s" % (oldmaxuser,newmaxuser,oldname,newname)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        print "get group details api return: "
                        print json.dumps(data2, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, get group details api request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def delGrpMem(self, groupid):
        # delete a group member
        print "groupid is: ", groupid
        try:
            #Get All members of a Group
            get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
            if get.status_code == 200:
                data0 = get.json()
                oldmember = []
                for a in data0['data']:
                    for x, y in a.items():
                        oldmember.append(y)
                self.r = requests.delete("%s/%s/%s/chatgroups/%s/users/%s" % (url, org, app, groupid, user3),headers=self.headers)
                if self.r.status_code == 200:
                    data1 = self.r.json()
                    get2 = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                    data2 = get2.json()
                    newmember = []
                    for a in data2['data']:
                        for x, y in a.items():
                            newmember.append(y)
                    if user3 in oldmember and user3 not in newmember:
                        print "delete group member %s success, now members list is: %s" %(user3,newmember)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "delete group member %s failed, now members list is: %s" %(user3,newmember)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % self.r.status_code
                    print json.dumps(self.r.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, Get All members of a Group request error" % get.status_code
                print json.dumps(get.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def delMultiMem(self, groupid):
        # delete multi group membet
        print "groupid is: ", groupid
        try:
            get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
            data0 = get.json()
            oldmember = []
            for a in data0['data']:
                for x, y in a.items():
                    oldmember.append(y)
            self.r = requests.delete("%s/%s/%s/chatgroups/%s/users/%s,%s" % (url, org, app, groupid, user4,user5),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                newmember = []
                for a in data2['data']:
                    for x, y in a.items():
                        newmember.append(y)
                if user4 not in newmember and user5 not in newmember:
                    print "delete group multi member %s %s success, now members list is: %s" %(user4,user5,newmember)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "delete group multi member %s %s failed, now members list is: %s" %(user4,user5,newmember)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e

    def MemToBlack(self, groupid):
        #move group member to black
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/chatgroups/%s/blocks/users/%s" % (url, org, app, groupid, user3),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get1 = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                if get1.status_code == 200:
                    data2 = get1.json()
                    nowmember = []
                    for a in data2['data']:
                        for x, y in a.items():
                            nowmember.append(y)
                else:
                    print "status code is %s, get group all members request error" % get1.status_code
                    print json.dumps(get1.json(), sort_keys=True, indent=2)
                    return False
                get2 = requests.get("%s/%s/%s/chatgroups/%s/blocks/users" % (url, org, app, groupid), headers=self.headers)
                if get2.status_code == 200:
                    data3 = get2.json()
                    blacklist = data3['data']
                    if user3 in blacklist and user3 not in nowmember:
                        print "move %s to black success, now member is: %s" %(user3,nowmember)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "move %s to black failed, now member is: %s" % (user3, nowmember)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, get black list request error" % get2.status_code
                    print json.dumps(get2.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def MultiMemToBlack(self, groupid):
        # move multi group member to black
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/chatgroups/%s/blocks/users" % (url, org, app, groupid),
                                   data=json.dumps(self.MemstoblkBody),
                                   headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                nowmember = []
                for a in data2['data']:
                    for x, y in a.items():
                        nowmember.append(y)
                get = requests.get("%s/%s/%s/chatgroups/%s/blocks/users" % (url, org, app, groupid), headers=self.headers)
                data3 = get.json()
                blacklist = data3['data']
                print "black list is: ",blacklist
                if user4 in blacklist and user4 not in nowmember and user5 in blacklist and user5 not in nowmember:
                    print "move %s and %s to black success, now member is: %s" % (user4,user5, nowmember)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "move %s and %s to black failed, now member is: %s" % (user4,user5, nowmember)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def RmBlackMem(self, groupid):
        #rm member from black
        print "groupid is: ", groupid
        try:
            self.r = requests.delete("%s/%s/%s/chatgroups/%s/blocks/users/%s" % (url, org, app, groupid, user3),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/blocks/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                blacklist = data2['data']
                if user3 not in blacklist:
                    print "remove %s member from blacklist success, now blacklist is: %s" % (user3, blacklist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "remove %s member from blacklist failed, now blacklist is: %s" % (user3, blacklist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def RmBlkMultiMem(self, groupid):
        # rm multi member from black
        print "groupid is: ", groupid
        try:
            self.r = requests.delete("%s/%s/%s/chatgroups/%s/blocks/users/%s,%s" % (url, org, app, groupid, user4,user5),
                                     headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/blocks/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                blacklist = data2['data']
                if user4 not in blacklist and user5 not in blacklist:
                    print "remove %s %s members from blacklist success, now blacklist is: %s" % (user4,user5, blacklist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "remove %s %s members from blacklist failed, now blacklist is: %s" % (user4,user5, blacklist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    @ornament
    def sendGrpMess(self, groupid):
        # send group message
        sendmessBody = { "target_type":"chatgroups",
                 "target":[groupid],
                 "msg":{
                 "type":"txt",
                 "msg":messages
                },
                "from":"rest"
        }
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url, org, app),data=json.dumps(sendmessBody),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    def MuteMember(self, groupid):
        # mute member
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/chatgroups/%s/mute" % (url, org, app, groupid),data = json.dumps(self.muteMemBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/mute" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                mutelist = []
                if data2['data']:
                    for a in data2['data']:
                        mutelist.append(a['user'])
                    if user3 in mutelist:
                        print "mute user %s success, mute list is: %s" %(user3,mutelist)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "mute user %s failed" % user3
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "mute user %s failed" % user3
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e

    def unMuteMember(self, groupid):
        # unmute member
        print "groupid is: ", groupid
        try:
            self.r = requests.delete("%s/%s/%s/chatgroups/%s/mute/%s" % (url, org, app, groupid,user3),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/mute" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                mutelist = []
                if data2['data']:
                    for a in data2['data']:
                        mutelist.append(a['user'])
                    if user3 not in mutelist:
                        print "unmute user %s success, mute list is: %s" % (user3, mutelist)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "unmute user %s failed, mute list is: %s" % (user3, mutelist)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "unmute user %s success" % user3
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def addAdmin(self, groupid):
        # add a  member to admin
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/chatgroups/%s/admin" % (url, org, app, groupid),data=json.dumps(self.addAdminBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/admin" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                adminlist = data2['data']
                if user1 in adminlist:
                    print "add member %s to admin success, admin list is: %s" %(user1,adminlist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "add member %s to admin failed, admin list is: %s" % (user1, adminlist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def delAdmin(self, groupid):
        # delete a member to admin
        print "groupid is: ", groupid
        try:
            self.r = requests.delete("%s/%s/%s/chatgroups/%s/admin/%s" % (url, org, app, groupid,user1),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/admin" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                adminlist = data2['data']
                if user1 not in adminlist:
                    print "delete member %s from admin list success, admin list is: %s" % (user1, adminlist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "delete member %s from admin list  failed, admin list is: %s" % (user1, adminlist)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def ApplyJoinGrp(self, groupid):
        # apply to join group, this api need user token to apply join group
        print "groupid is: ", groupid
        try:
            tkBody =  {
                    "grant_type": "password",
                    "username": user3,
                    "password": "1"
                    }
            req = requests.post("%s/%s/%s/token" % (url, org, app), data=json.dumps(tkBody),
                                headers={'Accept': 'application/json', 'Content-Type': 'application/json'})
            if req.status_code == 200:
                contents = json.loads(req.content)
                usertokens = contents["access_token"]
                expires_in = contents["expires_in"]
                print "token is: ",usertokens
                print "expires is: ", expires_in
            else:
                print "get user token api error"
                print "status code is: ",req.status_code, req.content
            global userheaders
            userheaders = {'Accept': 'application/json',
                       'Content-Type': 'application/json',
                       'Authorization': "Bearer %s" % usertokens}
            self.r = requests.post("%s/%s/%s/chatgroups/%s/apply" % (url, org, app, groupid),headers=userheaders)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                members = []
                for a in data2['data']:
                    for x, y in a.items():
                        members.append(y)
                print "members is: ",members
                if user3 in members:
                    print "user %s apply join groups is success, now members is: %s" %(user3,members)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "user %s apply join groups is failed, now members is: %s" % (user3, members)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def deleteGroup(self,groupid):
        # delete a group
        print "groupid is: ", groupid
        try:
            self.r = requests.delete("%s/%s/%s/chatgroups/%s" % (url, org, app, groupid), headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                if get.status_code == 404 and groupid in data2['error_description']:
                    print "delete group %s success" %groupid
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "delete group %s failed" % groupid
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def CrePubVerify(self):
        try:
            self.r = requests.post("%s/%s/%s/chatgroups" % (url, org, app),data=json.dumps(self.CPGVbody), headers=self.headers)
            if self.r.status_code == 200:
                data = self.r.json()
                if data['data']['groupid']:
                    global cPubVrfyGrpID
                    cPubVrfyGrpID = data['data']['groupid']
                    print "Create public need verify groups success, group id is: ",cPubVrfyGrpID
                    print json.dumps(data, sort_keys=True, indent=2)
                    return True,cPubVrfyGrpID
                else:
                    print "Create public need verify groups Failed"
                    return False,None
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False,None

    def vefyAlyJoinGrp(self, groupid):
        # verify apply join group
        print "groupid is: ", groupid
        try:
            self.r = requests.post("%s/%s/%s/chatgroups/%s/apply_verify" % (url, org, app, groupid),data=json.dumps(self.verifyBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                members = []
                for a in data2['data']:
                    for x, y in a.items():
                        members.append(y)
                print "members is: ", members
                if user3 in members:
                    print "verify user %s apply join groups is success, now members is: %s" % (user3, members)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "verify user %s apply join groups is failed, now members is: %s" % (user3, members)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def CrePrivateGrp(self):
        try:
            self.r = requests.post("%s/%s/%s/chatgroups" % (url, org, app),data=json.dumps(self.privateBody), headers=self.headers)
            if self.r.status_code == 200:
                data = self.r.json()
                if data['data']['groupid']:
                    global GroupID
                    GroupID = data['data']['groupid']
                    print "Create private groups success, group id is: ",GroupID
                    print json.dumps(data, sort_keys=True, indent=2)
                    return True,GroupID
                else:
                    print "Create private groups Failed"
                    return False,None
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False,None

    def CtePrivAllowGrp(self):
        try:
            self.r = requests.post("%s/%s/%s/chatgroups" % (url, org, app),data=json.dumps(self.privateAllowBody), headers=self.headers)
            if self.r.status_code == 200:
                data = self.r.json()
                if data['data']['groupid']:
                    global GroupID
                    GroupID = data['data']['groupid']
                    print "Create private allow Invite groups success, group id is: ",GroupID
                    print json.dumps(data, sort_keys=True, indent=2)
                    return True,GroupID
                else:
                    print "Create private allow Invite groups Failed"
                    return False,None
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False,None

    def LeaveGroup(self, groupid):
        # leave the group   user3
        print "groupid is: ", groupid
        try:
            self.r = requests.delete("%s/%s/%s/chatgroups/%s/quit" % (url, org, app, groupid), headers=userheaders)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatgroups/%s/users" % (url, org, app, groupid), headers=self.headers)
                data2 = get.json()
                members = []
                for a in data2['data']:
                    for x, y in a.items():
                        members.append(y)
                print "members is: ", members
                if user3 not in members:
                    print "user %s leave groups is success, now members is: %s" % (user3, members)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "verify user %s apply join groups is failed, now members is: %s" % (user3, members)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False





