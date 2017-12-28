# -*- coding: utf-8 -*-
from appium import webdriver
from appium.webdriver.webelement import WebElement
from appium.webdriver.common.touch_action import TouchAction
from time import sleep
import json
import time
import requests
import configdata
import os
import rest

def android_para(test_env,test_im):
	global dversion, android_sdk, time_out, appPackage
	dversion = "4.4.2"
	if test_env == "aws" or test_env == "vip7":
		time_out = 15
	else:
		time_out = 5
	print "timeout is %s seconds" %time_out
	if test_im == "msync":
		android_sdk = "msync"	# This value only can be 'xmpp' or 'msync'
		appPackage = "com.hyphenate.chatuidemo"
	else:
		android_sdk = "xmpp"
		appPackage = "com.easemob.chatuidemo"

def startDemo(deviceid):
	desired_caps = {}
	desired_caps['platformName'] = "Android"
	desired_caps['platformVersion'] = dversion
	desired_caps['deviceName'] = deviceid
	desired_caps['udid'] = deviceid
	desired_caps['appPackage'] = appPackage
	desired_caps['appActivity'] = '%s.ui.SplashActivity' %appPackage
	desired_caps['newCommandTimeout'] = 1200
	desired_caps['noReset'] = True
	global driver1 
	driver1 = webdriver.Remote('http://localhost:4723/wd/hub', desired_caps)
	driver1.implicitly_wait(time_out)
	return driver1

def startDemo2(deviceid2):
	desired_caps = {}
	desired_caps['platformName'] = "Android"
	desired_caps['platformVersion'] = dversion
	desired_caps['deviceName'] = deviceid2
	desired_caps['udid'] = deviceid2
	desired_caps['appPackage'] = appPackage
	desired_caps['appActivity'] = '%s.ui.SplashActivity' %appPackage
	desired_caps['newCommandTimeout'] = 1200
	desired_caps['noReset'] = True
	global driver2 
	driver2 = webdriver.Remote('http://localhost:4725/wd/hub', desired_caps)
	driver2.implicitly_wait(time_out)
	return driver2
	
def clickname(driver,name):
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']" %name).click()
	
def findname(driver,name):
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']" %name)
	except:
		raise Exception("not find element named %s" %name)
	
def notfindname(driver,name):
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']" %name)
		raise Exception("should not find element named %s" %name)
	except:
		print "not find element named %s as expected" %name
	
def back(driver):
	sleep(0.5)
	driver.press_keycode(4)
	
def back2(driver):
	for i in range(2):
		back(driver)
		sleep(0.5)

def back_left(driver):
	driver.find_element_by_id("%s:id/left_layout" %appPackage).click()

def swipe_up(driver,start_point=3/float(4),end_point=1/float(4)):
	height = driver.get_window_size()["height"]
	width = driver.get_window_size()["width"]
	driver.swipe(width/2, height*start_point, width/2, height*end_point, 1000)
	
def swipe_down(driver,start_point=1/float(4),end_point=3/float(4)):
	height = driver.get_window_size()["height"]
	width = driver.get_window_size()["width"]
	driver.swipe(width/2, height*start_point, width/2, height*end_point, 1000)
	
def gotoConversation(driver):
	driver.find_element_by_id("%s:id/btn_conversation" %appPackage).click()
	
def gotoSetting(driver):
	driver.find_element_by_id("%s:id/btn_setting" %appPackage).click()
	
def gotoContact(driver):
	driver.find_element_by_id("%s:id/btn_address_list" %appPackage).click()
	
def gotoGroup(driver):
	gotoContact(driver)
	driver.find_element_by_xpath("//android.widget.TextView[@text='Group chat']").click()
	
def gotoChatroomlist(driver):
	gotoContact(driver)
	driver.find_element_by_xpath("//android.widget.TextView[@text='Chat room']").click()	
	
def backfromgroupinfo(driver):
	sleep(1)
	driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='0']/android.widget.LinearLayout[@index='0']").click()
	driver.find_element_by_id("%s:id/left_image" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.LinearLayout[@index='0']/android.widget.ImageView").click()
	gotoConversation(driver)
	
def backfromroom(driver):
	sleep(1)
	driver.find_element_by_id("%s:id/left_image" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='0']/android.widget.LinearLayout").click()

def gotogroupinfo(driver,groupname):
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname).click()
	driver.find_element_by_id("%s:id/right_image" %appPackage).click()
	find_status = True
	while find_status:
		try:
			driver.find_element_by_id("%s:id/progressBar" %appPackage)
		except:
			find_status = False
	
