*** Settings ***
Documentation    记录会话tab页面元素
*** Variables ***
&{AndroidSessionPageXpath}    title=///android.widget.RelativeLayout/android.widget.TextView    #顶部会话标题
...    more_options=//android.widget.ImageView[@content-desc="更多选项"]    #右上角添加按钮
# ...    more_options=//android.view.ViewGroup/android.widget.RelativeLayout/android.widget.RelativeLayout/android.view.ViewGroup/androidx.appcompat.widget.LinearLayoutCompat
...    search_box=//android.widget.FrameLayout/android.widget.TextView   #搜索输入框
...    session_tab=//android.widget.FrameLayout[@content-desc="会话"]/android.widget.ImageView    #会话tab页面
...    photo_permissions=///android.widget.FrameLayout/android.widget.LinearLayout/android.widget.Button[2]    #获取拍摄照片和录制视频权限、录制音频权限
...    create_group=//android.widget.ListView/android.widget.LinearLayout[1]/android.widget.LinearLayout    #创建群组按钮
...    add_friends=//android.widget.ListView/android.widget.LinearLayout[2]/android.widget.LinearLayout    #添加好有按钮
...    user_serarch_box=//android.widget.FrameLayout/android.view.ViewGroup/android.widget.EditText
&{iOSSessionPageXpath}
