#!/system/bin/sh
# Bootloop guard: boot_pending is set here and cleared by service.sh once
# sys.boot_completed=1. If it survives to the next boot, disable the module.
MODDIR=${0%/*}; ST=/data/adb/u30p-boot-video; mkdir -p $ST
if [ -f $ST/boot_pending ]; then touch $MODDIR/disable; rm -f $ST/boot_pending; echo "$(date) previous boot did not complete -> module disabled" >> $ST/log; exit 0; fi
touch $ST/boot_pending
