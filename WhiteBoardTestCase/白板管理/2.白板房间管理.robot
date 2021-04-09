*** Settings ***
Resource    ../../Common/WhiteBoaardCommon/CreateWhiteBoard.robot
Resource    ../../Common/WhiteBoaardCommon/DeleteWhiteBoardCommon.robot
Test Setup    create whiteboard room
Test Teardown    Delete WhiteBorad RoomId
*** Test Cases ***
删除已存在白板房间
    [Documentation]    删除存在的白板房间
    #创建白板房间
    #${resp}    create whiteboard room
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    userId=${userid}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    #删除已存在的房间 
    ${resp}    /{orgName}/{appName}/whiteboards/{roomid}    'delete'    url    ${orgName}    ${appName}    ${globalRoomId}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${result}    to json    ${resp.content}
    Should Be True        ${result["status"]}
删除不存在的白板房间
    [Documentation]    删除不存在的白板房间
    ${roomid}    random userid
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    userId=${userid}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    #删除已存在的房间 
    ${resp}    /{orgName}/{appName}/whiteboards/{roomid}    'delete'    url    ${orgName}    ${appName}    ${roomId}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${result}    to json    ${resp.content}
    Should Be True        not ${result["status"]}
    Should Be Equal As Integers    ${result["error_code"]}    10
    Should Be Equal As Strings    ${result["error_msg"]}    white board not exist    
根据已存在房间id加入房间
    [Documentation]
    ...    根据房间id加入房间，userid和passw为必填项
    ...    此case传入userid和password
    #创建白板房间
    #${resp1}    create whiteboard room
    #${roomid}    Set Variable    ${resp1["roomId"]}
    Create session    url    ${whiteboardurl}
    #构建一个新用户id
    ${userid-new}    random userid
    &{data}    Create Dictionary    userId=${userid-new}    password=${whiteboardpassword}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    ${resp}    /{org_name}/{app_name}/whiteboards/{roomid}/url    'post'    url    ${orgName}    ${appName}    ${globalRoomId}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${result1}    to json    ${resp.content}
    Should Be True    ${result1["status"]}
    Should Be Equal As Strings    ${result1["roomId"]}    ${globalRoomId}
未传入用户id，使用房间id加入房间
    [Documentation]
    ...    根据房间id加入房间，userid和passw为必填项
    #创建白板房间
    #${resp1}    create whiteboard room
    #${roomid}    Set Variable    ${resp1["roomId"]}
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    password=${whiteboardpassword}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    ${resp}    /{org_name}/{app_name}/whiteboards/{roomid}/url    'post'    url    ${orgName}    ${appName}    ${globalRoomId}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${result}    to json    ${resp.content}
    Should Be True     not ${result["status"]}
    #Should Be Equal As Strings    ${result["roomId"]}    ${resp1["roomId"]}
根据房间名称加入房间
    #创建白板房间
    #${resp1}    create whiteboard room
    Create session    url    ${whiteboardurl}
    ${userid-new}    random userid
    &{data}    Create Dictionary    userId=${userid-new}    whiteBoardName=${whiteBoardName}    password=${whiteboardpassword}    
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    ${resp}    /{orgNmae}/{appName}/whiteboards/url-by-name    'post'    url    ${orgName}    ${appName}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${result}    to json    ${resp.content}
    Should Be True    ${result["status"]}
    Should Be String    ${result["userId"]}         
根据白板id使用错误的密码加入房间
    #${resp}    create whiteboard room
    Create session    url    ${whiteboardurl}
    #创建错误的房间密码
    ${password}    random password
    &{data}    Create Dictionary    userid=${userid}    password=${password}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    ${resp}    /{org_name}/{app_name}/whiteboards/{roomid}/url    'post'    url    ${orgName}    ${appName}    ${globalRoomId}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${restult}    to json    ${resp.content}
    Should Be Equal As Strings    ${restult["error_msg"]}    white board password error  
    Should Be Equal As Integers    ${restult["error_code"]}    15
加入不存在的房间ID
    #${resp}    create whiteboard room 
    ${roomId}    random userid
    Create session    url    ${whiteboardurl}
    &{data}    Create Dictionary    userid=${userid}    password=${whiteboardpassword}
    Set To Dictionary    ${header}    Authorization=Bearer ${whiteword-token}
    ${resp}    /{org_name}/{app_name}/whiteboards/{roomid}/url    'post'    url    ${orgName}    ${appName}    ${roomId}    ${header}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    ${restult}    to json    ${resp.content}
    Should Be Equal As Strings    ${restult["error_msg"]}    white board not exist  
    Should Be Equal As Integers    ${restult["error_code"]}    10
设置白板工具栏位置-顶部
设置白板工具栏位置-底部
设置白板工具栏位置-右边
