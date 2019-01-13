*** Settings ***
Documentation     使用环境：
...               python2.7版本
...               夜神模拟器5.0.0版本
...               Android 4.4版本
...               appium 1.4.16版本
...               屏幕分辨率为：480 * 800
Suite Setup       Setup Init Base    # Setup Init Base
Suite Teardown    Teardown Data Base    # 清理工作
Test Setup
Resource          ../Common/CollectionCommon/Setup/SetupCommon.robot
Resource          ../Common/CollectionCommon/Teardown/TeardownCommon.robot
Resource          ../Variable.robot
