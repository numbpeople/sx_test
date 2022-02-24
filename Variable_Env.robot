*** Variables ***
&{RestRes}        RestUrl=${URLDeclare.sgp_aws}    username=    password=    alias=    consolealias=    # 用例执行环境配置、console登录账号密码
&{URLDeclare}     ebs=http://a1.easemob.com    hw=http://a1-hw.easemob.com    frank=https://a51.easemob.com    sgp=https://a1-sgp.easemob.com    sgp_aws=https://a61.easemob.com
...    rest1_gray=http://a2.easemob.com    hk=https://hk.test.easemob.com    hsb=http://a1-hsb.easemob.com    frank_aws=https://a71.easemob.com    east=https://a41.easemob.com
...    rest2_sdb=http://39.96.116.29:8080    vip6=http://a1-vip6.easemob.com    # rest1.0灰度：https://a2.easemob.com、rest1.0沙箱：https://a1-hsb.easemob.com、rest2.0沙箱: http://39.96.116.29:8080、北京集群：https://a1.easemob.com    item    
&{Password}    password_ebs_hsb=huanxintest1024    other_password=12345678.  
&{ManagementApi}    ManagetmentHsbUrl=http://im-management.easemob.com    ManagetmentUrl=http://im-management-hsb.easemob.com
&{RunModelCaseConditionDic}    orgName=   appName=    specificBestToken=    specificAppkey=    # 是否指定appkey、是否指定超级token；specificAppkey参数不用填写！
${timeout}        ${30.0}    # 接口请求超时时间
&{ResponseStatus}    OK=OK    FAIL=FAIL
&{ApiResponse}    status=${ResponseStatus.OK}    errorDescribetion=    statusCode=    text=    url=    describetion=    # 接口请求后的返回结构
&{contentType}    JSON=application/json    TEXT=text/plain    urlencoded=application/x-www-form-urlencoded;charset=utf-8    # 请求header头中contentType值的类型
&{requestHeader}    Content-Type=    Authorization=    restrict-access=    thumbnail=    share-secret=    Accept=    thumbnail=    # 请求header头中可以设置的多种key&value类型
&{FilterEntity}    page_size=5    page_num=1    limit=20    # 接口请求参数
&{baseRes}        validOrgName=    invalidOrgName=    validAppName=   invalidAppName=    validIMUser=    invalidIMUser=    validOrgUUID=
...               validAppUUID=    validChatgroup=    validChatroom=    # 有效的app和user均在validOrgName组织下，无效变量则随机取值
${allowOpenRegistration}    ${EMPTY}    # 应用APP开放注册（true）、授权注册（false）
&{validIMUserInfo}    uuid=    username=    nickname=
&{Token}          bestToken=    orgToken=    appToken=    userToken=${RandomParameter.userToken}    # 多种token的配置，包含超管token、管理员token、应用token、用户登录token
&{RandomParameter}    userToken=a 
&{RunStatus}      RUN=True    NORUN=False    # 设置用例的执行装填，RUN即为执行、NORUN即为不执行
&{ModelCaseRunStatus}    OrgToken_ContentType=${RunStatus.RUN}    EmptyOrgToken_EmptyContentType=${RunStatus.RUN}    OrgToken_EmptyContentType=${RunStatus.RUN}    EmptyOrgToken_ContentType=${RunStatus.RUN}    BestToken_ContentType=${RunStatus.NORUN}
...    AppToken_ContentType=${RunStatus.RUN}    userToken_ContentType=${RunStatus.RUN}    # 模块用例的多种组合执行状态
${preRandomString}    imautotest    # 创建随机数的前缀字符串
&{appreciationservice}    orgname=easemob-demo        appname=chatdemoui    apptoken=    orgtoken=YWMtvrSFSJOYEeu09q2wt1cOGAAAAAAAAAAAAAAAAAAAAAHWVZvSOwZMUJ9NRQCEAaB2AQMAAAF4kf0CigBPGgDTibWmq85N0l3riEgYWnuuxwaiUTCEpzsnc5hBwNkIfw    Accept=application/json    ContentType=application/json    #测试增值服务相关的case（增值服务需要与开通，目前是有特殊的appkey）
&{callbackvariable}    telenumber=13400327666    callbackuri=http://www.baidu.com    
&{msghooksvariable}    msghooksuri=http://www.baidu.com