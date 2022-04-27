*** Variables ***
&{WayangRes}        RestUrl=https://a1-hsb.easemob.com    WSUrl=wss://webdemo.agora.io:8083/iov/websocket/dual?topic=    topic1=zktest    device=Webim    timeout=10    delay=10    WSconn=    WShandle=    alias=    consolealias=
&{WatyangUserinfo}    username=lizg1    password=1
&{Wayang2Res}        RestUrl=https://a1-hsb.easemob.com    WSUrl=wss://webdemo.agora.io:8083/iov/websocket/dual?topic=    topic1=zktest2    device=Webim    timeout=10    delay=10    WSconn=    WShandle=    alias=    consolealias=
&{WatyangUser2info}    username=lizg2    password=1
&{WayangappInfo}    orgname=easemob-demo        appname=easeim    apptoken=    orgtoken=YWMtvrSFSJOYEeu09q2wt1cOGAAAAAAAAAAAAAAAAAAAAAHWVZvSOwZMUJ9NRQCEAaB2AQMAAAF4kf0CigBPGgDTibWmq85N0l3riEgYWnuuxwaiUTCEpzsnc5hBwNkIfw 
${savecasepath}    ./jsoncase