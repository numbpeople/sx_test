*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot  

Suite Setup    connect_appium_method    ${driver.name}

*** Test Cases ***
Login
    [Template]    