def register(driver,name):
	driver.find_element_by_xpath("//android.widget.Button[@text='Register']").click()
	driver.find_element_by_id("%s:id/username" %appPackage).send_keys(name)
	driver.find_element_by_id("%s:id/password" %appPackage).send_keys("1")
	driver.find_element_by_id("%s:id/confirm_password" %appPackage).send_keys("1")
	driver.find_element_by_xpath("//android.widget.Button[@text='Register']").click()
	find_status = False
	for i in range(2):
		try:
			driver.find_element_by_xpath("//android.widget.Button[@text='Login']")
			find_status = True
			break
		except:	
			pass
	if find_status == False:
		driver.press_keycode(4)
		raise Exception("register failed!")	

def login_validAccount(driver,username,password):
	driver.find_element_by_id("%s:id/username" %appPackage).send_keys(username) 
	driver.find_element_by_id("%s:id/password" %appPackage).send_keys(password)
	driver.find_element_by_xpath("//android.widget.Button[@text='Login']").click()
	for i in range(41):
		if i<40:
			cur_Activity = driver.current_activity
			if cur_Activity == ".ui.MainActivity":
				print "Login success!"
				break
			else:
				sleep(1)
		else:
			raise Exception("Login failed!")

def delconversation(driver):
	try:
		while True:
			elem = driver.find_element_by_id("%s:id/list_itease_layout" %appPackage)
			action1 = TouchAction(driver)
			action1.long_press(elem).wait(1000).perform()
			if android_sdk == "xmpp":
				driver.find_element_by_xpath("//android.widget.TextView[@text='Delete conversation']").click()
			else:
				driver.find_element_by_xpath("//android.widget.TextView[@text='Delete conversation and messages']").click()
	except:
		print 'No conversation to be deleted'			
		
def login_wrongAccount(driver,username,password):
	driver.find_element_by_id("%s:id/username" %appPackage).send_keys(username)
	driver.find_element_by_id("%s:id/password" %appPackage).send_keys(password)
	driver.find_element_by_xpath("//android.widget.Button[@text='Login']").click()
	for i in range(6):
		if i < 5:
			cur_Activity = driver.current_activity
			if cur_Activity == ".ui.MainActivity":
				raise Exception("Login success with wrong password, case failed!")				
			else:
				sleep(1)
		else:
			print "Not login as expected, case passed!"

def addContact(driver,name):
	driver.find_element_by_id("%s:id/right_image" %appPackage).click()
	driver.find_element_by_id("%s:id/edit_note" %appPackage).send_keys(name)
	driver.find_element_by_id("%s:id/search" %appPackage).click()
	driver.find_element_by_id("%s:id/indicator" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.ImageView").click()
	
def findContact(driver,name,contact_case):
	swipe_up(driver)
	if contact_case == "agree":
		try:
			driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
			print "Add contact %s successfully!" %name
		except:
			raise Exception("Add contact failed since cannot find it!")
		finally:
			gotoConversation(driver)
	else:
		try:
			driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
			raise Exception("Invitation is refused failed! add friend unexpectedly.")
		except:
			print "Invitation is refused successfully! not add this friend."
		finally:
			gotoConversation(driver)

def agreeContact(driver):
	sleep(3)
	driver.find_element_by_xpath("//android.widget.TextView[@text='Invitation and notification']").click()
	try:
		driver.find_element_by_xpath("//android.widget.Button[@text='Agree']").click()
		sleep(2)
	except:
		raise Exception("Failed! Cannot find agree button.")	
	
def refuseContact(driver):
	if android_sdk == "msync":
		driver.find_element_by_xpath("//android.widget.TextView[@text='Invitation and notification']").click()
		try:
			driver.find_element_by_xpath("//android.widget.Button[@text='Refuse']").click()
			sleep(2)
		except:
			raise Exception("Failed! Cannot find refuse button.")
	else:
		driver.find_element_by_xpath("//android.widget.TextView[@text='Invitation and notification']").click()

def delContact(driver,name):
	swipe_up(driver)
	elem = driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
	action1 = TouchAction(driver)
	action1.long_press(elem).wait(2000).perform()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Delete the contact']").click()
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
		raise Exception("contact deleted failed since still find it.")
	except:
		print "contact deleted successful."
	finally:
		gotoConversation(driver)

def addBlacklist_contact(driver,name):
	swipe_up(driver)
	elem = driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
	action1 = TouchAction(driver)
	action1.long_press(elem).wait(2000).perform()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Move into the blacklist']").click()
	gotoSetting(driver)
	elem_id = "%s:id/ll_black_list" %appPackage
	text = "black list item."
	elem = findelem_swipe(driver,elem_id,text)
	elem.click()
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
		print "add black list successful."
	except:
		print "add black list failed since not find it."
	finally:
		back(driver)
		gotoConversation(driver)

def delBlacklist_contact(driver,name):
	gotoSetting(driver)
	elem_id = "%s:id/ll_black_list" %appPackage
	text = "black list item."
	elem = findelem_swipe(driver,elem_id,text)
	elem.click()
	elem = driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
	action1 = TouchAction(driver)
	action1.long_press(elem).wait(2000).perform()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Remove from blacklist']").click()
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%name)
		raise Exception("remove black list failed since still find it.")
	except:
		print "remove black list successful."
	finally:
		back(driver)
		gotoConversation(driver)
	
