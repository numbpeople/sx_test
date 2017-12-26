#coding=utf-8
import os
import re,time
from appium import webdriver
from time import sleep
from appium.webdriver.webelement import WebElement
from appium.webdriver.common.touch_action import TouchAction
import random
import string

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
    return mydic

def device_info():
	dinfo_dic = get_deviceinfo()

	deviceid1 = dinfo_dic.keys()[0]
	dversion1 = dinfo_dic.get(deviceid1)
	#deviceid2 = dinfo_dic.keys()[1]
	#dversion2 = dinfo_dic.get(deviceid2)
	return [deviceid1, dversion1]

def startDemo(deviceid, dversion, port):
	desired_caps = {}
	desired_caps['platformName'] = 'Android'
	desired_caps['platformVersion'] = dversion
	desired_caps['deviceName'] = deviceid
	desired_caps['udid'] = deviceid
	desired_caps['appPackage'] = 'com.hyphenate.chatuidemo'
	desired_caps['appActivity'] = 'com.hyphenate.chatuidemo.ui.SplashActivity'
	desired_caps['unicodeKeyboard']= True
	desired_caps['resetKeyboard']= True
	# desired_caps['automationName'] = 'Uiautomator2'
	desired_caps['noReset'] = True   #not clean app cache data
	desired_caps['newCommandTimeout']='2000'
	global driver
	driver = webdriver.Remote('http://127.0.0.1:'+port+'/wd/hub', desired_caps)
	driver.implicitly_wait(5)
	return driver

def setappiumimput(deviceid):
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
        for i in range(50):
            if i < 49:
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

    case_status[sys._getframe().f_code.co_name] = ret_status
    return ret_status

if __name__ == "__main__":
    device_list = device_info()
    deviceid1 = device_list[0]
    print "device_list 0 is: ", device_list[0]
    print "device_list 1 is: ", device_list[1]
    #deviceid2 = device_list[2]
    port1 = "4723"
    port2 = "4725"
    setappiumimput(deviceid1)
    clearAppdata(deviceid1)
    driver1 = startDemo(deviceid1, device_list[1], port1)
    #test_login(driver1, username="on1", password="asd")
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/username").send_keys("online111")
    driver.find_element_by_id("com.hyphenate.chatuidemo:id/password").send_keys("1")
    driver.find_element_by_xpath("//android.widget.Button[@text='Login']").click()
