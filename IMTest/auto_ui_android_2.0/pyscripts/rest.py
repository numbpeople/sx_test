# -*- coding: utf-8 -*-
import json
import urllib2
import requests
import time
import requests
import os
import configdata

def rest_getorgtoken(resturl,orgname,orgpwd):
	url = "http://%s/management/token" %resturl
	data = {"grant_type":"password","username":orgname,"password":orgpwd}
	resp = requests.post(url=url,data=json.dumps(data))
	token = json.loads(resp.text).get("access_token")
	return token

def rest_addbuddy(resturl,org,app,headers,user,friend):
	url = 'http://%s/%s/%s/users/%s/contacts/users/%s' %(resturl,org,app,user,friend)
	requests.post(url=url,headers=headers)
	time.sleep(2)
	
def rest_delbuddy(resturl,org,app,headers,user,friend):
	url = 'http://%s/%s/%s/users/%s/contacts/users/%s' %(resturl,org,app,user,friend)
	requests.delete(url=url,headers=headers)
	
def rest_adduserblock(resturl,org,app,headers,user,block):
	url='http://%s/%s/%s/users/%s/blocks/users/%s' %(resturl,org,app,user,block)
	requests.post(url=url,headers=headers)
	
def rest_deluserblock(resturl,org,app,headers,user,block):
	url='http://%s/%s/%s/users/%s/blocks/users/%s' %(resturl,org,app,user,block)
	requests.delete(url=url,headers=headers)

def rest_getuserblock(resturl,org,app,headers,user,block,case_type="addblock"):
	url='http://%s/%s/%s/users/%s/blocks/users' %(resturl,org,app,user)
	resp = requests.get(url=url,headers=headers)
	block_list = json.loads(resp.text)["data"]
	print "block list is:", block_list
	if block in block_list:
		if case_type == "addblock":
			print "add %s to %s block list successfully." %(block,user)
		else:
			raise Exception("Flaied, %s still in %s block list after removing via rest." %(block,user))
	else:
		if case_type == "addblock":
			raise Exception("Flaied, %s not in %s block list after adding via rest." %(block,user))
		else:
			print "remove %s from %s block list successfully." %(block,user)

def rest_postuser(resturl,org,app,headers,user,password):
	url = 'http://%s/%s/%s/users' %(resturl,org,app)
	data = {"username":user,"password":password}
	requests.post(url=url,headers=headers,data=json.dumps(data))
		
def rest_deluser(resturl,org,app,headers,user):
	url = 'http://%s/%s/%s/users/%s' %(resturl,org,app,user)
	requests.delete(url=url,headers=headers)

def rest_disconnectuser(resturl,org,app,headers,user):
	time.sleep(2)
	url = 'http://%s/%s/%s/users/%s/disconnect' %(resturl,org,app,user)
	requests.get(url=url,headers=headers)
		
def rest_deactivate(resturl,org,app,headers,user):
	time.sleep(2)
	url = 'http://%s/%s/%s/users/%s/deactivate' %(resturl,org,app,user)
	requests.post(url=url,headers=headers)		

def rest_activate(resturl,org,app,headers,user):
	url = 'http://%s/%s/%s/users/%s/activate' %(resturl,org,app,user)
	requests.post(url=url,headers=headers)

def rest_offlinemsg(resturl,org,app,headers,user,msgnum,status,biggroup):
	url = "http://%s/%s/%s/users/%s/offline_msg_count" %(resturl,org,app,user)
	resp = requests.get(url=url,headers=headers)
	result = json.loads(resp.text).get("data")
	offline = result.values()[0]
	print "Offline msg number is: %s" %offline
	if biggroup == "yes":
		expect_offline = msgnum*3
	else:
		expect_offline = msgnum*2
	if status == "online":
		if offline != 0:
			raise Exception("Failed! Offline msg number not 0 when online status!")
	else:
		if offline == expect_offline:
			print "Offline msg number OK!"
		else:
			raise Exception("Failed! Offline msg number not as expected!")
		
