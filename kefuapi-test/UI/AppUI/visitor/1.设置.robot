*** Settings ***
Documentation     UIAutomation2 is only supported since Android 5.0 (Lollipop). You could still use other supported backends in order to automate older Android versions.
Library           unittest
Library           requests
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Resource          env.robot
Resource          ../../../api/BaseApi/Note/NoteApi.robot
Resource          ../../../AgentRes.robot

*** Test Cases ***
startdemo
    [Documentation]    【操作步骤】：
    ...    - Step1、关闭所有demo
    ...    - Step2、启动客服demo
    ...    【预期结果】：
    ...    - Step1、模拟器上关闭所有demo
    ...    - Step2、模拟器上正常启动客服demo
    Comment    关闭所有app清空包缓存    automationName=Uiautomator2
    Close All Applications
    Evaluate    os.system("adb shell pm clear com.easemob.helpdeskdemo")    os
    Comment    启动客服访客端app
    ${REMOTE_URL}    set variable    http://127.0.0.1:4723/wd/hub
    ${PLATFORM_NAME}    set variable    Android
    ${PLATFORM_VERSION}    set variable    4.4.
    Comment    ${DEVICE_NAME}    set variable    517ebeda
    ${DEVICE_NAME}    set variable    127.0.0.1:62001
    ${appPackage}    set variable    com.easemob.helpdeskdemo
    ${appActivity}    set variable    com.easemob.helpdeskdemo.ui.MainActivity
    Open Application    ${REMOTE_URL}    alias=myapp1    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    appPackage=${appPackage}
    ...    appActivity=${appActivity}
    ${width}    Get Window Width
    ${height}    Get Window Height
    set global variable    ${width}
    set global variable    ${height}

QR_code
    [Documentation]    【操作步骤】：
    ...    - Step1、进入设置项点击二维码按钮
    ...    - Step2、确认扫描二维码的功能可用
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、模拟器上出现扫描二维码框
    go_setting
    ${title}    Get Text    com.easemob.helpdeskdemo:id/btn_image_title
    should be equal    ${title}    Setting
    click element    com.easemob.helpdeskdemo:id/rl_qcode
    Comment    等待【扫描二维码】title
    ${QR_title}    Get Text    com.easemob.helpdeskdemo:id/tv_title
    should be equal    ${QR_title}    扫描二维码
    Comment    确认有扫描框出现
    Element Should Be Enabled    //android.widget.TextView[@text="识别二维码"]
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/fl_scan
    Go back

get_setup_info
    [Documentation]    【操作步骤】：
    ...    - Step1、使用rest api获取appkey等信息
    ...
    ...    【预期结果】：
    ...    - Step1、能够获取appkey，IM用户，tenantld等信息
    Comment    获取setting中的appkey等信息
    set global variable    ${RestEntity}
    set global variable    ${AdminUser}
    ${project}    get_projectid
    set global variable    ${appkey}    ${RestEntity.appKey}
    set global variable    ${IMserverNum}    ${RestEntity.serviceEaseMobIMNumber}
    set global variable    ${tenantld}    ${AdminUser.tenantId}
    set global variable    ${project}

setup_appkey
    [Documentation]    【操作步骤】：
    ...    - Step1、设置appkey
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、成功设置appkey
    Comment    设置appkey
    go_setting
    Comment    点击appkey进入设置页面
    click element    com.easemob.helpdeskdemo:id/tv_setting_appkey
    Wait Until Element Is Visible    com.easemob.helpdeskdemo:id/txtTitle
    Comment    清除文本输入appkey
    Clear Text    com.easemob.helpdeskdemo:id/edittext
    Input text    com.easemob.helpdeskdemo:id/edittext    ${appkey}
    Comment    保存退出并验证appkey是否输入成功
    click element    //android.widget.TextView[@text='Save']
    sleeps    1
    Element Should Be Enabled    //android.widget.TextView[@text="${appkey}"]

setup_IMserviceNum
    [Documentation]    【操作步骤】：
    ...    - Step1、设置IM服务号
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、成功设置IM服务号
    Comment    设置IM服务号
    setting_option    ${IMserverNum}    com.easemob.helpdeskdemo:id/tv_setting_account    //android.widget.TextView[@text="Customer Service Account"]    com.easemob.helpdeskdemo:id/edittext    //android.widget.TextView[@text="${IMserverNum}"]

setup_nickname
    [Documentation]    【操作步骤】：
    ...    - Step1、设置nickname
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、成功设置nickname
    Comment    设置昵称
    ${nickname}    set variable    user_${tenantld}
    setting_option    ${nickname}    com.easemob.helpdeskdemo:id/tv_setting_nick    //android.widget.TextView[@text="User Nick"]    com.easemob.helpdeskdemo:id/edittext    //android.widget.TextView[@text="${nickname}"]

setup_Tenantld
    [Documentation]    【操作步骤】：
    ...    - Step1、设置Tenantld
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、成功设置Tenantld
    Comment    设置租户ID
    setting_option    ${tenantld}    com.easemob.helpdeskdemo:id/tv_setting_tenant_id    //android.widget.TextView[@text="TenantId"]    com.easemob.helpdeskdemo:id/edittext    //android.widget.TextView[@text="${tenantld}"]

setup_leaveMessld
    [Documentation]    【操作步骤】：
    ...    - Step1、设置leaveMessld
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、成功设置leaveMessld
    Comment    设置留言ID
    setting_option    ${project}    com.easemob.helpdeskdemo:id/tv_setting_project_id    //android.widget.TextView[@text="Leave Message ID"]    com.easemob.helpdeskdemo:id/edittext    //android.widget.TextView[@text="${project}"]
