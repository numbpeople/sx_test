*** Variables ***
&{env}    platform=${driver.Android}     num=2
&{driver}    name=huaweip20    Android=Android    iOS=iOS
&{baseRes}    orgname=    appname=    token=
&{requestHeader}    Content-Type=application/json    Authorization=    restrict-access=    thumbnail=    share-secret=    Accept=    thumbnail=    # 请求header头中可以设置的多种key&value类型
&{Android}    platformName=Android    platformVersion=10    deviceName=CLB7N18B05003594    app=    appPackage=com.hyphenate.easeim
...    appActivity=com.hyphenate.easeim.section.login.activity.SplashActivity    noReset=True
&{iOS}    platformName=iOS    platformVersion=14.0    deviceName=iPhone    uuid=774e66fdc7db15c5756d3684b258d1d7cc189a7c    app=/Users/mac/Downloads/iOS_IM_SDK_V3.9.0/EaseIM.ipa    noReset=True    automationName=XCUITest

&{findby}    id=id    xpath=xpath
&{statuscode}    ricode=200    errcode=404
&{rightusername}    username=
&{errusername}    usernname4=
&{password}    spec_password=
