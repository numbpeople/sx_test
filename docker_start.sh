#!/bin/bash

# 配置参数
ROBOT_TESTS=kefuapi-test
DOCKER_IMAGE_NAME=kf-docker
EMAIL_RECEIVE=leoli@easemob.com
INCLUED_TAG=debugChat
EXCLUED_TAG=org,tool,ui,appui

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

echo sudo docker run -it --rm -v $(pwd)/kefuapi-test:/$ROBOT_TESTS -ti $DOCKER_IMAGE_NAME --listener /$ROBOT_TESTS/lib/MyListener.py:$EMAIL_RECEIVE $includetag $excludetag $ROBOT_TESTS
#docker执行客服自动化项目
sudo docker run -it --rm -v $(pwd)/kefuapi-test:/$ROBOT_TESTS -ti $DOCKER_IMAGE_NAME --listener /$ROBOT_TESTS/lib/MyListener.py:$EMAIL_RECEIVE $includetag $excludetag $ROBOT_TESTS