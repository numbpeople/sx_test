# -*- coding:utf-8 -*-
from appium import webdriver
import requests
import urllib2
import time
import os
import json
import random
import string
from time import sleep
from appium.webdriver.common.touch_action import TouchAction
from selenium.webdriver.firefox.webdriver import WebDriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from appium.webdriver.common.mobileby import MobileBy
from appium.webdriver.mobilecommand import MobileCommand
from appium.webdriver.webelement import WebElement

# Common Configurations
resturl = 'a1.easemob.com'
org = 'easemob-demo'
appkey = 'chatdemoui'
token = 'YWMt3q72Mq_nEeeyT0FN15xQqgAAAAAAAAAAAAAAAAAAAAGP-MBq3AgR45fkRZpPlqEwAQMAAAFfFKDZcABPGgCFsEI0cXnNV-RC-TvEoN-_z9Uk9OdXzEPgrtySXA0F6g'
header = {'Content-Type': 'application/json','Authorization': 'Bearer YWMt3q72Mq_nEeeyT0FN15xQqgAAAAAAAAAAAAAAAAAAAAGP-MBq3AgR45fkRZpPlqEwAQMAAAFfFKDZcABPGgCFsEI0cXnNV-RC-TvEoN-_z9Uk9OdXzEPgrtySXA0F6g'}
user1 = "autotest1"
user2 = "autotest2"
user3 = "autotest3"
psw = "1"
group1 = "Auto1"
group2 = "Auto2"
group3 = "Auto3"
group4 = "Auto4"
room = "autoTestRoom"

# Launch Demo
def start_demo(udid,deviceName,wdaPort):
    desired_caps = {}
    desired_caps['automationName'] = 'XCUITest'
    desired_caps['platformName'] = 'iOS'
    desired_caps['udid'] = udid
    desired_caps['deviceName'] = deviceName
    desired_caps['prebuildWDA'] = 'true'
    desired_caps['wdaLocalPort'] = wdaPort
    desired_caps['newCommandTimeout']='2000'
    desired_caps['app'] = os.path.abspath('./iOS_Automation/3.3.7.app')
    global wd
    wd = webdriver.Remote('http://localhost:4723/wd/hub', desired_caps)
    wd.implicitly_wait(3)
    return wd
     
def register_user(wd,name,psw):
    username = wd.find_element_by_id("username")
    password = wd.find_element_by_id("password")
    username.clear()
    username.send_keys(name)
    password.send_keys(psw)
    wd.find_element_by_id("Register").click()
    WebDriverWait(wd,10).until(EC.invisibility_of_element_located((By.ID,'Registering...')))

    alert = WebDriverWait(wd,10).until(EC.alert_is_present())
    if alert.text == "Registered successfully, please log in.":
        sleep(1)
        wd.execute_script('mobile: alert', {'action':'accept'})
        print "PASS: User %s has been registered successfully!" % str(name)
    else:
        print "FAIL:" + alert.text
        sleep(1)
        wd.execute_script('mobile: alert', {'action':'accept'})

def delete_user(user):
    url = 'https://%s/%s/%s/user/%s' % (resturl, org, appkey, user)
    delete_users = requests.delete(url, headers = header)

    if delete_users.status_code == 200 or delete_users.status_code == 404:
        print "PASS: User %s has been deleted successsfully!" % str(user)
    else:
        print "Return code: ", delete_users.status_code
        print "FAIL: Failed to delete user %s, please try again!" % str(user)
    
def contacts_page(wd):
    contacts_tab = wd.find_element_by_id("Contacts")
    contacts_tab.click()
    WebDriverWait(wd,10).until(EC.invisibility_of_element_located((By.ID,'Loading data...')))

def settings_page(wd):
    settings_tab = wd.find_element_by_id("Settings")
    settings_tab.click()

def conversation_page(wd):
    chats_tab = wd.find_element_by_id("Chats")
    chats_tab.click()

def switch_account(wd,name,psw):
    logout(wd)
    sleep(2)
    login(wd,name,psw)

# Find the target item
def find_target(wd,item):
    target = wd.find_elements_by_id(item)
    if len(target) == 0:
        return False
    elif len(target) == 1 and target[0].text == item:
        return True
    else:
        return False

def swipe_left(wd,user):
    i=0
    cells = wd.find_elements_by_class_name("XCUIElementTypeCell")
    while i < len(cells):
        target = cells[i].find_element_by_id(user)
        if target.text == user:
            wd.execute_script('mobile: scroll', {'direction':'right','element':cells[i]})
            break
        i+=1

# Swipe Left to Delete Friend
def swipe_to_delete(wd,friend):
    i=0
    cells = wd.find_elements_by_class_name("XCUIElementTypeCell")
    while i < len(cells):
        target = cells[i].find_element_by_class_name('XCUIElementTypeStaticText')
        if target.text == friend:
            wd.execute_script('mobile: scroll', {'direction':'right','element':cells[i]})
            wd.find_element_by_id('Delete').click()
            break
        i+=1

def click_target_item(wd,name):
    i=0
    cells = wd.find_elements_by_class_name("XCUIElementTypeCell")
    while i < len(cells):
        target = cells[i].find_element_by_class_name('XCUIElementTypeStaticText')
        if target.text == name:
            target.click()
            break
        i+=1

def back_to_previous_page(wd):
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"back"))).click()

def accept_alert(wd):
    alert = WebDriverWait(wd,10).until(EC.alert_is_present())
    sleep(1)
    wd.execute_script('mobile: alert', {'action':'accept'})
    sleep(1)

def accept_any_alerts(wd):
    if EC.alert_is_present() == False:
        pass
    else:
        try:
            alert = WebDriverWait(wd,3).until(EC.alert_is_present())
            while alert:
                sleep(1)
                wd.execute_script('mobile: alert', {'action':'accept'})
                sleep(1)
                if not alert:
                    break
        except:
            pass

# Swipe Down to Refresh
def swipe_to_refresh(wd):
    wd.execute_script('mobile: swipe', {'direction':'down'})

def swipe_up(wd):
    wd.execute_script('mobile: swipe', {'direction':'up'})

def long_press(wd,target):
    wd.execute_script('mobile: touchAndHold',{'element':target,'duration':2})

def login(wd,name,psw):
    username = wd.find_element_by_id("username")
    password = wd.find_element_by_id("password")
    username.clear()
    username.send_keys(name)
    password.send_keys(psw)
    wd.find_element_by_id("login").click()
    WebDriverWait(wd,60).until(EC.invisibility_of_element_located((By.ID,'Logging in...')))

    if EC.alert_is_present() == False:
        pass
    else:
        try:
            alert = WebDriverWait(wd,10).until(EC.alert_is_present())
            alert.text == 'Failed to connect to the server'
            while alert.text == 'Failed to connect to the server':
                sleep(1)
                wd.execute_script('mobile: alert', {'action':'accept'})
                sleep(1)
                wd.find_element_by_id("login").click()
                WebDriverWait(wd,60).until(EC.invisibility_of_element_located((By.ID,'Logging in...')))
                WebDriverWait(wd,10).until(EC.alert_is_present())
                if alert.text != 'Failed to connect to the server':
                    sleep(1)
                    pass
                    break
        except:
            pass
    accept_any_alerts(wd)
    sleep(2)

    if wd.find_element_by_id("Chats").is_displayed():
        print "PASS: Login %s successfully!" % str(name)
    else:
        print "FAIL: Failed to login, please try again!"
        raise
        
def logout(wd):
    settings_page(wd)
    swipe_up(wd)
    logout_button = wd.find_element_by_name('logoff')
    logout_button.click()
    
    login_page = wd.find_element_by_id("Login")
    if login_page != None and login_page.text == "Login":
        print "PASS: Logout successfully!" 
    else:
        print "FAIL: Failed to logout, please try again!"

def add_friend(wd,user,friend):
    contacts_page(wd)
    wd.find_element_by_id("add").click()
    wd.find_element_by_id("contact_name").send_keys(friend)
    wd.find_element_by_id("search_contact").click()
    wd.find_element_by_id("Add").click()
    wd.switch_to_alert().accept()

