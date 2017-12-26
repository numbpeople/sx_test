#coding=utf-8
from time import sleep
import json
import sys
import requests
import init
import case_common
from testdata import *
from appium import webdriver
from appium.webdriver.common.touch_action import TouchAction
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import case_common
import restHelper
import case_chat
import case_account

def get_grouplist(driver):
	grouplist = []
	mylist = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/name")
	for elem in mylist:
		groupname = elem.get_attribute("text")
		if groupname not in grouplist:
			grouplist.append(groupname)
		
	nongrouplist = ["Create new group", "Add public group"]
	for elem in nongrouplist:
		try:
			grouplist.remove(elem)
		except ValueError:
			pass
	
	return grouplist	

def goto_groupinfo(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/right_layout").click()
	mylist = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/progressBar")
	while mylist != []:
		mylist = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/progressBar")

def get_all_people(driver):
	memberelements = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/tv_name") #找出所有的群成员元素
	memberlist = []
	for i in memberelements:
		memberlist.append(i.get_attribute("text"))
	return memberlist

def get_group_roles(driver):
	adminlist = []
	memberlist = []

	allNameEments = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/tv_name")
	namelist = []
	for i in allNameEments:
		namelist.append(i.get_attribute("text"))
	print namelist
	owner = namelist[0]

	len0 = len(namelist)
	ellist1 = driver.find_elements_by_xpath("//android.widget.LinearLayout[@index='0']/android.widget.GridView[@index='1']/*")
	len1 = len(ellist1)
	for i in range(1, len1):
		adminlist.append(namelist[i])

	for i in namelist:
		if (i is not owner) & (i not in adminlist):
			memberlist.append(i)

	dic1 = {"owner":owner, "adminlist":adminlist, "members":memberlist}
	return dic1

def find_memberElement(driver, name):
	allNameEments = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/tv_name")
	namelist = []
	for i in allNameEments:
		namelist.append(i.get_attribute("text"))

	len0 = len(namelist)
	
	ellist1 = driver.find_elements_by_xpath("//android.widget.LinearLayout[@index='0']/android.widget.GridView[@index='1']/*")
	len1 = len(ellist1)

	targetIndex = namelist.index(name) - len1
	targetElement = driver.find_element_by_xpath("//android.widget.GridView[@index='3']/android.widget.RelativeLayout[@index='%s']" %str(targetIndex))

	return targetElement

def find_adminElement(driver, name):	
	allNameEments = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/tv_name")
	namelist = []
	for i in allNameEments:
		namelist.append(i.get_attribute("text"))

	ellist1 = driver.find_elements_by_xpath("//android.widget.LinearLayout[@index='0']/android.widget.GridView[@index='1']/*")
	targetIndex = namelist.index(name)
	targetElement = driver.find_element_by_xpath("//android.widget.GridView[@index='1']/android.widget.RelativeLayout[@index='%s']" %str(targetIndex))
	return targetElement

def del_member(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_remove_member").click()

def add_group_blacklist(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_add_to_blacklist").click()

def rm_group_blacklist(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_remove_from_blacklist").click()

def mute(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_mute").click()

def unmute(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_unmute").click()

def add_admin(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_add_admin").click()

def rm_admin(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_rm_admin").click()

def trans_owner(driver):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/menu_item_transfer_owner").click()

def click_addButton(driver):
	ellist = driver.find_elements_by_id("com.hyphenate.chatuidemo:id/button_avatar")
	ellist[-1].click()

def invite_contacts_join(driver, memberlist):
	for i in memberlist:
		driver.find_element_by_xpath("//android.widget.TextView[@text='%s']"%i).click() #从contactlist里选择member
	driver.find_element_by_xpath("//android.widget.Button[@text='Save']").click() #拉人界面点击右上角保存按钮

def add_groupmember(driver, memberlist):
	click_addButton(driver)
	invite_contacts_join(driver, memberlist)

def search_group(driver, groupid):
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/btn_search").click() # 公开群列表界面 点击“搜索”按钮
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_search_id").send_keys(groupid) # 输入群id
	driver.find_element_by_id("com.hyphenate.chatuidemo:id/search").click() # 搜索群
	elem = driver.find_element_by_id("com.hyphenate.chatuidemo:id/rl_searched_group") # 定位到目标群对应的元素
	return elem 

def button_join_group(driver):
	elem = driver.find_element_by_id("com.hyphenate.chatuidemo:id/btn_add_to_group")
	return elem

#//////////////////////////////////////////////////////////
def test_add_groupmember_agree(driver1, driver2, groupname, testaccount, memberlist, isadmincase, ismemberinvite):
	ret_status = False
	print "< case start: add group member->agree >"

	groupid = restHelper.get_groupid(testaccount, groupname)

	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	case_common.swipeDown(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	sleep(1)
	goto_groupinfo(driver1)
	add_groupmember(driver1, memberlist)
	sleep(4)

	case_common.gotoContact(driver2)
	if case_common.find_notice(driver2, groupid):
		accept_groupinvite(driver2, groupid)
		sleep(5)
		namelist = get_all_people(driver1)
		for i in memberlist:
			if i in namelist:
				ret_status = True
				break
	else:
		print "B not receive group Invitation, cannot complete agree operation!"

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.gotoConversation(driver1)
	case_common.back(driver2)
	sleep(1)
	case_common.gotoConversation(driver2)

	if ret_status == True:
		print "< case end: pass >"
	else:
		print "< case end: fail >"

	if isadmincase == 1:
		mystr = ":groupAdmin"
	else:
		if ismemberinvite == 1:
			mystr = ":memberinvite"
		else:
			mystr = ":groupOwner"
	case_status[sys._getframe().f_code.co_name+mystr] = ret_status
	return ret_status

def test_add_groupmember_refuse(driver1, driver2, groupname, testaccount, memberlist, isadmincase):
	ret_status = False
	print "< case start: add group member->refuse >"

	groupid = restHelper.get_groupid(testaccount, groupname)
	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)
	add_groupmember(driver1, memberlist)
	case_common.gotoContact(driver2)
	if check_groupinvite(driver2, groupid):
		refuse_groupinvite(driver2, groupid)
	
	sleep(3)
	namelist = get_all_people(driver1)
	for i in memberlist:
		if i not in namelist:
			ret_status = True
			break

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	if ret_status == True:
		print "< case end: pass! >"
	else:
		print "< case end: failed! >"

	if isadmincase == 1:
		mystr = ":groupAdmin"
	else:
		mystr = ":groupOwner"
	
	case_status[sys._getframe().f_code.co_name+mystr] = ret_status
	return ret_status

			
def test_del_groupmember(driver1, driver2, groupname, testaccount, dellist, isadmincase):
	ret_status = False
	print "< case start: del groupmember >"

	groupid = restHelper.get_groupid(testaccount,groupname)
	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)
	
	for i in dellist:
		elem = find_memberElement(driver1, i)
		elem.click()
		del_member(driver1)
	sleep(5)
	namelist = get_all_people(driver1)
	for name in dellist:
		if name not in namelist:
			print "deleted user: ", name
			sleep(2)
			Bgrouplist = get_grouplist(driver2)
			if groupname in Bgrouplist:
				print "del groupmember failed!"
				print "< case end: fail >"	
			else:
				print "del group member sucess!"
				ret_status = True
				print "< case end: pass >"
		else:
			print "%s still in %s" %(name, groupname)

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_common.back(driver2)
	case_common.gotoConversation(driver2)
	
	if isadmincase == 1:
		mystr = ":groupAdmin"
	else:
		mystr = ":groupOwner"
	
	case_status[sys._getframe().f_code.co_name+mystr] = ret_status
	return ret_status

def test_block_groupmember(driver1, driver2, groupname, testaccount, blockname, isadmincase):
	ret_status = False
	print "< case start: block groupmember>"

	groupid = restHelper.get_groupid(testaccount,groupname)
	
	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)

	elem = find_memberElement(driver1, blockname)
	elem.click()
	add_group_blacklist(driver1)

	sleep(5)
	Bgrouplist = get_grouplist(driver2)
	if groupname not in Bgrouplist:
		print "Received beBlocked notice!"
		print "< case end: pass >"
		ret_status = True
	else:
		print "Not eceived beBlocked notice!"
		print "< case end: fail >"

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	if isadmincase == 1:
		mystr = ":groupAdmin"
	else:
		mystr = ":groupOwner"
	case_status[sys._getframe().f_code.co_name+mystr] = ret_status
	return ret_status

def test_unblock_groupmember(driver1, groupname, unblock_name, isadmincase):
	ret_status = False

	print "< case start: ublock groupmember >"
	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)
	
	elem = find_memberElement(driver1, unblock_name)
	elem.click()
	rm_group_blacklist(driver1)

	case_common.back(driver1)
	goto_groupinfo(driver1)

	mylist = get_all_people(driver1)
	if unblock_name not in mylist:
		print "unblock success!"
		ret_status = True
		print "< case end: pass>"
	else:
		print "< case end: fail >"

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	if isadmincase == 1:
		mystr = ":groupAdmin"
	else:
		mystr = ":groupOwner"
	
	case_status[sys._getframe().f_code.co_name+mystr] = ret_status
	return ret_status

def test_mute_groupmember(driver1, driver2, groupname, testaccount, mute_name, isadmincase):
	ret_status = False
	print "< case satart: mute >"

	groupid = restHelper.get_groupid(testaccount, groupname)
	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)

	elem = find_memberElement(driver1, mute_name)
	elem.click()
	mute(driver1)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, groupname)
	case_chat.clear_groupmsg(driver2)

	if not case_chat.send_msg_txt(driver2, content="test msg!"):
		print "mute B sucess!"
		ret_status = True
		print "< case end: pass >"
	else:
		print "< case end: fail >"

	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	if isadmincase == 1:
		mystr = ":groupAdmin"
	else:
		mystr = ":groupOwner"
	
	case_status[sys._getframe().f_code.co_name+mystr] = ret_status
	return ret_status

def test_unmute_groupmember(driver1, driver2, groupname, testaccount, unmute_name, isadmincase):
	ret_status = False
	print "< case start: unmute >"

	groupid = restHelper.get_groupid(testaccount, groupname)

	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)

	elem = find_memberElement(driver1, unmute_name)
	elem.click()
	unmute(driver1)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, groupname)
	case_chat.clear_groupmsg(driver2)

	if case_chat.send_msg_txt(driver2, content="test msg!"):
		print "Unmute B sucess!"
		ret_status = True
		print "< case end: pass> "
	else:
		print "< case end: fail >"

	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	if isadmincase == 1:
		mystr = ":groupAdmin"
	else:
		mystr = ":groupOwner"
	case_status[sys._getframe().f_code.co_name+mystr] = ret_status
	return ret_status

def test_add_admin(driver1, driver2, groupname, testaccount, adm_name):
	ret_status = False
	print "< case start: add group admin >"

	groupid = restHelper.get_groupid(testaccount, groupname)

	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, groupname)
	goto_groupinfo(driver2)

	elem = find_memberElement(driver1, adm_name)
	elem.click()
	add_admin(driver1)
	print "A added B as admin."
	sleep(5)

	mydic = get_group_roles(driver2)
	if adm_name in mydic["adminlist"]:
		ret_status = True
		print "B received +admin notice sucess!"
		print "< case end: pass >"
	else:
		print "B not receive +admin notice, fail!"
		print "< case end: fail >"

	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_status[sys._getframe().f_code.co_name] = ret_status
	return ret_status


