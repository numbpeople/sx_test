*** Settings ***
Library           unittest
Library           requests
Library           AppiumLibrary
Library           Collections
Library           os
Library           RequestsLibrary
Library           String
Resource          ../../../api/BaseApi/Note/NoteApi.robot
Resource          ../../../AgentRes.robot

*** Variables ***
&{leave_message}    content=This is a test leave message case    name=ZhangSan    phone=13869696868    email=zhangsan@qq.com    theme=easemobtest
${respones_info}    This is a respones infomation

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
    [Documentation]    向下滑动
    Swipe    0    0    ${width/2}    ${height/5}

clean_chat_records
    Comment    需要进入客服聊天窗口
    Click Element    com.easemob.helpdeskdemo:id/right_layout
    Click Element    com.easemob.helpdeskdemo:id/alert_right_btn
    sleep    0.5

get_projectid
    ${resp}=    /tenants/{tenantId}/projects    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword And Return    set variable    ${j['entities'][0]['id']}

setting_option
    [Arguments]    ${input_contant}    ${click_into}    ${wait_locator}    ${input_locator}    ${contant_verify}
    go_setting
    click element    ${click_into}
    Wait Until Element Is Visible    ${wait_locator}
    Clear Text    ${input_locator}
    Input text    ${input_locator}    ${input_contant}
    click element    //android.widget.TextView[@text="Save"]
    sleeps    1
    Element Should Be Enabled    ${contant_verify}

swipe_up
    [Documentation]    向上滑动
    Swipe    ${width/2}    ${height/5}    0    0

timestamps
    ${timestamp}=    get time    epoch
    Run Keyword And Return    set variable    ${timestamp}
