#coding= utf-8
import sys
import unittest

sys.path.append("..")

from apiconfig import *
from User.proUserMan import *
from User.userbody import *


class TestUserManage(unittest.TestCase):
    def setUp(self):
        self.TUM = UserManage(headers,userToken,cteUserBody,cteMultiUsrBody,setPWordBody,nicknameBody,MulUserStatBody)
    def testClitSecret_1(self):
        u'验证获取client secret'
        global client_id,client_secret
        result,client_id,client_secret = self.TUM.getClitSecret()
        self.assertTrue(result,True)
    def testGetAdmToken_2(self):
        u'验证获取admin的Token'
        self.assertTrue(self.TUM.getAdminToken(client_id,client_secret), True)
    def testUserToken_3(self):
        u'验证获取用户的Token'
        self.assertTrue(self.TUM.getUserToken(), True)
    def testGetAllUser_4(self):
        u'验证获取所有用户'
        self.assertEqual(self.TUM.getAllUser(),200)
    def testCrteUser_5(self):
        u'验证创建用户'
        self.assertEqual(self.TUM.CreateUser(),200)
    def testCteMulUser_6(self):
        u'验证创建多个用户'
        self.assertTrue(self.TUM.CrteMulieUser(), True)
    def testGetUsrDetail_7(self):
        u'验证获取用户详情'
        self.assertEqual(self.TUM.getUserDetail(),200)
    def testMulUsrDetail_8(self):
        u'验证获取多个用户详情'
        self.assertEqual(self.TUM.getMulUsrDetail(),200)
    def testChkOnlineStat_9(self):
        u'验证检查用户是否在线'
        self.assertEqual(self.TUM.ChkOnlineStat(),200)
    def testDelUser_10(self):
        u'验证删除一个用户'
        self.assertTrue(self.TUM.deleteUser("rest116"), True)
        self.TUM.deleteUser("rest117")
        self.TUM.deleteUser("rest118")
        self.TUM.deleteUser("rest119")
        self.TUM.deleteUser("rest120")
        self.TUM.deleteUser("rest121")

    def testResetPword_11(self):
        u'验证修改用户密码'
        self.assertEqual(self.TUM.ResetPword(),200)
    def testModNickname_12(self):
        u'验证修改nickname'
        self.assertTrue(self.TUM.ModifyNickname(),True)
    def testAddFriend_13(self):
        u'验证为用户添加一个好友'
        self.assertTrue(self.TUM.addFriends(user1,user2), True)
        self.TUM.addFriends(user1, user3)
        self.TUM.addFriends(user1, user4)
        self.TUM.addFriends(user1, user5)
    def testDelFriend_14(self):
        u'验证删除用户的一个好友'
        self.assertTrue(self.TUM.delFriends(user1, user5), True)
    def testGetFridList_15(self):
        u'验证获取好友列表'
        self.assertTrue(self.TUM.FriendsList(user1), True)
    def testMvToBlack_16(self):
        u'验证将好友移到黑名单'
        self.assertEqual(self.TUM.MvToBlack(user1,user2),200)
    def testGetBlackList_17(self):
        u'验证获取黑名单列表'
        self.assertTrue(self.TUM.GetBlackList(user1), True)
    def testRmBlkList_18(self):
        u'验证将好友从黑名单列表移除'
        self.assertTrue(self.TUM.RmBlkList(user1,user2), True)
    def testDeactivUser_19(self):
        u'验证Deactivate用户'
        self.assertTrue(self.TUM.DeactivateUser(user5), True)
    def testActivUser_20(self):
        u'验证Activate User'
        self.assertTrue(self.TUM.ActivateUser(user5), True)
    def testDsconnectUser_21(self):
        u'验证Disconnect User'
        self.assertTrue(self.TUM.DisconnectUser(), True)
    def testMulUsrOnline_22(self):
        u'验证多用户在线状态'
        self.assertTrue(self.TUM.MulUserStatus(), True)



class TestDelOperate(TestUserManage):
    def testDelMulUser_1(self):
        u'验证删除多个用户'
        self.assertEqual(self.TUM.delMultiUser(),200)