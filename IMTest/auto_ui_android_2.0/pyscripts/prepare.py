# -*- coding: utf-8 -*-
import urllib2
import json
import time
import requests
import rest
import configdata



test_env = "vip8" #e.g ebs, k8s_sdb, vip1, vip5, vip6, vip7, aws
appkey = "easemob-demo#vip8coco"

get_token = "yes"
test_type = "full"
test_im = "msync"

server_config = configdata.server_config(test_env,test_type,test_im)
resturl= server_config[0]
test_para = configdata.test_parameter(test_env,appkey,get_token,resturl)

org = test_para[0]
app = test_para[1]
token = test_para[2]

print token
headers = {'Content-Type':'application/json','Authorization':'Bearer '+token}

print "Test env: ", test_env
print "Test url: ", resturl
print 'Appkey: %s#%s' %(org,app)

check_env = raw_input("\nInput yes if test parameter OK, otherwise press Enter key:")
print check_env
if check_env != "yes":
	raise Exception("Test parameter wrong, stop.")
else:
	print "start preparing test data:"

def postwithbody(emurl,emheaders,emdata=None):
	resp = requests.post(url=emurl,headers=emheaders,data=json.dumps(emdata))
	status_code = resp.status_code
	if status_code == 200:
		print "status code:", status_code
		return json.loads(resp.text)
	else:
		print "status code:", status_code
		print resp.text

#Create users
print "\nCreate users:"
url = 'http://%s/%s/%s/users' %(resturl,org,app)
pwd = '1'
users = ['at0','at1','at2','b0','b1','member1']
for user in users:
	data = {"username":user,"password":pwd}
	postwithbody(url,headers,data)
	
#Add friend
print "\nAdd friend:"
friends = ['at0','b0','member1']
user = 'at1'
for friend in friends:
	url = 'http://%s/%s/%s/users/%s/contacts/users/%s' %(resturl,org,app,user,friend)
	postwithbody(url,headers)

#Add block:
print "\nAdd block:"
user = 'at1'
data = {"usernames":["b1"]}
url = 'http://%s/%s/%s/users/%s/blocks/users' %(resturl,org,app,user)
postwithbody(url,headers,data)	
	
#Create groups
print "\nCreate groups:"
print "group 1: main group Ginfo"
url = 'http://%s/%s/%s/chatgroups/' %(resturl,org,app)
data = {"groupname":"Ginfo",
		"desc":'Rest created groups',
		"public":True,
		"approval":True,
		"owner":"at1",
		"maxusers":2000,
		"members":["at0","b0"]}
result = postwithbody(url,headers,data)
groupid1 = result["data"]["groupid"]
print groupid1

print "\ngroup 2: at2GK for exiting group"
data = {"groupname":"at2GK",
		"desc":'Rest created groups',
		"public":True,
		"approval":True,
		"owner":"at2",
		"maxusers":2000,
		"members":["at1"]}
result = postwithbody(url,headers,data)
groupid2 = result["data"]["groupid"]
print groupid2

print "\ngroup 3: at2 for join public and not approval group"
data = {"groupname":"at2",
		"desc":'Rest created groups',
		"public":True,
		"approval":False,
		"owner":"at2",
		"maxusers":2000}
result = postwithbody(url,headers,data)
groupid5 = result["data"]["groupid"]
print groupid5

#Create chatroom
print "\nCreate chatroom:"
roomname = app+"room"
url = 'http://%s/%s/%s/chatrooms' %(resturl,org,app)
data = {"name":roomname,
	"description":"chatroom description",
	"maxusers":5000,
	"owner":"at2"}
result = postwithbody(url,headers,data)
roomid = result["data"]["id"]
print roomname, roomid

#Create big10000 group
# print "\nCreate big10000 group:"
# user = "at1"
# biggroupname = "big_at1"
# big_groupid = rest.im_creategroup10000(user,biggroupname)

print "\nThe end."


#Initiate.py
# Ginfo_id = "12199245447169"	第一个群Ginfo 主要群
# at2GK_id = "1468655789517"	第二个群at2GK for退群
# at2_id = "12199599865857"		第三个群at2 公开不验证

