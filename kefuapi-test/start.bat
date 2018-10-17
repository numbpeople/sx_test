@echo off

rem ##################################################################################################################
rem 可修改配置参数列表：
rem EMAIL_RECEIVE: 接收测试报告的邮箱账号，多个邮箱账号使用逗号隔开，例如：leoli@easemob.com,zhukai@easemob.com
rem KEFUURL: 客服登录地址，例如：http://sandbox.kefu.easemob.com
rem USERNAME: 客服可登录的坐席邮箱账号，例如：lijipeng_1@qq.com
rem PASSWORD: 客服登录账号的密码，例如：llijipeng123
rem STATUS: 客服登录状态，取值范围：Online、Busy、Leave、Hidden，例如：Online
rem EMAIL_FILENAME: 接收测试报告HTML文件名称，建议使用英文，暂时仅支持html格式。并且不建议使用report.html、log.html，例如：emailreport.html
rem MESSAGEGATEWAY: 访客进行发消息时，选取的消息渠道来源。取值范围：im、secondGateway。im：使用IM的rest接口发送消息，secondGateway：使用客服的第二通道接口发送消息
rem ORGNAME: 使用租户下已有的关联发消息，orgName为关联下的组织名称，例如：sipsoft
rem APPNAME: 使用租户下已有的关联发消息，appName为关联下的应用名称，例如：sandbox
rem SERVICEEASEMOBIMNUMBER: 使用租户下已有的关联发消息，serviceEaseMobIMNumber为关联的IM服务号，例如：117497
rem RESTDOMAIN: 使用租户下已有的关联发消息，restDomain为appkey所属集群rest地址，例如：a1.esemob.com
rem
rem INCLUED_TAG: 执行用例的Tag标签名称，多个标签使用逗号隔开。若需要全部执行用例，可以不填写值，例如：debugChat
rem EXCLUED_TAG: 不执行用例的Tag标签名称，使用逗号隔开。若需要全部执行用例，该四个值需要填写不要修改，例如：org,tool,ui,appui
rem ##################################################################################################################

set email_reveiver=
set url=
set username=
set password=
set status=
set messageGateway=
set orgName=
set appName=
set serviceEaseMobIMNumber=
set restDomain=

set curdir=%cd%
cd..
set "bd=%curdir%"
set casesuite=%curdir%
set reportfolder=%bd%\log
set emailname=emailreport.html


echo pybot.bat --variable url:%url% --variable username:%username% --variable password:%password% --variable status:%status% --variable messageGateway:%messageGateway% --variable orgName:%orgName% --variable appName:%appName% --variable serviceEaseMobIMNumber:%serviceEaseMobIMNumber% --variable restDomain:%restDomain% --listener %casesuite%\lib\MyListener.py;%email_reveiver%;%reportfolder%\%emailname%;%url%;%username%;%password%;%status% -d %reportfolder% --include debugChat --exclude tool --exclude ui --exclude appui --exclude org %casesuite%


pybot.bat --variable url:%url% --variable username:%username% --variable password:%password% --variable status:%status% --variable messageGateway:%messageGateway% --variable orgName:%orgName% --variable appName:%appName% --variable serviceEaseMobIMNumber:%serviceEaseMobIMNumber% --variable restDomain:%restDomain% --listener %casesuite%\lib\MyListener.py;%email_reveiver%;%reportfolder%\%emailname%;%url%;%username%;%password%;%status% -d %reportfolder% --include debugChat --exclude tool --exclude ui --exclude appui --exclude org %casesuite%