def test_rm_admin(driver1, driver2, groupname, testaccount, adm_name):
	ret_status = False
	print "< case start: remove admin >"

	groupid = restHelper.get_groupid(testaccount, groupname)

	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, groupname)
	goto_groupinfo(driver2)

	elem = find_adminElement(driver1, adm_name)
	elem.click()
	rm_admin(driver1)
	sleep(5)

	mydic = get_group_roles(driver2)
	if adm_name not in mydic["adminlist"]:
		ret_status = True
		print "B received -admin notice sucess!"
		print "< case end: pass >"
	else:
		print "B not receive -admin notice, fail!"
		print "< case end: fail >"

	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_status[sys._getframe().f_code.co_name] = ret_status
	return ret_status


def test_trans_owner(driver1, driver2, groupname, testaccount, adm_name):
	ret_status = False
	print "<case start: transfer owner >"

	groupid = restHelper.get_groupid(testaccount, groupname)

	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, groupname)
	goto_groupinfo(driver2)

	elem = find_adminElement(driver1, adm_name)
	elem.click()
	trans_owner(driver1)
	sleep(5)

	mydic = get_group_roles(driver2)
	if adm_name in mydic["owner"]:
		ret_status = True
		print "B received trans_owner notice sucess!"
		print "< case end: pass >"
	else:
		print "B not receive trans_owner notice, fail!"
		print "< case end: fail >"

	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_status[sys._getframe().f_code.co_name] = ret_status
	return ret_status	