# Reject Friend Application
def reject_friend(wd1,wd2,friend,user):
    add_friend(wd1,user,friend)
    reject_invitation(wd2)
    alert = WebDriverWait(wd1,10).until(EC.alert_is_present())
    sleep(1)
    alert.accept()
    if find_target(wd1,friend) == False:
        print "PASS: Friend application from %s is rejected by %s successfully!" % (user,friend)
    else:
        print "FAIL: Failed to reject friend application!"

# Accept Friend Application
def accept_friend(wd1,wd2,friend,user):
    add_friend(wd1,user,friend)
    accept_invitation(wd2)
    alert = WebDriverWait(wd1,10).until(EC.alert_is_present())
    sleep(1)
    alert.accept()
    back_to_previous_page(wd2)
    
    if find_target(wd1,friend) == True:
        print "PASS: Friend application from %s is accepted by %s successfully!" % (user,friend)
    else:
        print "FAIL: Failed to accept friend application!"

# Add Friend to Blacklist
def add_user_to_blacklist(wd1,user,friend):
    contacts_page(wd1)
    target1 = wd1.find_element_by_id(friend)
    long_press(wd1,target1)
    wd1.find_element_by_name("Move to blacklist").click()
    sleep(1)
    settings_page(wd1)
    wd1.find_element_by_id("Blacklist").click()
    WebDriverWait(wd1,10).until(EC.invisibility_of_element_located((By.ID,'Loading data...')))
    cells = wd1.find_element_by_class_name("XCUIElementTypeCell")
    target2 = cells.find_element_by_class_name("XCUIElementTypeStaticText")
    
    if target2.text == friend:
            print "PASS: %s has been added to blacklist!" % str(friend)
            wd1.find_element_by_id("Settings").click()
            contacts_page(wd1)
    else:
            print "FAIL: Failed to add %s to blacklist!" % str(friend)
            wd1.find_element_by_id("Settings").click()
            contacts_page(wd1)

def add_user_to_blacklist_multidev(wd1,wd3,user,friend):
    contacts_page(wd1)
    target1 = wd1.find_element_by_id(friend)
    long_press(wd1,target1)
    wd1.find_element_by_name("Move to blacklist").click()
    sleep(1)
    settings_page(wd1)
    wd1.find_element_by_id("Blacklist").click()
    WebDriverWait(wd1,10).until(EC.invisibility_of_element_located((By.ID,'Loading data...')))
    cells = wd1.find_element_by_class_name("XCUIElementTypeCell")
    target2 = cells.find_element_by_class_name("XCUIElementTypeStaticText")
    
    if target2.text == friend:
            print "PASS: %s has been added to blacklist!" % str(friend)
            wd1.find_element_by_id("Settings").click()
            contacts_page(wd1)
    else:
            print "FAIL: Failed to add %s to blacklist!" % str(friend)
            wd1.find_element_by_id("Settings").click()
            contacts_page(wd1)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Contact Multi-devices' and '5' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of adding blacklist!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of adding blacklist!"

# Remove User from Blacklist
def remove_user_from_blacklist(wd1,wd3,user,friend):
    settings_page(wd1)
    wd1.find_element_by_id("Blacklist").click()
    WebDriverWait(wd1,10).until(EC.invisibility_of_element_located((By.ID,'Loading data...')))
    swipe_left(wd1,friend)
    wd1.find_element_by_id('Delete').click()

    if find_target(wd1,friend) != True:
        print "PASS: User %s is removed from blacklist successfully!" % str(friend)
        wd1.find_element_by_id("Settings").click()
        contacts_page(wd1)
    else:
        print "FAIL: Failed to remove %s from blacklist!" % str(friend)
        wd.find_element_by_id("Settings").click()
        contacts_page(wd1)

def remove_user_from_blacklist_multidev(wd1,wd3,user,friend):
    settings_page(wd1)
    wd1.find_element_by_id("Blacklist").click()
    WebDriverWait(wd1,10).until(EC.invisibility_of_element_located((By.ID,'Loading data...')))
    swipe_left(wd1,friend)
    wd1.find_element_by_id('Delete').click()

    if find_target(wd1,friend) != True:
        print "PASS: User %s is removed from blacklist successfully!" % str(friend)
        wd1.find_element_by_id("Settings").click()
        contacts_page(wd1)
    else:
        print "FAIL: Failed to remove %s from blacklist!" % str(friend)
        wd.find_element_by_id("Settings").click()
        contacts_page(wd1)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Contact Multi-devices' and '6' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of removing blacklist!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of removing blacklist!"

# Delete Friend
def delete_contact(wd1,wd3,user,friend):
    contacts_page(wd1)
    sleep(2)
    swipe_to_delete(wd1,friend)
    wd1.switch_to_alert().accept()

    if find_target(wd1,friend)!= True:
        print "Contact %s is deleted successfully!" % str(friend)
    else:
        print "Failed to delete contact %s" % str(friend)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Contact Multi-devices' and '2' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of deleting contact!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of deleting contact!"
# Send Messages
def send_text(wd,content):
    wd.find_element_by_class_name("XCUIElementTypeTextView").send_keys("%s\n" %content)

def send_image(wd):
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"more"))).click()
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"image"))).click()
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Camera Roll"))).click()
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Photo, Landscape, March 13, 2011, 8:17 AM"))).click()
    if EC.alert_is_present()(wd):
        accept_alert(wd)
        WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"more"))).click()
        WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"image"))).click()
        WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Camera Roll"))).click()
        WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Photo, Landscape, March 13, 2011, 8:17 AM"))).click()
    else:
        pass
    back_to_previous_page(wd)

def send_audio(wd):
    wd.find_element_by_id("style").click()
    audio = wd.find_element_by_id("hold down to talk")
    wd.execute_script('mobile:touchAndHold',{'element':audio,'duration':5})
    back_to_previous_page(wd)

def send_location(wd):
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"more"))).click()
    wd.find_element_by_id("location").click()
    accept_any_alerts(wd)
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Send"))).click()
    back_to_previous_page(wd)

def send_audio_call(wd):
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"more"))).click()
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"语音"))).click()
    WebDriverWait(wd,30).until(EC.invisibility_of_element_located((By.ID,'Calling')))

def send_video_call(wd):
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"more"))).click()
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"视频"))).click()
    WebDriverWait(wd,30).until(EC.invisibility_of_element_located((By.ID,'Calling')))

def send_to_user(wd,user):
    contacts_page(wd)
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,user))).click()

# Check message is received or not
def check_message(wd,sender,msg):
    cells = wd.find_elements_by_class_name("XCUIElementTypeCell")

    if len(cells) == 0:
        print "No message is recieved!"
        return False

    texts = cells[0].find_elements_by_class_name("XCUIElementTypeStaticText")
    msgs = str(sender + ": " + msg)
    
    if texts[2].text == msgs:
        return True
    else:
        return False

# Send Text Message to User
def send_text_to_user(wd1,wd2,sender,receiver,content):
    send_to_user(wd1,receiver)
    send_text(wd1,content)
    back_to_previous_page(wd1)
    conversation_page(wd2)

    if check_message(wd2, sender, content)  == True:
        print "PASS: Text message is recieved!"
    else:
        print "FAIL: Text message is not recieved!"

# Send Image Message to User
def send_image_to_user(wd1,wd2,sender,receiver):
    send_to_user(wd1,receiver)
    send_image(wd1)
    sleep(5)
    conversation_page(wd2)

    if check_message(wd2, sender,"[image]") == True:
        print "PASS: Image message is recieved!"
    else:
        print "FAIL: Image message is not recieved!"

# Send Audio Message to User
def send_audio_to_user(wd1,wd2,sender,receiver):
    send_to_user(wd1,receiver)
    send_audio(wd1)
    conversation_page(wd2)

    if check_message(wd2, sender,"[audio]") == True:
        print "PASS: Audio message is recieved!"
    else:
        print "FAIL: Audio message is not recieved!"

# Send Location Message to User
def send_location_to_user(wd1,wd2,sender,receiver):
    send_to_user(wd1,receiver)
    send_location(wd1)
    conversation_page(wd2)

    if check_message(wd2, sender,"[location]") == True:
        print "PASS: Location message is recieved!"
    else:
        print "FAIL: Location message is not recieved!"

def initial_audio_call(wd,receiver):
    send_to_user(wd,receiver)
    send_audio_call(wd)

    if wd.find_element_by_id('Establish call finished').is_displayed():
        print "PASS: Audio call is established successfully!"
    else:
        print "FAIL: Audio call is not established successfully!"

