*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../AgentRes.robot
Resource          ../../JsonDiff/KefuJsonDiff.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../commons/admin common/BaseKeyword.robot
Resource          ../../api/BaseApi/Settings/RoutingApi.robot
Resource          ../../api/MicroService/WebGray/WebGrayApi.robot
Resource          ../../tool/Tools-Resource.robot
Resource          ../../api/IM/IMApi.robot
Resource          ../../api/BaseApi/Channels/AppApi.robot
Resource          ../../api/BaseApi/Channels/WebimApi.robot
Resource          ../../api/BaseApi/Settings/CompanyApi.robot
Resource          ../../api/BaseApi/Members/Agent_Api.robot
Resource          ../../api/BaseApi/Members/Queue_Api.robot
Resource          ../../api/BaseApi/Robot/Robot_Api.robot
Resource          ../../api/MicroService/Organ/OrgApi.robot
Resource          ../../api/MicroService/Webapp/InitApi.robot
Resource          ../../api/MicroService/Webapp/OutDateApi.robot
Resource          ../../api/HomePage/Login/Login_Api.robot
Resource          ../../api/MicroService/GatewayIMRoutewayPartner/GatewayIMRoutewayPartnerApi.robot

*** Keywords ***
Send SecondGateway Msg
    [Arguments]    ${agent}    ${rest}    ${guest}    ${msg}
    [Documentation]    第二通道发消息，每次发送消息会生成新的msg_id_for_ack
    #在扩展字段中增加msg_id_for_ack字段
    ${msg_id_for_ack}    Uuid 4
    ${msg_id_for_ack}    convert to string    ${msg_id_for_ack}
    ${extJson}    set variable    ${msg.ext}    #解析ext的值
    &{weichatDic}    loads    ${extJson}    #转化成字典
    ${weichatJson}    Dumps    ${weichatDic.weichat}    #取出json中的weichat参数的值
    &{j1}    loads    ${weichatJson}    #转化为字典
    set to dictionary    ${j1}    msg_id_for_ack=${msg_id_for_ack}    #在weichat的扩展中增加msg_id_for_ack字段
    ${ext}    Dumps    ${j1}    #转化成json
    Remove From Dictionary    ${msg.ext}    \    #避免重复key，先移除ext字段
    ${weichatExt}    set variable    {"weichat":${ext}}    #重新设置weichat扩展
    set to dictionary    ${msg}    ext=${weichatExt}    #将ext字段重新设置到${msg}变量中
    log dictionary    ${msg}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    ${resp}=    /v1/imgateway/messages    ${agent}    ${rest}    ${guest}    ${msg}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
