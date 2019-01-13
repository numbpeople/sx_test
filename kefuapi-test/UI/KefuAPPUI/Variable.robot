*** Variables ***
${packagename}    com.easemob.helpdesk
${REMOTE_URL}     http://127.0.0.1:4723/wd/hub
${PLATFORM_NAME}    Android
${PLATFORM_VERSION}    4.4.
${DEVICE_NAME}    127.0.0.1:62001
${appPackage}     ${packagename}
${appActivity}    ${appPackage}.activity.SplashActivity
${Retrytimes}     10
@{pageElementModelList}    Login    Conversation    Setting    Queue    TenantExpire    Avatar    Chat
...               Base    # Base需要放置到最后一个位置，否则会出现变量中不到问题，后续优化
${BackTrackValitPath}    {"ConversationAndQueue":{"path":"Conversation-Queue"},"ConversationAndSetting":{"path":"Conversation-Avatar-Setting"},"QueueAndSetting":{"path":"Queue-Avatar-Setting"},"TenantExpireAndQueue":{"path":"TenantExpire-Queue"},"ChatAndQueue":{"path":"Chat-Back-Queue"},"ChatAndConversation":{"path":"Chat-Back-Conversation"},"ChatAndSetting":{"path":"Chat-Back-Avatar-Setting"}}
