*** Settings ***
Documentation    记录注册页面元素
*** Variables ***
&{Register}    register_name=    register_pwd=    register_pwd_confirm=    select=    back=    btn_register1=    btn_register2=
&{AndroidId}    login_name=com.hyphenate.easeim:id/et_login_name
...    login_pwd=com.hyphenate.easeim:id/et_login_pwd
...    login_pwd_confirm=com.hyphenate.easeim:id/et_login_pwd_confirm
...    select=com.hyphenate.easeim:id/cb_select
...    btn_login=com.hyphenate.easeim:id/btn_login
&{AndroidRegisterXpath}    register_name=//android.widget.EditText[1]
...    register_pwd=//android.widget.EditText[2]
...    register_pwd_confirm=//android.widget.EditText[3]
...    select=//android.widget.CheckBox
...    btn_register2=//android.widget.Button
...    back=//android.widget.ImageButton[@content-desc="转到上一层级"]
...    btn_register1=//android.view.ViewGroup/android.widget.TextView[1]
&{iOSRegisterXpath}    register_name=//XCUIElementTypeTextField
...    register_pwd=//XCUIElementTypeSecureTextField[1]
...    register_pwd_confirm=//XCUIElementTypeSecureTextField[2]
...    select=//XCUIElementTypeButton[@name="unAgreeProtocol"]
...    btn_register2=(//XCUIElementTypeStaticText[@name="注册账号"])[2]
...    back=//XCUIElementTypeButton[@name="back left"]
...    btn_register1=(//XCUIElementTypeStaticText[@name="注册账号"])[1]

${num}    2