def rest_status(resturl,org,app,headers,user,expect_status):
	url = "http://%s/%s/%s/users/%s/status" %(resturl,org,app,user)
	resp = requests.get(url=url,headers=headers)
	result = json.loads(resp.text).get("data")
	status = result.values()[0]
	print "User status is: %s" %status
	if status == expect_status:
		print "User status OK!"
	else:
		raise Exception("Failed! User status not as expected!")	
	
def rest_creategroup(resturl,org,app,headers,groupname,user):
	url = 'http://%s/%s/%s/chatgroups' %(resturl,org,app)
	data = {"groupname":groupname, "desc":'Rest groups',"public":True,"approval":True,"owner":user, "maxusers":200}
	resp = requests.post(url=url,headers=headers,data=json.dumps(data))
	result = json.loads(resp.text).get("data")
	groupid = result.values()[0]
	return groupid
	
def rest_delgroup(resturl,org,app,headers,groupid):
	url = 'http://%s/%s/%s/chatgroups/%s' %(resturl,org,app,groupid)
	requests.delete(url=url,headers=headers)

def rest_delgroup_vianame(resturl,org,app,headers,user,groupname):
	groupidlist = rest_getgrouplist(resturl,org,app,headers,user,groupname)

	if len(groupidlist) == 0:
		print "no group named %s need delete" %groupname
	else:
		for groupid in groupidlist:
			rest_delgroup(resturl,org,app,headers,groupid)

def rest_addmember(resturl,org,app,headers,groupid,member):
	url = 'http://%s/%s/%s/chatgroups/%s/users/%s' %(resturl,org,app,groupid,member)
	requests.post(url=url,headers=headers)
		
def rest_delmember(resturl,org,app,headers,groupid,member):
	url = 'http://%s/%s/%s/chatgroups/%s/users/%s' %(resturl,org,app,groupid,member)
	requests.delete(url=url,headers=headers)
	
def rest_addgroupblock(resturl,org,app,headers,groupid,block):	
	url='http://%s/%s/%s/chatgroups/%s/blocks/users/%s' %(resturl,org,app,groupid,block)
	requests.post(url=url,headers=headers)
	
def rest_delgroupblock(groupid,block,resturl,org,app,headers):
	url='http://%s/%s/%s/chatgroups/%s/blocks/users/%s' %(resturl,org,app,groupid,block)	
	requests.delete(url=url,headers=headers)
		
def rest_getgroupid(resturl,org,app,headers,user,groupname):
	url = "http://%s/%s/%s/users/%s/joined_chatgroups" %(resturl,org,app,user)
	resp = requests.get(url=url,headers=headers)
	if resp.status_code != 200:
		print resp.status_code, resp.text
	res_dic = json.loads(resp.text)
	groupdata = res_dic['data']
	for i in range(len(groupdata)):
		if groupdata[i]['groupname'] == groupname:
			groupid = groupdata[i]['groupid']
			print "groupid of %s is: %s" %(groupname,groupid)
			return groupid

def rest_getgrouplist(resturl,org,app,headers,user,groupname):
	url = "http://%s/%s/%s/users/%s/joined_chatgroups" %(resturl,org,app,user)
	resp = requests.get(url=url,headers=headers)
	if resp.status_code != 200:
		print resp.status_code, resp.text
	res_dic = json.loads(resp.text)
	groupdata = res_dic['data']
	print groupdata
	groupidlist=[]
	for i in range(len(groupdata)):
		if groupdata[i]['groupname'] == groupname:
			groupid = groupdata[i]['groupid']
			groupidlist.append(groupid)
			print "groupid of %s is: %s" %(groupname,groupid)
	return groupidlist	

