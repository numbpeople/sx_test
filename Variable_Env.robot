*** Variables ***
&{RestRes}        RestUrl=${URLDeclare.rest1_sdb}    username=leoli@easemob.com    password=lijipeng123    alias=    # 用例执行环境配置、console登录账号密码
&{URLDeclare}     bj=https://a1.easemob.com    rest1_gray=https://a2.easemob.com    rest1_sdb=https://a1-hsb.easemob.com    rest2_sdb=http://39.96.116.29:8080    # rest1.0灰度：https://a2.easemob.com、rest1.0沙箱：https://a1-hsb.easemob.com、rest2.0沙箱: http://39.96.116.29:8080、北京集群：https://a1.easemob.com
&{RunModelCaseConditionDic}    orgName=    appName=    specificBestToken=    specificAppkey=    # 是否指定appkey、是否指定超级token；specificAppkey参数不用填写！
${timeout}        ${30.0}    # 接口请求超时时间
&{ResponseStatus}    OK=OK    FAIL=FAIL
&{ApiResponse}    status=${ResponseStatus.OK}    errorDescribetion=    statusCode=    text=    url=    describetion=    # 接口请求后的返回结构
&{contentType}    JSON=application/json    TEXT=text/plain    # 请求header头中contentType值的类型
&{requestHeader}    Content-Type=    Authorization=    restrict-access=    thumbnail=    share-secret=    Accept=    thumbnail=
...               # 请求header头中可以设置的多种key&value类型
&{FilterEntity}    page_size=5    page_num=1    limit=20    # 接口请求参数
&{baseRes}        validOrgName=    invalidOrgName=    validAppName=    invalidAppName=    validIMUser=    invalidIMUser=    validOrgUUID=
...               validAppUUID=    validChatgroup=    validChatroom=    # 有效的app和user均在validOrgName组织下，无效变量则随机取值
${allowOpenRegistration}    true    # 应用APP开放注册（true）、授权注册（false）
&{Token}          bestToken=    orgToken=    appToken=    userToken=    # 多种token的配置，包含超管token、管理员token、应用token、用户登录token
&{RunStatus}      RUN=True    NORUN=False    # 设置用例的执行装填，RUN即为执行、NORUN即为不执行
&{ModelCaseRunStatus}    OrgToken_ContentType=${RunStatus.RUN}    EmptyOrgToken_EmptyContentType=${RunStatus.RUN}    OrgToken_EmptyContentType=${RunStatus.RUN}    EmptyOrgToken_ContentType=${RunStatus.RUN}    BestToken_ContentType=${RunStatus.NORUN}    AppToken_ContentType=${RunStatus.RUN}    # 模块用例的多种组合执行状态
${preRandomString}    imautotest    # 创建随机数的前缀字符串
