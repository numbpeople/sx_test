@echo on

start cmd /k "appium -a 127.0.0.1 -p 4723 -bp 4724 -U 71d9f2f1 --session-override --command-timeout 1200"