#!/system/bin/sh
rm -rf /data/adb/u30p-usb-adb
[ "$(getprop sys.usb.config)" = "ncm,mtp,adb" ] && setprop sys.usb.config ncm,mtp
