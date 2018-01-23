*** Settings ***
Library           json
Library           requests
Library           Collections
Library           String
Library           RequestsLibrary
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../BaseKeyword.robot

*** Keywords ***
One Service Valid Conversation
    [Arguments]    ${agent}    ${rest}
    [Documentation]    创建一个单服务有效会话，并进行满意度评价，记录会话创建时间、结束时间
    ${originType}    set variable    "weixin"
    ${curTimeVisitor}    get time    epoch
    ${curTime}    get time    epoch
    ${guestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    ${msgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":${originType}}}
    #发送消息并创建访客
    Send Message    ${rest}    ${guestEntity}    ${msgEntity}
    #根据访客昵称查询待接入列表
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${guestEntity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j["total_entries"]} == 1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestEntity.userName}    访客名称不正确：${resp.content}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #坐席回复消息并发送邀请评价,此处sleep是为了增加会话时长
    sleep    2000ms
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    ${curTimeAgent}    get time    epoch
    ${AgentMsgEntity}    create dictionary    msg=${curTimeAgent}:agent test msg!    type=txt
    Agent Send Message    ${agent}    ${j[0]['user']['userId']}    ${j[0]['serviceSessionId']}    ${AgentMsgEntity}
    sleep    50ms
    Send InviteEnquiry    ${agent}    ${j[0]['serviceSessionId']}
    sleep    50ms
    #关闭进行中会话
    Stop Processing Conversation    ${agent}    ${j[0]['user']['userId']}    ${j[0]['serviceSessionId']}
    ${curTimeStop}    get time    epoch
    #访客发送评价
    set to dictionary    ${msgEntity}    msg=5
    Send Message    ${rest}    ${guestEntity}    ${msgEntity}
    #记录会话创建时间、结束时间
    set to dictionary    ${ConDateRange}    beginDateTime=${curTimeVisitor}000    endDateTime=${curTimeStop}000