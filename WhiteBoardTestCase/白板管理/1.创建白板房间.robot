*** Settings ***
Library    RequestsLibrary    
Library    json
Library    Collections
Resource    ../../WhtieBoard_Varable.robot
Resource    ../../RestApi/whiteboard/whiteboard.robot
Resource    ../../Common/WhiteBoaardCommon/CreateWhiteBoard.robot
Resource     ../../Common/WhiteBoaardCommon/DeleteWhiteBoardCommon.robot
Test Teardown    Delete WhiteBorad RoomId
*** Test Cases ***
创建不存在的白板房间
    [Documentation]    创建白板房间
    ...    设置顶部显示工具栏，全局按钮，允许互动
    #创建白板
    ${resp}    create whiteboard room
    #判断房间是否创建成功
    Should Be Equal    ${resp["domainName"]}    https://wbrtc.easemob.com
创建不允许互动的房间
    [Documentation]    创建白板房间
    ...    设置不允许互动
    #创建白板
    ${resp}    create whiteboard room Baninteraction
    #判断房间是否创建成功
    Should Be Equal    ${resp["domainName"]}    https://wbrtc.easemob.com
创建存在的白板房间
    [Documentation]    创建已存在的白板白板
    #先创建一个不存在的白板房间
    ${restult1}    create whiteboard room 
    #创建一个已存在的白板房间
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    userId=${userId}    whiteBoardName=${whiteBoardName}      password=${whiteboard_password}    level=${whiteboard.level}    uplaodPattern=${whiteboard.uplaodPattern}    globalButton=${whiteboard.globalButton}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token} 
    ${resp}    /{orgName}/{appName}/whiteboards    'post'    url    ${orgName}    ${appName}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${restult2}    to json    ${resp.content}
    #判断status
    Should Be True    not ${restult2["status"]}
    #判断error_code
    Should Be Equal As Numbers    ${restult2['error_code']}    45
    #判断error_message    
    Should Be Equal    ${restult2["error_msg"]}    whiteboard name repeat