def initial_video_call(wd,receiver):
    send_to_user(wd,receiver)
    send_video_call(wd)

    if wd.find_element_by_id('Establish call finished').is_displayed():
        print "PASS: Video call is established successfully!"
    else:
        print "FAIL: Video call is not established successfully!"

def answer_call(wd):
    wd.find_element_by_id('Button Answer').click()
    wd.implicitly_wait(5)

    if wd.find_element_by_id('00:3').is_displayed():
        print "PASS: The call is answered successfully!"
    else:
        print "FAIL: Failed to answer the call!"

def reject_call(wd1,wd2):
    wd2.find_element_by_id('Button End').click()
    sleep(2)
    alert = WebDriverWait(wd1,10).until(EC.alert_is_present())

    if alert.text == 'Reject the call':
        print "PASS: Call is rejected successfully!"
        wd1.execute_script('mobile: alert', {'action':'accept'})
        back_to_previous_page(wd1)
    else:
        print "FAIL: Failed to reject the call!"
        wd1.execute_script('mobile: alert', {'action':'accept'})
        back_to_previous_page(wd1)

def end_call(wd):
    wd.find_element_by_id('Button End').click()

    if wd.find_element_by_id('more').is_displayed():
        print "PASS: Call is ended successfully!"
        back_to_previous_page(wd)
    else:
        print "FAIL: Failed to end the call!"
        back_to_previous_page(wd)

# Go to Group Pages
def group_page(wd):
    contacts_page(wd)
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Group"))).click()
    WebDriverWait(wd,10).until(EC.invisibility_of_element_located((By.ID,'Loading data...')))

def group_chat_page(wd,groupname):
	group_page(wd)
	WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,groupname))).click()

def group_details_page(wd,groupname):
    group_chat_page(wd,groupname)
    wd.find_element_by_id('group detail').click()
    sleep(3)

def leave_group_details_page(wd,groupname):
    back_to_previous_page(wd)
    leave_group_chat_page(wd,groupname)

def leave_group_chat_page(wd,groupname):
    back_to_previous_page(wd)
    leave_group_list_page(wd)

def leave_group_list_page(wd):
    back_to_previous_page(wd)

def leave_public_group_page(wd):
    back_to_previous_page(wd)
    leave_group_list_page(wd)

def accept_invitation(wd):
    contacts_page(wd)
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Application and Notification"))).click()
    wd.find_element_by_id("Accept").click()
    sleep(2)

def reject_invitation(wd):
    contacts_page(wd)
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Application and Notification"))).click()
    wd.find_element_by_id("Reject").click()
    back_to_previous_page(wd)

def group_members_page(wd,groupname):
	group_details_page(wd,groupname)
	wd.find_element_by_id('Load More').click()

def public_group_page(wd):
    group_page(wd)
    click_target_item(wd,'Join public group')
    WebDriverWait(wd,10).until(EC.invisibility_of_element_located((By.ID,'Loading data...')))

# Find Target Public Group
def find_public_group(wd,groupname):
    if find_target(wd,groupname) == True and wd.find_element_by_id(groupname).is_displayed():
        wd.find_element_by_id(groupname).click()

    while find_target(wd,groupname) == True and not wd.find_element_by_id(groupname).is_displayed():
        wd.execute_script('mobile: scroll', {'direction': 'down'})
        if wd.find_element_by_id(groupname).is_displayed():
            wd.find_element_by_id(groupname).click()
            break

    while find_target(wd,groupname) == False:
        wd.execute_script('mobile: scroll', {'direction': 'down'})
        if wd.find_element_by_id(groupname).is_displayed():
            wd.find_element_by_id(groupname).click()
            break

# Create Private Groups that Allow members to Invite
def create_private_invite_group(wd1,wd3,groupname):
    group_page(wd1)
    click_target_item(wd1,"Create a group")
    wd1.find_element_by_id("group_name").send_keys(groupname)
    grptype = wd1.find_element_by_id("group_type")
    allow_invite = wd1.find_element_by_id("member_permission")
    allow_invite.click()
    wd1.find_element_by_id("add_member").click()
    wd1.find_element_by_id("done_button").click()
    WebDriverWait(wd1,10).until(EC.invisibility_of_element_located((By.ID,'Create a group...')))
    sleep(2)

    if find_target(wd1,groupname) == True:
        print "PASS: Group %s is created successfully!" % str(groupname)
        leave_group_list_page(wd1)
    else:
        print "FAIL: Group %s is not found!"
        leave_group_list_page(wd1)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '10' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of creating group!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of creating group!"

# Create Private Groups that Forbid members to Invite
def create_private_group(wd2,groupname):
    group_page(wd2)
    click_target_item(wd2,"Create a group")
    wd2.find_element_by_id("group_name").send_keys(groupname)
    wd2.find_element_by_id("add_member").click()
    wd2.find_element_by_id("done_button").click()
    WebDriverWait(wd2,10).until(EC.invisibility_of_element_located((By.ID,'Create a group...')))
    sleep(2)

    if find_target(wd2,groupname) == True:
        print "PASS: Group %s is created successfully!" % str(groupname)
        back_to_previous_page(wd2)
    else:
        print "FAIL: Group %s is not found!"
        back_to_previous_page(wd2)

# Create Public Groups Free to Join
def create_public_free_group(wd2,groupname):
    group_page(wd2)
    click_target_item(wd2,"Create a group")
    wd2.find_element_by_id("group_name").send_keys(groupname)
    grptype = wd2.find_element_by_id("group_type")
    allow_invite = wd2.find_element_by_id("member_permission")
    grptype.click()
    allow_invite.click()
    wd2.find_element_by_id("add_member").click()
    wd2.find_element_by_id("done_button").click()
    WebDriverWait(wd2,10).until(EC.invisibility_of_element_located((By.ID,'Create a group...')))
    sleep(2)

    if find_target(wd2,groupname) == True:
        print "PASS: Group %s is created successfully!" % str(groupname)
        back_to_previous_page(wd2)
    else:
        print "FAIL: Group %s is not found!"
        back_to_previous_page(wd2)

# Create Public Groups Free to Join
def create_public_permission_group(wd1,wd3,groupname):
    group_page(wd1)
    click_target_item(wd1,"Create a group")
    wd1.find_element_by_id("group_name").send_keys(groupname)
    grptype = wd1.find_element_by_id("group_type")
    allow_invite = wd1.find_element_by_id("member_permission")
    grptype.click()
    wd1.find_element_by_id("add_member").click()
    wd1.find_element_by_id("done_button").click()
    WebDriverWait(wd1,10).until(EC.invisibility_of_element_located((By.ID,'Create a group...')))
    sleep(2)

    if find_target(wd1,groupname) == True:
        print "PASS: Group %s is created successfully!" % str(groupname)
        back_to_previous_page(wd1)
        accept_alert(wd3)
    else:
        print "FAIL: Group %s is not found!" % str(groupname)
        back_to_previous_page(wd1)
        accept_alert(wd3)

# Add Members to Group
def add_group_member(wd1,wd2,wd3,groupname,member):
    group_details_page(wd1,groupname)
    wd1.find_element_by_id('+').click()
    wd1.find_element_by_id(member).click()
    wd1.find_element_by_id('done_button').click()
    leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '17' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of inviting member!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of inviting member!"

    contacts_page(wd2)
    accept_invitation(wd2)
    back_to_previous_page(wd2)
    accept_any_alerts(wd1)
    accept_any_alerts(wd3)
    group_page(wd2)

    if find_target(wd2,groupname) == True:
        print "PASS: %s is added to %s!" %(member, groupname)
        leave_group_list_page(wd2)
    else:
        print "FAIL: Group %s is not found!" % str(groupname)
        leave_group_list_page(wd2)

# Remove Members from Group
def remove_group_member(wd1,wd2,wd3,groupname,member):
    group_members_page(wd1,groupname)
    swipe_left(wd1,member)
    wd1.find_element_by_id('Remove').click()
    sleep(2)
    accept_alert(wd1)
    sleep(2)
    accept_alert(wd2)
    sleep(2)
    accept_alert(wd3)
    sleep(2)

    if find_target(wd1,member) == False:
        print "PASS: %s has been removed from group successfully!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "FAIL: Failed to remove %s from group!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '20' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of kicking member!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of kicking member!"

