*** Settings ***
Documentation    记录会话tab页面元素
*** Variables ***
&{AndroidSessionPageXpath}    title=///android.widget.RelativeLayout/android.widget.TextView    #顶部会话标题
...    More_Options=//android.widget.ImageView[@content-desc="更多选项"]    #右上角添加按钮
...    search_box=//android.widget.FrameLayout/android.widget.TextView   #搜索输入框
...    session_tab=//android.widget.FrameLayout[@content-desc="会话"]/android.widget.ImageView
&{iOSSessionPageXpath}
