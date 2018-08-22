*** Variables ***
${settingsenterprisebasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/enterprise","GrayKey":"base","ResourceKey":"admin_settings_enterprise"}},"elements":[{"name":"h1","xPath":"//*[@id='em-company']/header/h1","text":{"zh-CN":"企业信息","en-US":"Company"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingssystembasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/system","GrayKey":"base","ResourceKey":"admin_settings_system"}},"elements":[{"name":"h1","xPath":"//*[@id='em-formula']/header/h1","text":{"zh-CN":"系统开关","en-US":"System settings"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingstimeplanbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/time_plan","GrayKey":"base","ResourceKey":"admin_settings_time_plan"}},"elements":[{"name":"h1","xPath":"//*[@id='em-timeplan']/header/h1","text":{"zh-CN":"时间计划设置","en-US":"Business hours"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingspermissionbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/permission","GrayKey":"base","ResourceKey":"admin_settings_permission"}},"elements":[{"name":"h1","xPath":"//*[@id='em-permissionSetting']/header/h1","text":{"zh-CN":"权限管理","en-US":"Permissions"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsphrasebasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/phrase","GrayKey":"base","ResourceKey":"admin_settings_phrase"}},"elements":[{"name":"h1","xPath":"//*[@id='em-phrase']/header/h1","text":{"zh-CN":"公共常用语","en-US":"Phrases"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsemojibasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/emoji","GrayKey":"customMagicEmoji","ResourceKey":"admin_settings_emoji"}},"elements":[{"name":"h1","xPath":"//*[@id='em-emoji']/header/h1","text":{"zh-CN":"自定义表情","en-US":"Custom stickers"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingssummarybasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/summary","GrayKey":"base","ResourceKey":"admin_settings_summary"}},"elements":[{"name":"h1","xPath":"//*[@id='em-summary']/header/h1","text":{"zh-CN":"会话标签","en-US":"Conversation tags"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsiframebasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/iframe","GrayKey":"base","ResourceKey":"admin_settings_iframe"}},"elements":[{"name":"h1","xPath":"//*[@id='em-ifm']/header/h1","text":{"zh-CN":"自定义信息接口","en-US":"Iframe"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingscallbackbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/callback","GrayKey":"showCallback","ResourceKey":"admin_settings_callback"}},"elements":[{"name":"h1","xPath":"//*[@id='em-callback']/header/h1","text":{"zh-CN":"自定义事件推送","en-US":"Webhook"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsroutesbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/routes","GrayKey":"base","ResourceKey":"admin_settings_routes"}},"elements":[{"name":"h1","xPath":"//*[@id='em-routingStrategy']/header/h1","text":{"zh-CN":"会话分配规则","en-US":"Routing"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsevaluatebasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/evaluate","GrayKey":"base","ResourceKey":"admin_settings_evaluate"}},"elements":[{"name":"h1","xPath":"//*[@id='em-evaluate']/header/h1","text":{"zh-CN":"满意度评价邀请设置","en-US":"Satisfaction survey"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsqualitysettingsbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/qualitysettings","GrayKey":"base","ResourceKey":"admin_settings_qualitysettings"}},"elements":[{"name":"h1","xPath":"//*[@id='em-qualitySetting']/header/h1","text":{"zh-CN":"质检评分设置","en-US":"Review settings"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsssobasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/sso","GrayKey":"ssocfg","ResourceKey":"admin_settings_sso"}},"elements":[{"name":"h1","xPath":"//*[@id='em-sso']/header/h1","text":{"zh-CN":"单点登录","en-US":"Single sign-on (SSO)"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsnotesbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/notes","GrayKey":"noteCategory","ResourceKey":"admin_settings_notes"}},"elements":[{"name":"h1","xPath":"//*[@id='em-noteSetting']/header/h1","text":{"zh-CN":"留言设置","en-US":"Note settings"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsreganswerbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/reganswer","GrayKey":"reganswer","ResourceKey":"admin_settings_reganswer"}},"elements":[{"name":"h1","xPath":"//*[@id='em-regAnswer']/header/h1","text":{"zh-CN":"关键字匹配","en-US":"Keyword match"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsorderinfobasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/orderinfo","GrayKey":"base","ResourceKey":"admin_settings_orderinfo"}},"elements":[{"name":"h1","xPath":"//*[@id='em-orderInfo-kefu']/header/h1","text":{"zh-CN":"订单列表","en-US":"Order list"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingsquestionnairebasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/questionnaire","GrayKey":"questionnaireEnable","ResourceKey":"admin_settings_questionnaire"}},"elements":[{"name":"h1","xPath":"//*[@id='em-questionnaire']/header/h1","text":{"zh-CN":"问卷调查","en-US":"Questionnaire"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${settingstriggerbasejson}    {"navigator":{"Admin":{"uri":"/mo/admin/webapp/settings/trigger","GrayKey":"customRules","ResourceKey":"admin_settings_trigger"}},"elements":[{"name":"h1","xPath":"//*[@id='em-trigger']/header/h1","text":{"zh-CN":"自定义业务规则","en-US":"Advanced rule customization"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