def showGroupinfo(driver,groupname):
	member_list = []
	expected_list = set(["at1","b0","at0"])
	gotogroupinfo(driver,groupname)
	elems = driver.find_elements_by_xpath("//android.widget.RelativeLayout/android.widget.LinearLayout/android.widget.TextView")
	for elem in elems:
		member = elem.get_attribute("text")
		member_list.append(member)
	print "expected member list is:", list(expected_list)
	print "actual member list is: ", member_list
	if len(set(member_list).symmetric_difference(expected_list)) == 0:
		print "Group member get successful."
		backfromgroupinfo(driver)
	else:
		backfromgroupinfo(driver)
		raise Exception("Group member list not as expected")
	
def createGroup(driver,groupname,ifpublic,membername=None):
	driver.find_element_by_xpath("//android.widget.TextView[@text='Create new group']").click()
	driver.find_element_by_id("%s:id/edit_group_name" %appPackage).send_keys(groupname)
	if ifpublic == "public":
		driver.find_element_by_id("%s:id/cb_public" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.Button[@text='Save']").click()
	if membername != None:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%membername).click()
	driver.find_element_by_xpath("//android.widget.Button[@text='Save']").click()
	sleep(2)
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)
		print "create group successful."
	except:
		raise Exception("create group failed since not find it.")
	finally:
		back(driver)
		gotoConversation(driver)
	
def dismissGroup(driver,groupname):
	gotogroupinfo(driver,groupname)
	driver.find_element_by_id("%s:id/btn_exitdel_grp" %appPackage).click()
	driver.find_element_by_id("%s:id/btn_exit" %appPackage).click()
	sleep(2)
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)
	except:
		print "group dismiss successful."
	else:
		raise Exception("case failed since still find group after dismissing.")
	finally:
		back(driver)
		gotoConversation(driver)

def addGroupmember_agree(driver,groupname,membername):
	gotogroupinfo(driver,groupname)
	elems = driver.find_elements_by_xpath("//android.widget.GridView/android.widget.RelativeLayout")
	addindex = len(elems)-2
	driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='%s']"%addindex).click()
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%membername).click()
	driver.find_element_by_xpath("//android.widget.Button[@text='Save']").click()
	backfromgroupinfo(driver)

def addmanyGroupmember_agree(driver,membernum):
	gotogroupinfo(driver,groupname)
	elems = driver.find_elements_by_xpath("//android.widget.GridView/android.widget.RelativeLayout")
	addindex = len(elems)-2
	driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='%s']"%addindex).click()
	member_list = []
	while True:
		elems = driver.find_elements_by_id("%s:id/name" %appPackage)		
		for elem in elems:
			member_len = len(member_list)
			member = elem.get_attribute("text")
			if member not in member_list and member_len < membernum:
				member_list.append(member)
				elem.click()
		swipe_up()
		if member_len == membernum:
			break
	print "member list length", member_len
	driver.find_element_by_xpath("//android.widget.Button[@text='Save']").click()
	start_time = time.time()
	elems = driver.find_elements_by_xpath("//android.widget.RelativeLayout/android.widget.LinearLayout/android.widget.TextView")
	if 	len(elems) >= 2:
		end_time = time.time()
		cost_time = end_time - start_time
		print "%s seconds costs after adding %s members: success." %(cost_time,membernum)
	else:
		end_time = time.time()
		cost_time = end_time - start_time
		print "%s seconds costs after adding %s members: failed." %(cost_time,membernum)
		
def createaddmanyGroupmember_agree(driver,membernum):
	driver.find_element_by_id("%s:id/rl_group" %appPackage).click()
	driver.find_element_by_id("%s:id/edit_group_name" %appPackage).send_keys(groupname)
	driver.find_element_by_id("%s:id/cb_public" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.Button[@text='Save']").click()	
	member_list = []
	while True:
		elems = driver.find_elements_by_id("%s:id/name" %appPackage)		
		for elem in elems:
			member_len = len(member_list)
			member = elem.get_attribute("text")
			if member not in member_list and member_len < membernum:
				member_list.append(member)
				elem.click()
		swipe_up()
		if member_len == membernum:
			break
	print "member list length", member_len
	driver.find_element_by_xpath("//android.widget.Button[@text='Save']").click()
 	start_time = time.time()	
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='Group chat']")
		end_time = time.time()
		cost_time = end_time - start_time
		print "%s seconds costs after adding %s members: success." %(cost_time,membernum)
	except:
		end_time = time.time()
		cost_time = end_time - start_time
		print "%s seconds costs after adding %s members: failed." %(cost_time,membernum)
	
