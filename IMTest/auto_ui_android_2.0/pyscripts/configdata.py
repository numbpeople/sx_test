# -*- coding: utf-8 -*-
import rest

def server_config(test_env,test_type,test_im):
	config = {"ebs":{"rest":"a1.easemob.com","ejabberd_gray":"182.92.239.119:5222","msync_gray":"60.205.128.208:443",\
				"ejabberd":"im1.easemob.com","msync":"msync-im1.easemob.com"},\
		"sdb":{"rest":"118.193.28.212:31080","ejabberd":"118.193.28.212:31092","msync":"118.193.28.212:31097"},\
		"vip1":{"rest":"a1-vip1.easemob.com","ejabberd":"im1-vip1.easemob.com","msync":"msync-im1-vip1.easemob.com:443"},\
		"vip5":{"rest":"a1-vip5.easemob.com","ejabberd":"im1-vip5.easemob.com","msync":"101.37.226.88:443"},\
		"vip6":{"rest":"a1-vip6.easemob.com","ejabberd":"im1-vip6.easemob.com","msync":"60.205.85.241:6717"},\
		"vip7":{"rest":"a1-vip7.easemob.com","ejabberd":"im1-vip7.easemob.com:5222","msync":"msync-vip7.easemob.com:6717"},\
		"vip8":{"rest":"a1-vip8.easemob.com","ejabberd":"im1-vip8.easemob.com:5222","msync":"msync-vip8.easemob.com:6717"},\
		"aws":{"rest":"a1-pro4.easemob.com","ejabberd":"im1-pro4.easemob.com:5222","msync":"msync-pro4.easemob.com:6717"},\
		}
	if test_type == "gray":
		im = test_im + "_" + test_type
	else:
		im = test_im
	try:
		rest_server = config[test_env]["rest"]
		im_server = config[test_env][im]
		server = [rest_server, im_server]
		return server
	except KeyError:
		raise Exception("some config not find, check again.")

def test_parameter(test_env,appkey,get_token,resturl):
    orgapp = appkey.split("#")
    org = orgapp[0]
    app = orgapp[1]
    token_env = env_token(test_env,get_token,resturl)
    token = token_env[0]
    im_token = token_env[1]
    headers = {'Content-Type':'application/json','Authorization':'Bearer '+token}
    imheaders = {'Content-Type':'application/json','Authorization':'Bearer '+im_token}
    print "test environment: %s" %test_env
    print "appkey: %s" %appkey
    return [org, app, token, headers]

def org_token(test_env,resturl):
	parameter = {"ebs":{"orgname":"easemobdemoadmin","orgpwd":"thepushbox123"},\
				"sdb":{"orgname":"easemob","orgpwd":"easemob"},\
				"vip1":{"orgname":"easemobdemovip1admin","orgpwd":"thepushbox"},\
				"vip5":{"orgname":"vip5demoadmin","orgpwd":"thepushbox"},\
				"vip6":{"orgname":"admin","orgpwd":"123456"},\
				"vip7":{"orgname":"","orgpwd":""},\
				"vip8":{"orgname":"vip8demoadmin","orgpwd":"thepushbox"},\
				"aws":{"orgname":"admin","orgpwd":"1234567"}				
				}
	orgname = parameter[test_env]["orgname"]
	orgpwd = parameter[test_env]["orgpwd"]
	token = rest.rest_getorgtoken(resturl,orgname,orgpwd)
	return token

def env_token(test_env,get_token,resturl):
	parameter = {"ebs":{"token":"YWMtImJ7VKzAEeeBehvyqCjuuAAAAAAAAAAAAAAAAAAAAAGP-MBq3AgR45fkRZpPlqEwAQMAAAFe__NGEgBPGgB7ws_kUZrWmXNdQhY95AhP_3ODyzQDrf2zAyvAb7AaPA"},\
                "sdb":{"token":"YWMtv82_qp0xEeeqiHXfi5VoRAAAAV_O_eCaUvYTSJDoP7zgUveIjnlRoDj-n2Y"},\
                "vip1":{"token":"YWMtKjipeoL-EeekNuv9745IpgAAAV8jRw2H42rOKOMUSBYTXF2mxiIwfooVey8"},\
                "vip5":{"token":"YWMtMq0PSq4-EeejI62A2cz8sgAAAAAAAAAAAAAAAAAAAAEQ9tSAuFkR5aTJWWIOBU6WAQMAAAFfCbsqfQBPGgCmAr-IUTMDHy56VYsGTMuGsqMJaVQgvsGRZsMJxCmSag"},\
                "vip6":{"token":"YWMtaOrLOK4-EeeaM92Bz9Xk2gAAAWA-uh33z6v-WGf7IBzvWe1jLauP09msU90"},\
                "vip7":{"token":"YWMtcinYcL7mEeeJziMwCB3S9gAAAWCr4ud3osO2KZE0yAYFYdDHuBMC6Tov82o"},\
                "aws":{"token":"YWMtcAacrq49Eee_xJeRGpdneAAAAWA-s77UqUd0Gvk_3Kvy5OmNxLMBKUSFun0"},\
                "im_token":"YWMt39RfMMOqEeKYE_GW7tu81ABCDT71lGijyjG4VUIC2AwZGzUjVbPp_4qRD5k"
                }  
	if get_token == "yes":
		token = org_token(test_env,resturl)
	else:
	    token = parameter[test_env]["token"]
	im_token = parameter["im_token"]
	return [token, im_token]

