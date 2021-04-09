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
Delete WhiteBorad RoomId
    [Documentation]    删除存在的白板房间
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    userId=${userid}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    #删除已存在的房间 
    ${resp}    /{orgName}/{appName}/whiteboards/{roomid}    'delete'    url    ${orgName}    ${appName}    ${globalroomid}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${result}    to json    ${resp.content}
    #Should Be True        ${result["status"]}