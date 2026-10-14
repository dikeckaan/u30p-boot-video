#!/system/bin/sh
ST=/data/adb/u30p-boot-video
i=0; while [ "$(getprop sys.boot_completed)" != "1" ] && [ $i -lt 150 ]; do sleep 2; i=$((i+1)); done
[ "$(getprop sys.boot_completed)" = "1" ] && rm -f $ST/boot_pending && echo "$(date) boot completed" >> $ST/log
