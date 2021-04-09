*** Settings ***
Library    RequestsLibrary    
Library    json
Library    Collections
Resource    ../../WhtieBoard_Varable.robot
Resource    ../../RestApi/whiteboard/whiteboard.robot
Library    String    
Library    random
Library    sys
*** Keywords ***
random userid
    #产生一个随机字符串
    ${string}=    Generate Random String
    [Return]    ${string}
 random whiteBoardName
    ${num}    Evaluate    str(random.random())[-6:]    random
    [Return]    ${num}
 random password
    [Documentation]
    ${password}    Evaluate    str(random.random())[-3:]    random
    [Return]    ${password}
 random level
    [Documentation]    创建是否允许互动值
    ${Allowinteraction}    Evaluate    random.choice('123')    
    ${Baninteraction}    Evaluate    random.choice('456')
    ${interaction}    Create List    ${Allowinteraction}    ${Baninteraction}
    [Return]    ${interaction}
create whiteboard room
    [Documentation]    创建白板房间,需要传入用户id、白板房间名称、白板密码
    ...    允许互动
    ${level}    random level
    ${userid}    random userid
    #设置userid为全局变量，方便删除房间使用   
    Set Global Variable    ${userid}     
    #设置whiteBoardName为全局变量
    ${whiteBoardName}    random whiteBoardName
    Set Global Variable    ${whiteBoardName}
    #设置全局为全局变量，方便后期使用  
    ${whiteboardpassword}    random password
    Set Suite Variable    ${whiteboardpassword}
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    userId=${userId}    whiteBoardName=${whiteBoardName}      password=${whiteboardpassword}    level=${level[0]}    uplaodPattern=${whiteboard.uplaodPattern}    globalButton=${whiteboard.globalButton}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token} 
    ${resp}    /{orgName}/{appName}/whiteboards    'post'    url    ${orgName}    ${appName}    ${header}    ${data}    ${timeout}  
    ${restult}    to json    ${resp.content}
    #设置返回的房间ID为全局变量
    Set Global Variable    ${globalRoomId}    ${restult["roomId"]}
    [Return]    ${restult}
create whiteboard room Baninteraction
    [Documentation]    创建白板房间,需要传入用户id、白板房间名称、白板密码
    ...    不允许互动
    ${level}    random level
    ${userid}    random userid
    #设置userid为全局变量，方便删除房间使用   
    Set Global Variable    ${userid}     
    #设置whiteBoardName为全局变量
    ${whiteBoardName}    random whiteBoardName
    Set Global Variable    ${whiteBoardName}
    #设置全局为全局变量，方便后期使用  
    ${whiteboardpassword}    random password
    Set Suite Variable    ${whiteboardpassword}
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    userId=${userId}    whiteBoardName=${whiteBoardName}      password=${whiteboardpassword}    level=${level[1]}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token} 
    ${resp}    /{orgName}/{appName}/whiteboards    'post'    url    ${orgName}    ${appName}    ${header}    ${data}    ${timeout}  
    ${restult}    to json    ${resp.content}
    #设置返回的房间ID为全局变量
    Set Global Variable    ${globalRoomId}    ${restult["roomId"]}
    [Return]    ${restult}