def test_create_group(driver1, groupname, grouptype):
	print "< case start: create %s group >" %grouptype
	ret_status = False
	
	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	case_common.click_name(driver1, "Create new group")
	driver1.find_element_by_id("com.hyphenate.chatuidemo:id/edit_group_name").send_keys(groupname)
	if grouptype == "gknotapproval":
		driver1.find_element_by_id("com.hyphenate.chatuidemo:id/cb_public").click()
	elif grouptype == "gkapproval":
		driver1.find_element_by_id("com.hyphenate.chatuidemo:id/cb_public").click()
		driver1.find_element_by_id("com.hyphenate.chatuidemo:id/cb_member_inviter").click()
	elif grouptype == "syinvite":
		driver1.find_element_by_id("com.hyphenate.chatuidemo:id/cb_member_inviter").click()

	sleep(1)

	driver1.find_element_by_xpath("//android.widget.Button[@text='Save']").click()
	sleep(2)
	driver1.find_element_by_xpath("//android.widget.Button[@text='Save']").click()

	if find_group(driver1, groupname):
		ret_status = True
		print "group: %s created success!" %groupname
		print "< case end: pass >"
	else:
		print "< case end: fail >"

	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_status[sys._getframe().f_code.co_name+"_"+grouptype] = ret_status
	return ret_status

