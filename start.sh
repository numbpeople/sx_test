# 配置邮件接收人
ROBOT_TESTS=kefuapi-test
DOCKER_IMAGE_NAME=kf-docker
EMAIL_RECEIVE=leoli@easemob.com,260553619@qq.com
INCLUED_TAG=test
EXCLUED_TAG=test1

# docker执行客服自动化项目
sudo docker run -i -t -e ROBOT_TESTS=$ROBOT_TESTS -e INCLUED_TAG=$INCLUED_TAG -e EXCLUED_TAG=$EXCLUED_TAG -e EMAIL_RECEIVE=$EMAIL_RECEIVE -v $(pwd)/kefuapi-test:$ROBOT_TESTS -ti $DOCKER_IMAGE_NAME /bin/bash -c "run.sh"