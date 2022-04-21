*** Variables ***
${variablename}    
&{AndroidAdressBookXpath}    
...    address=//android.widget.FrameLayout[@content-desc="通讯录"]    #通讯录tab
...    new_friend_button=//android.view.ViewGroup/android.widget.TextView[@text="新的好友"]    #新的好友按钮
...    group_chat_button=//android.view.ViewGroup/android.widget.TextView[@text="群聊"]    #群聊按钮
...    chatrooms_button=//android.view.ViewGroup/android.widget.TextView[@text="聊天室"]    #聊天室按钮
...    friend=//android.view.ViewGroup/android.widget.TextView[@text="${variablename}"]    #好友
...    delete_button=//android.widget.TextView[@text="删除联系人"]    #删除联系人按钮
...    add_block_button=//android.widget.TextView[@text="移入到黑名单"]    #添加到黑名单
...    confirm_button=//android.widget.Button[@text="确定"]    #确认按钮
...    cancel_button=//android.widget.Button[[@text="取消"]]    #取消按钮
&{iOSAdressBookXpath}
...    address=//XCUIElementTypeButton[@name="通讯录"]   #通讯录tab
...    new_friend_button=//XCUIElementTypeStaticText[@name="新的好友"]    #新的好友按钮
...    group_chat_button=//XCUIElementTypeStaticText[@name="群聊"]    #群聊按钮
...    chatrooms_button=//XCUIElementTypeStaticText[@name="聊天室"]    #聊天室按钮
...    friend=//XCUIElementTypeStaticText[@name="${variablename}"]    #好友
...    delete_button=//XCUIElementTypeButton[@name="删除"]    #删除联系人按钮
...    back_buttom=//XCUIElementTypeNavigationBar[@name="个人资料"]/XCUIElementTypeButton[1]    #个人资料页面返回按钮
...    setting_button=//XCUIElementTypeNavigationBar[@name="个人资料"]/XCUIElementTypeButton[2]    #个人资料页面右上角设置按钮
...    add_block_button=//XCUIElementTypeStaticText[@name="加入黑名单"]    #添加到黑名单




