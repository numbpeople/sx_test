*** Settings ***
Library    Lib/im_lib/Public.py
Library    AppiumLibrary
*** Test Cases ***
login
    ${driver}    connect_appium_method    huaweip20
    Log    ${driver}    
    login_page    android_login    ${driver}    "1111"    "1"