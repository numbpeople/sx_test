*** Variables ***
&{RestRes}        RestUrl=${URLDeclare.rest1_sdb}    username=leoli@easemob.com    password=lijipeng123    alias=
&{URLDeclare}     bj=https://a1.easemob.com    rest1_gray=https://a2.easemob.com    rest1_sdb=https://a1-hsb.easemob.com    rest2_sdb=http://39.96.116.29:8080    # rest1.0灰度：https://a2.easemob.com、rest1.0沙箱：https://a1-hsb.easemob.com、rest2.0沙箱: http://39.96.116.29:8080、北京集群：https://a1.easemob.com
&{RunModelCaseConditionDic}    orgName=    appName=    specificBestToken=    specificAppkey=    # 是否指定appkey、是否指定超级token；specificAppkey参数不用填写！
${timeout}        ${30.0}    # 接口请求超时时间
&{ResponseStatus}    OK=OK    FAIL=FAIL
&{ApiResponse}    status=${ResponseStatus.OK}    errorDescribetion=    statusCode=    text=    url=    describetion=
&{contentType}    JSON=application/json    TEXT=text/plain
&{requestHeader}    Content-Type=    Authorization=    restrict-access=    thumbnail=    share-secret=    Accept=    thumbnail=
&{FilterEntity}    page_size=5    page_num=1    limit=20
&{baseRes}        validOrgName=    invalidOrgName=    validAppName=    invalidAppName=    validIMUser=    invalidIMUser=    validOrgUUID=
...               validAppUUID=    validChatgroup=    validChatroom=    # 有效的app和user均在validOrgName组织下，无效变量则随机取值
${allowOpenRegistration}    true    # 应用APP开放注册（true）、授权注册（false）
&{Token}          bestToken=    orgToken=    appToken=    userToken=
&{RunStatus}      RUN=True    NORUN=False
&{ModelCaseRunStatus}    OrgToken_ContentType=${RunStatus.RUN}    EmptyOrgToken_EmptyContentType=${RunStatus.RUN}    OrgToken_EmptyContentType=${RunStatus.RUN}    EmptyOrgToken_ContentType=${RunStatus.RUN}    BestToken_ContentType=${RunStatus.NORUN}    AppToken_ContentType=${RunStatus.RUN}
${preRandomString}    imautotest
