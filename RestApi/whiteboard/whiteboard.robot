*** Keywords ***
/{orgName}/{appName}/whiteboards
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${header}    ${data}    ${timeout}
    [Documentation]    创建白板房间
    ${uri}=    set variable    /${org_name}/${app_name}/whiteboards/
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
    Run Keyword And Return if    ${method}=='get'    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}
/{orgName}/{appName}/whiteboards/{roomid}
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${roomid}    ${header}    ${data}    ${timeout}
    [Documentation]    删除白板房间
    ${uri}=    set variable    /${org_name}/${app_name}/whiteboards/${roomid}
    Run Keyword And Return if    ${method}=='delete'    Delete Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
/{orgName}/{appName}/whiteboards/{roomid}/interact
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${roomid}    ${header}    ${data}    ${timeout}
    [Documentation]    控制互动接口
    ${uri}=    set variable    /${org_name}/${app_name}/whiteboards/${roomid}
    Run Keyword And Return if    ${method}==‘delete'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
/{org_name}/{app_name}/whiteboards/{roomid}/url
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${roomid}    ${header}    ${data}    ${timeout}
    [Documentation]    根据会议id加入白板房间
    ${uri}=    set variable    /${org_name}/${app_name}/whiteboards/${roomid}/url
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
/{orgNmae}/{appName}/whiteboards/url-by-name
    [Arguments]    ${method}    ${session}    ${org_name}    ${app_name}    ${header}    ${data}    ${timeout}
    [Documentation]    根据会议名称加入白板房间
    ${uri}=    set variable    /${org_name}/${app_name}/whiteboards/url-by-name
    Run Keyword And Return if    ${method}=='post'    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
/rtc/data/appkey/{appname}/whiteboard/{starttime}/{endtime}/0/10