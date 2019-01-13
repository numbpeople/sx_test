@echo off

start cmd /k "adb connect 127.0.0.1:62001"

echo wscript.sleep 5000 > delay.vbs
cscript //nologo delay.vbs & del delay.vbs

start cmd /k "adb devices"