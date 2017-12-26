#coding:utf-8

import sys
sys.path.append("..")

from apiconfig import *
from User.userbody import *
import requests
import json,time

class UserManage:
    def __init__(self,headers,userToken,cteUserBody,cteMultiUsrBody,setPWordBody,nicknameBody,MulUserStatBody):
        self.headers = headers
        self.userToken = userToken
        self.cteUserBody = cteUserBody
        self.cteMultiUsrBody = cteMultiUsrBody
        self.setPWordBody = setPWordBody
        self.nicknameBody = nicknameBody
        self.MulUserStatBody = MulUserStatBody

    def getClitSecret(self):
        # get client secret
        try:
            self.r = requests.get("%s/%s/%s/credentials" % (url, org, app),headers=self.headers)
            if self.r.status_code == 200:
                data = self.r.json()
                if data['credentials']['client_id']:
                    client_id = data['credentials']['client_id']
                    client_secret = data['credentials']['client_secret']
                    print "Get client secret success, client_id is: %s, client_secret is: %s" %(client_id,client_secret)
                    print json.dumps(data, sort_keys=True, indent=2)
                    return True, client_id,client_secret
                else:
                    print "Get client secret Failed"
                    return False, None, None
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except (KeyError,requests.exceptions.ConnectionError), e:
            return "Your url error or response result no json: " % e, None, None

    def getAdminToken(self, client_id,client_secret):
        # get admin token
        admTokenBody = {
            "grant_type": "client_credentials",
            "client_id": client_id,
            "client_secret": client_secret
        }
        try:
            self.r = requests.post("%s/%s/%s/token" % (url, org, app),
                                   data=json.dumps(admTokenBody),
                                   headers={'Content-Type': 'application/json'})
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["access_token"]:
                    print "get admin token success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get admin token failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return True

    def getUserToken(self):
        # get user token
        try:
            self.r = requests.post("%s/%s/%s/token" % (url, org, app),
                                   data=json.dumps(self.userToken),
                                   headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["access_token"]:
                    print "get user token success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get user token failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    @ornament
    def getAllUser(self):
        # get All user info
        try:
            self.r = requests.get("%s/%s/%s/users" % (url, org, app),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def CreateUser(self):
        # create a user
        try:
            self.r = requests.post("%s/%s/%s/users" % (url, org, app),data=json.dumps(self.cteUserBody),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r

    def CrteMulieUser(self):
        # create multi users
        try:
            self.r = requests.post("%s/%s/%s/users" % (url, org, app),data=json.dumps(self.cteMultiUsrBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get1 = requests.get("%s/%s/%s/users/%s" % (url, org, app, user7),headers=self.headers)

                get2 = requests.get("%s/%s/%s/users/%s" % (url, org, app, user8),headers=self.headers)
                get3 = requests.get("%s/%s/%s/users/%s" % (url, org, app, user9),headers=self.headers)
                if get1.status_code == 200 and get2.status_code == 200 and get3.status_code == 200:
                    print "create multi user success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "create multi user failed, get %s detail status_code is: %s, " \
                          "get %s detail status_code is: %s, get %s detail status_code is: %s," %(user7,get1.status_code,
                                                                                                  user8,get2.status_code,
                                                                                                  user9,get3.status_code)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    @ornament
    def getUserDetail(self):
        # get a user details
        try:
            self.r = requests.get("%s/%s/%s/users/%s" % (url, org, app, user6),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def getMulUsrDetail(self):
        # get Multi user detail
        try:
            self.r = requests.get("%s/%s/%s/users?limit=30" % (url, org, app),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def ChkOnlineStat(self):
        # check user onine status
        try:
            self.r = requests.get("%s/%s/%s/users/%s/status" % (url, org, app, user1),
                                  headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r

    def deleteUser(self,user):
        # delete a user
        try:
            self.r = requests.delete("%s/%s/%s/users/%s" % (url, org, app, user),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                time.sleep(1)
                get = requests.get("%s/%s/%s/users/%s" % (url, org, app, user),headers=self.headers)
                data2 = get.json()
                if get.status_code == 404:
                    print "delete user %s success" % user
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "delete user %s failed, get deleted user detail status code is not 404, is %s " % (user,get.status_code)
                    print "delete user,get user detail: "
                    print json.dumps(data2, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    @ornament
    def delMultiUser(self):
        # delete multi users
        try:
            self.r = requests.delete("%s/%s/%s/users?limit=5" % (url, org, app),
                                     headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def ResetPword(self):
        # reset password to user
        try:
            self.r = requests.put("%s/%s/%s/users/%s/password" % (url, org, app, user5),
                                  data=json.dumps(self.setPWordBody),
                                  headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r


    def ModifyNickname(self):
        # modify nickname for user
        try:
            self.r = requests.put("%s/%s/%s/users/%s" % (url, org, app, user5),
                                  data=json.dumps(self.nicknameBody),
                                  headers=self.headers)
            if self.r.status_code == 200:
                data = self.r.json()
                newname = data['entities'][0]['nickname']
                print "new nice name is: ",newname
                if newname and newname == self.nicknameBody["nickname"]:
                    print "modify nickname success"
                    print json.dumps(data, sort_keys=True, indent=2)
                    return True
                else:
                    print "modify nickname failed"
                    print json.dumps(data, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except (ValueError,Exception),e:
            print "response result no json",json.dumps(data, sort_keys=True, indent=2),e
            return False

    def addFriends(self,user,friend):
        # add friend for user
        try:
            self.r = requests.post("%s/%s/%s/users/%s/contacts/users/%s" % (url, org, app, user,friend),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/users/%s/contacts/users" % (url, org, app, user),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if friend in data2["data"]:
                        print "user %s additional friend %s success" %(user,friend)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "user %s additional friend %s failed" % (user, friend)
                        print "get user friends list return data: "
                        print json.dumps(data2, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    def delFriends(self, user, friend):
        # del friend for user
        try:
            self.r = requests.delete("%s/%s/%s/users/%s/contacts/users/%s" % (url, org, app, user, friend),
                                   headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/users/%s/contacts/users" % (url, org, app, user),
                                   headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if friend not in data2["data"]:
                        print "user %s delete friend %s success" % (user, friend)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "user %s delete friend %s failed" % (user, friend)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    def FriendsList(self, user):
        # get friend list
        try:
            self.r = requests.get("%s/%s/%s/users/%s/contacts/users" % (url, org, app, user),
                                     headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["data"]:
                    print "get friend list success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get friend list failed，error status code is: %s" % self.r.status_code
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    @ornament
    def MvToBlack(self, user,friend):
        # move friend to black list
        MvblackBody = {"usernames": [friend]}
        try:
            self.r = requests.post("%s/%s/%s/users/%s/blocks/users" % (url, org, app, user),
                                   data=json.dumps(MvblackBody),
                                  headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" %e
        else:
            return self.r

    def GetBlackList(self, user):
        # get user  black list
        try:
            self.r = requests.get("%s/%s/%s/users/%s/blocks/users" % (url, org, app, user),
                                   headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["data"]:
                    print "%s add black user and get black user success" %user
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "%s add black user and get black user failed" % user
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    def RmBlkList(self, user,blackuser):
        # remove friend from black list
        try:
            self.r = requests.delete("%s/%s/%s/users/%s/blocks/users/%s" % (url, org, app, user,blackuser),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/users/%s/blocks/users" % (url, org, app, user),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if blackuser not in data2["data"]:
                        print "blackuser %s remove from black list success" %blackuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "blackuser %s remove from black list failed" % blackuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    def DeactivateUser(self, user):
        # Deactivate a User
        try:
            self.r = requests.post("%s/%s/%s/users/%s/deactivate" % (url, org, app, user),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/users/%s" % (url, org, app, user),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if data2['entities'][0]['username'] == user and data2['entities'][0]['activated'] == False:
                        print "deactivate user %s success" % user
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "deactivate user %s failed" % user
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    def ActivateUser(self, user):
        # Activate a User
        try:
            self.r = requests.post("%s/%s/%s/users/%s/activate" % (url, org, app, user),
                                   headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/users/%s" % (url, org, app, user),
                                   headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    activate = data2['entities'][0]['activated']
                    if data2['entities'][0]['username'] == user and data2['entities'][0]['activated'] == True:
                        print "Activate user %s success" % user
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "Activate user %s failed" % user
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    def DisconnectUser(self):
        # Disconnect User
        try:
            self.r = requests.get("%s/%s/%s/users/%s/disconnect" % (url, org, app, user1),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/users/%s/status" % (url, org, app, user1),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if data2["data"][user1]== 'offline':
                        print "Disconnect user %s success" %user1
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "Disconnect user %s failed" %user1
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False

    def MulUserStatus(self):
        # check multi user online status
        try:
            self.r = requests.post("%s/%s/%s/users/batch/status" % (url, org, app),
                                   data=json.dumps(self.MulUserStatBody),
                                   headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                users = []
                for a in data1['data']:
                    for x, y in a.items():
                        users.append(x)
                if user1 in users and user2 in users and user3 in users:
                    print "get multi users %s %s %s online status success" %(user1,user2,user3)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get multi users %s %s %s online status failed" % (user1, user2, user3)
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" %e
            return False
