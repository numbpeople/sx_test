*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/KefuApi.robot
Resource          ../../JsonDiff/OrgJsonDiff.robot
Resource          ../../api/MicroService/Organ/OrgApi.robot
Resource          ../../commons/admin common/BaseKeyword.robot
Resource          ../../UIcommons/Org/dashboard.robot
Library           uuid
Library           urllib
Library           Selenium2Library

*** Test Cases ***
org管理员登录
    #Set Selenium Timeout    3
    #接口登录
    Create Session    orguiadminsession    ${orgurl}
    set to dictionary    ${OrgAdminUser}    session=orguiadminsession
    ${resp}=    /v2/orgs/{orgId}/token    post    ${OrgAdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${OrgAdminUser}    cookies=${resp.cookies}    userId=${j['entity']['user']['userId']}    nicename=${j['entity']['user']['nicename']}    session=orgadminsession
    set global variable    ${OrgAdminUser}    ${OrgAdminUser}
    #打开浏览器并写入cookie
    @{t}=    Get Dictionary Keys    ${resp.cookies}
    open browser    ${orgurl}    ${OrgAdminUser.browser}
    : FOR    ${key}    IN    @{t}
    \    log    ${key}
    \    ${value}=    Get From Dictionary    ${resp.cookies}    ${key}
    \    Add Cookie    ${key}    ${value}
    ${cookies}=    Get Cookies
    go to    ${orgurl}${dashboardUri}
    log    ${OrgAdminUser.nicename}
    Wait Until Page Contains    xpath=${AppTitleXPath}    ${OrgAdminUser.nicename}    ${UIdelay}

tt
    ${proxy}=    Evaluate    sys.modules['selenium.webdriver'].Proxy()    sys, selenium.webdriver
    ${proxy.http_proxy}=    Set Variable    localhost:8888
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --lang\=en
    log    ${options.arguments}
    open browser    http://kefu.easemob.com    chrome    ChromeOptions=${options}

t1
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --lang\=en
    open browser    http://kefu.easemob.com    chrome    desired_capabilities=${options}
