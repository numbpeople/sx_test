*** Variables ***
${WebimLoginCMD}         {"type":1,"objId":10000,"device":"","cmd":"open","sequence":0,"info":{"params":[{"user":"%s","pwd":"%s","appKey":"%s"}]},"extra":{"returnResult":true}}
${WebimLoginResp}         {"accessToken":"YWMtWUQuSsVtEey1i4_JuIcTOY37FkG22EULu-123456789WX0bQghkR64BOUUYjAsIxAwMAAAGAZkdq-wAAAHidbUVzDllAVtMrHeF3Lp4n9v5vWCCVUCH7pBGsDNQCBA","duration":120}
@{WebimLoginExclude}    root['accessToken']    root['duration']
${WebimLogoutCMD}         {"type":1,"objId":10000,"device":"","cmd":"close","sequence":0,"info":{"params":[]},"extra":{"returnResult":true}}
