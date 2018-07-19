#coding=utf-8
import os,sys,urllib2
import re,time
from appium import webdriver
from time import sleep
from appium.webdriver.webelement import WebElement
from appium.webdriver.common.touch_action import TouchAction


login_waittime = 90
#appkey = "easemob-demo#chatdemoui"
appkey = "hrcl#test1"
#restIP = "118.193.28.212:31080"
restIP = "47.94.89.233:38080"
#imIP = "118.193.28.212:31097"
imIP = "47.94.89.233:38082"
onlineuser = "online111"
userlist = ["at0","at1","rest111","rest112","rest113"]
def get_devicelist():
    patt = "\n(.+)\tdevice"
    text = os.popen("adb devices").read()
    devicelist = re.findall(patt, text)
    if devicelist == []:
        print "No device detected!\nplease check the connect!"
    return devicelist


def get_deviceinfo():
    mydic = {}
    patt = "\d\.\d[\.\d]?"
    dlist = get_devicelist()
    vlist = []
    for name in dlist:
        text = os.popen("adb -s %s shell getprop ro.build.version.release" % name).read()  # 获取系统版本
        cmd_api = os.popen('adb -s %s shell getprop ro.build.version.sdk' % name).read()  # 获取系统api版本
        version = re.findall(patt, text)[0]
        mydic[name] = version
    print "mydic is: ", mydic
    return mydic

def device_info():
    dinfo_dic = get_deviceinfo()
    for dev,ver in dinfo_dic.items():
        if '62001' in dev:
            deviceid1 = dev
            dversion1 = ver
            # deviceid1 = dinfo_dic.keys()[0]
            # dversion1 = dinfo_dic.get(deviceid1)
            #deviceid2 = dinfo_dic.keys()[1]
            #dversion2 = dinfo_dic.get(deviceid2)
            return [deviceid1, dversion1]

def startDemo(deviceid, dversion, port):
    desired_caps = {}
    desired_caps['platformName'] = 'Android'
    desired_caps['platformVersion'] = dversion
    desired_caps['deviceName'] = deviceid
    desired_caps['udid'] = deviceid
    desired_caps['appPackage'] = 'com.easemob.helpdeskdemo'
    desired_caps['appActivity'] = 'com.easemob.helpdeskdemo.ui.MainActivity'
    desired_caps['unicodeKeyboard']= True
    desired_caps['resetKeyboard']= True
    #desired_caps['automationName'] = 'Uiautomator2'
    desired_caps['noReset'] = True   #not clean app cache data
    desired_caps['newCommandTimeout']='2000'
    global driver1
    driver1 = webdriver.Remote('http://127.0.0.1:'+port+'/wd/hub', desired_caps)
    driver1.implicitly_wait(20)
    return driver1

def setappiumimput(deviceid):
    #set input method
    resp= os.popen("adb -s %s shell ime set io.appium.android.ime/.UnicodeIME" %deviceid).readlines

def clearAppdata(deviceid):
    os.popen("adb -s %s shell pm clear com.hyphenate.chatuidemo" %deviceid).readlines()



def test_login(driver, username, password):
    print("< case start : login >")
    ret_status = False

    driver.find_element_by_id("com.hyphenate.chatuidemo:id/username").send_keys(username)
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/password").send_keys(password)

    n = 1
    while ret_status == False and n <= 3:
        driver.find_element_by_xpath("//android.widget.Button[@text='Login']").click()
        for i in range(90):
            if i < 89:
                cur_Activity = driver.current_activity
                if cur_Activity == ".ui.MainActivity":
                    print "%s login successful." % username
                    print "< case end: pass >"
                    ret_status = True
                    break
                else:
                    time.sleep(1)
            else:
                print "%s login fail %s time." % (username, n)
                print "< case end: fail >"
        n = n + 1
        if driver.find_elements_by_id("android:id/progress") != []:
            back(driver)
    return ret_status

def goto_setting(driver):
    driver.find_element_by_xpath("//android.widget.RadioButton[@text='Setting']").click()

def goto_contacter():
    driver.find_element_by_xpath("//android.widget.Button[@text='Address book']").click()

def swipe_up(driver, start_point=2 / float(4), end_point=1 / float(4)):
    height = driver.get_window_size()["height"]
    width = driver.get_window_size()["width"]
    driver.swipe(width / 2, height * start_point, width / 2, height * end_point, 1000)
def back(driver):
    sleep(0.5)
    driver.press_keycode(4)

