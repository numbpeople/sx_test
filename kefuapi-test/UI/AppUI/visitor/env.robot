*** Settings ***
Library           unittest
Library           requests
Library           AppiumLibrary
Library           Collections
Library           os
Library           String
Library           mode.py

*** Keywords ***
go_setting
    Click Element    //android.widget.RadioButton[@text='Setting']

go_shop
    Click Element    //android.widget.RadioButton[@text='Shop']

go_Note
    Click Element    //android.widget.RadioButton[@text='Note']

go_Chat
    Click Element    //android.widget.RadioButton[@text='Chat']

sleeps
    [Arguments]    ${num}
    Evaluate    time.sleep(${num})    time

swipe_down
    Swipe    0    0    ${width/2}    ${height/5}

clean_chat_records
    Comment    需要进入客服聊天窗口
    Click Element    com.easemob.helpdeskdemo:id/right_layout
    Click Element    com.easemob.helpdeskdemo:id/alert_right_btn
