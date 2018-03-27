*** Settings ***
Resource          ../Utils/baseUtils.robot

*** Variables ***
${chatbasejson}    {"navigator":{"Agent":{"uri":"/mo/agent/webapp/sessions/chat","GrayKey":"base","ResourceKey":"agent_currentsession"}},"elements":[{"name":"header","xPath":"//*[@id='em-chat']/header/h1","text":{"zh_CN":"会话","en_US":"Conversations"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${chatlistlistr}    '{"elements":[{"name":"li","xPath":"//*[@id=\\'em-chat\\']/div[1]/div/div[1]/div/div[3]/ul/li[%d]","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[{"name":"class","value":{"zh_CN":"em-chat-itm-visitor%s%s","en_US":"em-chat-itm-visitor%s%s"}}],"elements":[{"name":"sourcespan","xPath":"/div[1]/span","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[{"name":"class","value":{"zh_CN":"channel-source-%s","en_US":"channel-source-%s"}}],"elements":[]},{"name":"visitorp","xPath":"/div[2]/p[1]","text":{"zh_CN":"%s","en_US":"%s"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}]}'
${chattest}       {"navigator":{"Admin":{"uri":"/mo/admin/webapp/current","ShowKey":"base"}},"elements":[{"name":"header","xPath":".//*[@id='em-session']/header/h1","text":{"zh_CN":"当前会话","en_US":"Ongoing"},"op":"show","attributes":[],"elements":[]},{"name":"filterspan","xPath":"//*[@id='em-session']/header/span[2]","text":{"zh_CN":"","en_US":""},"op":"show","attributes":[{"name":"name","value":{"zh_CN":"filter","en_US":"filter"}}],"elements":[{"name":"filtericon","xPath":"//*[@id='em-session']/header/span[2]/span[1]","text":{"zh_CN":"","en_US":""},"op":"show","attributes":[],"elements":[]},{"name":"filter","xPath":"//*[@id='em-session']/header/span[2]/span[2]","text":{"zh_CN":"筛选排序","en_US":"Sort"},"op":"show","attributes":[],"elements":[]}]},{"name":"refreshspan","xPath":"//*[@id='em-session']/header/span[1]","text":{"zh_CN":"","en_US":""},"op":"show","attributes":[{"name":"name","value":{"zh_CN":"refresh","en_US":"refresh"}}],"elements":[{"name":"refreshtextspan","xPath":"//*[@id='em-session']/header/span[1]/span","text":{"zh_CN":"刷新","en_US":"Refresh"},"op":"show","attributes":[],"elements":[]}]}]}
@{chatlistliclassattributes}    ' noAnswer'    ' selected'

*** Keywords ***
format chatlistlijson
    [Arguments]    ${i}    ${origintype}    ${visitorname}    @{attributes}
    ${s}    evaluate    ${chatlistlistr} % (${i},${attributes[0]},${attributes[1]},${attributes[0]},${attributes[1]},'${origintype}','${origintype}','${visitorname}','${visitorname}')
    return from keyword    ${s}

goto and checkchatebasejson
    ${jbase}    to json    ${chatbasejson}
    Check Base Module    ${kefuurl}    ${uiagent}    ${jbase}