def findGroupmember(driver,groupname,membername):
	gotogroupinfo(driver,groupname)
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%membername)
		print "find member %s in group." %membername
	except:
		raise Exception("case failed since not find member %s in group."%membername)
	finally:
		backfromgroupinfo(driver)
	
def addGroupmember_refuse(driver,groupname,membername):
	gotogroupinfo(driver,groupname)

def shieldgroup(driver,groupname):
	gotogroupinfo(driver,groupname)
	driver.find_element_by_id("%s:id/iv_switch_close" %appPackage).click()
	backfromgroupinfo(driver)

def notshieldgroup(driver,groupname):
	gotogroupinfo(driver,groupname)
	driver.find_element_by_id("%s:id/iv_switch_open" %appPackage).click()
	backfromgroupinfo(driver)

def delGroupmember(driver,groupname,groupmember):
	gotogroupinfo(driver,groupname)
	sleep(2)
	elems = driver.find_elements_by_xpath("//android.widget.GridView/android.widget.RelativeLayout")
	delindex = len(elems)-1
	driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='%s']"%delindex).click()
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupmember).click()
	sleep(5)
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupmember)
		raise Exception("case failed since still find %s in group after deleting it"%groupmember)
	except:
		print "delete %s successful from group" %groupmember
	finally:
		backfromgroupinfo(driver)

def gotogroupbalcklist(driver):
	driver.find_element_by_id("%s:id/rl_blacklist" %appPackage).click()
	find_status = True
	while find_status:
		try:
			driver.find_element_by_id("%s:id/progressBar" %appPackage)
		except:
			find_status = False

def addBlacklist_group(driver,groupname,membername):
	gotogroupinfo(driver,groupname)
	elem = driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%membername)
	action1 = TouchAction(driver)
	action1.long_press(elem).wait(2000).perform()
	driver.find_element_by_id("%s:id/btn_ok" %appPackage).click()
	gotogroupbalcklist(driver)
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%membername)
		print "find %s in group black list" %membername
	except:
		raise Exception("not find %s in group black list") %membername
	finally:
		back(driver)
		backfromgroupinfo(driver)

def delBlacklist_group(driver,groupname,membername):
	gotogroupinfo(driver,groupname)
	gotogroupbalcklist(driver)
	elem = driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%membername)
	action1 = TouchAction(driver)
	action1.long_press(elem).wait(2000).perform()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Remove from blacklist']").click()
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%membername)
		raise Exception("case failed since still find it after removing from black list")
	except:
		print "member %s deleted successful from group." %membername
	finally:
		back(driver)
		backfromgroupinfo(driver)
	
def joinGroup(driver,groupid):
	driver.find_element_by_xpath("//android.widget.TextView[@text='Add public group']").click()
	driver.find_element_by_id("%s:id/btn_search" %appPackage).click()
	driver.find_element_by_id("%s:id/et_search_id" %appPackage).send_keys(groupid)
	driver.find_element_by_id("%s:id/search" %appPackage).click()
	elem = driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='2']/android.widget.TextView")
	groupname = elem.get_attribute("text")
	print groupname
	elem.click()
	driver.find_element_by_id("%s:id/btn_add_to_group" %appPackage).click()
	sleep(5)
	for i in range(3):
		back(driver)
		sleep(0.5)
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)
		print "join group successful."
	except:
		raise Exception("join group failed since not find it.")
	finally:
		back(driver)
 		gotoConversation(driver)
	
def exitGroup(driver,groupname):
	gotogroupinfo(driver,groupname)
	driver.find_element_by_id("%s:id/btn_exit_grp" %appPackage).click()
	driver.find_element_by_id("%s:id/btn_exit" %appPackage).click()
	sleep(2)
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)
		raise Exception("case failed since still find group after dismissing.")
	except:
		print "group dismiss successful."
	finally:
		back(driver)
		gotoConversation(driver)

def clearMsg(driver):
	sleep(2)
	driver.find_element_by_id("%s:id/right_image" %appPackage).click()
	driver.find_element_by_id("%s:id/btn_ok" %appPackage).click()
	
def clearGroupMsg(driver,groupname):
	gotogroupinfo(driver,groupname)
	driver.find_element_by_id("%s:id/clear_all_history" %appPackage).click()
	driver.find_element_by_id("%s:id/btn_ok" %appPackage).click()
	back(driver)
	