# Join Public Groups Free to Join
def join_public_free_group(wd1,wd2,wd3,user,groupname):
    public_group_page(wd1)
    find_public_group(wd1,groupname)
    wd1.find_element_by_id('Join the group').click()
    back_to_previous_page(wd1)
    sleep(2)
    accept_alert(wd2)

    if find_target(wd1,groupname) == True:
        print "PASS: Join group %s successfully!" % str(groupname)
        leave_group_list_page(wd1)
    else:
        print "FAIL: Failed to Join Public Group %s!" % str(groupname)
        leave_group_list_page(wd1)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '12' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of joining group!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of joining group!"

# Join Public Groups Need Group Owners' Permission
def join_public_permission_group_reject(wd1,wd2,wd3,user,groupname):
    public_group_page(wd2)
    find_public_group(wd2,groupname)
    wd2.find_element_by_id('Join the group').click()
    wd2.find_element_by_id('ok').click()
    back_to_previous_page(wd2)
    leave_public_group_page(wd2)
    
    reject_invitation(wd1)
    sleep(2)
    accept_alert(wd2)
    group_members_page(wd1,groupname)
    sleep(2)
    if find_target(wd1,user) == True:
        print "PASS: Join group %s successfully!" % str(groupname)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "PASS: Failed to Join Public Group %s!" % str(groupname)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '16' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of rejecting application!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of rejecting application!"

def join_public_permission_group_accept(wd1,wd2,wd3,user,groupname):
    public_group_page(wd2)
    find_public_group(wd2,groupname)
    wd2.find_element_by_id('Join the group').click()
    wd2.find_element_by_id('ok').click()
    back_to_previous_page(wd2)
    leave_public_group_page(wd2)
    
    accept_invitation(wd1)
    accept_alert(wd2)
    sleep(1)
    accept_alert(wd1)
    sleep(1)
    back_to_previous_page(wd1)
    group_members_page(wd1,groupname)
    sleep(2)
    accept_alert(wd3)
    if find_target(wd1,user) == True:
        print "PASS: Join group %s successfully!" % str(groupname)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "PASS: Failed to Join Public Group %s!" % str(groupname)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '15' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of accepting application!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of accepting application!"

def apply_join_group(wd1,wd2,wd3,groupname):
    url = 'https://%s/%s/%s/chatgroups' % (resturl, org, appkey)
    data = {"groupname":"auto5","desc":"RST created group","public":True,"approval":True,"owner":user2}
    requests.post(url, headers = header, data = json.dumps(data))
    sleep(2)

    accept_alert(wd2)
    sleep(1)
    public_group_page(wd1)
    find_public_group(wd1,groupname)
    wd1.find_element_by_id('Join the group').click()
    wd1.find_element_by_id('ok').click()
    back_to_previous_page(wd1)
    leave_public_group_page(wd1)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '14' in alert.text:
        accept_alert(wd3)
        print "PASS: Multi-devices sync of applying to join group!"
    else:
        accept_alert(wd3)
        print "FAIL: Multi-devices sync of applying to join group!"
    
def reject_group_invitation(wd1,wd2,wd3,groupname,member):
    group_details_page(wd2,groupname)
    wd2.find_element_by_id('+').click()
    wd2.find_element_by_id(member).click()
    wd2.find_element_by_id('done_button').click()
    leave_group_details_page(wd2,groupname)

    contacts_page(wd1)
    reject_invitation(wd1)
    accept_alert(wd2)
    sleep(1)
    group_page(wd1)

    if find_target(wd1,groupname) == False:
        print "PASS: %s is not added to %s!" %(member, groupname)
        leave_group_list_page(wd1)
    else:
        print "FAIL: Group %s is found!" % str(groupname)
        leave_group_list_page(wd1)
        
    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '19' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of rejecting of group invitation!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of rejectiong of group invitation!"

def accept_group_invitation(wd1,wd2,wd3,groupname,member):
    group_details_page(wd2,groupname)
    wd2.find_element_by_id('+').click()
    wd2.find_element_by_id(member).click()
    wd2.find_element_by_id('done_button').click()
    leave_group_details_page(wd2,groupname)

    contacts_page(wd1)
    accept_invitation(wd1)
    back_to_previous_page(wd1)
    accept_any_alerts(wd2)
    group_page(wd1)

    if find_target(wd1,groupname) == True:
        print "PASS: %s is added to %s!" %(member, groupname)
        back_to_previous_page(wd1)
    else:
        print "FAIL: Group %s is not found!" % str(groupname)
        back_to_previous_page(wd1)
        
    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '18' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of accepting of group invitation!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of accepting of group invitation!"

# Group Member Invite Friends to Group
def member_invite_to_group(wd1,wd2,wd3,groupname,member):
    group_details_page(wd2,groupname)
    wd2.find_element_by_id('+').click()
    wd2.find_element_by_id(member).click()
    wd2.find_element_by_id('done_button').click()
    leave_group_details_page(wd2,groupname)
    
    contacts_page(wd3)
    accept_invitation(wd3)
    back_to_previous_page(wd3)
    accept_alert(wd1)
    sleep(2)
    accept_any_alerts(wd2)
    group_page(wd3)
    sleep(2)

    if find_target(wd3,groupname) == True:
        print "PASS: %s is added to %s!" %(member, groupname)
        leave_group_list_page(wd3)
    else:
        print "FAIL: Group %s is not found!" % str(groupname)
        leave_group_list_page(wd3)

# Add Member to Mute List
def add_to_mute_list(wd1,wd2,wd3,groupname,member):
    group_members_page(wd1,groupname)
    swipe_left(wd1,member)
    wd1.find_element_by_id('Mute').click()
    back_to_previous_page(wd1)
    accept_alert(wd2)
    swipe_up(wd1)
    swipe_up(wd1)
    wd1.find_element_by_id('Mute List').click()
    if wd1.find_element_by_id(member).is_enabled():
        print "PASS: %s has been added to mute list successfully!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "FAIL: Failed to add %s to mute list!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '28' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of muting!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of muting!"

# Remove Member from Mute List 
def remove_from_mute_list(wd1,wd2,wd3,groupname,member):
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    swipe_up(wd1)
    wd1.find_element_by_id('Mute List').click()
    sleep(1)
    swipe_left(wd1,member)
    wd1.find_element_by_id('Remove').click()
    sleep(2)
    accept_alert(wd2)

    if find_target(wd1,member) == False:
        print "PASS: %s has been removed from mute list!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)   
    else:
        print "FAIL: Failed to remove %s from mute list!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '29' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of unmuting!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of unmuting!"

# Add Member to Blacklist
def add_member_to_blacklist(wd1,wd2,wd3,groupname,member):
    group_members_page(wd1,groupname)
    swipe_left(wd1,member)
    wd1.find_element_by_id('Block').click()
    back_to_previous_page(wd1)
    accept_alert(wd2)
    swipe_up(wd1)
    wd1.find_element_by_id('Blacklist').click()

    if wd1.find_element_by_id(member).is_enabled():
        print "PASS: %s has been added to blacklist successfully!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "FAIL: Failed to add %s to blacklist!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '21' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of adding group blacklist!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of adding group blacklist!"

# Remove Member from Blacklist
def remove_member_from_blacklist(wd1,wd3,groupname,member):
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    wd1.find_element_by_id('Blacklist').click()
    sleep(1)
    swipe_left(wd1,member)
    wd1.find_element_by_id('Remove').click()

    if find_target(wd1,member) == False:
        print "PASS: %s has been removed from blacklist!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "FAIL: Failed to remove %s from blacklist!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '22' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of removing group blacklist!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of removing group blacklist!"

# Add Member to Admin List
def add_member_to_admin(wd1,wd2,wd3,groupname,member):
    group_members_page(wd1,groupname)
    swipe_left(wd1,member)
    wd1.find_element_by_id('Upgrade').click()
    back_to_previous_page(wd1)
    accept_alert(wd2)
    wd1.find_element_by_id('Admin List').click()

    if wd1.find_element_by_id(member).is_enabled():
        print "PASS: %s has been added to admin list successfully!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "FAIL: Failed to add %s to admin list!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '26' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of adding admin!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of adding admin!"

