#!/system/bin/sh
# Adds adb to the stock ncm,mtp USB composition and re-adds it whenever the
# framework resets the port to plain ncm,mtp (e.g. after a cable replug).
ST=/data/adb/u30p-usb-adb
log() { echo "$(date '+%F %T') $*" >> $ST/log; }

i=0; while [ "$(getprop sys.boot_completed)" != "1" ] && [ $i -lt 150 ]; do sleep 2; i=$((i+1)); done
[ "$(getprop sys.boot_completed)" = "1" ] && rm -f $ST/boot_pending
[ "$(wc -l < $ST/log 2>/dev/null || echo 0)" -gt 500 ] && tail -n 200 $ST/log > $ST/log.tmp && mv $ST/log.tmp $ST/log

while true; do
  if [ "$(getprop sys.usb.config)" = "ncm,mtp" ]; then
    setprop sys.usb.config ncm,mtp,adb
    log "sys.usb.config ncm,mtp -> ncm,mtp,adb"
  fi
  sleep 3
done