def checkmsgsent(driver,msgtype):
	send_status = False
	elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout")
	msgnum = len(elems)
	send_index = msgnum-1
	print "current msgnum:", msgnum
	#this if else used to ensure message in sent finish status.
	if msgtype == "image":
		elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='%s']\
		/android.widget.LinearLayout/android.widget.RelativeLayout/android.widget.LinearLayout/*"%send_index)
		#if length == 2, means progress_bar found. After sending successfully, elems[0].get_attribute("resourceId") will
		#report index error since len(elems) == 0
		while len(elems) == 2:
			sleep(2)
			elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='%s']\
			/android.widget.LinearLayout/android.widget.RelativeLayout/android.widget.LinearLayout/*"%send_index)
	else:
		elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='%s']\
		/android.widget.LinearLayout/android.widget.RelativeLayout/*"%send_index)
		while elems[0].get_attribute("resourceId") == "%s:id/progress_bar" %appPackage:
			sleep(2)
			elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='%s']\
			/android.widget.LinearLayout/android.widget.RelativeLayout/*"%send_index)
	
	elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='%s']\
		/android.widget.LinearLayout/android.widget.RelativeLayout/*"%send_index)
	if elems[0].get_attribute("resourceId") == "%s:id/tv_length" %appPackage:
		send_status = True
		print "%s message send successfully." %msgtype
	elif elems[0].get_attribute("resourceId") == "%s:id/ll_loading" %appPackage:
		send_status = True
		print "%s message send successfully." %msgtype	
	elif elems[0].get_attribute("resourceId") == "%s:id/bubble" %appPackage:
		send_status = True
		print "%s message send successfully." %msgtype
	elif elems[0].get_attribute("resourceId") == "%s:id/tv_ack" %appPackage:
		send_status = True
		print "%s message has been read." %msgtype
	elif elems[0].get_attribute("resourceId") == "%s:id/msg_status" %appPackage:
		print "%s message send failed." %msgtype
	return send_status
	
def sendmsg_text(driver,content,case_type=None):
	msgtype = "text"
	driver.find_element_by_id("%s:id/et_sendmessage" %appPackage).send_keys(content)
	driver.find_element_by_id("%s:id/btn_send" %appPackage).click()
	send_status = checkmsgsent(driver,msgtype)
	if send_status == False:
		if case_type == "black":
			print "message send fail as expected since in black list."
		else:	
			raise Exception("message send fail not as expected.")
	else:
		print "message send successful as expected."

def sendmsg_text_fail(driver,content):
	msgtype = "text"
	driver.find_element_by_id("%s:id/et_sendmessage" %appPackage).send_keys(content)
	driver.find_element_by_id("%s:id/btn_send" %appPackage).click()
	send_status = checkmsgsent(driver,msgtype)
	if send_status == False:
		print "message send fail as expected."
	else:
		raise Exception("message send successful not as expected.")
		
def sendmsg_image(driver):
	msgtype = "image"
	driver.find_element_by_id("%s:id/btn_more" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Capture']").click()
	driver.find_element_by_id("com.android.camera:id/shutter_button").click()
	try:
		driver.find_element_by_id("com.android.camera:id/btn_done").click()
		driver.find_element_by_xpath("//android.widget.TextView[@text='Capture']")
	except:
		driver.find_element_by_id("com.android.camera:id/btn_cancel").click()
	sleep(2)
	checkmsgsent(driver,msgtype)

def sendmsg_location(driver):
	msgtype = "location"
	driver.find_element_by_id("%s:id/btn_more" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Location']").click()
	sleep(3)
	driver.find_element_by_id("%s:id/btn_location_send" %appPackage).click()
	sleep(2)
	checkmsgsent(driver,msgtype)
	
def sendmsg_audio(driver):
	msgtype = "audio"
	driver.find_element_by_id("%s:id/btn_set_mode_voice" %appPackage).click()
	elem = driver.find_element_by_id("%s:id/btn_press_to_speak" %appPackage)
	action1 = TouchAction(driver)
	action1.long_press(elem).wait(4000).perform()
	sleep(3)
	checkmsgsent(driver,msgtype)
	
def download_image(driver):
	driver.find_element_by_id("%s:id/image" %appPackage).click()
	sleep(3)
	back(driver)
	
def download_audio(driver):
	driver.find_element_by_id("%s:id/iv_voice" %appPackage).click()
	sleep(1)
	
def checkreadnum(driver,readnum):
	sleep(1)
	msgread = 0
	elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout")
	msgnum = len(elems)
	for i in range(msgnum):
		elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='%s']\
		/android.widget.LinearLayout/android.widget.RelativeLayout/*"%i)
		if elems[0].get_attribute("resourceId") == "%s:id/tv_ack" %appPackage:
			msgread += 1
		elif elems[0].get_attribute("resourceId") == "%s:id/ll_loading" %appPackage:
			if elems[1].get_attribute("resourceId") == "%s:id/tv_ack" %appPackage:
				msgread += 1
	print "message read number:", msgread
	if msgread == readnum:
		print "message read OK"
		back(driver)
		gotoConversation(driver)
	else:
		back(driver)
		gotoConversation(driver)
		raise Exception("message not read as expected.")

def dial_voice(driver):
	driver.find_element_by_id("%s:id/btn_more" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Voice call']").click()

def dial_video(driver):
	driver.find_element_by_id("%s:id/btn_more" %appPackage).click()
	driver.find_element_by_xpath("//android.widget.TextView[@text='Video call']").click()

def answer_call(driver):
	i = 1
	find_status = False
	while not find_status and i<=3:
		try:
			driver.find_element_by_id("%s:id/btn_answer_call" %appPackage).click()
			find_status = True
			print "find answer button."
		except:
			print "not find answer button."
		i = i+1	
	if find_status == False:
		raise Exception("not find answer button.")

def in_call_check(driver):
	i = 1
	find_status = False
	while not find_status and i<=3:
		try:
			driver.find_element_by_xpath("//android.widget.TextView[@text='In the call..']")
			find_status = True
			print "in call state."
		except:
			print "not in call state."
		i = i+1
	if find_status == False:
		raise Exception("not in call state.")
	
def mute_unmute(driver):
	try:
		driver.find_element_by_id("%s:id/iv_handsfree" %appPackage).click()
	except:
		raise Exception("not find mute/unmute button.")
	
def hangup(driver,name):
	try:
		driver.find_element_by_id("%s:id/btn_hangup_call" %appPackage).click()
	except:
		raise Exception("not find hang up button.")
	findname(driver,name)
				
def chatroom_joinandleave(resturl,org,app,headers,driver,testaccount,roomname,roomid):
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%roomname).click()
	sleep(4)
	mem_list = rest.get_roommember(resturl,org,app,headers,roomid)
	if testaccount in mem_list:
		print "join chatroom %s successful." %roomname
		backfromroom(driver)
	else:
		backfromroom(driver)
		raise Exception("join chatroom %s failed." %roomname)
	mem_list = rest.get_roommember(resturl,org,app,headers,roomid)
	if testaccount not in mem_list:
		print "member not in chatroom after leaving chatroom."
	else:
		raise Exception("member still in chatroom.")
		
def chatroom_10historymsg(driver,roomname):
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%roomname).click()
	sleep(2)
	msg_list = []
	for n in range(3):
		elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout")
		for i in range(len(elems)-1,-1,-1):
			try:
				elem = driver.find_element_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='%s']\
			/android.widget.LinearLayout/android.widget.RelativeLayout/android.widget.RelativeLayout/android.widget.TextView"%i)
				msg = elem.get_attribute("text")
			except:
				print "not get element text attribute, maybe covered by other element."
			if msg not in msg_list:
				msg_list.insert(0,msg)
		swipe_down(driver)
	print "message list:", msg_list
	print "get %d history message." %len(msg_list)
	if len(msg_list) >= 10:
		driver.find_element_by_id("%s:id/left_image" %appPackage).click()
		sleep(1)
		driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='0']/android.widget.LinearLayout").click()
	else:
		driver.find_element_by_id("%s:id/left_image" %appPackage).click()
		sleep(1)
		driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='0']/android.widget.LinearLayout").click()
		raise Exception("history message less than 10.")

def chatroom_txtmsg(driver,roomname,msgcontent):
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%roomname).click()
	sleep(2)
	driver.find_element_by_id("%s:id/et_sendmessage" %appPackage).send_keys(msgcontent)
	driver.find_element_by_id("%s:id/btn_send" %appPackage).click()
	elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout")
	send_index = len(elems)-1
	elems = driver.find_elements_by_xpath("//android.widget.LinearLayout[@index='%s']/android.widget.LinearLayout\
	/android.widget.RelativeLayout/*"%send_index)
	while elems[0].get_attribute("resourceId") == "%s:id/progress_bar" %appPackage:
		sleep(3)
		elems = driver.find_elements_by_xpath("//android.widget.LinearLayout[@index='%s']/android.widget.LinearLayout\
		/android.widget.RelativeLayout/*"%send_index)
	if elems[0].get_attribute("resourceId") == "%s:id/bubble" %appPackage:
		print "message sent successful!"
		backfromroom(driver)
	elif elems[0].get_attribute("resourceId") == "%s:id/msg_status" %appPackage:
		backfromroom(driver)
		raise Exception("message send failed!")
	else:
		backfromroom(driver)
		raise Exception("some other error occurs.")

def chatroom_revtextmsg(driver,roomname,msgcontent):
	sleep(2)
	try:
		findname(driver,msgcontent)
		print "receive msg successful."
		backfromroom(driver)
	except:
		backfromroom(driver)
		raise Exception("not receive msg.")
	
def chatroom_audiomsg(driver,roomname,msgcontent):
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%roomname).click()
	sleep(2)
	driver.find_element_by_id("%s:id/btn_set_mode_voice" %appPackage).click()
	elem = driver.find_element_by_id("%s:id/btn_press_to_speak" %appPackage)
	action1 = TouchAction(driver)
	action1.long_press(elem).wait(4000).perform()
	sleep(3)
	elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.LinearLayout")
	send_index = len(elems)-1
	elems = driver.find_elements_by_xpath("//android.widget.LinearLayout[@index='%s']/android.widget.LinearLayout\
	/android.widget.RelativeLayout/*"%send_index)
	try:
		while elems[0].get_attribute("resourceId") == "%s:id/progress_bar" %appPackage:
			sleep(3)
			elems = driver.find_elements_by_xpath("//android.widget.LinearLayout[@index='%s']/android.widget.LinearLayout\
			/android.widget.RelativeLayout/*"%send_index)
		if elems[0].get_attribute("resourceId") == '%s:id/tv_length' %appPackage:
			print "message sent successful!"
			backfromroom(driver)
		elif mylist[0].get_attribute("resourceId") == '%s:id/msg_status' %appPackage:
			backfromroom(driver)
			raise Exception("message send failed!")
		else:
			backfromroom(driver)
			raise Exception("cannot find any info with voice, voice message not send at all.")
	except:
		backfromroom(driver)
		raise Exception("cannot find any info with voice, voice message not send at all.")

def rest_kickroommember(resturl,org,app,headers,driver,testaccount,roomname,roomid):
	driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%roomname).click()
	sleep(3)
	rest.rest_delroommember(resturl,org,app,headers,roomid,testaccount)
	mem_list = rest.get_roommember(resturl,org,app,headers,roomid)
	print "%s in room %s check via rest:" %(testaccount,roomid), testaccount in mem_list
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='Chat room']")
		print "back to chatroom list view when kicked by rest."
		back(driver)
		gotoConversation(driver)
	except:
		backfromroom(driver)
		gotoConversation(driver)
		raise Exception("not back to chatroom list view when kicked by rest.")

def checkNewmsg(driver):
	badge_list = []
	elems = driver.find_elements_by_xpath("//android.widget.ListView/android.widget.RelativeLayout\
	/android.widget.RelativeLayout/android.widget.TextView")
	for elem in elems:
		badge = int(elem.get_attribute("text"))
		badge_list.append(badge)
	print badge_list
	return badge_list

def getContact(driver,expectedlist):
	non_contactlist = ["Invitation and notification","Group chat","Chat room","Robot chat"]
	contactlist = []
	for i in range(2):
		elems = driver.find_elements_by_id("%s:id/name" %appPackage)
		for ele in elems:
			name = ele.get_attribute("text")
			if name not in contactlist and name not in non_contactlist:
				contactlist.append(name)
		swipe_up(driver)
	print "expected contact list:", expectedlist
	print "actual contact list:", contactlist
	swipe_down(driver)
	if len(set(contactlist).symmetric_difference(expectedlist)) == 0:
		print "contact list as expected."
	else:
		raise Exception("contact list not as expected.")

def logout(driver):
	driver.find_element_by_id("%s:id/btn_setting" %appPackage).click()
	swipe_up(driver)
	find_status = False
	xpath_id = "%s:id/btn_logout" %appPackage
	text = "logout button."
	elem = findelem_swipe(driver,xpath_id,text)
	elem.click()
	
	mylist = driver.find_elements_by_id("android:id/progress")
	while mylist != []:
		mylist = driver.find_elements_by_id("android:id/progress")

	listA = driver.find_elements_by_xpath("//android.widget.Button[@text='Login']")
	if listA != []:
		print "logout successful."
	else:
		print "logout fail."

def clearAppCache(deviceid):
	os.popen('adb -s %s shell pm clear %s' %(deviceid,appPackage)).read()
	
def disconnetuser(driver):
	try:
		driver.find_element_by_id("android:id/button1").click()
		driver.find_element_by_xpath("//android.widget.Button[@text='Login']")
		print "Rest disconnet/deactivate/delete user successfully!"
	except:
		raise Exception("Failed! Rest disconnet/deactivate/delete failed!")
		
def addbuddy(driver,friend):
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']" %friend)
		print "Rest add friend %s successfully!" %friend
	except:
		raise Exception("Failed! Rest add friend failed, cann't find friend %s!" %friend)

def delbuddy(driver,friend):
	try:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']" %friend)
		raise Exception("Failed! Rest delete friend failed, %s still in friend list!" %friend)
	except:
		print "Rest delete friend %s successfully!" %friend	
		
def groupinvite(driver,biggroup,groupname):
	try:
		if biggroup == "no":
			driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)			
		else:
			driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)
		print "Find group conversation,case passed!"
	except:
		raise Exception("Not find group conversation,case failed!")

def delgroupinvite(driver,biggroup,groupname):
	try:
		if biggroup == "no":
			driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)			
		else:
			driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%groupname)
	except:
		print "Not find group conversation, case passed!"
	else:
		raise Exception("Shouldn't find group conversation,case failed")

def findelem_swipe(driver,xpath_id,text,find_type="by_id"):
	find_status = False
	while not find_status:
		swipe_up(driver,3/float(4),2/float(4))
		try:
			if find_type == "by_xpath":
				elem = driver.find_element_by_xpath(xpath_id)
			else:
				elem = driver.find_element_by_id(xpath_id)
			find_status = True
			print "find %s" %text
		except:
			swipe_up(driver,5/float(6),4/float(6))
			print "not find %s" %text
	return elem

def find_customsetting(driver):
	elem_id1 = "com.hyphenate.chatuidemo:id/switch_custom_appkey"
	text1 = "appkey setting."
	elem_id2 = "com.hyphenate.chatuidemo:id/switch_custom_server"
	text2 = "server setting."
	elem1 = findelem_swipe(driver,elem_id1,text1)
	elem2 = findelem_swipe(driver,elem_id2,text2)
	return [elem1, elem2]
	
def change_appkey(driver,account,appkey):
	ebsurl = "a1.easemob.com"
	get_token = "yes"
	test_env = "ebs"
	ebs_parameter = configdata.test_parameter(test_env,appkey,get_token,ebsurl)
	ebstoken = ebs_parameter[2]
	ebsheaders = {'Content-Type':'application/json','Authorization':'Bearer '+ebstoken}
	if android_sdk == "msync":
		gotoSetting(driver)
		elems = find_customsetting(driver)
		elems[0].click()
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/edit_custom_appkey").send_keys(appkey)
		logout(driver)
	else:
		for i in range(5):
			rest.rest_changeappkey(account,appkey,ebsheaders,ebsurl)
				
def change_server(driver,account,rest_server,im_server):
	ebsurl = "a1.easemob.com"
	appkey = "easemob-demo#chatdemoui"
	get_token = "yes"
	test_env = "ebs"
	ebs_parameter = configdata.test_parameter(test_env,appkey,get_token,ebsurl)
	ebstoken = ebs_parameter[2]
	ebsheaders = {'Content-Type':'application/json','Authorization':'Bearer '+ebstoken}
	if android_sdk == "msync":
		gotoSetting(driver)
		elems = find_customsetting(driver)
		elems[1].click()
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/rl_custom_server").click()
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_rest").send_keys(rest_server)
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_im").send_keys(im_server)
		back_left(driver)
		logout(driver)
	else:
		for i in range(5):
			rest.rest_changeserver(account,rest_server,im_server,ebsheaders,ebsurl)

def	change_appkeyandserver(driver,account,appkey,rest_server,im_server,headers):
	ebsurl = "a1.easemob.com"
	get_token = "yes"
	test_env = "ebs"
	ebs_parameter = configdata.test_parameter(test_env,appkey,get_token,ebsurl)
	ebstoken = ebs_parameter[2]
	ebsheaders = {'Content-Type':'application/json','Authorization':'Bearer '+ebstoken}
	target_headers = headers
	target_url = rest_server
	org_app = appkey.split("#")
	org = org_app[0]
	app = org_app[1]
	print org,app
	if android_sdk == "msync":
		gotoSetting(driver)
		elems = find_customsetting(driver)
		elems[0].click()
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/edit_custom_appkey").send_keys(appkey)
		elems[1].click()
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/rl_custom_server").click()
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_rest").send_keys(rest_server)
		driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_im").send_keys(im_server)
		back_left(driver)
		logout(driver)
	else:
		change_server_first = False
		if change_server_first:
			for i in range(2):
				rest.rest_changeserver(account,rest_server,im_server,ebsheaders,ebsurl)
			login_validAccount(driver,account,"1")
			for i in range(1):
				rest.rest_changeappkey(account,appkey,target_headers,target_url)
		else:
			for i in range(2):
				rest.rest_changeappkey(account,appkey,ebsheaders,ebsurl)
			login_validAccount(driver,account,"1")
			for i in range(1):
				rest.rest_changeserver(account,rest_server,im_server,ebsheaders,ebsurl,org,app)


if __name__ == '__main__':
	android_para("vip6","msync")
	deviceid = "517ebeda"

	token = "YWMtaOrLOK4-EeeaM92Bz9Xk2gAAAWA-uh33z6v-WGf7IBzvWe1jLauP09msU90"
	headers = {'Content-Type':'application/json','Authorization':'Bearer '+token}

	rest.rest_creategroup("a1-vip6.easemob.com","easemob-demo","vip6coco",headers,"dismiss","b0")

	# clearAppCache(deviceid)

	driver = startDemo(deviceid)
	# login_validAccount(driver,"at1","1")

	# change_appkey(driver,"at1","easemob-demo#coco")
	# change_server(driver,"at1","a1-vip6.easemob.com","im1-vip6.easemob.com")
	# change_appkeyandserver(driver,"at1","easemob-demo#coco","a1-vip6.easemob.com","im1-vip6.easemob.com",headers)

	# driver = startDemo(deviceid)
	# login_validAccount(driver,"at1","1")

	# change_appkey(driver,account,appkey)

	gotoGroup(driver)
	dismissGroup(driver,"dismiss")
