# -*- coding: utf-8 -*-
import json
import urllib2
import sys
import time
import rest
import configdata

def initiate_env(resturl,org,app,headers,test_env,appkey):
	start_time = time.time()

	myprivate_id = rest.rest_getgroupid(resturl,org,app,headers,'at1','myprivate')
	mypublic_id = rest.rest_getgroupid(resturl,org,app,headers,'at1','mypublic')

	#第一个群Ginfo 主要群
	#第二个群at2GK for退群
	#第三个群at2 公开不验证
	group_list = configdata.group_data(test_env,appkey)
	Ginfo_id = group_list[0]
	at2GK_id =group_list[1]
	at2_id = group_list[2]

	#注销账号
	print "\ndelete registered account accountA:"
	rest.rest_deluser(resturl,org,app,headers,"accountA")

	#添加好友
	print "\nadd contact at0 to at1:"	
	rest.rest_addbuddy(resturl,org,app,headers,"at1","at0")
	rest.rest_addbuddy(resturl,org,app,headers,"at1","b0")
	rest.rest_addbuddy(resturl,org,app,headers,"at1","member1")

	#删除好友
	print "\ndelete at2 from at1 contact:"
	rest.rest_delbuddy(resturl,org,app,headers,"at1","at2")

	#好友黑名单减人
	print "\ndelete b0 from at1 black list:"
	rest.rest_deluserblock(resturl,org,app,headers,"at1","b0")

	#好友黑名单加人
	print "\nadd b1 back to at1 black list:"
	rest.rest_adduserblock(resturl,org,app,headers,"at1","b1")

	#群组加人
	print "\nadd at0,b0,b1 back to group Ginfo:"
	for member in ["at0","b0","b1"]:
		rest.rest_addmember(resturl,org,app,headers,Ginfo_id,member)

	#群黑名单减人
	# print "\ndelete b0 from group Ginfo block list:"
	# rest.rest_delgroupblock(Ginfo_id,"b0")

	#群黑名单加人
	print "\nadd b1 back to group Ginfo block list:"
	rest.rest_addgroupblock(resturl,org,app,headers,Ginfo_id,"b1")

	#群组加人2	
	print "\nadd at1 back to group at2GK after exiting:"
	rest.rest_addmember(resturl,org,app,headers,at2GK_id,"at1") 

	#群组减人
	print "\ndelete at2 from group0:"
	rest.rest_delmember(resturl,org,app,headers,Ginfo_id,"at2")

	#群组减人2
	print "\ndelete at1 from public & approval false group:"
	rest.rest_delmember(resturl,org,app,headers,at2_id,"at1")

	#删除群组'myprivate'跟'mypublic'
	print "\ndelete created group myprivate and mypublic:"
	rest.rest_delgroup(resturl,org,app,headers,myprivate_id)
	rest.rest_delgroup(resturl,org,app,headers,mypublic_id)

	rest.rest_delgroup_vianame(resturl,org,app,headers,"at1","myprivate")
	rest.rest_delgroup_vianame(resturl,org,app,headers,"at1","mypublic")
	rest.rest_delgroup_vianame(resturl,org,app,headers,"at1","group1")
	rest.rest_delgroup_vianame(resturl,org,app,headers,"at1","dismiss")


	end_time = time.time()
	cost_time = end_time - start_time
	print "\n%s seconds costs to execute this script." %cost_time

	print '\nThe End'

if __name__ == "__main__":
	test_env = "k8s_sdb"
	appkey = "easemob-demo#k8ssdbcoco"
	test_type = "full"
	test_im = "msync"
	get_token = "yes"
	server_config = configdata.server_config(test_env,test_type,test_im)
	resturl = server_config[0]

	test_para = configdata.test_parameter(test_env,appkey,get_token,resturl)
	org = test_para[0]
	app = test_para[1]
	token = test_para[2]
	headers = test_para[3]
	initiate_env(resturl,org,app,headers,test_env,appkey)
	