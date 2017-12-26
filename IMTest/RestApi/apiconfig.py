#coding: utf-8

import requests,json
import datetime,sys


url = sys.argv[1]
org = sys.argv[2]
app = sys.argv[3]
username = sys.argv[4]
password = sys.argv[5]


user1 = "rest111"
user2 = "rest112"
user3 = "rest113"
user4 = "rest114"
user5 = "rest115"
user88 = "rest188"

userlist = [user1,user2,user3,user4,user5,user88]

messages = "message from automation rest test"



#get before 3 days date
historymess = datetime.datetime.now() - datetime.timedelta(days=3)
olddate = historymess.strftime('%Y%m%d%H')



## get Admin token
def acquire_token(url,username,password):
    tokenbody = {
        "grant_type":"password",
        "username":username,
        "password":password }
    try:
        req = requests.post("%s/management/token" %(url),data=json.dumps(tokenbody),headers={'Accept':'application/json','Content-Type': 'application/json'})
    except requests.exceptions.ConnectionError,e:
        return "Your url is error :", e.message
    try:
        if req.status_code == 200:
            contents = json.loads(req.content)
            tokens = contents["access_token"]
            expires_in = contents["expires_in"]
            return tokens,expires_in
        else:
            return req.status_code,req.content
    except UnboundLocalError,e:
        return e,e.message


token,expires_in = acquire_token(url,username,password)

print "Token is: %s, Expires_in is: %s" %(token,expires_in)
'''
#token = "YWMthsaJMtpMEeeORH166O_Q3gAAAAAAAAAAAAAAAAAAAAFe2JYa1n8R45heowo6U5LUAQMAAAFgKnTR2QBPGgA45in-uKuDCUlPHnPHc5iOvzL_qkiTyYRJOi8re-QzrA"


#超级token
#token = "YWMtmPpRmt5ZEeedV_961BhnFQAAAAAAAAAAAAAAAAAAAAFe2JYa1n8R45heowo6U5LUAQMAAAFgRQFecABPGgD7v50BoYYFAfDgr3XCGSgm9zdQGNyIseJjXBswqJQYSQ"

#灰度token
#token = "YWMtlIXhXM4YEeezpfcn9NztsAAAAAAAAAAAAAAAAAAAAAE0jHVaFpQR5oOh13fSZKt6AQMAAAFf2nu5qgBPGgCsETm-lBkrSIqrlQmESeEMS-WarDIpqx0VrTTSG6x9RQ"

#ebs2超级token
token = "YWMtOpwXCuVNEeeYz5WJF7Y7pQAAAWGnjexwtRAwHWPnRAS-TwyosxBdjm8FM14"
'''

headers = {'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': "Bearer %s" % token}


def ornament(func):
    def judge(*args, **kwargs):
        try:
            r = func(*args, **kwargs)
            data = r.json()
            print json.dumps(data, sort_keys=True, indent=2)
        except (ValueError,TypeError), e:
            return "your url error or resport result is not json: %s, status code is: %s" % (e,r.status_code)
        if r.status_code != 200:
            return r.status_code,r.content
        else:
            return r.status_code
    return judge


for myuser in userlist:
    req = requests.get("%s/%s/%s/users/%s" % (url, org, app, myuser),headers=headers)
    if req.status_code == 404:
        CreateUserBody = {"username":myuser,"password":"1"}
        r = requests.post("%s/%s/%s/users" % (url, org, app),
                          data=json.dumps(CreateUserBody),
                          headers=headers)
    else:
        pass