def group_data(test_env,appkey):
	group = {"ebs":{"easemob-demo#chatdemoui":{"Ginfo_id":"12199245447169","at2GK_id":"1468655789517","at2_id":"12199599865857"},\
					"easemob-demo#coco":{"Ginfo_id":"1492673161102","at2GK_id":"246601204069564852","at2_id":"246601204619018676"},\
					"easemob-demo#ebscoco":{"Ginfo_id":"31661066616833","at2GK_id":"31661066616834","at2_id":"31661066616835"}},\
	"sdb":{"easemob-demo#chatdemoui":{"Ginfo_id":"22008455823361","at2GK_id":"22008456871937","at2_id":"22008458969090"},\
			"easemob-demo#coco":{"Ginfo_id":"17824812695553","at2GK_id":"17824813744129","at2_id":"17824815841281"},\
			"easemob-demo#k8ssdbcoco":{"Ginfo_id":"32682167828481","at2GK_id":"32682167828482","at2_id":"32682168877057"}},\
	"vip1":{"easemob-demo#chatdemoui":{"Ginfo_id":"1471332204739","at2GK_id":"1471333351858","at2_id":"230933459772638580"},\
			"easemob-demo#vip1coco":{"Ginfo_id":"33507371974657","at2GK_id":"33507373023233","at2_id":"33507373023234"},\
			"easemob-demo#coco":{"Ginfo_id":"18901973925889","at2GK_id":"18901973925890","at2_id":"18901974974466"}},\
	"vip5":{"easemob-demo#chatdemoui":{"Ginfo_id":"236196310200355576","at2GK_id":"236196312159095540","at2_id":"236196312956013304"},\
			"easemob-demo#vip5coco":{"Ginfo_id":"33507533455361","at2GK_id":"33507533455362","at2_id":"33507533455363"},\
			"easemob-demo#coco":{"Ginfo_id":"31055551725569","at2GK_id":"31055551725570","at2_id":"31055551725571"}},\
	"vip6":{"easemob-demo#chatdemoui":{"Ginfo_id":"1471341334823","at2GK_id":"1471341538205","at2_id":"230970279109594244"},\
			"easemob-demo#coco":{"Ginfo_id":"15098034847745","at2GK_id":"15098034847746","at2_id":"15098036944897"},\
			"easemob-demo#vip6coco":{"Ginfo_id":"31663201517569","at2GK_id":"31663202566145","at2_id":"31663202566146"}},\
	"vip7":{"easemob-demo#chatdemoui":{"Ginfo_id":"22781606559745","at2GK_id":"22781604462593","at2_id":"22781608656897"},\
			"easemob-demo#coco":{"Ginfo_id":"31600791322625","at2GK_id":"31600792371201","at2_id":"31600792371202"}},\
	"vip8":{"easemob-demo#coco":{"Ginfo_id":"32954557464577","at2GK_id":"32954557464578","at2_id":"32954557464579"},\
			"easemob-demo#vip8coco":{"Ginfo_id":"32954627719169","at2GK_id":"32954627719170","at2_id":"32954627719171"}},\
	"aws":{"easemob-demo#chatdemoui":{"Ginfo_id":"247000596257704396","at2GK_id":"247000610514143812","at2_id":"247000619716446672"},\
			"easemob-demo#awscoco":{"Ginfo_id":"33507909894145","at2GK_id":"33507910942721","at2_id":"33507991683073"},\
			"easemob-demo#coco":{"Ginfo_id":"330879681920240056","at2GK_id":"330879684172581300","at2_id":"330879693920143796"}},\
	}
	try:
		Ginfo_id = group[test_env][appkey]["Ginfo_id"]
		at2GK_id = group[test_env][appkey]["at2GK_id"]
		at2_id = group[test_env][appkey]["at2_id"]
		group_list = [Ginfo_id, at2GK_id, at2_id]
		return group_list
	except KeyError:
		print 
		raise Exception("some group id not find, check again.")

def env_change(test_env,test_type,appkey):
	server_change = "no"
	appkey_change = "no"
	appkeyandserver_change = "no"
	if test_env != "ebs" and appkey != "easemob-demo#chatdemoui":
		appkeyandserver_change = "yes"
	elif test_env == "ebs" and test_type == "gray":
		if appkey == "easemob-demo#chatdemoui":
			server_change = "yes"
		else:
			appkeyandserver_change = "yes"
	elif test_env != "ebs":
		server_change = "yes"
	elif appkey != "easemob-demo#chatdemoui":
		appkey_change = "yes"
	else:
		print "no need change appkey and server."
	return [server_change, appkey_change, appkeyandserver_change]

if __name__ == '__main__':
	pass