# Remove Member from Admin List
def remove_member_from_admin(wd1,wd2,wd3,groupname,member):
    group_details_page(wd1,groupname)
    wd1.find_element_by_id('Admin List').click()
    i=0
    cells = wd1.find_elements_by_class_name("XCUIElementTypeCell")
    while i < len(cells):
        target = cells[i].find_element_by_id(member)
        if target.text == member:
            location = cells[i].location
            point_y = location['y']
            width = cells[i].size['width']
            from_x = int(width * 0.5)
            to_x = int(width * 0.35)
            params = {'toX': to_x, 'toY': point_y, 'element': member, 'duration': 0.5, 'fromY': point_y, 'fromX': from_x}
            wd1.execute_script('mobile: dragFromToForDuration', params)
            break
        i+=1
    wd1.find_element_by_id('Degrade').click()
    sleep(2)
    accept_alert(wd2)

    if find_target(wd1,member) == False:
        print "PASS: %s has been removed from admin list!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        print "FAIL: Failed to remove %s from admin list!" % str(member)
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '27' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of removing admin!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of removing admin!"

# Transfer Group
def transfer_group(wd1,wd2,wd3,groupname,newowner):
    group_details_page(wd2,groupname)
    wd2.find_element_by_id('Change owner').click()
    target = wd2.find_element_by_id(newowner)
    width = target.size['width']
    height = target.size['height']
    x = int(width*0.5)
    y = int(height*0.5)
    wd2.execute_script('mobile: tap', {'x':x,'y':y,'element':target.id})
    wd2.find_element_by_id('Save').click()
    sleep(2)
    accept_alert(wd1)
    back_to_previous_page(wd2)
    wd2.find_element_by_id('group detail').click()
    swipe_up(wd2)

    if wd2.find_element_by_id('Leave group').is_displayed():
        print "PASS: Group owner has been transfered to %s successfully!" % str(newowner)
        leave_group_details_page(wd2,groupname)
    else:
        print "FAIL: Failed to transfer group!"
        leave_group_details_page(wd2,groupname)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '25' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of transfering group!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of transfering group!"

# Change Group Name
def change_group_name(wd,groupname,newname):
    group_details_page(wd,groupname)
    wd.find_element_by_id('Change Group Name').click()
    ttf = wd.find_element_by_class_name('XCUIElementTypeTextField')
    ttf.clear()
    ttf.send_keys(newname)
    wd.find_element_by_id('Save').click()
    back_to_previous_page(wd)
    back_to_previous_page(wd)
    swipe_to_refresh(wd)

    if find_target(wd,newname) == True:
        print "PASS: Group name has been changed successfully!"
        leave_group_list_page(wd)
    else:
        print "FAIL: Failed to change groupname!"
        leave_group_list_page(wd)
    
# Group Announcement
def group_announcement(wd1,wd2,wd3,groupname):
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    wd1.find_element_by_id('Group Announcement').click()
    ttf = wd1.find_element_by_class_name('XCUIElementTypeTextField')
    ttf.clear()
    ttf.send_keys('group announcement')
    wd1.find_element_by_id('ok').click()
    sleep(2)
    accept_alert(wd3)

    result = EC.alert_is_present()(wd2)
    alert = WebDriverWait(wd2,10).until(EC.alert_is_present())
    if 'Group Announcement Update' in alert.text:
        alert.accept()
        print "PASS: Group annoucement has been released successfully!"
        leave_group_details_page(wd1,groupname)
    else:
        print alert.text
        alert.accept()
        print "FAIL: Failed to release group annoucement!"
        leave_group_details_page(wd1,groupname)

# Group Share Files
def upload_group_files(wd1,wd2,groupname):
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    WebDriverWait(wd1,30).until(EC.element_to_be_clickable((By.ID,"Share Files"))).click()
    WebDriverWait(wd1,30).until(EC.element_to_be_clickable((By.ID,"Upload"))).click()
    sleep(2)
    WebDriverWait(wd1,30).until(EC.element_to_be_clickable((By.ID,"Camera Roll"))).click()
    WebDriverWait(wd1,30).until(EC.element_to_be_clickable((By.ID,"Photo, Landscape, March 13, 2011, 8:17 AM"))).click()
    try:
        result = EC.alert_is_present()
        if result:
            sleep(1)
            wd1.execute_script('mobile: alert', {'action':'accept'})
            sleep(1)
            WebDriverWait(wd1,30).until(EC.element_to_be_clickable((By.ID,"Upload"))).click()
            WebDriverWait(wd1,30).until(EC.element_to_be_clickable((By.ID,"Camera Roll"))).click()
            WebDriverWait(wd1,30).until(EC.element_to_be_clickable((By.ID,"Photo, Landscape, March 13, 2011, 8:17 AM"))).click()
        else:
            pass
    except:
        pass
    WebDriverWait(wd1,20).until(EC.invisibility_of_element_located((By.ID,'Uploading...')))
    sleep(2)

    alert = WebDriverWait(wd2,10).until(EC.alert_is_present())
    if 'Group SharedFile Update' in alert.text:
        alert.accept()
        print "PASS: File has been uploaded successfully!"
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        alert.accept()
        print "FAIL: Failed to upload group file!"
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

# Remove Group Shared Files
def remove_group_files(wd1,wd2,groupname):
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    wd1.find_element_by_id('Share Files').click()
    swipe_left(wd1,'1.81 MB')
    wd1.find_element_by_id('Remove').click()
    sleep(2)

    alert = WebDriverWait(wd2,10).until(EC.alert_is_present())
    if 'Group SharedFile Update' in alert.text:
        alert.accept()
        print "PASS: File has been removed successfully!"
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)
    else:
        alert.accept()
        print "FAIL: Failed to remove group file!"
        back_to_previous_page(wd1)
        leave_group_details_page(wd1,groupname)

# Block Group Message
def block_group_message(wd1,wd2,wd3,groupname):
    group_details_page(wd1,groupname)
    wd1.find_element_by_id('Group Setting').click()
    wd1.find_element_by_name('block_switch').click()
    wd1.find_element_by_id('Save').click()
    back_to_previous_page(wd1)
    sleep(1)
    leave_group_details_page(wd1,groupname)
    conversation_page(wd1)

    group_chat_page(wd2,groupname)
    send_text(wd2,'block message')
    back_to_previous_page(wd2)
    leave_group_list_page(wd2)

    if check_message(wd1, user2, "block message")  == False:
        print "PASS: Group message has been blocked successfully!"
    else:
        print "FAIL: Failed to block group message!"

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '23' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of blocking group message!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of blocking group message!"

# Unblock Group Message
def unblock_group_message(wd1,wd2,wd3,groupname):
    group_details_page(wd1,groupname)
    wd1.find_element_by_id('Group Setting').click()
    wd1.find_element_by_name('block_switch').click()
    wd1.find_element_by_id('Save').click()
    back_to_previous_page(wd1)
    sleep(1)
    leave_group_details_page(wd1,groupname)
    conversation_page(wd1)

    group_chat_page(wd2,groupname)
    send_text(wd2,'unblock message')
    back_to_previous_page(wd2)
    leave_group_list_page(wd2)

    if check_message(wd1, user2, "unblock message")  == True:
        print "PASS: Group message has been unblocked successfully!"
    else:
        print "FAIL: Failed to unblock group message!"

    if check_message(wd1, user2, "block message")  == False:
        print "PASS: Group message has been blocked successfully!"
    else:
        print "FAIL: Failed to block group message!"

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '24' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of unblocking group message!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of unblocking group message!"

# Send Text Message to Group
def send_text_to_group(wd1,wd2,sender,groupname,content):
    group_chat_page(wd1,groupname)
    send_text(wd1,content)
    back_to_previous_page(wd1)
    leave_group_list_page(wd1)

    conversation_page(wd2)
    if check_message(wd2, sender, content)  == True:
        print "PASS: Text message is recieved!"
    else:
        print "FAIL: Text message is not recieved!"

# Send Picture Message to Group
def send_image_to_group(wd1,wd2,sender,groupname):
    group_chat_page(wd1,groupname)
    send_image(wd1)
    sleep(5)
    leave_group_list_page(wd1)
    
    conversation_page(wd2)
    if check_message(wd2, sender, "[image]")  == True:
        print "PASS: Image message is recieved!"
    else:
        print "FAIL: Image message is not recieved!"

