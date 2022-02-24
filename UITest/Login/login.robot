*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/android_bases_page/android_home_page.py
Library    AppiumLibrary
*** Test Cases ***
login
    ${driver}    connect_appium_method    huaweip20
    Log    ${driver}    
    login_page    android_login    ${driver}    "1111"    "1"