def test_dismiss_group(driver1, groupname, grouptype):
	ret_status = False
	print "< case satart: dismiss group >"

	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)	
	goto_groupinfo(driver1)

	text = "dismiss group"
	xpath_id = "com.hyphenate.chatuidemo:id/btn_exitdel_grp"
	elem = case_common.findelem_swipe(driver1, xpath_id, text)
	elem.click() # 点击解散群组按钮
	driver1.find_element_by_id("com.hyphenate.chatuidemo:id/btn_exit").click() # 确认解散群组
	
	sleep(3)
	mygrouplist = get_grouplist(driver1)
	if groupname not in mygrouplist:
		ret_status = True
		print "group: %s dismiss success!" %groupname
		print "< case end: pass >"
	else:
		print "< case end: fail >"
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_status[sys._getframe().f_code.co_name+"_"+grouptype] = ret_status
	return ret_status

def test_exit_group(driver1, driver2, membername, groupname):
	ret_status = False
	print "< case start: exit group >"

	case_common.gotoContact(driver1)
	case_common.gotoGroup(driver1)
	find_group(driver1, groupname)
	case_common.click_name(driver1, groupname)
	goto_groupinfo(driver1)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, groupname)
	goto_groupinfo(driver2)
	sleep(1)
	case_common.swipeUp(driver2)
	driver2.find_element_by_id("com.hyphenate.chatuidemo:id/btn_exit_grp").click() # 点击退出群组按钮
	driver2.find_element_by_id("com.hyphenate.chatuidemo:id/btn_exit").click() # 确认退出
	sleep(5)
	
	mygrouplist = get_grouplist(driver2)
	if groupname not in mygrouplist:
		print "%s exited from group:%s" %(membername, groupname)

	sleep(5)
	A_memberlist = get_all_people(driver1)
	if membername not in A_memberlist:
		print "A received B exit group notice success!"
		print "< case end: pass >"
		ret_status = True
	else:
		print "< case end: fail >"

	case_common.back(driver2)
	case_common.gotoConversation(driver2)
	case_common.back(driver1)
	sleep(1)
	case_common.back(driver1)
	sleep(2)
	case_common.back(driver1)
	case_common.gotoConversation(driver1)

	case_status[sys._getframe().f_code.co_name] = ret_status
	return ret_status

def test_join_group(driver1, driver2, applyer, owner, groupname, approval_type):
	ret_status = False
	print "< case start: join group >"
	
	groupid = restHelper.get_groupid(owner, groupname)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, "Add public group")
	search_group(driver2, groupid).click()
	button_join_group(driver2).click()
	print "B sended join group apply."
	sleep(2)
	case_common.back(driver2)
	sleep(0.5)
	case_common.back(driver2)
	sleep(0.5)
	case_common.back(driver2)
	sleep(0.5)

	if approval_type == "approval":
		case_common.gotoContact(driver1)
		case_common.gotoInvitation(driver1)
		if check_groupapply(driver1, groupname, applyer):
			print "A received group join apply."
			accept_groupapply(driver1, groupname)
			print "A agreed apply."
		else:
			print "A not receive B join apply"
		case_common.back_topleft_arrow(driver1)
		sleep(1)
		case_common.gotoConversation(driver1) 

	try:
		find_group(driver2, groupname)
		print "B join group success!"
		print "< case end: pass >"
		ret_status = True 
	except:
		print "B join group fail!"
		print "<case end: fail >"

	print "will back"
	sleep(5)
	# case_common.back_topleft_arrow(driver2)
	case_common.back(driver2)
	case_common.gotoConversation(driver2)

	case_status[sys._getframe().f_code.co_name+"_"+groupname] = ret_status
	return ret_status