# Send Audio Message to Group
def send_audio_to_group(wd1,wd2,sender,groupname):
    group_chat_page(wd1,groupname)
    send_audio(wd1)
    leave_group_list_page(wd1)
    
    conversation_page(wd2)
    if check_message(wd2, sender, "[audio]")  == True:
        print "Audio message is recieved!"
    else:
        print "!!!Audio message is not recieved!"

# Send Location Message to Group
def send_location_to_group(wd1,wd2,sender,groupname):
    group_chat_page(wd1,groupname)
    send_location(wd1)
    leave_group_list_page(wd1)
    
    conversation_page(wd2)
    if check_message(wd2, sender, "[location]")  == True:
        print "PASS: Location message is recieved!"
    else:
        print "FAIL: Location message is not recieved!"

# Dismiss Group
def dismiss_group(wd1,wd2,wd3,groupname):
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    wd1.find_element_by_id('Dismiss group').click()
    sleep(2)
    accept_alert(wd2)
    sleep(2)

    if find_target(wd1,groupname) == False:
        print "PASS: Group %s has been dismissed successfully!" % str(groupname)
        leave_group_list_page(wd1)
    else:
        print "FAIL: Failed to dismiss group %s!" % str(groupname)
        leave_group_list_page(wd1)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '11' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of dismissing group!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of dismissing group!"

# Leave Group
def leave_group(wd1,wd2,wd3,groupname):
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    wd1.find_element_by_id('Leave group').click()
    sleep(2)
    accept_alert(wd2)
    sleep(2)
    if find_target(wd1,groupname) == False:
        print "PASS: Leave group %s successfully!" % str(groupname)
        leave_group_list_page(wd1)
    else:
        print "FAIL: Failed to leave group %s!" % str(groupname)
        leave_group_list_page(wd1)

    alert = WebDriverWait(wd3,10).until(EC.alert_is_present())
    if 'Group Multi-devices' and '13' in alert.text:
        alert.accept()
        print "PASS: Multi-devices sync of leaving group!"
    else:
        alert.accept()
        print "FAIL: Multi-devices sync of leaving group!"

# Go to Chatroom List Page
def chatroom_list_page(wd):
    contacts_page(wd)
    WebDriverWait(wd,30).until(EC.element_to_be_clickable((By.ID,"Chatroom"))).click()
    sleep(3)

# Go to Chatroom Details Page
def chatroom_details_page(wd,roomname):
    wd.find_element_by_name('group detail').click()

# Leave Chatroom List Page
def leave_chatroom_list_page(wd):
    back_to_previous_page(wd)

# Leave Chatroom Page
def leave_chatroom_page(wd,roomname):
    back_to_previous_page(wd)
    sleep(2)
    leave_chatroom_list_page(wd)

# Leave Chatroom Details Page
def leave_chatroom_details_page(wd,roomname):
    back_to_previous_page(wd)
    sleep(2)
    leave_chatroom_page(wd,roomname)

# Find Target Chatroom
def find_target_chatroom(wd,roomname):
    if find_target(wd,roomname) == True:
        return True
        print "Find chatroom %s!" % str(roomname)
    
    while find_target(wd,roomname) == False:
        wd.execute_script('mobile: scroll', {'direction': 'down'})
        if find_target(wd,roomname) == True:
            break
        return True
        print "Find chatroom %s!" % str(roomname)

# Enter Target Chatroom
def enter_target_chatroom(wd,roomname):
    if find_target(wd,roomname) == True and wd.find_element_by_id(roomname).is_displayed():
        click_target_item(wd,roomname)

    while find_target(wd,roomname) == True and not wd.find_element_by_id(roomname).is_displayed():
        wd.execute_script('mobile: scroll', {'direction': 'down'})
        if wd.find_element_by_id(roomname).is_displayed():
            click_target_item(wd,roomname)
            break
            
    while find_target(wd,roomname) == False:
        wd.execute_script('mobile: scroll', {'direction': 'down'})
        if wd.find_element_by_id(roomname).is_displayed():
            click_target_item(wd,roomname)
            break
                
# Create Chatroom
def create_chatroom(wd,roomname):
    chatroom_list_page(wd)
    create_button = wd.find_element_by_id("创建")
    create_button.click()
    chatroom_name = wd.find_element_by_id("Please input chatroom name")
    chatroom_name.send_keys(roomname)
    wd.find_element_by_id("done").click()
    sleep(2)

    swipe_to_refresh(wd)
    if find_target_chatroom(wd,roomname) == True:
        print "PASS: Chatroom %s has been created successfully!" % str(roomname)
    else:
        print "FAIL: Failed to create chatroom %s!" % str(roomname)

# Send Message to Chatroom
def send_message_to_chatroom(wd1,wd2,roomname):
    enter_target_chatroom(wd1,roomname)
    chatroom_list_page(wd2)
    enter_target_chatroom(wd2,roomname)
    send_text(wd1,'chatroom message')
    sleep(2)
    
    if wd2.find_element_by_id('chatroom message').is_displayed():
        print "PASS: Send message to chatroom successfully!"
    else:
        print "FAIL: Not receive chatroom message!"

# Get ChatroomID
def get_chatroom_id(wd,roomname):
    cells = wd.find_elements_by_class_name('XCUIElementTypeCell')
    static_texts = cells[0].find_elements_by_class_name('XCUIElementTypeStaticText')
    global chatroom_id
    chatroom_id = static_texts[1].text

# Add Chatroom Member to Admin List
def add_to_chatroom_admin(wd1,wd2,roomname,member):
    chatroom_details_page(wd1,roomname)
    sleep(1)
    wd1.find_element_by_id('members count').click()
    target = wd1.find_element_by_id(member)
    long_press(wd1,target)
    wd1.find_element_by_id('Add to admin').click()
    sleep(2)
    accept_alert(wd2)
    back_to_previous_page(wd1)
    wd1.find_element_by_id('Admin List').click()
    swipe_to_refresh(wd1)

    if find_target(wd1,member) == True:
        print 'PASS: Add %s to admin list successfully!' % str(member)
    else:
        print 'FAIL: Failed to add %s to admin list!' % str(member)

# Remove Chatroom Member from Admin List
def remove_from_chatroom_admin(wd1,wd2,roomname,member):
    target = wd1.find_element_by_id(member)
    long_press(wd1,target)
    wd1.find_element_by_id('Remove from Admin').click()
    sleep(2)
    accept_alert(wd2)

    if find_target(wd1,member) == False:
        print 'PASS: Remove %s from admin list successfully!' % str(member)
        back_to_previous_page(wd1)
    else:
        print 'FAIL: Failed to remove %s from admin list!' % str(member)
        back_to_previous_page(wd1)

# Add Chatroom Member to Mute List
def add_to_chatroom_mute(wd1,wd2,roomname,member):
    wd1.find_element_by_id('members count').click()
    target = wd1.find_element_by_id(member)
    long_press(wd1,target)
    wd1.find_element_by_id('Mute').click()
    sleep(2)
    accept_alert(wd2)
    back_to_previous_page(wd1)
    wd1.find_element_by_id('Mute List').click()

    if find_target(wd1,member) == True:
        print 'PASS: Add %s to mute list successfully!' % str(member)
    else:
        print 'FAIL: Failed to add %s to mute list!' % str(member)

# Remove Chatroom Member from Mute List
def remove_from_chatroom_mute(wd1,wd2,roomname,member):
    target = wd1.find_element_by_id(member)
    long_press(wd1,target)
    wd1.find_element_by_id('Unmute').click()
    sleep(2)
    accept_alert(wd2)

    if find_target(wd1,member) == False:
        print 'PASS: Remove %s from mute list successfully!' % str(member)
        back_to_previous_page(wd1)
    else:
        print 'FAIL: Failed to remove %s from mute list!' % str(member)
        back_to_previous_page(wd1)

# Add Chatroom Member to Black List
def add_to_chatroom_blacklist(wd,roomname,member):
    wd.find_element_by_id('members count').click()
    target = wd.find_element_by_id(member)
    long_press(wd,target)
    wd.find_element_by_id('Move to blacklist').click()
    sleep(2)
    back_to_previous_page(wd)
    wd.find_element_by_id('Blacklist').click()

    if find_target(wd,member) == True:
        print 'PASS: Add %s to blacklist successfully!' % str(member)
    else:
        print 'FAIL: Failed to add %s to blacklist!' % str(member)

