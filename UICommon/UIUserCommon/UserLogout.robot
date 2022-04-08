*** Settings ***
Library    String
Library    Collections
Resource    ../../UITest_Env/MyTabElement/MyTabPageElement.robot
Resource    ../../UITest_Env/MyTabElement/SettingElement.robot
Resource    ../../UITest_Env/UITeset_Env.robot

*** Variables ***
${waitpagetime}    5

*** Keywords ***
Get My xPaths Used
    [Documentation]
    ...   1.根据平台判断登录、注册页面使用的xpath
    ${methods}    Set Variable    ${findby.xpath}
    ${myPage}    ${platform}    Change Xpath    ${AndroidMyPageElement}    ${iOSMyPageElement}
    ${login}    ${platform}    Change Xpath    ${AndroidLoginXpath}    ${iOSLoginXpath}
    ${seting}    ${platform}    Change Xpath    ${AndroidSetingElement}    ${iOSSetingElement}
    Return From Keyword    ${methods}    ${MyPage}    ${login}    ${seting}
    
User Logout
    [Documentation]    
    ...    1.用户登出
    ${methods}    ${MyPage}    ${login}    ${seting}     Get My xPaths Used
    #点击“我的”,进入我的页面
    Click Element    ${methods}=${mypage.my_tab}
    #等待页面出现“设置”按钮
    Wait Until Page Contains Element    ${methods}=${mypage.seting}    ${waitpagetime}
    #点击“设置”
    Click Element    ${methods}=${mypage.seting}
    #等待设置页面出现“退出登录按钮”
    Wait Until Page Contains Element    ${methods}=${seting.logout}    ${waitpagetime}
    #点击退出登录
    Click Element    ${methods}=${seting.logout}
    Sleep    ${waitpagetime}    
    #解决退出登录时“解绑推送token失败”问题。
    Run Keyword And Ignore Error    Click Element    ${methods}=${seting.logout}
    Wait Until Page Contains Element    id=com.hyphenate.easeim:id/tv_version    ${waitpagetime}    ${waitpagetime}内未返回到登录页面
    Element Should Be Visible    id=com.hyphenate.easeim:id/tv_version    
    
User Logout Telepate
    [Arguments]    ${username}
    [Documentation]    
    ...    1.用户登出模板