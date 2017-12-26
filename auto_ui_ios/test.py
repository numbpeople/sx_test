# -*- coding:utf-8 -*-
from appium import webdriver
from auto_ui_ios_multi_devices import *
user1 = "test001"
user2 = "test002"
user3 = "test003"
psw = "1"


wd1 = start_demo('79CC5ED6-3EAF-4A9A-9D68-7B2C2BF004B7','iPhone 7',8100)
accept_alert(wd1)

#delete_user(user1)
register_user(wd1,user1,psw)
login(wd1,user1,psw)
send_text_to_user(wd1,wd2,user1,user2,'chat message')