# Remove Chatroom Member from Black List
def remove_from_chatroom_blacklist(wd,roomname,member):
    target = wd.find_element_by_id(member)
    long_press(wd,target)
    wd.find_element_by_id('Remove from blacklist').click()

    if find_target(wd,member) == False:
        print 'PASS: Remove %s from blacklist successfully!' % str(member)
        back_to_previous_page(wd)
    else:
        print 'FAIL: Failed to remove %s from blacklist!' % str(member)
        back_to_previous_page(wd)

# Kick Chatroom Member out of Chatroom
def remove_member_from_chatroom(wd1,wd2,roomname,member):
    chatroom_list_page(wd2)
    enter_target_chatroom(wd2,roomname)
    wd1.find_element_by_id('members count').click()
    target = wd1.find_element_by_id(member)
    long_press(wd1,target)
    wd1.find_element_by_id('Remove from group').click()

    if find_target(wd1,member) == False:
        print 'PASS: Remove %s from chatroom successfully!' % str(member)
        back_to_previous_page(wd1)
    else:
        print 'FAIL: Failed to remove %s from chatroom!' % str(member)
        back_to_previous_page(wd1)

# Transfer Chatroom
def transfer_chatroom(wd1,wd2,roomname,newowner):
    wd1.find_element_by_id('Owner').click()
    chatroom_owner = wd1.find_element_by_class_name('XCUIElementTypeTextField')
    chatroom_owner.clear()
    chatroom_owner.send_keys(newowner)
    wd1.find_element_by_id('ok').click()
    sleep(2)
    accept_alert(wd2)
    back_to_previous_page(wd1)
    wd1.find_element_by_id('group detail').click()

    if wd1.find_element_by_id('Leave the chatroom').is_displayed():
        print "PASS: Chatroom owner has been transfered to %s successfully!" % str(newowner)
    else:
        print "FAIL: Failed to transfer group!"

# Leave Chatroom
def leave_chatroom(wd,roomname):
    wd.find_element_by_id('Leave the chatroom').click()
    if wd.find_element_by_id('创建').is_displayed():
        print "PASS: Leave chatroom successfully!"
        leave_chatroom_list_page(wd)
    else:
        print "FAIL: Failed to leave chatroom!"
        leave_chatroom_list_page(wd)

# Destroy Chatroom
def destroy_chatroom(wd,roomname):
    chatroom_list_page(wd)
    enter_target_chatroom(wd,roomname)
    wd.find_element_by_id('group detail').click()
    get_chatroom_id(wd,roomname)
    
    wd.find_element_by_id('Destroy the chatroom').click()
    url = 'https://%s/%s/%s/chatrooms/%s' % (resturl, org, appkey, chatroom_id)
    get_chatroom_details = requests.get(url, headers = header)

    if get_chatroom_details.status_code == 404:
        print "PASS: Chatroom %s has been destroyed successfully!" % str(roomname)
        leave_chatroom_list_page(wd)
    else:
        print "FAIL: Failed to destroy chatroom %s!" % str(roomname)
        leave_chatroom_list_page(wd)
        print "Return code: ", get_chatroom_details.status_code
    
def initial_multi_audio_call(wd1,wd2,wd3):
    contacts_page(wd2)
    WebDriverWait(wd2,30).until(EC.element_to_be_clickable((By.ID,'Mutil Voice Conference'))).click()
    sleep(2)
    wd2.find_element_by_id('conf add').click()
    sleep(2)
    wd2.find_element_by_id(user1).click()
    wd2.find_element_by_id(user3).click()
    wd2.find_element_by_id('Down').click()
    sleep(3)

    if wd2.find_element_by_id(user1).is_displayed() and wd2.find_element_by_id(user2).is_displayed() and wd2.find_element_by_id(user3).is_displayed():
        print 'PASS: Multi-voice conference is established successfully!'
    else:
        print 'FAIL: Failed to establish multi-voice conference!'

def quit_multi_audio_call(wd1,wd2,wd3):
    wd1.find_element_by_id('Button End').click()
    wd2.find_element_by_id('Button End').click()
    wd3.find_element_by_id('Button End').click()

    if wd1.find_element_by_id("Contacts").is_displayed() and wd2.find_element_by_id("Contacts").is_displayed() and wd3.find_element_by_id("Contacts").is_displayed():
        print 'PASS: Quit multi-voice conference call successfully!'
    else:
        print 'FAIL: Failed to quit multi-voice conference call!'

def initial_multi_video_call(wd1,wd2,wd3):
    contacts_page(wd2)
    WebDriverWait(wd2,30).until(EC.element_to_be_clickable((By.ID,'Mutil Video Conference'))).click()
    wd2.find_element_by_id('conf plus').click()
    sleep(2)
    wd2.find_element_by_id(user1).click()
    wd2.find_element_by_id(user3).click()
    wd2.find_element_by_id('Down').click()
    sleep(3)

    if wd2.find_element_by_id(user1).is_displayed() and wd2.find_element_by_id(user2).is_displayed() and wd2.find_element_by_id(user3).is_displayed():
        print 'PASS: Multi-video conference is established successfully!'
    else:
        print 'FAIL: Failed to establish multi-video conference!'

def quit_multi_video_call(wd1,wd2,wd3):
    wd1.find_element_by_id('Button End').click()
    wd2.find_element_by_id('Button End').click()
    wd3.find_element_by_id('Button End').click()

    if wd1.find_element_by_id("Contacts").is_displayed() and wd2.find_element_by_id("Contacts").is_displayed() and wd3.find_element_by_id("Contacts").is_displayed():
        print 'PASS: Quit multi-video conference call successfully!'
    else:
        print 'FAIL: Failed to quit multi-video conference call!'

def recall_chat_message(wd1,wd2,caller,callee):
    send_to_user(wd1,callee)
    sleep(2)
    target = wd1.find_element_by_id('chat message')
    long_press(wd1,target)
    wd1.find_element_by_id('Recall').click()
    sleep(2)

    if wd1.find_element_by_id('You recall a message').is_displayed() and wd2.find_element_by_id(caller + ' recall a message'):
        print 'PASS: Chat message is recalled successfully!'
        back_to_previous_page(wd1)
    else:
        print 'FAIL: Failed to recall chat message!'
        back_to_previous_page(wd1)

def recall_group_message(wd1,wd2,groupname,caller,callee):
    group_chat_page(wd1,groupname)
    sleep(2)
    target = wd1.find_element_by_id('group message')
    long_press(wd1,target)
    wd1.find_element_by_id('Recall').click()
    sleep(2)

    if wd1.find_element_by_id('You recall a message').is_displayed() and wd2.find_element_by_id(caller + ' recall a message'):
        print 'PASS: Group message is recalled successfully!'
        leave_group_chat_page(wd1,groupname)
    else:
        print 'FAIL: Failed to recall group message!'
        leave_group_chat_page(wd1,groupname)

def recall_chatroom_message(wd1,wd2,roomname,caller,callee):
    target = wd1.find_element_by_id('chatroom message')
    long_press(wd1,target)
    wd1.find_element_by_id('Recall').click()
    sleep(2)

    if wd1.find_element_by_id('You recall a message').is_displayed() and wd2.find_element_by_id(caller + ' recall a message'):
        print 'PASS: Chatroom message is recalled successfully!'
    else:
        print 'FAIL: Failed to recall chatroom message!'

def pull_chatmsg_from_server(wd1,wd2,sender,receiver):
    settings_page(wd1)
    swipe_up(wd1)
    switch = wd1.find_element_by_id('The priority server gets the message')
    switch.click()
    msg1 = ''.join(random.sample(string.ascii_letters + string.digits, 8))
    msg2 = ''.join(random.sample(string.ascii_letters + string.digits, 8))
    send_text_to_user(wd1,wd2,sender,receiver,msg1)
    send_text_to_user(wd1,wd2,sender,receiver,msg2)
    send_to_user(wd1,receiver)
    sleep(2)
    wd1.find_element_by_id('delete').click()
    wd1.find_element_by_id('ok').click()
    swipe_to_refresh(wd1)
    sleep(2)

    if find_target(wd1,msg1) == True and find_target(wd1,msg2) == True:
        print 'PASS: Chat message is pulled from server succesfully!'
        back_to_previous_page(wd1)
    else:
        print 'FAIL: Failed to pull chat message from server!'
        back_to_previous_page(wd1)

