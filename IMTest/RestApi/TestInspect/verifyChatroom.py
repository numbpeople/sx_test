#coding= utf-8
import sys
import unittest


sys.path.append("..")

from apiconfig import *
from Chatroom.proChatroom import *
from Chatroom.roombody import *

class TestChatRoom(unittest.TestCase):
    def setUp(self):
        self.TCR = chatroom(headers,CteroomBody,modifyBody,MultiMemBody)
    def testCteroom_1(self):
        u'验证创建聊天室'
        global roomid
        result,roomid = self.TCR.Ctechatroom()
        self.assertTrue(result, True)
    def testGetAllRoom_2(self):
        u'验证获取所有聊天室'
        self.assertTrue(self.TCR.getAllRoom(), True)
    def testModifyRoom_3(self):
        u'验证修改聊天室'
        self.assertTrue(self.TCR.ModifyRoom(roomid), True)
    def testRoomDetail_4(self):
        u'验证获取聊天室详情'
        self.assertTrue(self.TCR.getRoomDetail(roomid), True)
    def testInviteMem_5(self):
        u'验证邀请聊天室成员'
        self.assertTrue(self.TCR.InviteMemRoom(roomid,user2), True)
    def testInvtMulMem_6(self):
        u'验证邀请多个聊天室成员'
        self.assertTrue(self.TCR.InvMultiMemRoom(roomid), True)
    def testKickMemRoom_7(self):
        u'验证从聊天室踢掉一个成员'
        self.assertTrue(self.TCR.KickMemRoom(roomid,user2), True)
    def testKickMulMem_8(self):
        u'验证从聊天室踢掉多个成员'
        self.assertTrue(self.TCR.KickMultiMemRoom(roomid), True)
    def testJoinAllRooms_9(self):
        u'验证查询用户加入的所有聊天室'
        self.assertTrue(self.TCR.getJoinAllRoom(user1), True)
    def testGetAllRobot_10(self):
        u'验证查询所有的Robots'
        self.assertEqual(self.TCR.getAllRobot(),200)
    def testSendMessRoom_11(self):
        u'验证发送消息到聊天室'
        self.assertEqual(self.TCR.SendMessRoom(roomid),200)
    def testAddRoomAdmin_12(self):
        u'验证增加一个聊天室管理员'
        self.assertTrue(self.TCR.AddAdminRoom(roomid,user2), True)
    def testgetAdminList_13(self):
        u'验证查看管理员列表'
        self.assertTrue(self.TCR.getAdminList(roomid), True)
    def testRmRoomAdmin_14(self):
        u'验证移除一个聊天室管理员'
        self.assertTrue(self.TCR.RmRoomAdmin(roomid,user2), True)
    def testMuteMembet_15(self):
        u'禁言一个聊天室成员'
        self.assertTrue(self.TCR.RoomMuteMember(roomid,user2), True)
    def testGetMuteList_16(self):
        u'获取禁言成员的列表'
        self.assertTrue(self.TCR.getMuteList(roomid), True)
    def testRmMuteMember_17(self):
        u'给禁言成员解除禁言'
        self.assertTrue(self.TCR.RmMuteMember(roomid,user2), True)
    def testDelChatroom_18(self):
        u'删除聊天室'
        self.assertTrue(self.TCR.DelChatRoom(roomid), True)