def test_sendrcv_msg(driver1, driver2, groupname):
	ret_status = False
	print "< case start: send and receive msg in %s group >" %groupname

	msgtype = "text"
	chattype = "group_chat"
	msgcontent = case_common.random_str(8)

	case_common.gotoContact(driver2)
	case_common.gotoGroup(driver2)
	find_group(driver2, groupname)
	case_common.click_name(driver2, groupname)
	case_chat.send_msg_txt(driver2, msgcontent)
	if case_chat.check_if_receivemsg(driver1, groupname, msgcontent):
		print "< case end: pass >"
		ret_status = True
	else:
		print "< case end: fail >"

	case_common.back(driver2)
	sleep(1)
	case_common.back(driver2)
	sleep(1)
	case_common.gotoConversation(driver2)

	case_status[sys._getframe().f_code.co_name+"_"+groupname] = ret_status
	return ret_status

def check_groupinvite(driver, groupid):
	ret_status = False
	
	sleep(2)
	driver.find_element_by_xpath("//android.widget.TextView[@text = 'Invitation and notification']").click()
	elems = driver.find_elements_by_xpath("//android.widget.TextView[@text='%s']/../android.widget.RelativeLayout/*"%groupid)
	for elem in elems:
		if elem.get_attribute("text") == "Refuse":
			print "find expected group invitation"
			ret_status = True

	if ret_status ==  False:
		print "not find expected group invitation"
	
	return ret_status
	
def accept_groupinvite(driver, groupid):
	ret_status = False

	elems = driver.find_elements_by_xpath("//android.widget.TextView[@text='%s']/../android.widget.RelativeLayout/*"%groupid)
	for elem in elems:
		if elem.get_attribute("text") == "Agree":
  			elem.click()
			ret_status = True
			break

	return ret_status

def refuse_groupinvite(driver, groupid):	
	ret_status = False
	
	elems = driver.find_elements_by_xpath("//android.widget.TextView[@text='%s']/../android.widget.RelativeLayout/*"%groupid)
	for elem in elems:
		if elem.get_attribute("text") == "Refuse":
  			elem.click()
			ret_status = True
			break

	return ret_status
			
def check_groupapply(driver, groupname, username):
	ret_status = False
	
	driver.find_element_by_xpath("//android.widget.TextView[@text = 'Invitation and notification']").click()
	# elems = driver.find_elements_by_xpath("//android.widget.TextView[@text='Apply to join the group%s']/../android.widget.TextView[0]"%groupname)
	elems = driver.find_elements_by_xpath("//android.widget.TextView[@text='Apply to join the group%s']/../android.widget.TextView[@index='0']"%groupname)
	print "elems length:", len(elems)
	for elem in elems:
		if elem.get_attribute("text") == username:
			ret_status = True
	
	return ret_status

def accept_groupapply(driver, groupname):
	ret_status = False

	elems = driver.find_elements_by_xpath("//android.widget.TextView[@text='Apply to join the group%s']/../android.widget.RelativeLayout[@index='2']/*"%groupname)
	for elem in elems:
		if elem.get_attribute("text") == "Agree":
			elem.click()
			ret_status = True
			break

def refuse_groupapply(driver, groupname):
	ret_status = False
	
	elems = driver.find_elements_by_xpath("//android.widget.TextView[@text='%s']/../../preceding-sibling::android.widget.RelativeLayout/*" %groupname)
	for elem in elems:
		if elem.get_attribute("text") == "Refuse":
			elem.click()
			ret_status = True
			break
	
	return ret_status

def find_toast(driver, message, timeout, poll_frequency):
	message = '//*[@text=\'%s\']' %message
	print message
	element = WebDriverWait(driver, timeout,poll_frequency).until(expected_conditions.presence_of_element_located((By.XPATH, message)))
	print element
	
def find_toast2(driver, message):
	try:
		driver.find_element_by_xpath('//*[@text=\'%s\']' %message)
		print "find toast message %s" %message
	except:
		print "not find toast message %s" %message

