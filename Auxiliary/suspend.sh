#!/bin/sh

# adb push suspend.sh /sdcard/
# adb shell "nohup sh /sdcard/suspend.sh > /sdcard/output.txt &"

rm -f /sdcard/output.txt

echo begin

echo enable airplane mode
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
settings put global airplane_mode_on 1

for i in `seq 1 5`
do
	echo go $i
	sleep 1
done

echo clicking power key
input keyevent 26

echo end
exit 0

