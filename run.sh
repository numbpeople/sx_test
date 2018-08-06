#!/bin/bash

set -e

# 设置默认值
DEFAULT_ROBOT_TESTS="false"
DEFAULT_EMAIL_RECEIVE="[]"
DEFAULT_REPORT_FILE="emailreport.html"
DEFAULT_INCLUED_TAG="false"
DEFAULT_EXCLUED_TAG="false"

# 如果docker启动时，没有指定参数，则使用默认值
ROBOT_TESTS=${ROBOT_TESTS:-$DEFAULT_ROBOT_TESTS}
EMAIL_RECEIVE=${EMAIL_RECEIVE:-$DEFAULT_EMAIL_RECEIVE}
REPORT_FILE=${REPORT_FILE:-$DEFAULT_REPORT_FILE}
INCLUED_TAG=${INCLUED_TAG:-$DEFAULT_INCLUED_TAG}
EXCLUED_TAG=${EXCLUED_TAG:-$DEFAULT_EXCLUED_TAG}
ROBOT_MyLISTENER=${ROBOT_TESTS}"/lib/MyListener.py"

if [[ "${ROBOT_TESTS}" == "false" ]]; then
  echo "Error: Please specify directory as env var ROBOT_TESTS, for example: kefuapi-test"
  exit 1
fi

# 打印变量的值情况
echo -e "开始执行测试用例"
echo -e "ROBOT_TESTS 参数值 :" ${ROBOT_TESTS}
echo -e "EMAIL_RECEIVE 参数值 :" ${EMAIL_RECEIVE}
echo -e "REPORT_FILE 参数值 :" ${REPORT_FILE}
echo -e "INCLUED_TAG 参数值 :" ${INCLUED_TAG}
echo -e "EXCLUED_TAG 参数值 :" ${EXCLUED_TAG}
echo -e "ROBOT_MyLISTENER 参数值 :" ${ROBOT_MyLISTENER}
echo -e "================================="

# 判断参数传入${INCLUED_TAG}和${EXCLUED_TAG}的值，来执行启动用例
if [[ "${INCLUED_TAG}" == "false" ]]; then
  if [[ "${EXCLUED_TAG}" == "false" ]]; then
    echo "执行命令：" pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} ${ROBOT_TESTS}
    pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} ${ROBOT_TESTS}
  else
    echo "执行命令：" pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} --exclude ${EXCLUED_TAG} ${ROBOT_TESTS}
    pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} --exclude ${EXCLUED_TAG} ${ROBOT_TESTS}
  fi    
fi

if [[ "${INCLUED_TAG}" != "false" ]]; then
  if [[ "${EXCLUED_TAG}" == "false" ]]; then
    echo "执行命令：" pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} --include ${INCLUED_TAG} ${ROBOT_TESTS}
    pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} --include ${INCLUED_TAG} ${ROBOT_TESTS}
  else
    echo "执行命令：" pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} --include ${INCLUED_TAG} --exclude ${EXCLUED_TAG} ${ROBOT_TESTS}
    pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} --include ${INCLUED_TAG} --exclude ${EXCLUED_TAG} ${ROBOT_TESTS}
  fi    
fi

echo -e "测试用例执行结束"

# pybot --listener ${ROBOT_MyLISTENER}:${EMAIL_RECEIVE}:${REPORT_FILE} --include ${INCLUED_TAG} --exclude ${EXCLUED_TAG} ${ROBOT_TESTS}

# sudo docker build -t kf-docker .

# sudo docker run --rm -i -t -e ROBOT_TESTS:kefuapi-test -v $(pwd)/kefuapi-test:/kefuapi-test -ti kf-docker /bin/bash -c "run.sh;bash"