def rest_delallmember(resturl,org,app,headers,groupid):
	url = "http://%s/%s/%s/chatgroups/%s" %(resturl,org,app,groupid)
	resp=requests.get(url=url,headers=headers)
	affiliations=json.loads(resp.text)["data"][0]["affiliations"]
	for i in range(len(affiliations)):
		try:
			member = affiliations[i]["member"]
			url = "http://%s/%s/%s/chatgroups/%s/users/%s" %(resturl,org,app,groupid,member)
			resp = requests.delete(url=url,headers=headers)
		except KeyError:
			pass

def Rest_ifpublicgroup(resturl,org,app,headers,groupid):
	url = "http://%s/%s/%s/chatgroups/%s" %(resturl,org,app,groupid)
	resp=requests.get(url=url,headers=headers)
	public = json.loads(resp.text).get("data")[0].get("public")
	return public

def rest_getgroupname(resturl,org,app,headers,groupid):
	url = "http://%s/%s/%s/chatgroups/%s" %(resturl,org,app,groupid)
	resp=requests.get(url=url,headers=headers)
	groupname=json.loads(resp.text)["data"][0]["name"]
	print "public and not approval group name is:%s" %groupname
	return groupname
	
def im_creategroup10000(user,biggroupname):
	imurl = "http://%s/api/easemob.com/%s/%s/groups/" %(restbase.imurl,restbase.org,restbase.app)
	data = {"groupname":biggroupname, "desc":"im big10000", "public":True, "approval":True, "maxusers":10000, "owner":user, "largegroup":True}
	resp = requests.post(url=imurl,headers=imheaders,data=json.dumps(data))
	try:
		groupid = json.loads(resp.text)["groupid"]
		print "big10000 groupid: %s" %groupid
		return groupid
	except:
		print "cann't create big10000 group via im interface."
		
def get_roomnameandid(resturl,org,app,headers):
	url = "http://%s/%s/%s/chatrooms?pagenum=1&pagesize=20" %(resturl,org,app)
	resp = requests.get(url=url,headers=headers)
	result = json.loads(resp.text).get("data")
	roomid = result[0].get("id")
	roomname = result[0].get("name")
	room_info = [roomid,roomname]
	return room_info

def get_roomid(resturl,org,app,headers,roomname):
	url = "http://%s/%s/%s/chatrooms?pagenum=1&pagesize=20" %(resturl,org,app)
	resp = requests.get(url=url,headers=headers)
	data = json.loads(resp.text).get("data")
	for i in range(len(data)):
		if data[i].get("name") == roomname:
			chatroomid = data[i].get("id")
			return chatroomid

def get_roommember(resturl,org,app,headers,roomid):
	url = "http://%s/%s/%s/chatrooms/%s" %(resturl,org,app,roomid)
	resp = requests.get(url=url,headers=headers)
	affiliations = json.loads(resp.text)["data"][0].get("affiliations")
	member_list = []
	for i in range(len(affiliations)):
		member = affiliations[i].values()[0]
		member_list.append(member)
	return member_list

def rest_delroommember(resturl,org,app,headers,roomid,member):
	url = 'http://%s/%s/%s/chatrooms/%s/users/%s' %(resturl,org,app,roomid,member)
	requests.delete(url=url,headers=headers)
	
def rest_delallroommember(roomid,resturl,org,app,headers):
	member_list = get_roommember(roomid)
	for member in member_list:
		rest_delroommember(roomid,member)

def Rest_sendmsg(resturl,org,app,headers,msgtype='users',fromname='myRest',toname='at1',number=5):
	i = 1
	url = "http://%s/%s/%s/messages" %(resturl,org,app)
	while i <= number:
		print "send %s msg: %d" %(msgtype,i)
		content = "rest_msg_%d" %i
		data = {"target_type":msgtype,"target":[toname],"msg":{"type":"txt","msg":content},"from":fromname}
		resp = requests.post(url=url,headers=headers,data=json.dumps(data))
		if resp.status_code != 200:
			print resp.status_code, resp.text
		i += 1
		time.sleep(0.8)

