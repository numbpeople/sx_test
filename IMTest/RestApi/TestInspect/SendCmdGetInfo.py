#coding= utf-8
import sys
import unittest


sys.path.append("..")

from apiconfig import *
from Chat.sendCMDgetInfo import *

class TestCmdMessageGetInfo(unittest.TestCase):

    def setUp(self):
        self.SCMGI = SendCmdGetInfo(headers,sendCmdbody,sendCmdStartDebugbody,sendCmdStopDebugbody,
                                    sendCmdUploadLogbody,sendCmdChagServerbody,sendCmdChagAppkeyboey,sendBroadcastbody)
    def testCmdMess_1(self):
        u'''发送一个命令消息'''
        self.assertEqual(self.SCMGI.sendCmdMess(), 200)
    def testCmdStartDebug_2(self):
        u'''发送命令开启debug'''
        self.assertEqual(self.SCMGI.sendCmdStartDebugmess(),200)
    def testCmdStopDebug_3(self):
        u'''发送命令关闭debug'''
        self.assertEqual(self.SCMGI.sendCmdStopDebugmess(),200)
    def testCmdUploadLog_4(self):
        u'''发送命令上传日志'''
        self.assertEqual(self.SCMGI.sendCmdUploadLogMess(),200)
    def testCmdChagServer_5(self):
        u'''发送命令改变服务器地址'''
        self.assertEqual(self.SCMGI.sendCmdChagServerMess(),200)
    def testCmdChagAppkey_6(self):
        u'''发送命令改变key'''
        self.assertEqual(self.SCMGI.sendCmdChagAppkeyMess(),200)
    def testgetUserHistory_7(self):
        u'''获取用户聊天历史记录-沙箱测试专用(老接口)'''
        self.assertEqual(self.SCMGI.getUserChatHistoryMess(),200)
    def testGetOfflineMessCout_8(self):
        u'''获取用户离线消息数目'''
        self.assertEqual(self.SCMGI.getOfflineMessCout(),200)
    def testChkOffliMessStat_9(self):
        u'''检查用户离线消息状态'''
        self.assertEqual(self.SCMGI.ChkOffliMessStat(),200)
    def testSendBCMess_10(self):
        u'''发送广播消息'''
        self.assertEqual(self.SCMGI.sendBroadcastMess(),200)
    def testChatMessage_11(self):
        u'获取用户聊天历史记录-线上测试专用(新接口)'
        self.assertTrue(self.SCMGI.NewUserHistoryMess(), True)

    def tearDown(self):
        self.SCMGI = None




