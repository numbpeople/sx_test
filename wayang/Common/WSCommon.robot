*** Settings ***
Documentation     websocket使用相关

*** Settings ***
Library           WebSocketClient

*** Keywords ***
WSConnect
    [Arguments]    ${url}    ${timeout}
    Log    ${url}
    &{ssldict}    Create Dictionary    cert_reqs=${0}
    ${conn}    WebSocketClient.Connect    ${url}    ${timeout}   sslopt=${ssldict}
    RETURN    ${conn}

WSSend
    [Arguments]    ${conn}    ${msg}
    WebSocketClient.Send    ${conn}    ${msg}

WSRecv
    [Arguments]    ${conn}
    ${result}    WebSocketClient.Recv    ${conn}
    RETURN    ${result}

WSPING
    [Arguments]    ${conn}    ${delay}
    WHILE    True    limit=NONE
    WebSocketClient.Ping    ${conn}
    Sleep    ${delay}
    END

WSCLOSE
    [Arguments]    ${conn}
    WebSocketClient.Close    ${conn}