def rest_mutegroupmember(resturl,org,app,headers,groupid,member):
	url = "http://%s/%s/%s/chatgroups/%s/mute" %(resturl,org,app,groupid)
	data = {"usernames":[member],"mute_duration":100000}
	resp = requests.post(url=url,headers=headers,data=json.dumps(data))
	if resp.status_code != 200:
		print resp.status_code, resp.text
			
def rest_unmutegroupmember(resturl,org,app,headers,groupid,member):
	url = "http://%s/%s/%s/chatgroups/%s/mute/%s" %(resturl,org,app,groupid,member)
	resp = requests.delete(url=url,headers=headers)
	if resp.status_code != 200:
		print resp.status_code, rest.text
	
def get_devices():
	device_list = []
	resp = os.popen("adb devices").readlines()
	for i in range(1, len(resp)-1):
		deviceid = resp[i].strip().split("\t")[0]
		device_list.append(deviceid)
	return device_list
	
def connect_simulator(simulator_id):
	device_list = get_devices()
	i = 1
	while simulator_id not in device_list and i <= 2:
		os.popen("adb connect %s" %simulator_id)
		device_list = get_devices()
		i = i + 1
	if 	simulator_id not in device_list:
		raise Exception("%s not connected successfully via adb command." %simulator_id)
	else:
		print "%s connected successfully via adb command." %simulator_id
	if simulator_id == device_list[1]:
 		pass
 	else:
 		device_list.reverse()
	print device_list
	return device_list
		
def setappiuminput(deviceid):
	resp = os.popen("adb -s %s shell ime set io.appium.android.ime/.UnicodeIME" %deviceid).readlines()
	if len(resp) == 0:
		print "resp is [] when setappiuminput"
	elif "selected" in resp[-1]:
		print "appium input set successfully."
	else:
		print "appium input set failed."

def setnonappiumimput(deviceid):
	ime_list = []
	resp = os.popen("adb -s %s shell ime list -s" %deviceid).readlines()
	for i in range(len(resp)):
		ime = resp[i].strip()
# use "Permission" in ime to avoid result "open: Permission denied" on HongMi phone.
# use ime_list[-1] since maybe ime installed in the last.
		if ime != "io.appium.android.ime/.UnicodeIME" and "Permission" not in ime:
			ime_list.append(ime)
	os.popen("adb -s %s shell ime set %s" %(deviceid,ime_list[-1])) 

def rest_changeappkey(account,appkey,myheaders,myresturl,org="easemob-demo",app="chatdemoui"):
	url = "http://%s/%s/%s/messages" %(myresturl,org,app)
	print url
	data = {"target_type":"users","target":[account],"msg":{"type":"cmd","action":"em_change_appkey"},\
	"from":"test", "ext": {"appkey":appkey}}	
	resp = requests.post(url=url,headers=myheaders,data=json.dumps(data))
	if resp.status_code != 200:
		print resp.status_code, resp.text
	
def rest_changeserver(account,rest_server,im_server,myheaders,myresturl,org="easemob-demo",app="chatdemoui"):
	url = "http://%s/%s/%s/messages" %(myresturl,org,app)
	print url
	data = {"target_type":"users","target":[account],"msg":{"type":"cmd","action":"em_change_servers"},\
 	"from":"test", "ext": {"im_server":im_server,"rest_server":rest_server}}
	resp = requests.post(url=url,headers=myheaders,data=json.dumps(data))
	if resp.status_code != 200:
		print resp.status_code, resp.text
		
if __name__ == "__main__":
	test_env = "ebs"
	appkey = "easemob-demo#chatdemoui"
	orgname = "easemobdemoadmin"
	orgpwd = "thepushbox123"
	get_token = "no"
	test_para = configdata.test_parameter(test_env,appkey,get_token)
	org = test_para[0]
	app = test_para[1]
	token = test_para[2]
	headers = token = test_para[3]

	token = rest_getorgtoken("a1.easemob.com",orgname,orgpwd)
	print token

	print "\nThe end."
	