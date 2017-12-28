rem Mi:517ebeda  nexus 5:03bcf834437e92b5 Huawei: MYV0215B06001770
@echo on
start cmd /k "appium -a 127.0.0.1 -p 4723 -bp 4724 --session-override --command-timeout 1200"

start cmd /k "appium -a 127.0.0.1 -p 4725 -bp 4726 --session-override --command-timeout 1200"