*** Variables ***
${myticketlistbasejson}    {"navigator":{"Agent":{"uri":"/mo/agent/ticket/mytickets/ticketlist","GrayKey":"ticket","ResourceKey":"agent_ticket_ticketlist"}},"elements":[{"name":"header","xPath":"//*[@id='em-ticket']/header/h1","text":{"zh-CN":"工单","en-US":"Ticket"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${myticketdownloadbasejson}    {"navigator":{"Agent":{"uri":"/mo/agent/ticket/mytickets/ticketdownload","GrayKey":"ticket","ResourceKey":"agent_ticket_ticketdownload"}},"elements":[{"name":"header","xPath":"//*[@id='em-ticket-ticketdownload']/header/h1","text":{"zh-CN":"导出管理","en-US":"Export"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
