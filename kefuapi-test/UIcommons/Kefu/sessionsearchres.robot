*** Variables ***
${sessionsearchbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/search","ShowKey":"base"},"Agent":{"uri":"/mo/agent/webapp/mysearch","ShowKey":"base"}},"elements":[{"name":"header","xPath":"//*[@id='em-search']/header/h1","text":{"zh_CN":"搜索","en_US":"Search"},"op":"show","attributes":[],"elements":[]},{"name":"searchinput","xPath":"//*[@id='em-search']/section[1]/div[1]/div/span/input","text":{"zh_CN":"","en_US":""},"op":"input","attributes":[{"name":"type","value":{"zh_CN":"text","en_US":"text"}},{"name":"placeholder","value":{"zh_CN":"请输入搜索内容","en_US":"Pleaseenter..."}},{"name":"value","value":{"zh_CN":"","en_US":""}},{"name":"autocomplete","value":{"zh_CN":"off","en_US":"off"}}],"elements":[]},{"name":"searchbutton","xPath":"//*[@id='em-search']/section[1]/div[1]/div/span/span[1]/span","text":{"zh_CN":"","en_US":""},"op":"click","attributes":[],"elements":[]}]}

*** Keywords ***