def find_group(driver, groupname):
	ret_status = False

	grouplist = get_grouplist(driver)
	lastgroup0 = grouplist[-1]
	
	while groupname not in grouplist:
		case_common.swipeUp(driver)
		grouplist = get_grouplist(driver)

		lastgroup1 = grouplist[-1]
		if lastgroup1 == lastgroup0:
			print "group %s not found!" %groupname
			break
		else:
			lastgroup0 =lastgroup1
	
	ret_status = True
	print "find group %s" %groupname
	return ret_status


# /////////////////////////////////////////////////////////////////////////////////////////////////
def testset_group(driver1, driver2, dic_Group, isadmincase):
	if isadmincase == 0:
		userA = accountA
		userB = accountB
		print "********************************************---Group (non-admin)---********************************************"
	elif isadmincase == 1:
		userA = accountC
		userB = accountB
		print "********************************************---Group (admin)---********************************************"

	test_add_groupmember_agree(driver1, driver2, groupname=dic_Group["add_agree"], testaccount=userA, memberlist=[userB], isadmincase=isadmincase, ismemberinvite=0)
	print "------------------------------------------------------------------------------------------------------------------"
	test_add_groupmember_refuse(driver1, driver2, groupname=dic_Group["add_refuse"], testaccount=userA, memberlist=[userB], isadmincase=isadmincase)
	print "------------------------------------------------------------------------------------------------------------------"
	test_del_groupmember(driver1, driver2, groupname=dic_Group["del_member"], testaccount=userA, dellist=[userB], isadmincase=isadmincase)
	print "------------------------------------------------------------------------------------------------------------------"
	test_block_groupmember(driver1, driver2, groupname=dic_Group["block_member"], testaccount=userA, blockname=userB, isadmincase=isadmincase)
	print "------------------------------------------------------------------------------------------------------------------"
	test_unblock_groupmember(driver1, groupname=dic_Group["unblock_member"], unblock_name=userB, isadmincase=isadmincase)
	print "------------------------------------------------------------------------------------------------------------------"
	test_mute_groupmember(driver1, driver2, groupname=dic_Group["main_group"], testaccount=userA, mute_name=userB, isadmincase=isadmincase)
	print "------------------------------------------------------------------------------------------------------------------"
	test_unmute_groupmember(driver1, driver2, groupname=dic_Group["main_group"], testaccount=userA, unmute_name=userB, isadmincase=isadmincase)
	print "------------------------------------------------------------------------------------------------------------------"		
	
	if isadmincase == 0:
		test_add_groupmember_agree(driver1, driver2, groupname=dic_Group["member_invite"], testaccount=userA, memberlist=[userB], isadmincase=isadmincase, ismemberinvite=1)
		print "------------------------------------------------------------------------------------------------------------------"
		test_add_admin(driver1, driver2, groupname=dic_Group["main_group"], testaccount=userA, adm_name=userB)
		print "------------------------------------------------------------------------------------------------------------------"
		test_rm_admin(driver1, driver2, groupname=dic_Group["main_group"], testaccount=userA, adm_name=userB)
		print "------------------------------------------------------------------------------------------------------------------"
		test_trans_owner(driver1, driver2, groupname=dic_Group["trans_owner"], testaccount=userA, adm_name=userB)
		print "------------------------------------------------------------------------------------------------------------------"
		test_exit_group(driver1, driver2, membername=userB, groupname=dic_Group["B_exit"])
		print "------------------------------------------------------------------------------------------------------------------"
		test_join_group(driver1, driver2, applyer=userB, owner=userA, groupname=dic_Group["B_join"], approval_type="approval")
		print "------------------------------------------------------------------------------------------------------------------"
		if test_create_group(driver1, groupname="gknotapproval", grouptype="gknotapproval"):
			print "------------------------------------------------------------------------------------------------------------------"
			if test_join_group(driver1, driver2, applyer=userB, owner=userA, groupname="gknotapproval", approval_type="notapproval"):
				print "------------------------------------------------------------------------------------------------------------------"
				test_sendrcv_msg(driver1, driver2, groupname="gknotapproval")
				print "------------------------------------------------------------------------------------------------------------------"
		test_dismiss_group(driver1, groupname="gknotapproval", grouptype='gknotapproval')
		print "------------------------------------------------------------------------------------------------------------------"


if __name__ == "__main__":

	userA = accountA
	userB = accountB
	driver1 = case_common.startDemo1()
	case_common.gotoContact(driver1)
	a = check_groupapply(driver1,'B_join','lst222')
	if a:
		accept_groupapply(driver1,'B_join')

	
	print "\nend test."