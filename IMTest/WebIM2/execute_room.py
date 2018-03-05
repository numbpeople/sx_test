#coding: utf-8
import time,sys,requests
sys.path.append("..")
from selenium import webdriver
from config import *
from chat_room import ChatRoom
import unittest


class TestChatRoom(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.driver3 = webdriver.Chrome()
        self.threeuser = ChatRoom(self.driver3, user3, gpasswd, url, user2,groupname)
        options = webdriver.ChromeOptions()
        options.add_argument('disable-infobars')
        self.browser = webdriver.Chrome(chrome_options=options)
        self.twouser = ChatRoom(self.browser, user2, gpasswd, url, user1,groupname)
        driver1 = webdriver.Chrome()
        self.oneuser = ChatRoom(driver1, user1, gpasswd, url, user2,groupname)

    def testJoinChatroom_1(self):
        u'验证加入聊天室'
        global roomID
        self.oneuser.sign_in()
        self.twouser.sign_in()
        self.threeuser.sign_in()
        self.oneuser.login()
        self.twouser.login()
        roomID = createroom()
        self.oneuser.JoinAssignRoom(roomID)
        self.twouser.JoinAssignRoom(roomID)
        self.threeuser.login()
        self.assertTrue(self.threeuser.JoinAssignRoom(roomID), True)
    def testSendImage_2(self):
        u'验证chatroom发送图片'
        self.oneuser.sendimage()
        self.assertTrue(self.twouser.receiveimage(), True)
    def testSendFile_3(self):
        u'验证chatroom发送文件'
        self.oneuser.sendfile()
        self.assertTrue(self.twouser.receivefile(), True)
    def testSdMultiMess_4(self):
        u'验证发送多条消息'
        self.twouser.sendroomMess(groupmess_num)
        self.assertTrue(self.threeuser.RoomMessNum(groupmess_num), True)
    def testCleanMessage_5(self):
        u'验证清除所有消息'
        self.oneuser.sendroomMess(groupmess_num)
        self.threeuser.RoomMessNum(groupmess_num)
        time.sleep(2)
        self.threeuser.cleanchat()
        self.assertFalse(self.threeuser.RoomMessNum(groupmess_num), False)
        delroom(roomID)

    @classmethod
    def tearDownClass(self):
        self.oneuser.quitBrowser()
        self.threeuser.quitBrowser()
        self.twouser.quitBrowser()
        self.oneuser = None
        self.twouser = None
        self.threeuser = None