def pull_groupmsg_from_server(wd1,wd2,sender,groupname):
    msg1 = ''.join(random.sample(string.ascii_letters + string.digits, 8))
    msg2 = ''.join(random.sample(string.ascii_letters + string.digits, 8))
    send_text_to_group(wd1,wd2,sender,groupname,msg1)
    send_text_to_group(wd1,wd2,sender,groupname,msg2)
    group_details_page(wd1,groupname)
    swipe_up(wd1)
    wd1.find_element_by_id('Clear all messages').click()
    wd1.find_element_by_id('ok').click()
    back_to_previous_page(wd1)
    swipe_to_refresh(wd1)
    sleep(2)

    if find_target(wd1,msg1) == True and find_target(wd1,msg2) == True:
        print 'PASS: Group message is pulled from server succesfully!'
        leave_group_chat_page(wd1,groupname)
    else:
        print 'FAIL: Failed to pull group message from server!'
        leave_group_chat_page(wd1,groupname)

def multi_devices_send_msg(wd1,wd2,wd3,sender,receiver):
    send_text_to_user(wd1,wd2,sender,receiver,'send msg sync')
    send_to_user(wd3,receiver)
    sleep(1)

    if wd3.find_element_by_id('send msg sync').is_displayed():
        print 'PASS: Msg sent is synchronized on antoher device!'
        back_to_previous_page(wd3)
    else:
        print 'FAIL: Msg sent is not synchronized on another device!'
        back_to_previous_page(wd3)

def multi_devices_receive_msg(wd1,wd2,wd3,sender,receiver):
    send_text_to_user(wd2,wd1,sender,receiver,'receive msg sync')
    msg = 'receive msg sync'
    conversation_page(wd1)
    conversation_page(wd3)
    sleep(1)

    if check_message(wd1, sender, msg) == True and check_message(wd3, sender, msg) == True:
        print 'PASS: Msg received is synchronized on antoher device!'
    else:
        print 'FAIL: Msg received is not synchronized on another device!'

def friend():
    user1 = ''.join(random.sample(string.ascii_letters + string.digits, 8))
    user2 = ''.join(random.sample(string.ascii_letters + string.digits, 8))
    regiser_user(wd1,user1,psw)
    regiser_user(wd1,user2,psw)
    login(wd1,user1,psw)
    login(wd2,user2,psw)
    reject_friend(wd1,wd2,user2,user1)
    accept_friend(wd1,wd2,user2,user1)
    delete_contact(wd1,user1,user2)
    delete_user(user1)
    delete_user(user2)


if __name__ == "__main__":
    wd1 = start_demo('A6F3C55A-EBBC-43C6-B42E-EC661C60335E','iPhone 7',8100)
    accept_alert(wd1)
    wd2 = start_demo('AE2E7730-BCCE-41C4-9D8D-547F7DB0ABF5','iPhone X',8200)
    accept_alert(wd2)
    wd3 = start_demo('E4B77E6E-F117-4748-819A-1374DB2943D0','iPhone 8',8300)
    accept_alert(wd3)
    delete_user(user1)
    delete_user(user2)
    delete_user(user3)
    register_user(wd1,user1,psw)
    register_user(wd1,user2,psw)
    register_user(wd1,user3,psw)
    login(wd1,user1,psw)
    login(wd2,user2,psw)
    login(wd3,user3,psw)
    reject_friend(wd1,wd2,user2,user1)
    accept_friend(wd1,wd2,user2,user1)
    accept_friend(wd2,wd3,user3,user2)
    switch_account(wd3,user1,psw)
    add_user_to_blacklist_multidev(wd1,wd3,user1,user2)
    remove_user_from_blacklist_multidev(wd1,wd3,user1,user2)
    switch_account(wd3,user3,psw)
    send_text_to_user(wd1,wd2,user1,user2,'chat message')
    recall_chat_message(wd1,wd2,user1,user2)
    send_image_to_user(wd1,wd2,user1,user2)
    send_audio_to_user(wd1,wd2,user1,user2)
    send_location_to_user(wd1,wd2,user1,user2)
    initial_audio_call(wd1,user2)
    reject_call(wd1,wd2)
    initial_audio_call(wd1,user2)
    answer_call(wd2)
    end_call(wd1)
    initial_video_call(wd1,user2)
    reject_call(wd1,wd2)
    initial_video_call(wd1,user2)
    answer_call(wd2)
    end_call(wd1)
    initial_multi_audio_call(wd1,wd2,wd3)
    quit_multi_audio_call(wd1,wd2,wd3)
    initial_multi_video_call(wd1,wd2,wd3)
    quit_multi_video_call(wd1,wd2,wd3)
    switch_account(wd3,user1,psw)
    create_private_invite_group(wd1,wd3,group1)
    add_group_member(wd1,wd2,wd3,group1,user2)
    switch_account(wd3,user3,psw)
    member_invite_to_group(wd1,wd2,wd3,group1,user3)
    switch_account(wd3,user1,psw)
    create_private_group(wd2,group2)
    create_public_free_group(wd2,group3)
    create_public_permission_group(wd1,wd3,group4)
    join_public_free_group(wd1,wd2,wd3,user2,group3)
    join_public_permission_group_reject(wd1,wd2,wd3,user2,group4)
    join_public_permission_group_accept(wd1,wd2,wd3,user2,group4)
    apply_join_group(wd1,wd2,wd3,'auto5')
    # reject_group_invitation(wd1,wd2,wd3,group2,user1)
    accept_group_invitation(wd1,wd2,wd3,group2,user1)
    send_text_to_group(wd1,wd2,user1,group1,'group message')
    recall_group_message(wd1,wd2,group1,user1,user2)
    send_image_to_group(wd1,wd2,user1,group1)
    send_audio_to_group(wd1,wd2,user1,group1)
    send_location_to_group(wd1,wd2,user1,group1)
    pull_chatmsg_from_server(wd1,wd2,user1,user2)
    pull_groupmsg_from_server(wd1,wd2,user1,group1)
    block_group_message(wd1,wd2,wd3,group1)
    unblock_group_message(wd1,wd2,wd3,group1)
    upload_group_files(wd1,wd2,group1)
    remove_group_files(wd1,wd2,group1)
    group_announcement(wd1,wd2,wd3,group1)
    change_group_name(wd2,'auto5','newname5')
    remove_group_member(wd1,wd2,wd3,group1,user3)
    add_to_mute_list(wd1,wd2,wd3,group1,user2)
    remove_from_mute_list(wd1,wd2,wd3,group1,user2)
    add_member_to_admin(wd1,wd2,wd3,group1,user2)
    remove_member_from_admin(wd1,wd2,wd3,group1,user2)
    add_member_to_blacklist(wd1,wd2,wd3,group1,user2)
    remove_member_from_blacklist(wd1,wd3,group1,user2)
    transfer_group(wd1,wd2,wd3,group2,user1)
    leave_group(wd1,wd2,wd3,group3)
    dismiss_group(wd1,wd2,wd3,group2)
    create_chatroom(wd1,room)
    send_message_to_chatroom(wd1,wd2,room)
    recall_chatroom_message(wd1,wd2,room,user1,user2)
    add_to_chatroom_admin(wd1,wd2,room,user2)
    remove_from_chatroom_admin(wd1,wd2,room,user2)
    add_to_chatroom_mute(wd1,wd2,room,user2)
    remove_from_chatroom_mute(wd1,wd2,room,user2)
    add_to_chatroom_blacklist(wd1,room,user2)
    remove_from_chatroom_blacklist(wd1,room,user2)
    remove_member_from_chatroom(wd1,wd2,room,user2)
    transfer_chatroom(wd1,wd2,room,user2)
    leave_chatroom(wd1,room)
    destroy_chatroom(wd2,room)
    multi_devices_send_msg(wd1,wd2,wd3,user1,user2)
    multi_devices_receive_msg(wd1,wd2,wd3,user2,user1)
    delete_contact(wd1,wd3,user1,user2)
    logout(wd1)
    logout(wd2)
    logout(wd3)


    print "--- Test End ---"
    

