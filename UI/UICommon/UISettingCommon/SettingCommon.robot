*** Settings ***
Resource    ../UIUserCommon/UserLogout.robot
Resource    ../UIUserCommon/FriendAndBlackListCommon.robot
*** Keywords ***
Click Setting
    [Documentation]    点击我中的【设置】
    Wait Until Page Contains Element    ${methods}=${mypage.seting}    ${waitpagetime}
    Click Element    ${methods}=${mypage.seting}

Click Privacy
    [Documentation]    点击设置中的【隐私】
    Wait Until Page Contains Element    ${methods}=${mypage.privacy}    ${waitpagetime}
    Click Element    ${methods}=${mypage.privacy}

Click Blacklist
    [Documentation]    点击隐私中的【黑名单】
    Wait Until Page Contains Element    ${methods}=${mypage.blacklist}    ${waitpagetime}
    Click Element    ${methods}=${mypage.blacklist}

Click Remove Blacklist
    [Documentation]    点击【移除黑名单】
    ${blackname}    Set Variable    //android.widget.TextView[@text="移出黑名单"]
    Wait Until Page Contains Element    //android.widget.TextView[@text="移出黑名单"]
    Click Element    ${methods}=${blackname}
    Set Test Variable    ${blackname}
    
Removing Blacklist 
    [Documentation]    黑名单列表中删除用户操作
    [Arguments]    ${friendusername}
    IF    "${platform}" == "android"
        #Androd：长按用户昵称
        Long Press Friend Operation    ${friendusername}
        #选择移除黑名单
        Click Remove Blacklist
    ELSE
        #iOS：按住用户昵称滑动
        Wipe Friend Operation    ${friendusername}
        #选择移除黑名单

    END