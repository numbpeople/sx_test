#!/bin/bash

# 该脚本使用需要先构建镜像文件后，才能执行客服自动化用例。即：先执行docker_build.sh构建镜像后，才能执行脚本
# 该脚本使用需要先构建镜像文件后，才能执行客服自动化用例。即：先执行docker_build.sh构建镜像后，才能执行脚本
# 该脚本使用需要先构建镜像文件后，才能执行客服自动化用例。即：先执行docker_build.sh构建镜像后，才能执行脚本

#=========================================
# 可修改配置参数列表：
# EMAIL_RECEIVE: 接收测试报告的邮箱账号，多个邮箱账号使用逗号隔开，例如：leoli@easemob.com,zhukai@easemob.com
# KEFUURL: 客服登录地址，例如：http://sandbox.kefu.easemob.com
# USERNAME: 客服可登录的坐席邮箱账号，例如：lijipeng_1@qq.com
# PASSWORD: 客服登录账号的密码，例如：llijipeng123
# STATUS: 客服登录状态，取值范围：Online、Busy、Leave、Hidden，例如：Online
# INCLUED_TAG: 执行用例的Tag标签名称，多个标签使用逗号隔开。若需要全部执行用例，可以不填写值，例如：debugChat
# EXCLUED_TAG: 不执行用例的Tag标签名称，使用逗号隔开。若需要全部执行用例，该四个值需要填写不要修改，例如：org,tool,ui,appui
# VOLUME_REPORT: docker容器执行完测试用例，在宿主机器查看测试报告的文件夹，例如：autotest_report
# EMAIL_FILENAME: 接收测试报告HTML文件名称，建议使用英文，暂时仅支持html格式。并且不建议使用report.html、log.html，例如：emailreport.html
# MESSAGEGATEWAY: 访客进行发消息时，选取的消息渠道来源。取值范围：im、secondGateway。im：使用IM的rest接口发送消息，secondGateway：使用客服的第二通道接口发送消息
# ORGNAME: 使用租户下已有的关联发消息，orgName为关联下的组织名称，例如：sipsoft
# APPNAME: 使用租户下已有的关联发消息，appName为关联下的应用名称，例如：sandbox
# SERVICEEASEMOBIMNUMBER: 使用租户下已有的关联发消息，serviceEaseMobIMNumber为关联的IM服务号，例如：117497
# RESTDOMAIN: 使用租户下已有的关联发消息，restDomain为appkey所属集群rest地址，例如：a1.esemob.com
#=========================================
EMAIL_RECEIVE=
KEFUURL=
USERNAME=
PASSWORD=
STATUS=
INCLUED_TAG=debugChat
EXCLUED_TAG=org,tool,ui,appui
VOLUME_REPORT=autotest_report
EMAIL_FILENAME=emailreport.html
MESSAGEGATEWAY=
ORGNAME=
APPNAME=
SERVICEEASEMOBIMNUMBER=
RESTDOMAIN=


#=========================================
# 默认配置，不允许修改
# ROBOT_TESTS: 测试用例集名称
# DOCKER_IMAGE_NAME: docker镜像名称
# REPORT_FOLDERNAME: 接收测试报告的文件夹名称，例如：log
#=========================================
ROBOT_TESTS=kefuapi-test
DOCKER_IMAGE_NAME=kf-docker
REPORT_FOLDERNAME=log


#=========================================
# Docker执行部分，不允许修改
#=========================================
# 设置include标签
function include()
{
  OLD_IFS="$IFS"
  IFS=','
  arr=($INCLUED_TAG)
  IFS="$OLD_IFS"
  tag=''
  for x in ${arr[@]};
    do
      tag=$tag$"--include"" "$x" "
    done
  echo $tag
}

# 设置exclude标签
function exclude()
{
  OLD_IFS="$IFS"
  IFS=','
  arr=($EXCLUED_TAG)
  IFS="$OLD_IFS"
  extag=''
  for x in ${arr[@]};
    do
      extag=$extag$"--exclude"" "$x" "
    done
  echo $extag
}

includetag=$(include)
excludetag=$(exclude)
array=(${KEFUURL//:/ })
DOCKER_KEFUURL=${array[1]}
LISTENERPATH=/$ROBOT_TESTS/lib/MyListener.py
REPORTFOLDERPATH=/$REPORT_FOLDERNAME
EMAILREPORTPATH=/$REPORT_FOLDERNAME/$EMAIL_FILENAME
CURDIR=`cd $(dirname $0) && pwd`

echo sudo docker run -v $CURDIR/$VOLUME_REPORT:$REPORTFOLDERPATH -it --rm $DOCKER_IMAGE_NAME --variable url:${KEFUURL} --variable username:${USERNAME} --variable password:${PASSWORD} --variable status:${STATUS} --variable messageGateway:${MESSAGEGATEWAY} --variable orgName:${ORGNAME} --variable appName:${APPNAME} --variable serviceEaseMobIMNumber:${SERVICEEASEMOBIMNUMBER} --variable restDomain:${RESTDOMAIN} --listener $LISTENERPATH:$EMAIL_RECEIVE:$EMAILREPORTPATH:${DOCKER_KEFUURL}:${USERNAME}:${PASSWORD}:${STATUS} -d $REPORTFOLDERPATH $includetag $excludetag $ROBOT_TESTS

#docker执行客服自动化项目
sudo docker run -v $CURDIR/$VOLUME_REPORT:$REPORTFOLDERPATH -it --rm $DOCKER_IMAGE_NAME --variable url:${KEFUURL} --variable username:${USERNAME} --variable password:${PASSWORD} --variable status:${STATUS} --variable messageGateway:${MESSAGEGATEWAY} --variable orgName:${ORGNAME} --variable appName:${APPNAME} --variable serviceEaseMobIMNumber:${SERVICEEASEMOBIMNUMBER} --variable restDomain:${RESTDOMAIN} --listener $LISTENERPATH:$EMAIL_RECEIVE:$EMAILREPORTPATH:${DOCKER_KEFUURL}:${USERNAME}:${PASSWORD}:${STATUS} -d $REPORTFOLDERPATH $includetag $excludetag $ROBOT_TESTS