def swipe_down(driver, start_point=1 / float(4), end_point=3 / float(4)):
    height = driver.get_window_size()["height"]
    width = driver.get_window_size()["width"]
    driver.swipe(width / 2, height * start_point, width / 2, height * end_point, 1000)
def change_server(appkey,rest,im):
    goto_setting()
    time.sleep(0.5)
    swipe_up(driver)
    driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='11']/android.widget.FrameLayout").click()
    driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='11']/android.widget.EditText").send_keys(
        appkey)
    driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='12']/android.widget.FrameLayout").click()
    driver.find_element_by_xpath("//android.widget.RelativeLayout[@index='12']").click()
    time.sleep(0.5)
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_rest").send_keys(rest)
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_im").send_keys(im)
    driver.back()
    swipe_up(driver, 3 / float(4), 1 / float(4))
    driver.find_element_by_xpath("//android.widget.LinearLayout/android.widget.Button").click()

def login(user):
    num = 0
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/username").send_keys(user)
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/password").send_keys("1")
    driver.find_element_by_xpath("//android.widget.Button[@text='Login']").click()
    while num <= login_waittime:
        #print "driver.current_activity is: ", driver.current_activity
        num += 1
        time.sleep(1)
        if driver.current_activity == ".ui.MainActivity":
            print "user %s login success" % user
            break
    if num == login_waittime:
        print "loging failed"

def target(user):
    driver.find_element_by_xpath("//android.widget.TextView[@text='%s']" %user).click()

#["gray02","gray03","gray04","gray05","gray06"]
def sendtxt_to_friendlist(startnum=11,endnum=21):
    #driver.find_element_by_xpath("//android.widget.TextView[@text='%s']" % name).click()
    for num in range(startnum,endnum):
        driver.find_element_by_id("com.hyphenate.chatuidemo:id/et_sendmessage").send_keys(num)
        driver.find_element_by_id("com.hyphenate.chatuidemo:id/btn_send").click()


def send_image():
    #driver.find_element_by_xpath("//android.widget.ListView/android.widget.LinearLayout[@index='1']/android.widget.RelativeLayout/android.widget.LinearLayout").click()
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/btn_more").click()
    driver.find_element_by_xpath(
        "//android.widget.GridView/android.widget.LinearLayout[@index='1']/android.widget.LinearLayout/android.widget.RelativeLayout").click()
    driver.find_element_by_xpath(
        "//android.widget.GridView/android.widget.LinearLayout[@index='1']/android.widget.FrameLayout").click()
    driver.find_element_by_xpath(
        "//android.widget.LinearLayout/android.widget.LinearLayout[@index='1']/android.widget.TextView").click()
    driver.find_element_by_xpath(
        "//android.widget.RelativeLayout[@index='0']/android.widget.FrameLayout/android.widget.ImageView").click()
    driver.find_element_by_id("com.miui.gallery:id/pick_num_indicator").click()

def send_file():
    driver.find_element_by_xpath(
        "//android.widget.GridView/android.widget.LinearLayout[@index='4']/android.widget.LinearLayout/android.widget.RelativeLayout").click()
    driver.find_element_by_xpath(
        "//android.widget.GridView/android.widget.LinearLayout[@index='1']/android.widget.FrameLayout").click()
    driver.find_element_by_xpath(
        "//android.widget.LinearLayout/android.widget.LinearLayout[@index='1']/android.widget.TextView").click()
    driver.find_element_by_xpath(
        "//android.widget.RelativeLayout[@index='0']/android.widget.FrameLayout/android.widget.ImageView").click()
    driver.find_element_by_id("com.miui.gallery:id/pick_num_indicator").click()

if __name__ == "__main__":
    try:
        device_list = device_info()
        deviceid1 = device_list[0]
        print "device_list 0 is: ", device_list[0]
        print "device_list 1 is: ", device_list[1]
        #deviceid2 = device_list[2]
        port1 = "4723"
        port2 = "4725"
        setappiumimput(deviceid1)
        clearAppdata(deviceid1)
        driver = startDemo(deviceid1, device_list[1], port1)

        # #login
        # login(onlineuser)
        # time.sleep(1)
        # change_server(appkey,restIP,imIP)
        # driver = startDemo(deviceid1, device_list[1], port1)
        # login(userlist[0])
        # goto_contacter()
        # swipe_up(driver)
        # #send message text,image file
        # del userlist[0]
        # for name in userlist:
        #     target(name)
        #     sendtxt_to_friendlist()
        #     send_image()
        #     send_file()
        #     back(driver)
        #     back(driver)
    except urllib2.URLError ,e:
        print "no start appium server, error info: ",e


